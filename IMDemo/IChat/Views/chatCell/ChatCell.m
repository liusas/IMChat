//
//  ChatCell.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/5.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatCell.h"
#import "ChatMessage.h"

@implementation ChatCell
@synthesize reuseIdentifier = _reuseIdentifier;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public methods
//根据message配置view
- (void)configCellWithMessage:(ChatBaseMessage *)message {
    
    [self.messageView setUpViewWithMessage:message];
    [self setUpMessageViewConstraints:message.messageType];
    self.messageContentViewWidthConstraint.constant = [self.messageView intrinsicContentSize].width;
    self.messageContentHeightConstraint.constant = [self.messageView intrinsicContentSize].height;

    /** 修复 iOS10 +  layoutSubview  计算contentSize 不准确问题 */
    self.messageContentView.maskView.frame = CGRectMake(0, 0, self.messageContentViewWidthConstraint.constant, self.messageContentHeightConstraint.constant);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//根据消息类型,为messageView添加约束
- (void)setUpMessageViewConstraints:(ChatMessageType)messageType {
    
}

#pragma mark - private methods
//设置约束
- (void)setUp {
    
    if ([self getChatMode] == ChatModeGroup) {//群聊显示昵称
        self.nickNameLabel.hidden = NO;
        self.nickNameHeightConstraint.constant = 20.0f;
    } else {//单聊隐藏昵称
        self.nickNameLabel.hidden = YES;
        self.nickNameHeightConstraint.constant = .0f;
    }
    
    //添加消息视图到messageContentView中,这个消息视图可能是text,image,voice等类型
    ChatMessageView *reuseView = [ChatMessageView messageViewWithMessageType:[self getChatMessageType]];
    [self.messageContentView addSubview:self.messageView = reuseView];
}

//根据reuseIdentifier获取聊天类型
- (ChatMode)getChatMode {
    return [self.reuseIdentifier.lowercaseString containsString:@"group"] ? ChatModeGroup : ChatModeSingle;
}

//根据reuseIdentifier获取消息类型
- (ChatMessageType)getChatMessageType {
    if ([self.reuseIdentifier.lowercaseString containsString:@"system"]) {
        return ChatMessageTypeSystem;
    } else if ([self.reuseIdentifier.lowercaseString containsString:@"text"]) {
        return ChatMessageTypeText;
    } else if ([self.reuseIdentifier.lowercaseString containsString:@"image"]) {
        return ChatMessageTypeImage;
    } else if ([self.reuseIdentifier.lowercaseString containsString:@"voice"]) {
        return ChatMessageTypeVoice;
    } else if ([self.reuseIdentifier.lowercaseString containsString:@"video"]) {
        return ChatMessageTypeVideo;
    } else if ([self.reuseIdentifier.lowercaseString containsString:@"location"]) {
        return ChatMessageTypeLocation;
    } else {
        return ChatMessageTypeUnknow;
    }
}



#pragma mark - Setters
- (void)setReuseIdentifier:(NSString *)reuseIdentifier {
    _reuseIdentifier = [reuseIdentifier copy];
    [self setUp];
}

@end
