//
//  EmojiHelper.h
//  IMDemo
//
//  Created by 刘峰 on 2018/12/2.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYWebImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmojiHelper : NSObject

/**
 表情组,包括系统自带表情和自定义表情
 
 @return 返回类型数组
 */
@property (nonatomic, strong) NSMutableArray *emojiGroups;

+ (instancetype)share;

/**
 图片缓存
 */
- (YYMemoryCache *)imageCache;


/**
 根据图片名字获取图片
 */
- (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
