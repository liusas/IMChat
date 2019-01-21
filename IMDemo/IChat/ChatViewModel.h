//
//  ChatViewModel.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/3.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChatServer.h"

@class ChatViewController;
@class ChatBaseMessage;
@interface ChatViewModel : NSObject <UITableViewDataSource>

/**
 NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END之间的属性都具有nullable的特征,nullable可以用来修饰属性,方法参数,方法返回值
 */
@property (nonatomic, weak, nullable) ChatViewController *chatVC;

/**
 存放数据源
 */
@property (nonatomic, strong, readonly, nonnull) NSMutableArray<ChatBaseMessage *> *messages;

/**
 *  chatVM的会话类型
 */
@property (nonatomic, assign, readonly) ChatMode chatMode;

- (instancetype)initWithChatMode:(ChatMode)chatMode;

- (void)sendMessage:(ChatBaseMessage *)message;


/**
 根据消息的数据类型返回相应的数组

 @param messageType 消息类型image,text,voice,video等
 @return 对应消息类型的消息数组
 */
- (NSArray<ChatBaseMessage *> *_Nonnull)filterMessageWithType:(ChatMessageType)messageType;


/**
 根据图片在图片浏览器中的index索引找出整个tableView对应的indexPath
 从而找到图片当前点击的cell

 @param index 图片在图片浏览器中的索引
 @return 返回cell对应的indexPath
 */
- (NSIndexPath *)getIndexPathFromImageMessageIndex:(NSInteger)index;

@end
