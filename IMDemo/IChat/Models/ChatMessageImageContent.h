//
//  ChatMessageImageContent.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/23.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageImageContent : NSObject

//低分辨率图片,可以是字符串,url,图片地址,UIImage
@property (nonatomic, strong) id thumbnail;
//高分辨率图片
@property (nonatomic, copy) id bmiddle;
//图片大小
@property (nonatomic, assign) CGSize imageSize;


/**
 将图片数据传进model

 @param thumbnail 缩略图
 @param bmiddle 高清图
 @param imageSize 图片尺寸
 @return 返回model实例
 */
- (instancetype)initWithThunbnail:(id)thumbnail andBmiddle:(nullable id)bmiddle andImageSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END
