//
//  ChatViewController+ChatCellDelegate.m
//  IMDemo
//
//  Created by 刘峰 on 2019/1/16.
//  Copyright © 2019年 Liufeng. All rights reserved.
//

#import "ChatViewController+ChatCellDelegate.h"
#import "LFPhotoBrowser.h"

@implementation ChatViewController (ChatCellDelegate)

/**
 点击了消息内容
 */
- (void)messageDidTapMessageContent:(ChatCell *)cell {
//    1.获取ChatMessageType->indexPath->ChatBaseMessage
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ChatBaseMessage *message = self.chatViewModel.messages[indexPath.row];
    
    if (message.messageType == ChatMessageTypeImage) {//点击的是图片
        NSArray *filterImageMessages = [self.chatViewModel filterMessageWithType:ChatMessageTypeImage];
        
        NSMutableArray *photos = [NSMutableArray array];
        [filterImageMessages enumerateObjectsUsingBlock:^(ChatImageMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LFPhoto *photo = [LFPhoto new];
            photo.thumbnailImage = obj.image;
            photo.hightQuality = obj.content.bmiddle;
            [photos addObject:photo];
        }];
        
        LFPhotoBrowser *photoBrowser = [[LFPhotoBrowser alloc] init];
        photoBrowser.currentIndex = [filterImageMessages indexOfObject:message];
        photoBrowser.sourceImageView = (UIImageView *)cell.messageView;
        [photoBrowser showByLastViewController:self andPhotos:photos];
    }
}

/**
 点击头像
 */
- (void)messageDidTapAvantar:(ChatCell *)cell {
    
}


@end
