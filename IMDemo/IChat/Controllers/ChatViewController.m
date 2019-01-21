//
//  ChatViewController.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/3.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatViewController+ChatCellDelegate.h"
#import "UITableView+cellRegister.h"
#import "ChatBar.h"
#import "ChatCell.h"
#import "ChatMoreView.h"
#import "ChatFaceView.h"
#import "TZImagePickerController.h"
#import "LFAudioIndicatorHUD.h"

@interface ChatViewController () <UITableViewDelegate, ChatBarDelegate, FaceViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) ChatBar *chatBar;/**< 底部工具栏*/
@property (nonatomic, strong) ChatMoreView *moreView;/**< 工具栏上加号弹出的更多选项视图*/
@property (nonatomic, strong) ChatFaceView *faceView;/**< 表情面板*/
@property (nonatomic, strong) MASConstraint *chatBarBottomConstraint;/**< chatBar的底部约束*/

@end

@implementation ChatViewController

- (instancetype)initWithChatMode:(ChatMode)chatMode {
    if (self = [super init]) {
        self.chatViewModel = [[ChatViewModel alloc] initWithChatMode:chatMode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self setUpConstraints];
    [self getNotificationAndObserver];
    [self setUpGestures];
}

- (void)viewDidLayoutSubviews {
    [self scrollToBottom];
}

/**
 初始化页面
 */
- (void)setUpUI {
    self.navigationController.navigationBar.translucent = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = self.tableView.backgroundColor = CHATVIEW_BACKGROUND_COLOR;
    [self.view addSubview:self.chatBar];
    [self.view addSubview:self.tableView];
    
    self.moreView = [[ChatMoreView alloc] init];
    self.faceView = [[ChatFaceView alloc] init];
    self.faceView.delegate = self;
}

/**
 添加约束
 */
- (void)setUpConstraints {
    [_chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        self.chatBarBottomConstraint = make.bottom.equalTo(self.view).offset(iPhoneX ? -34 : 0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(kChatBarHeight);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.chatBar.mas_top).offset(0);
    }];
}

//给tableview添加手势
- (void)setUpGestures {
    //添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self.tableView addGestureRecognizer:tap];
}

/**
 接收通知和KVO监听chatbar的recordType属性
 */
- (void)getNotificationAndObserver {
    //监听键盘弹起和收回的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChangeListen:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //监听加号按钮的照片,拍照,视频等的点击事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreViewDidSelectListen:) name:kMoreItemSelectNotification object:nil];
    
    /**< 监听recordType值的变化,执行不同的录音操作*/
    [self.chatBar addObserver:self forKeyPath:@"recordType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)scrollToBottom {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatViewModel.messages.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//#pragma mark - LFPhotoBrowserDelegate
////当前消息列表中图片的数量
//- (NSInteger)numberOfPhotosInPhotoBrowser:(LFPhotoBrowser *)photoBrowser {
//    return [self.chatViewModel filterMessageWithType:ChatMessageTypeImage].count;
//}
////当前图片浏览器显示的图片的缩略图
//- (UIImage *)photoBrowser:(LFPhotoBrowser *)photoBrowser thumbnailImageIndex:(NSInteger)index {
//    NSArray *chatImageMessages = [self.chatViewModel filterMessageWithType:ChatMessageTypeImage];
//    return [(ChatImageMessage *)chatImageMessages[index] image];
//}
////当前图片浏览器显示的图片的高分辨率图,可以是string, url, UIImage对象
//- (id)photoBrowser:(LFPhotoBrowser *)photoBrowser hightQualityUrlForIndex:(NSInteger)index {
//    NSArray *chatImageMessages = [self.chatViewModel filterMessageWithType:ChatMessageTypeImage];
//    return [[(ChatImageMessage *)chatImageMessages[index] content] bmiddle];
//}
////当前图片浏览器显示的图片的图片源,用于制作过场动画
//- (UIImageView *)imageViewInPhotoBrowser:(LFPhotoBrowser *)photoBrowser withCurrentIndex:(NSInteger)index {
//    ChatCell *clickCell = [self.tableView cellForRowAtIndexPath:[self.chatViewModel getIndexPathFromImageMessageIndex:index]];
//    return (UIImageView *)clickCell.messageView;
//}

#pragma mark - 加号按钮的照片,拍照,视频等操作
//打开相册选照片
- (void)showPhotoLibrary {
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
}

//打开相机
- (void)showCamera {
    
}

#pragma mark - 手势相关
//单击手势
- (void)handleTapAction:(UITapGestureRecognizer *)tapGR {
    
    if (tapGR.state == UIGestureRecognizerStateEnded) {//点击手势结束调用
        CGPoint point = [tapGR locationInView:self.tableView];//手势的质心
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        ChatCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (CGRectContainsPoint(cell.avatarImageView.frame, [tapGR locationInView:cell])) {//单击的点是头像
            NSLog(@"点击了头像");
        } else if (CGRectContainsPoint(cell.messageContentView.frame, [tapGR locationInView:cell])) {//单击的点是消息内容
            [cell.delegate messageDidTapMessageContent:cell];
            
        } else if (CGRectContainsPoint(cell.chatStateView.frame, [tapGR locationInView:cell])) {//单击的点是消息状态
            NSLog(@"点击了消息状态");
        } else {
            NSLog(@"点击了空白部分");
            
        }
        [self chatBarShowViewDidChanged:ChatShowingNoneView];
        [self.chatBar resetChatBarButtonStatus];
    }
}

#pragma mark - ChatBarDelegate
/**
 判断在对底部工具栏操作后,显示什么视图

 @param chatShowType 视图显示类型
 */
- (void)chatBarShowViewDidChanged:(ChatShowingView)chatShowType {
    
    if (chatShowType == ChatShowingNoneView || chatShowType == ChatShowingVoiceView) {//不显示任何视图
        self.chatBar.textView.inputView = nil;
        [self.chatBar.textView resignFirstResponder];
    } else if (chatShowType == ChatShowingFaceView) {//显示表情视图
        self.chatBar.textView.inputView = self.faceView;
        self.chatBar.textView.extraAccessoryViewHeight = kChatViewHeight;
        [self.chatBar.textView reloadInputViews];
        [self.chatBar.textView becomeFirstResponder];
    } else if (chatShowType == ChatShowingOtherView) {//显示更多选项的View
        self.chatBar.textView.inputView = self.moreView;
        self.chatBar.textView.extraAccessoryViewHeight = kChatViewHeight;
        [self.chatBar.textView reloadInputViews];
        [self.chatBar.textView becomeFirstResponder];
    } else if (chatShowType == ChatShowingKeyboard) {
        self.chatBar.textView.inputView = nil;
        [self.chatBar.textView reloadInputViews];
        [self.chatBar.textView becomeFirstResponder];
    }
}


/**
 发送文本消息

 @param message 消息内容
 */
- (void)chatBarSendTextMessage:(ChatTextMessage *)message {
    [self.chatViewModel sendMessage:message];
    [self.tableView reloadData];
    [self scrollToBottom];
}


/**
 发送图片消息

 @param images UIImage类型的对象
 */
- (void)chatBarSendImageMessage:(NSArray<UIImage *> *)images {
    for (UIImage *image in images) {
        ChatMessageImageContent *content = [[ChatMessageImageContent alloc] initWithThunbnail:image andBmiddle:nil andImageSize:CGSizeMake(image.size.width, image.size.height)];
        ChatImageMessage *message = [[ChatImageMessage alloc] initWithContent:content state:ChatMessageStateSending owner:ChatOwnerSelf chatMode:ChatModeSingle];
        [self.chatViewModel sendMessage:message];
    }
    [self.tableView reloadData];
    [self scrollToBottom];
    
    [self.chatBar resetChatBarButtonStatus];
}

#pragma mark 录音状态的KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"recordType"]) {
        ChatBar *chatBar = object;
        [LFAudioIndicatorHUD currentTypeForOperation:chatBar.recordType];
    }
}

#pragma mark - FaceViewDelegate
//点击了表情cell
- (void)didSelectEmotionText:(NSString *)text {
    [self.chatBar.textView insertText:text];
}

//点击了删除cell
- (void)didSelectDeleteCell {
    [self.chatBar.textView deleteBackward];
}

#pragma mark YYTextViewDelegate
//文本结束编辑
- (void)textViewDidEndEditing:(YYTextView *)textView {
}

#pragma mark - 通知事件处理
- (void)keyboardFrameChangeListen:(NSNotification *)notification {
    //键盘弹起收回结束后的Frame
    CGRect kRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!(SCREEN_HEIGHT - kRect.origin.y)) {//键盘处于收起状态
        self.chatBarBottomConstraint.equalTo(iPhoneX ? -34.f : 0.f);
    } else {//键盘处于弹出状态
        self.chatBarBottomConstraint.equalTo(-(SCREEN_HEIGHT - kRect.origin.y));
    }
    
    [self.view layoutIfNeeded];//立即更新布局,会是的聊天工具框更平滑的更新约束
    [self scrollToBottom];
}

//监听加号按钮的照片,拍照,视频等的点击事件通知
- (void)moreViewDidSelectListen:(NSNotification *)notification {
    ChatMoreItemType itemType = [[notification object] integerValue];
    switch (itemType) {
        case ChatMoreItemPicture: {
            [self showPhotoLibrary];
        }
            break;
        case ChatMoreItemCamera: {
            [self showCamera];
        }
            break;
        case ChatMoreItemVideo: {
            
        }
            break;
        case ChatMoreItemLocation: {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self chatBarShowViewDidChanged:ChatShowingNoneView];
    [self chatBarSendImageMessage:photos];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.chatBar removeObserver:self forKeyPath:@"recordType"];
}

#pragma mark - Setters
- (void)setChatViewModel:(ChatViewModel<UITableViewDataSource> *)chatViewModel {
    _chatViewModel = chatViewModel;
    _chatViewModel.chatVC = self;
    self.tableView.dataSource = chatViewModel;
}

#pragma mark - Getters
//单聊还是群聊
- (ChatMode)chatMode {
    return self.chatViewModel.chatMode;
}

- (ChatBar *)chatBar {
    if (!_chatBar) {
        _chatBar = [[ChatBar alloc] init];
        _chatBar.chatBarDelegate = self;
    }
    return _chatBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = (id<UITableViewDataSource>)self.chatViewModel;
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerChatCell];
        
        _tableView.estimatedRowHeight = 240.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
