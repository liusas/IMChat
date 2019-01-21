//
//  ChatBar.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/25.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "ChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChatBarDelegate <NSObject>
/**< 根据不同的操作显示不同的view*/
- (void)chatBarShowViewDidChanged:(ChatShowingView)chatShowType;

/**< 发送文本消息*/
- (void)chatBarSendTextMessage:(ChatTextMessage *)message;
@end

@protocol ChatBarRecordDelegate <NSObject>
/**< 录音状态改变*/
- (void)chatBarRecordTypeChanged:(ChatBarRecordType)chatBarRecordType;

@end

@interface ChatBar : UIView

@property (nonatomic, strong) YYTextView *textView;/**< 输入框 */
@property (nonatomic, weak) id<ChatBarDelegate> chatBarDelegate;
@property (nonatomic, weak) id<ChatBarRecordDelegate> ChatBarRecordDelegate;
@property (nonatomic, assign) ChatBarRecordType recordType;/**< 录音类型*/

/**
 重置聊天工具栏按钮的状态
 */
- (void)resetChatBarButtonStatus;

@end

NS_ASSUME_NONNULL_END
