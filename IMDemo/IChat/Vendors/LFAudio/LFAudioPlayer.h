//
//  LFAudioPlayer.h
//  IMDemo
//
//  Created by 刘峰 on 2019/1/1.
//  Copyright © 2019年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFAudioPlayer : NSObject

- (void)startPlaying;
- (void)stopPlaying;

- (void)playWithUrl:(NSURL *)fileUrl;

@end

NS_ASSUME_NONNULL_END
