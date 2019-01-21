//
//  EmojiHelper.m
//  IMDemo
//
//  Created by 刘峰 on 2018/12/2.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "EmojiHelper.h"
#import "EmojiModel.h"

@implementation EmojiHelper

+ (instancetype)share {
    static EmojiHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        
        NSString *qqEmojiPath = [[NSBundle mainBundle] pathForResource:@"QQIcon" ofType:@"bundle"];
        NSString *emoticonPlistPath = [qqEmojiPath stringByAppendingPathComponent:@"info.plist"];
        NSArray *emoticons = [NSArray arrayWithContentsOfFile:emoticonPlistPath];
        
        [emoticons enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *pngDic = [NSMutableDictionary dictionary];
            NSString *imagePath = [qqEmojiPath stringByAppendingPathComponent:[obj.allValues[0] stringByAppendingString:@"@2x.png"]];
            
            YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
            pngDic[obj.allKeys[0]] = image;
            [self.emojiGroups addObject:pngDic];
           
//            EmojiModel *emotion = [EmojiModel new];
//            emotion.emotionKey = obj.allKeys.firstObject;
//            emotion.emotionValue = image;
//            [self.emojiGroups addObject:emotion];
        }];
    }
    return self;
}

- (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"IMImageCache";
    });
    return cache;
}

- (NSString *)pathComponent:(NSString *)name ofType:(NSString *)ext {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"QQIcon" ofType:@"bundle"];
    return [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", name, ext]];
}

- (UIImage *)imageNamed:(NSString *)name {
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (!ext.length) ext = @"png";
    image = [UIImage imageWithContentsOfFile:[self pathComponent:name ofType:ext]];
    [[self imageCache] setObject:image forKey:name];
    return image;
}

#pragma mark - Getters
- (NSArray *)emojiGroups {
    if (!_emojiGroups) {
        _emojiGroups = [NSMutableArray array];
    }
    return _emojiGroups;
}
@end
