//
//  ChatMoreItem.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatMoreItem.h"

@interface ChatMoreItem ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ChatMoreItem

- (id)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

/**
 初始化
 */
- (void)setUp {
    [self addSubview:self.button];
    [self addSubview:self.titleLabel];
    
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.centerX.equalTo(self);
        make.height.equalTo(50);
        make.width.equalTo(50);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(8);
        make.centerX.equalTo(self);
    }];
}

- (void)configMoreItemWithImageName:(NSString *)imageName andTitle:(NSString *)title {
    [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.titleLabel.text = title;
}

//按钮点击事件
- (void)buttonClick {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Getters
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
    return _titleLabel;
}

@end
