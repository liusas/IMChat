//
//  ChatMoreItem.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMoreItem : UIControl

@property (nonatomic, assign) ChatMoreItemType moreItemType;/**< 照片相机等的类型*/
- (void)configMoreItemWithImageName:(NSString *)imageName andTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
