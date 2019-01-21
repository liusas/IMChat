//
//  ChatTextView.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/8.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatTextView.h"
#import "ChatTextParser.h"
#import "EmojiHelper.h"
#import "YYText.h"

@interface ChatTextView ()

@property (weak, nonatomic) IBOutlet YYLabel *textLabel;

@end

@implementation ChatTextView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.autoresizingMask = UIViewAutoresizingNone;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.font = [UIFont systemFontOfSize:14.f];
    
    ChatTextParser *parser = [[ChatTextParser alloc] init];
    parser.emoticonArray = [EmojiHelper share].emojiGroups;
    parser.emotionSize = CGSizeMake(20.f, 20.f);
    parser.alignFont = [UIFont systemFontOfSize:16.f];
    parser.alignment = YYTextVerticalAlignmentBottom;
    self.textLabel.textParser = parser;
    
    //设置固定行高
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    mod.fixedLineHeight = 26;
    self.textLabel.linePositionModifier = mod;
}

#pragma mark - Methods
- (void)setUpViewWithMessage:(ChatTextMessage *)aMessage {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:aMessage.content];

    [self.textLabel.textParser parseText:one
                           selectedRange:NULL];

    one.yy_font = self.textLabel.font;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kMessageViewMaxWidth-36, CGFLOAT_MAX)];
    container.linePositionModifier = self.textLabel.linePositionModifier;

    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:one];
    self.textLabel.textLayout = layout;
    self.contentSize  = CGSizeMake(MIN(MIN(layout.textBoundingSize.width + 36, kMessageViewMaxWidth), self.textLabel.textLayout.textBoundingSize.width + 36), layout.rowCount * [(YYTextLinePositionSimpleModifier *)self.textLabel.linePositionModifier fixedLineHeight]+20);
}



@end
