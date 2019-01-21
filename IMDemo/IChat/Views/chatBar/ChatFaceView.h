//
//  ChatFaceView.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FaceViewDelegate <NSObject>
/**< 选中了表情*/
- (void)didSelectEmotionText:(NSString *)text;

/**< 删除表情或文字*/
- (void)didSelectDeleteCell;

@end

@interface ChatFaceView : UIView

@property (nonatomic, weak) id<FaceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
