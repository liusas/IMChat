//
//  ChatSystemCell.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/5.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatSystemCell.h"

@interface ChatSystemCell ()

@property (weak, nonatomic) IBOutlet UIButton *systemTitleButton;

@end

@implementation ChatSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
