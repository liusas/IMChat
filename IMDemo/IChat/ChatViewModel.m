//
//  ChatViewModel.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/3.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatViewModel.h"
#import "UITableView+cellRegister.h"

#import "ChatOwnCell.h"
#import "ChatOtherCell.h"
#import "ChatSystemCell.h"

#import "ChatMessage.h"
#import "MessageBaseClass.h"
#import "ChatMessageImageContent.h"

@interface ChatViewModel ()

@property (nonatomic, strong) NSMutableArray<ChatBaseMessage *> *messages;
@property (nonatomic, assign) ChatMode chatMode;

@end

@implementation ChatViewModel

- (instancetype)initWithChatMode:(ChatMode)chatMode {
    if (self = [super init]) {
        _chatMode = chatMode;
        _messages = [NSMutableArray array];
        [self initData];
    }
    return self;
}

//初始化数据
- (void)initData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"json"];
    NSString *parseJson = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [parseJson dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //这里可以替换成自己的消息model
        MessageBaseClass *messageModel = [MessageBaseClass modelObjectWithDictionary:obj];
        if ([messageModel.type isEqualToString:@"text"]) {
            ChatTextMessage *textMessage = [[ChatTextMessage alloc] initWithContent:messageModel.text state:ChatMessageStateSuccess owner:idx%2==0 ? ChatOwnerSelf : ChatOwnerOther chatMode:ChatModeSingle];
            [self.messages addObject:textMessage];
        } else if ([messageModel.type isEqualToString:@"image"]) {
            //图片的content类型(thumbnail缩略图, bmiddle高清图, imageSize图片尺寸)
            ChatMessageImageContent *content = [[ChatMessageImageContent alloc] initWithThunbnail:messageModel.thumbnail andBmiddle:messageModel.bmiddle andImageSize:CGSizeMake(messageModel.width.floatValue, messageModel.height.floatValue)];
            
            ChatImageMessage *imageMessage = [[ChatImageMessage alloc] initWithContent:content state:ChatMessageStateSuccess owner:idx%2 == 0 ? ChatOwnerSelf : ChatOwnerOther chatMode:ChatModeSingle];
            
            [self.messages addObject:imageMessage];
        }
    }];
}

- (void)sendMessage:(ChatBaseMessage *)message {
    [self.messages addObject:message];
}

/**
 根据消息的数据类型返回相应的数组
 
 @param messageType 消息类型image,text,voice,video等
 @return 对应消息类型的消息数组
 */
-(NSArray<ChatBaseMessage *> *)filterMessageWithType:(ChatMessageType)messageType {
    return [self.messages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"messageType = %ld", (long)messageType]]];
}

/**
 根据图片在图片浏览器中的index索引找出整个tableView对应的indexPath
 从而找到图片当前点击的cell
 
 @param index 图片在图片浏览器中的索引
 @return 返回cell对应的indexPath
 */
- (NSIndexPath *)getIndexPathFromImageMessageIndex:(NSInteger)index {
    NSArray *photos = [self filterMessageWithType:ChatMessageTypeImage];
    NSInteger cellIndex = [self.messages indexOfObject:photos[index]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    return indexPath;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatBaseMessage *message = self.messages[indexPath.row];
    NSString *identifier = [tableView cellForIdentiferWithMessage:message];
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = (id<ChatCellDelegate>)self.chatVC;
    [cell configCellWithMessage:message];
    return cell;
}


@end
