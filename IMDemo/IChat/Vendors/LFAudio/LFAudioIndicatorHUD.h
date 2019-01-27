//
//  LFAudioIndicatorHUD.h
//  IMDemo
//
//  Created by 刘峰 on 2018/12/25.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFAudioIndicatorHUD : UIView

/**< 单例*/
+ (instancetype)shared;

+ (void)show;

+ (void)hideAllHUD;


/**
 针对手势不同处理录音动画

 @param recordType 录音
 */
+ (void)currentTypeForOperation:(ChatBarRecordType)recordType;


/**
 改变录音动画上的音量大小

 @param value 音量大小
 */
+ (void)updateVolumeValue:(int)value;
@end

NS_ASSUME_NONNULL_END
