//
//  LFPhoto.h
//  IMDemo
//
//  Created by 刘峰 on 2019/1/15.
//  Copyright © 2019年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFPhoto : NSObject

@property (nonatomic, strong) UIImage *thumbnailImage;/**< 缩略图*/
@property (nonatomic, strong) id hightQuality;/**< 高分辨率图片url, string, UIImage*/

@end

NS_ASSUME_NONNULL_END
