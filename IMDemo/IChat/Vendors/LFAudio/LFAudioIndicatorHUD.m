//
//  LFAudioIndicatorHUD.m
//  IMDemo
//
//  Created by 刘峰 on 2018/12/25.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "LFAudioIndicatorHUD.h"

//录音动画--手指上滑时显示文字label的背景颜色
#define kBackgroundColor_DarkRed [UIColor colorWithRed:156/255.0 green:54/255.0 blue:56/255.0 alpha:1]

static  NSString *const kVoiceNoteText_ToRecord = @"手指上滑，取消发送";
static  NSString *const kVoiceNoteText_ToCancel = @"松开手指，取消发送";
static  NSString *const kVoiceNoteText_TooShort = @"说话时间太短";
static  NSString *const kVoiceNoteText_TooLong = @"说话时间超长";
static  NSString *const kVoiceNoteText_VolumeTooLow = @"请调大音量后播放";

@interface LFAudioIndicatorHUD ()

@property (nonatomic, strong) UIWindow *overlayWindow;

@property (nonatomic, strong) UIView *audioBackground;/**< 录音动画背景视图*/

@property (nonatomic, strong) UIView *recordingView;/**< 展示话筒和音量大小的背景视图*/
@property (nonatomic, strong) UIImageView *microphoneImageView;/**< 话筒*/
@property (nonatomic, strong) UIImageView *volumeImageView;/**< 音量*/

@property (nonatomic, strong) UIImageView *infoImageView;/**< 录音详情图片(取消, 录音时间太短, 录音时间太长)*/
@property (nonatomic, strong) UILabel *countLabel;/**< 倒计时展示label*/
@property (nonatomic, strong) UILabel *showInfoLabel;/**< 解释说明label*/

@property (nonatomic, strong) NSTimer *timer;/**< 录音时间计数器*/
@property (nonatomic, assign) NSTimeInterval seconds;/**< 录音时间计数*/
@end

@implementation LFAudioIndicatorHUD

#pragma mark - Public method
+ (instancetype)shared {
    static LFAudioIndicatorHUD *audioIndicatorHUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioIndicatorHUD = [[LFAudioIndicatorHUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return audioIndicatorHUD;
}

+ (void)show {
    [[LFAudioIndicatorHUD shared] showAudioHUD];
}

+ (void)hideAllHUD {
    [[LFAudioIndicatorHUD shared] dismiss];
}

+ (void)currentTypeForOperation:(ChatBarRecordType)recordType {
    
    [[LFAudioIndicatorHUD shared] initHiddenStyle];
    
    switch (recordType) {
        case ChatBarRecording:[LFAudioIndicatorHUD show];
            break;
        case ChatBarRecordFinish:[LFAudioIndicatorHUD hideAllHUD];
            break;
        case ChatBarRecordCancel:[LFAudioIndicatorHUD hideAllHUD];
            break;
        case ChatBarRecordDragEnter:[[LFAudioIndicatorHUD shared] dragEnterOperation];
            break;
        case ChatBarRecordDragExit:[[LFAudioIndicatorHUD shared] dragExitOperation];
            break;
        case ChatBarRecordTooLong:[LFAudioIndicatorHUD hideAllHUD];
            break;
        case ChatBarRecordTooShort:[LFAudioIndicatorHUD hideAllHUD];
        default:[LFAudioIndicatorHUD hideAllHUD];
            break;
    }
}

+ (void)updateVolumeValue:(CGFloat)value {
    [[LFAudioIndicatorHUD shared] changeVolumeView:value];
}

#pragma mark - Private method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        [self setUpConstraints];
    }
    return self;
}

/**< 创建视图*/
- (void)setUp {
    [self.overlayWindow addSubview:self];
    [self addSubview:self.audioBackground];
    [self addSubview:self.recordingView];
    [self.recordingView addSubview:self.microphoneImageView];
    [self.recordingView addSubview:self.volumeImageView];
    [self.audioBackground addSubview:self.infoImageView];
    [self.audioBackground addSubview:self.countLabel];
    [self.audioBackground addSubview:self.showInfoLabel];
}

/**< 适配*/
- (void)setUpConstraints {
    [self.audioBackground makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.overlayWindow);
        make.width.equalTo(150);
        make.height.equalTo(150);
    }];
    
    [self.recordingView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioBackground).offset(14.f);
        make.centerX.equalTo(self.audioBackground);
        make.width.equalTo(102);
        make.height.equalTo(100);
    }];
    
    [self.microphoneImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recordingView).offset(0);
        make.top.equalTo(self.recordingView).offset(0);
    }];
    
    [self.volumeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.recordingView).offset(0);
        make.top.equalTo(self.recordingView).offset(0);
    }];
    
    [self.infoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioBackground).offset(14.f);
        make.centerX.equalTo(self.audioBackground);
        make.width.equalTo(100);
        make.height.equalTo(100);
    }];
    
    [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioBackground).offset(14.f);
        make.centerX.equalTo(self.audioBackground);
        make.width.equalTo(100);
        make.height.equalTo(100);
    }];
    
    [self.showInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.audioBackground).offset(-12);
        make.left.equalTo(self.audioBackground).offset(8);
        make.right.equalTo(self.audioBackground).offset(-8);
        make.height.equalTo(21);
    }];
}

/**< 展示录音动画*/
- (void)showAudioHUD {
    self.showInfoLabel.text = kVoiceNoteText_ToRecord;
    self.seconds = 0;
    
    self.hidden = NO;
    self.recordingView.hidden = NO;
    self.showInfoLabel.hidden = NO;
    self.showInfoLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.hidden = YES;
    self.infoImageView.hidden = YES;
    
    [self timer];
}

- (void)dismiss {
    self.hidden = YES;
    [self stopTimeCount];
}

/**< 手指移到按钮外面的HUD显示操作*/
- (void)dragExitOperation {
    self.infoImageView.hidden = NO;
    self.showInfoLabel.text = kVoiceNoteText_ToCancel;
    self.showInfoLabel.backgroundColor = kBackgroundColor_DarkRed;
}

/**< 手指移到按钮里面的HUD显示操作*/
- (void)dragEnterOperation {
    self.countLabel.hidden = (kRecordMaxCount - self.seconds > 10.f);
    self.showInfoLabel.text = kVoiceNoteText_ToRecord;
    self.showInfoLabel.backgroundColor = [UIColor clearColor];
    self.recordingView.hidden = !self.countLabel.hidden;
}

/**< 初始化视图状态*/
- (void)initHiddenStyle {
    self.infoImageView.hidden = YES;
    self.recordingView.hidden = YES;
    self.infoImageView.hidden = YES;
}

//展示倒计时10秒时的视图
- (void)showLastTenCountDownView {
    if (self.infoImageView.hidden == YES) {
        self.recordingView.hidden = YES;
        self.countLabel.hidden = NO;
    }
}

//改变音量大小视图
- (void)changeVolumeView:(CGFloat)value {
    NSInteger index = round(value);
    index = index > 8 ? 8 : index;
    index = index < 1 ? 1 : index;
    
    NSString *imageName = [NSString stringWithFormat:@"RecordingSignal00%ld", (long)index];
    self.volumeImageView.image = [UIImage imageNamed:imageName];
}

//计时器响应方法
- (void)timeLoad {
    if (self.seconds < kRecordMaxCount) {
        self.seconds++;
        self.countLabel.text = [NSString stringWithFormat:@"%.f", kRecordMaxCount - self.seconds];
        if (kRecordMaxCount - self.seconds < 10.f) {
            if (kRecordMaxCount - self.seconds == 0) {
                [self dismiss];
            } else {
                [self showLastTenCountDownView];
            }
        }
    } else {
        [self stopTimeCount];
    }
}

//停止计时
- (void)stopTimeCount {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Getters
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeLoad) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIWindow *)overlayWindow {
    if (!_overlayWindow) {
        _overlayWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _overlayWindow;
}

- (UIView *)audioBackground {
    if (!_audioBackground) {
        _audioBackground = [[UIView alloc] init];
        _audioBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        _audioBackground.layer.cornerRadius = 5;
    }
    return _audioBackground;
}

- (UIView *)recordingView {
    if (!_recordingView) {
        _recordingView = [[UIView alloc] init];
    }
    return _recordingView;
}

- (UIImageView *)microphoneImageView {
    if (!_microphoneImageView) {
        _microphoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordingBkg"]];
    }
    return _microphoneImageView;
}

- (UIImageView *)volumeImageView {
    if (!_volumeImageView) {
        _volumeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordingSignal001"]];
    }
    return _volumeImageView;
}

- (UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordCancel"]];
        _infoImageView.hidden = YES;
    }
    return _infoImageView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:80.f];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = @"60";
        _countLabel.hidden = YES;
    }
    return _countLabel;
}

- (UILabel *)showInfoLabel {
    if (!_showInfoLabel) {
        _showInfoLabel = [[UILabel alloc] init];
        _showInfoLabel.textColor = [UIColor whiteColor];
        _showInfoLabel.textAlignment = NSTextAlignmentCenter;
        _showInfoLabel.font = [UIFont systemFontOfSize:14.f];
        _showInfoLabel.text = @"手指上滑，取消发送";
    }
    return _showInfoLabel;
}

@end
