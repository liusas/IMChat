//
//  UITableView+cellRegister.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/15.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "UITableView+cellRegister.h"
#import "ChatOwnCell.h"
#import "ChatOtherCell.h"
#import "ChatSystemCell.h"

@implementation UITableView (cellRegister)

/**
 *  注册cell,cell的类型分为如下几种:
 *  消息拥有者(自己,别人,系统),
 *  聊天类型(单聊,群聊),
 *  消息类型(文本,语音,图片,视频,位置,名片等)
 */
- (void)registerChatCell {
    
    NSArray *ownerArr = @[@"ownerSelf", @"ownerOther", @"ownerSystem"];
    NSArray *chatTypeArr = @[@"single", @"group"];
    NSArray *messageTypeArr = @[@"system", @"text", @"image", @"voice", @"video", @"location", @"card"];
    
    for (NSString *ownerStr in ownerArr) {
        NSString *owndentifier = [NSString stringWithFormat:@"kChat_%@", ownerStr];
        for (NSString *chatTypeStr in chatTypeArr) {
            NSString *chatDentifier = [NSString stringWithFormat:@"%@_%@", owndentifier, chatTypeStr];
            for (NSString *messageTypeStr in messageTypeArr) {
                NSString *messageDentifier = [NSString stringWithFormat:@"%@_%@", chatDentifier, messageTypeStr];
                [self registerNib:[UINib nibWithNibName:[self cellNameWithIdentifer:messageDentifier] bundle:nil] forCellReuseIdentifier:messageDentifier];
            }
        }
    }
}

//根据唯一标识确定cell名称
- (NSString *)cellNameWithIdentifer:(NSString *)identifier {
    NSString *cellName = @"ChatOtherCell";//默认是别人发的
    if ([identifier containsString:@"ownerSelf"]) {//自己
        cellName = @"ChatOwnCell";
    } else if ([identifier containsString:@"ownerOther"]) {//别人
        cellName = @"ChatOtherCell";
    } else if ([identifier containsString:@"ownerSystem"]) {//系统
        cellName = @"ChatSystemCell";
    }
    return cellName;
}

//根据message内容确定使用什么identifier
- (NSString *)cellForIdentiferWithMessage:(ChatBaseMessage *)message {
    NSArray *ownerArr = @[@"ownerSelf", @"ownerOther", @"ownerSystem"];
    NSArray *chatTypeArr = @[@"single", @"group"];
    NSArray *messageTypeArr = @[@"system", @"text", @"image", @"voice", @"video", @"location", @"card"];
    
    NSString *ownerStr = ownerArr[message.ownerType];//消息拥有者
    NSString *chatTypeStr = chatTypeArr[message.chatMode];//聊天类型
    NSString *messageTypeStr = messageTypeArr[message.messageType];//消息类型
    
    return [NSString stringWithFormat:@"kChat_%@_%@_%@", ownerStr, chatTypeStr, messageTypeStr];
}

@end
