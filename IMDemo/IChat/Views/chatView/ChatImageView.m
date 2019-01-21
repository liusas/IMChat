//
//  ChatImageView.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/8.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatImageView.h"
#import "YYWebImage.h"
#import "ChatMessage.h"

@interface ChatImageView ()
//图片
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *contentImageView;

@end
@implementation ChatImageView

- (void)setUpViewWithMessage:(ChatImageMessage *)aMessage {
    //先只加载低分辨率图片,在高清图片加载完成或本地图片时thumbnail变成高清图片
    if ([aMessage.content.thumbnail isKindOfClass:[NSString class]]) {//网络图片地址或本地图片地址
        UIImage *image = [[YYWebImageManager sharedManager].cache getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:aMessage.content.thumbnail]]];
        if (image) {//如果有缓存image
            self.contentImageView.image = image;
            self.contentSize = CGSizeMake(image.size.width*3, image.size.height*3);
        } else {//没有缓存image,则根据服务器返回的image的size设置大小
            [self.contentImageView yy_setImageWithURL:[NSURL URLWithString:aMessage.content.thumbnail] placeholder:[UIImage imageNamed:@"加载中"]];
            self.contentSize = aMessage.content.imageSize;
        }
    } else if ([aMessage.content.thumbnail isKindOfClass:[UIImage class]]) {//UIImage对象
        self.contentImageView.image = aMessage.content.thumbnail;
        self.contentSize = aMessage.imageSize;
    } else {
        self.contentImageView.image = [UIImage imageNamed:@"加载中"];
        self.contentSize = CGSizeMake(self.contentImageView.image.size.width, self.contentImageView.image.size.height);
    }
}

@end
