//
//  ChatViewController+ChatVoice.m
//  IMDemo
//
//  Created by 刘峰 on 2019/1/22.
//  Copyright © 2019年 Liufeng. All rights reserved.
//

#import "ChatViewController+ChatVoice.h"
#import "ChatBar.h"
#import "LFAudioRecorder.h"
#import "LFAudioPlayer.h"
#import "LFAudioIndicatorHUD.h"

@interface ChatViewController () <LFAudioRecorderDelegate>

@end

@implementation ChatViewController (ChatVoice)

#pragma mark 录音状态的KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"recordType"]) {
        ChatBar *chatBar = object;
        [LFAudioIndicatorHUD currentTypeForOperation:chatBar.recordType];
        [self recordingOperationWithRecordType:chatBar.recordType];
    }
}


/**
 根据录音类型recordType执行不同的操作

 @param recordType 录音类型
 */
- (void)recordingOperationWithRecordType:(ChatBarRecordType)recordType {
    switch (recordType) {
        case ChatBarRecording:[self handleRecording];//开始录音
            break;
        case ChatBarRecordFinish:[self handleRecordFinish];//录音完成
            break;
        case ChatBarRecordCancel:[self handleRecordCancel];//取消录音
            break;
        case ChatBarRecordDragEnter:
            break;
        case ChatBarRecordDragExit:
            break;
        case ChatBarRecordTooLong:[self handleRecordFinish];//当时间超出最长录制时间时,自动结束录音
            break;
        case ChatBarRecordTooShort:[self handleRecordCancel];//录音时间太短,取消录音
        default:[LFAudioIndicatorHUD hideAllHUD];
            break;
    }
}


/**
 开始录音
 */
- (void)handleRecording {
    self.recorder = [[LFAudioRecorder alloc] init];
    self.recorder.delegate = self;
    [self.recorder startRecording];
}


/**
 录音完成
 */
- (void)handleRecordFinish {
    [self.recorder stopRecording];
}


/**
 取消录音
 */
- (void)handleRecordCancel {
    [self.recorder cancelRecording];
}

- (void)playRecordWithMessage:(ChatVoiceMessage *)message {
    LFAudioPlayer *audioPlayer = [[LFAudioPlayer alloc] init];
    [audioPlayer playWithUrl:[NSURL URLWithString:message.content]];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

//- (void)didFinishRecordWithRecorder:(AVAudioRecorder *)recorder recordingPath:(NSString *)recordingPath duration:(CGFloat)duration {
//    
//}

#pragma clang diagnostic pop

@end
