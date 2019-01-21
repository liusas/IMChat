//
//  ChatMessageView.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/5.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"
#import "MessageBaseClass.h"

@interface ChatMessageView : UIView

@property (nonatomic, assign) CGSize contentSize;

- (void)setUpViewWithMessage:(ChatBaseMessage *)aMessage;

+ (ChatMessageView *)messageViewWithMessageType:(ChatMessageType)messageType;
@end
