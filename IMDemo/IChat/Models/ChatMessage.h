//
//  ChatMessage.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/7.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageImageContent.h"

@interface ChatBaseMessage : NSObject
/**
 消息状态
 */
@property (nonatomic, assign) ChatMessageState messageState;
/**
 消息附加状态
 */
@property (nonatomic, assign) ChatMessageSubState messageSubstate;
/**
 消息拥有者类型ownerSelf,ownerOther,ownerSystem
 */
@property (nonatomic, assign) ChatOwnerType ownerType;
/**
 消息类型text,voice,image,video,location,card
 */
@property (nonatomic, assign) ChatMessageType messageType;
/**
 聊天类型,single,group
 */
@property (nonatomic, assign) ChatMode chatMode;

//消息发送时间
@property (nonatomic, assign) NSTimeInterval time;
//消息内容
@property (nonatomic, strong, readonly) id content;
//消息拥有者头像
@property (nonatomic, copy) NSString *avatarUrl;
//消息拥有者姓名
@property (nonatomic, copy) NSString *nickName;


/**
 实例化ChatMessage实例
 @param content 消息内容
 @param messageState 消息类型
 @param owner 消息拥有者
 @param chatMode 聊天类型
 @return 实例
 */
- (instancetype)initWithContent:(id)content
                          state:(ChatMessageState)messageState
                          owner:(ChatOwnerType)owner
                       chatMode:(ChatMode)chatMode;

/**
 实例化ChatMessage实例
 
 @param content 消息内容
 @param messageState 消息类型
 @param owner 消息拥有者
 @param chatMode 聊天类型
 @param aTime 发送时间
 @return 实例
 */
- (instancetype)initWithContent:(id)content
                          state:(ChatMessageState)messageState
                           owner:(ChatOwnerType)owner
                        chatMode:(ChatMode)chatMode
                           time:(NSTimeInterval)aTime;

@end

@interface ChatSystemMessage: ChatBaseMessage

@property (nonatomic, strong, readonly) NSString *content;

@end

@interface ChatTextMessage: ChatBaseMessage

@property (nonatomic, strong, readonly) NSString *content;

@end

@interface ChatImageMessage: ChatBaseMessage

//图片,可以是字符串,url,图片地址,UIImage
@property (nonatomic, strong) ChatMessageImageContent *content;
//图片地址
@property (nonatomic, copy) NSString *imagePath;
//图片对象
@property (nonatomic, strong) UIImage *image;
//图片大小
@property (nonatomic, assign) CGSize imageSize;

@end

@interface ChatVoiceMessage: ChatBaseMessage
//语音,可以是字符串,url,语音地址,或NSData型
@property (nonatomic, strong) id content;
@property (nonatomic, assign) CGFloat voiceTime;

@end

@interface ChatVideoMessage: ChatBaseMessage
@end

@interface ChatLocationMessage: ChatBaseMessage
@end
