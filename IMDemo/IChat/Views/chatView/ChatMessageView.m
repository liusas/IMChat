//
//  ChatMessageView.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/5.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatMessageView.h"

@implementation ChatMessageView

- (CGSize)intrinsicContentSize {
    return self.contentSize;
}

+ (ChatMessageView *)messageViewWithMessageType:(ChatMessageType)messageType {
    UINib *nib = [UINib nibWithNibName:[self messageViewIdentifierForMessageType:messageType] bundle:nil];
    return [[nib instantiateWithOwner:self options:nil] lastObject];
}

+ (NSString *)messageViewIdentifierForMessageType:(ChatMessageType)messageType {
    switch (messageType) {
        case ChatMessageTypeText:
            return @"ChatTextView";
            break;
        case ChatMessageTypeImage:
            return @"ChatImageView";
            break;
        case ChatMessageTypeVoice:
            return @"ChatVoiceView";
            break;
        case ChatMessageTypeVideo:
            return @"ChatVideoView";
            break;
        case ChatMessageTypeLocation:
            return @"ChatLocationView";
            break;
        default:
            return @"ChatUnknowView";
            break;
    }
}


//添加数据
- (void)setUpViewWithMessage:(ChatBaseMessage *)aMessage {
    
}

#pragma mark - Setters
- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
}

@end
