//
//  LFAudioPlayer.m
//  IMDemo
//
//  Created by 刘峰 on 2019/1/1.
//  Copyright © 2019年 Liufeng. All rights reserved.
//

#import "LFAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "amr_wav_converter.h"
#import <objc/runtime.h>

AVAudioPlayer *audioPlayer;//全局变量才好用,谁知道怎么回事儿
@interface LFAudioPlayer ()

@end

@implementation LFAudioPlayer

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)stopPlaying {
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
    }
}

- (void)setSpeakMode:(BOOL)speakMode {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        AVAudioSessionPortOverride portOverride = speakMode ? AVAudioSessionPortOverrideSpeaker : AVAudioSessionPortOverrideNone;
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:portOverride error:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UInt32 route = speakMode ? kAudioSessionOverrideAudioRoute_Speaker : kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
#pragma clang diagnostic pop
        
    }
}

- (void)playWithUrl:(NSURL *)fileUrl {
    NSString *amrPath = fileUrl.absoluteString;
    NSString *wavPath = [amrPath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:wavPath]) {
        amr_file_to_wave_file([amrPath cStringUsingEncoding:NSASCIIStringEncoding], [wavPath cStringUsingEncoding:NSASCIIStringEncoding]);
        [fileManager removeItemAtPath:amrPath error:nil];
    }

    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:wavPath] error:nil];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
 
}

@end
