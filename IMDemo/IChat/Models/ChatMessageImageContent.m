//
//  ChatMessageImageContent.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/23.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatMessageImageContent.h"

@implementation ChatMessageImageContent

- (instancetype)initWithThunbnail:(NSString *)thumbnail andBmiddle:(nullable NSString *)bmiddle  andImageSize:(CGSize)imageSize {
    if (self = [super init]) {
        _thumbnail = thumbnail;
        _bmiddle = bmiddle;
        _imageSize = imageSize;
    }
    return self;
}

@end
