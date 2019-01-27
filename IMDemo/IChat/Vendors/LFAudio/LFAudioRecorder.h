//
//  LFAudioRecorder.h
//  IMDemo
//
//  Created by 刘峰 on 2018/12/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LFAudioEncoderType) {
    LFAudioEncoderTypeCAF = 0,/**< 录音格式为caf*/
    LFAudioEncoderTypeAmr,/**< 录音格式为amr*/
    LFAudioEncoderTypeMP3,/**< 录音格式为MP3*/
};

@protocol LFAudioRecorderDelegate <NSObject>


/**
 录音音波变化

 @param recorder 录音对象
 @param power 音波强度
 */
- (void)didPickSpeckPowerWithRecorder:(AVAudioRecorder *)recorder power:(int)power;

/**
 录音完成的回调

 @param recorder 录音对象
 @param recordingPath 录音地址
 @param duration 录音时长
 */
- (void)didFinishRecordWithRecorder:(AVAudioRecorder *)recorder recordingPath:(NSString *)recordingPath duration:(CGFloat)duration;

@end

@interface LFAudioRecorder : NSObject

@property (nonatomic, weak) id<LFAudioRecorderDelegate> delegate;

/**
 录音的采样率 默认8000(电话的采样率),
 想要转换为AMR格式的话,采样率必须为8000,
 其他采样率有8000/11025/22050/44100/96000,采样率越高,录音质量越高
 */
@property (nonatomic, assign) NSUInteger samplate;


/**
 判断是否正在录音
 */
@property (nonatomic, assign, getter=getIfRecording) BOOL isRecording;


/**
 开始录音
 */
- (void)startRecording;

/**
 停止录音
 */
- (void)stopRecording;

/**
 取消录音
 */
- (void)cancelRecording;

@end

NS_ASSUME_NONNULL_END
