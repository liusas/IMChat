//
//  ChatMessage.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/7.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatMessage.h"
#import "YYWebImage.h"

@implementation ChatBaseMessage

- (instancetype)initWithContent:(id)content
                          state:(ChatMessageState)messageState
                          owner:(ChatOwnerType)owner
                       chatMode:(ChatMode)chatMode {
    return [self initWithContent:content
                           state:messageState
                           owner:owner
                        chatMode:chatMode
                            time:[[NSDate date] timeIntervalSince1970]];
}

- (instancetype)initWithContent:(id)content
                          state:(ChatMessageState)messageState
                          owner:(ChatOwnerType)owner
                       chatMode:(ChatMode)chatMode
                           time:(NSTimeInterval)aTime {
    if (self = [super init]) {
        _content = content;
        _messageState = messageState;
        _ownerType = owner;
        _chatMode = chatMode;
        _time = aTime;
    }
    return self;
}

@end

@implementation ChatSystemMessage
@dynamic content;

- (ChatMessageType)messageType {
    return ChatMessageTypeSystem;
}

@end

@implementation ChatTextMessage
@dynamic content;

- (ChatMessageType)messageType {
    return ChatMessageTypeText;
}

@end

@implementation ChatImageMessage
@dynamic content;

//消息类型messageType的getter方法
- (ChatMessageType)messageType {
    return ChatMessageTypeImage;
}

- (UIImage *)image {
    
    if (_image) {
        return _image;
    }
    
    if ([self.content.thumbnail isKindOfClass:[NSString class]]) {//网络图片地址或本地图片地址
        UIImage *image = [[YYWebImageManager sharedManager].cache getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.content.thumbnail]]];
        if (image) {//如果有缓存image
            return image;
        }
    } else if ([self.content.thumbnail isKindOfClass:[UIImage class]]) {//UIImage对象
        return self.content.thumbnail;
    } else {
        return [UIImage imageNamed:@"加载中"];
    }
    
    return nil;//返回nil时表示thumbnail图片是别人发来的新图片地址
}

//图片size大小
- (CGSize)imageSize {
    if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
        if (self.image) {
            CGFloat width = self.image.size.width;
            CGFloat height = self.image.size.height;
            CGFloat maxWidth = kMessageViewMaxWidth;
            if (height > width) {
                maxWidth = 80.f;
            } else {
                maxWidth = 140.f;
            }
            return CGSizeMake(MIN(width, maxWidth), (MIN(width, maxWidth)*height/width));
        } else {
            return self.content.imageSize;//没有缓存image,则根据服务器返回的image的size设置大小
        }
    }
    
    return _imageSize;
}

@end
