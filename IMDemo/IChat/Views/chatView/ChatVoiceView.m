//
//  ChatVoiceView.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/8.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatVoiceView.h"

@interface ChatVoiceView ()

/**< 语音播放图片*/
@property (weak, nonatomic) IBOutlet UIImageView *playingImageView;
/**< 加载语音的指示圈*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadVoiceIndicator;
@end

@implementation ChatVoiceView

- (void)setUpViewWithMessage:(ChatVoiceMessage *)aMessage {
    
    [self.loadVoiceIndicator stopAnimating];
    
    if (aMessage.ownerType == ChatOwnerSelf) {
        self.playingImageView.contentMode = UIViewContentModeRight;
        self.playingImageView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
    } else if (aMessage.ownerType == ChatOwnerOther) {
        self.playingImageView.contentMode = UIViewContentModeLeft;
        self.playingImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    }
    
    self.contentSize = CGSizeMake(75 + 2.5 * aMessage.voiceTime, kVoiceMessageViewHeight);
}

//设置语音播放动画的图片数组
- (NSArray *)setAnimationImages:(ChatOwnerType)ownerType {
    NSMutableArray *playingImageArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        if (ownerType == ChatOwnerSelf) {
            [playingImageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%ld", i]]];
        } else if (ownerType == ChatOwnerOther) {
            [playingImageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%ld", i]]];
        }
    }
    return playingImageArr;
}

@end
