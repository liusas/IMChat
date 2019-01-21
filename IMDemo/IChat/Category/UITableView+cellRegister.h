//
//  UITableView+cellRegister.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/15.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface UITableView (cellRegister)
/**
 *  注册cell,cell的类型分为如下几种:
 *  消息拥有者(自己,别人,系统),
 *  聊天类型(单聊,群聊),
 *  消息类型(文本,语音,图片,视频,位置,名片等)
 */
- (void)registerChatCell;

- (NSString *)cellForIdentiferWithMessage:(ChatBaseMessage *)message;

@end
