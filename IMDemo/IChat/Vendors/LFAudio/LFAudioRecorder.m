//
//  LFAudioRecorder.m
//  IMDemo
//
//  Created by 刘峰 on 2018/12/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "LFAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface LFAudioRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation LFAudioRecorder

- (instancetype)init {
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
    NSString *recordFilePath = [NSTemporaryDirectory() stringByAppendingString:@"records"];
    if (![fileManager fileExistsAtPath:recordFilePath]) {
        [fileManager createDirectoryAtPath:recordFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *recordFile = [recordFilePath stringByAppendingString:@"myRecord.wav"];
    
    NSDictionary *setting = @{
                              AVFormatIDKey: @(kAudioFormatLinearPCM),//音频格式
                              AVSampleRateKey: @8000,//采样率
                              AVLinearPCMBitDepthKey: @16,
                              AVNumberOfChannelsKey:@1
                              };
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:recordFile]
                                                     settings:setting
                                                        error:nil];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    
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
    
}

#pragma mark - AVAuidoRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
}

#pragma mark - Getters
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        
    }
    return _audioRecorder;
}


@end
