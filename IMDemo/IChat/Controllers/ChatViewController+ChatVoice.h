//
//  ChatViewController+ChatVoice.h
//  IMDemo
//
//  Created by 刘峰 on 2019/1/22.
//  Copyright © 2019年 Liufeng. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController (ChatVoice)

/**
 播放录音

 @param message 录音消息对象
 */
- (void)playRecordWithMessage:(ChatVoiceMessage *)message;

@end

NS_ASSUME_NONNULL_END
