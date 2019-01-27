//
//  LFAudioRecorder.m
//  IMDemo
//
//  Created by 刘峰 on 2018/12/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "LFAudioRecorder.h"
#import "amr_wav_converter.h"

static NSInteger const bitDepth = 16;//采样深度,影响声音质量
static NSInteger const channels = 1;//1单声道2双声道

@interface LFAudioRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, copy) NSString *wavRecorderUrl;/**< 录制的wav的url*/
@property (nonatomic, copy) NSString *amrRecorderUrl;/**< wav转amr的url*/
@property (nonatomic, strong) NSTimer *timer;/**< 录音声波大小计时器*/
@property (nonatomic, assign) BOOL ifCancelRecording;/**< 判断是否取消录音*/

@end

@implementation LFAudioRecorder

- (id)init {
    if (self = [super init]) {
        NSError *sessionError;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if (sessionError) {
            NSLog(@"音频会话创建错误: %@", [sessionError description]);
        } else {
            //激活会话
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
    }
    return self;
}


/**
 配置录音机
 */
- (void)setUpRecorder {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:PATH_OF_RECORD_FILE]) {
        [fileManager createDirectoryAtPath:PATH_OF_RECORD_FILE withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //先录制wav类型的音频
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.wavRecorderUrl = [NSString stringWithFormat:@"%@/myRecord%.0f.wav", PATH_OF_RECORD_FILE, timeInterval];
    NSLog(@"%@=====", self.wavRecorderUrl);
    NSDictionary *setting = @{
                              AVFormatIDKey: @(kAudioFormatLinearPCM),//音频格式
                              AVSampleRateKey: @8000,//采样率
                              AVLinearPCMBitDepthKey: @(bitDepth),//采样深度,影响声音质量
                              AVNumberOfChannelsKey:@(channels)//1单声道2双声道
                              };
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.wavRecorderUrl]
                                                     settings:setting
                                                        error:nil];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    
    /* creates the file and gets ready to record. happens automatically on record. */
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
    
    self.isRecording = YES;
    self.timer.fireDate = [NSDate distantPast];//启动定时器
}

/**
 开始录音
 */
- (void)startRecording {
    [self setUpRecorder];
}

/**
 停止录音
 */
- (void)stopRecording {
    [self.audioRecorder stop];
    self.timer.fireDate = [NSDate distantFuture];//停止定时器
}

/**
 取消录音
 */
- (void)cancelRecording {
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
    self.timer.fireDate = [NSDate distantFuture];//停止定时器
    self.ifCancelRecording = YES;
}

/**
 判断设备当前是否在录音

 @return 返回Yes or No
 */
- (BOOL)getIfRecording {
    return [self.audioRecorder isRecording];
}


/**
 录音音波变化监控
 */
- (void)audioPowerChange {
    [self.audioRecorder updateMeters];
    float power = [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频,音频强度为-160~0
    CGFloat progress = (1.0/20.0)*(power+160);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPickSpeckPowerWithRecorder:power:)]) {
        [self.delegate didPickSpeckPowerWithRecorder:self.audioRecorder power:ceil(progress)];
    }
}

#pragma mark - AVAuidoRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    if (self.ifCancelRecording) {//如果取消录音则不进行格式转换和发送消息等操作
        return;
    }
    
    NSString *wavToAmrUrl = [self.wavRecorderUrl stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
    int frames = wave_file_to_amr_file([self.wavRecorderUrl cStringUsingEncoding:NSASCIIStringEncoding], [wavToAmrUrl cStringUsingEncoding:NSASCIIStringEncoding], 1, 16);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager copyItemAtPath:wavToAmrUrl toPath:self.wavRecorderUrl error:nil];
    [fileManager removeItemAtPath:self.wavRecorderUrl error:nil];
    NSLog(@"duration = %f", (double)frames * 20.0 / 1000.0);
    NSLog(@"outPutURL = %@", wavToAmrUrl);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishRecordWithRecorder:recordingPath:duration:)]) {
        [self.delegate didFinishRecordWithRecorder:recorder recordingPath:wavToAmrUrl duration:(double)frames * 20.0 / 1000.0];
    }
}

#pragma mark - Getters
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        
    }
    return _audioRecorder;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


@end
