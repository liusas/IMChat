//
//  ChatViewController.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/3.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatViewModel.h"

@interface ChatViewController : UIViewController

@property (nonatomic, strong) ChatViewModel<UITableViewDataSource> *chatViewModel;

@property (nonatomic, assign, readonly) ChatMode chatMode;
@property (nonatomic, strong) UITableView *tableView;/**< 消息列表*/

- (instancetype)initWithChatMode:(ChatMode)chatMode;

- (void)setUpUI;

- (void)scrollToBottom;

- (void)setUpConstraints;

- (void)setUpGestures;

- (void)getNotificationAndObserver;

@end
