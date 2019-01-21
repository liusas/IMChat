//
//  ChatTextParser.h
//  IMDemo
//
//  Created by 刘峰 on 2018/12/7.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYText.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatTextParser : NSObject <YYTextParser>

//@property (nullable, copy) NSDictionary<NSString *, __kindof UIImage *> *emoticonMapper;
@property (nonatomic, copy) NSArray *emoticonArray;

@property (nonatomic, assign) CGSize emotionSize;
@property (nonatomic, copy, nonnull)   UIFont *alignFont;

/** 是否解析link */
@property (nonatomic, assign) BOOL parseLinkEnabled;

@property (nonatomic, assign) YYTextVerticalAlignment alignment;

@end

NS_ASSUME_NONNULL_END
