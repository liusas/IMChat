//
//  ChatConfiguration.h
//  IMDemo
//
//  Created by 刘峰 on 2018/11/3.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#ifndef ChatConfiguration_h
#define ChatConfiguration_h

#import <UIKit/UIKit.h>

//16进制颜色
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//聊天室背景颜色
#define CHATVIEW_BACKGROUND_COLOR [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f]
//底部工具栏边界线背景颜色
#define CHATBAR_BORDER_COLOR [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0f]

//常量定义
static NSString *const kChatSystemCellIdentifier = @"com.kChatSystemCellIdentifier";//系统消息类型
static NSString *const kChatOwnSingleCellIdentifier = @"com.kChatOwnSingleCellIdentifier";//自己发的单聊消息类型
static NSString *const kChatOwnGroupCellIdentifier = @"com.kChatOwnGroupCellIdentifier";//自己发的群聊消息类型
static NSString *const kChatOtherSingleCellIdentifier = @"com.kChatOtherSingleCellIdentifier";//别人发的单聊消息类型
static NSString *const kChatOtherGroupCellIdentifier = @"com.kChatOtherGroupCellIdentifier";//别人发的群聊消息类型
static NSString *const kMoreItemSelectNotification = @"com.kMoreItemSelectNotification";//更多栏的照片,拍照等事件通知

#define PATH_OF_RECORD_FILE [NSTemporaryDirectory() stringByAppendingString:@"records"]

#define SCREEN_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define kMessageViewMaxWidth (SCREEN_WIDTH - 45 - 32 - 16 - 20 - 32)

#define kChatViewHeight  215.0f + (iPhoneX ? 34.f : 0)
#define kVoiceMessageViewHeight 50.f
#define kRecordMaxCount 60.f //最大允许录音时间

#pragma mark - 枚举定义
//聊天室类型
typedef NS_ENUM(NSInteger, ChatMode) {
    ChatModeSingle = 0, /**< 单聊*/
    ChatModeGroup = 1, /**< 群聊*/
};

//消息拥有者类型
typedef NS_ENUM(NSInteger, ChatOwnerType) {
    ChatOwnerSelf = 0, /**< 拥有者是自己*/
    ChatOwnerOther = 1, /**< 拥有者是别人*/
    ChatOwnerSystem = 2, /**< 拥有者是系统*/
    ChatOwnerUnknow = 3, /**< 未知拥有者*/
};

//消息类型
typedef NS_ENUM(NSInteger, ChatMessageType) {
    ChatMessageTypeSystem = 0, /**< 系统消息*/
    ChatMessageTypeText, /**< 文本消息*/
    ChatMessageTypeImage, /**< 图片消息*/
    ChatMessageTypeVoice, /**< 语音消息*/
    ChatMessageTypeVideo, /**< 视频消息*/
    ChatMessageTypeLocation, /**< 位置消息*/
    ChatMessageTypeUnknow, /**< 未知消息类型*/
};

//消息发送状态
typedef NS_ENUM(NSUInteger, ChatMessageState) {
    /** 未知的消息装填 */
    ChatMessageUnknown = 0,
    /** 正在发送消息中 */
    ChatMessageStateSending = 10,
    /** 正在接受消息中 */
    ChatMessageStateRecieving,
    /** 消息成功 */
    ChatMessageStateSuccess = 20,
    /** 消息失败 */
    ChatMessageStateFailed,
};

//消息发送子状态
typedef NS_ENUM(NSUInteger, ChatMessageSubState) {
    
    ChatMessageSubStateSendingContent = 30,
    /** 发送消息内容失败 */
    ChatMessageSubStateSendContentFaield,
    /** 发送消息内容成功 */
    ChatMessageSubStateSendContentSuccess,
    /** 接收的消息的内容还没有下载*/
    ChatMessageSubStateUnRecievedContent = 40,
    /** 正在接收消息的内容 */
    ChatMessageSubStateRecievingContent,
    /** 接收消息内容失败 */
    ChatMessageSubStateRecieveContentFailed,
    /** 已成功接收消息的内容 */
    ChatMessageSubStateRecieveContentSuccess,
    /** 正在播放接收的消息内容 */
    ChatMessageSubStatePlayingContent,
    /** 无法播放消息的具体内容 */
    ChatMessageSubStatePlayContentFailed,
    /** 可以播放消息的具体内容 */
    ChatMessageSubStatePlayContentSuccess,
    /** 消息已读 */
    ChatMessageSubStateReadedContent
};

typedef NS_ENUM(NSInteger, ChatShowingView) {
    ChatShowingNoneView = 0, /**< 不展示任何视图*/
    ChatShowingVoiceView, /**< 显示录音界面*/
    ChatShowingFaceView, /**< 显示表情界面*/
    ChatShowingOtherView, /**< 显示更多选项界面*/
    ChatShowingKeyboard /**< 显示键盘*/
};

//录音状态
typedef NS_ENUM(NSInteger, ChatBarRecordType) {
    ChatBarRecording = 0, /**< 开始录音,正在录音*/
    ChatBarRecordFinish, /**< 录音完成*/
    ChatBarRecordCancel, /**< 取消录音*/
    ChatBarRecordDragEnter, /**< 手指移动到录音区域*/
    ChatBarRecordDragExit, /**< 手指移出录音区域*/
    ChatBarRecordTooShort, /**< 录音时间太短*/
    ChatBarRecordTooLong, /**< 录音时间过长*/
};

//照片相机等的类型
typedef NS_ENUM(NSInteger, ChatMoreItemType) {
    ChatMoreItemPicture = 0, /**< 照片*/
    ChatMoreItemCamera = 1, /**< 相机*/
    ChatMoreItemVideo, /**< 视频*/
    ChatMoreItemLocation, /**< 位置*/
};


#endif /* ChatConfiguration_h */
