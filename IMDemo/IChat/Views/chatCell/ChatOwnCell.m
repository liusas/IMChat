//
//  ChatOwnCellCell.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/5.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatOwnCell.h"

@implementation ChatOwnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backgroundImageView setImage:[[UIImage imageNamed:@"message_sender_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24) resizingMode:UIImageResizingModeStretch]];
    [self.backgroundImageView setHighlightedImage:[[UIImage imageNamed:@"message_sender_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24) resizingMode:UIImageResizingModeStretch]];
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:self.backgroundImageView.image highlightedImage:self.backgroundImageView.highlightedImage];
    
    self.messageContentView.maskView = maskImageView;
    self.messageContentViewWidthConstraint.constant = kMessageViewMaxWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpMessageViewConstraints:(ChatMessageType)messageType {
    [self.messageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageContentView.left).offset(messageType == ChatMessageTypeImage ? 0 : 16);
        make.right.equalTo(self.messageContentView.right).offset(messageType == ChatMessageTypeImage ? 0 : -12);
        make.top.equalTo(self.messageContentView.top).offset(messageType == ChatMessageTypeImage ? 0 : 6);
        make.bottom.equalTo(self.messageContentView.bottom).offset(messageType == ChatMessageTypeImage ? 0 : -16);
    }];
}

@end
