//
//  LFAudioRecorder.h
//  IMDemo
//
//  Created by 刘峰 on 2018/12/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LFAudioEncoderType) {
    LFAudioEncoderTypeCAF = 0,/**< 录音格式为caf*/
    LFAudioEncoderTypeAmr,/**< 录音格式为amr*/
    LFAudioEncoderTypeMP3,/**< 录音格式为MP3*/
};

@interface LFAudioRecorder : NSObject


/**
 录音的采样率 默认8000(电话的采样率),
 想要转换为AMR格式的话,采样率必须为8000,
 其他采样率有8000/11025/22050/44100/96000,采样率越高,录音质量越高
 */
@property (nonatomic, assign) NSUInteger samplate;



/**
 开始录音
 */
- (void)startRecording;

/**
 停止录音
 */
- (void)stopRecording;

@end

NS_ASSUME_NONNULL_END
