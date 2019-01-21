//
//  ChatCell.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/5.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageView.h"
#import "ChatStateView.h"

@class ChatBaseMessage;
@protocol ChatCellDelegate;
@interface ChatCell : UITableViewCell

@property (nonatomic, weak) id<ChatCellDelegate> delegate;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//消息框的背景视图
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//聊天消息的view
@property (weak, nonatomic) IBOutlet UIView *messageContentView;
//消息状态
@property (weak, nonatomic) IBOutlet ChatStateView *chatStateView;

@property (nonatomic, strong) ChatMessageView *messageView;
//昵称高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameHeightConstraint;
//消息内容宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContentViewWidthConstraint;
//消息内容高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContentHeightConstraint;

//根据数据创建messageContentView上的UI
- (void)setUp;
//传递cell的数据
- (void)configCellWithMessage:(ChatBaseMessage *)message;
//根据消息类型,为messageView添加约束
- (void)setUpMessageViewConstraints:(ChatMessageType)messageType;
@end

@protocol ChatCellDelegate <NSObject>

/**
 点击头像
 */
- (void)messageDidTapAvantar:(ChatCell *)cell;

/**
 点击了图片消息
 */
- (void)messageDidTapMessageContent:(ChatCell *)cell;

@end
