//
//  ChatBar.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/25.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatBar.h"
#import "ChatTextParser.h"
#import "EmojiHelper.h"

@interface ChatBar () <YYTextViewDelegate>

@property (nonatomic, strong) UIButton *voiceOrKeyboardButton;/**< 切换录音和键盘的按钮 */
@property (nonatomic, strong) UIButton *recordButton;/**< 录音按钮*/
@property (nonatomic, strong) UIButton *faceButton;/**< 表情按钮 */
@property (nonatomic, strong) UIButton *moreButton;/**< 加号按钮 */

@end

@implementation ChatBar

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.voiceOrKeyboardButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10.f);
        make.centerY.equalTo(self);
        make.height.equalTo(28.f);
        make.width.equalTo(self.voiceOrKeyboardButton.mas_height);
    }];
    
    [self.faceButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(10.5);
        make.width.equalTo(self.faceButton.mas_height);
    }];
    
    [self.moreButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(10.5);
        make.width.equalTo(self.moreButton.mas_height);
    }];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceOrKeyboardButton.mas_right).offset(10);
        make.right.equalTo(self.faceButton.mas_left).offset(-10);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
    }];
    
    [self.recordButton makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView);
    }];
}

//初始化
- (void)setUp {
    
    //设置border颜色
    self.layer.borderColor = CHATBAR_BORDER_COLOR.CGColor;
    self.layer.borderWidth = 1.0f;
    self.backgroundColor = CHATVIEW_BACKGROUND_COLOR;
    
    [self addSubview:self.voiceOrKeyboardButton];
    [self addSubview:self.recordButton];
    [self addSubview:self.textView];
    [self addSubview:self.faceButton];
    [self addSubview:self.moreButton];
    
    self.textView.layer.borderColor = CHATBAR_BORDER_COLOR.CGColor;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.cornerRadius = 4.0f;
    
    self.recordButton.layer.borderColor = CHATBAR_BORDER_COLOR.CGColor;
    self.recordButton.layer.borderWidth = 1.0f;
    self.recordButton.layer.cornerRadius = 4.0f;
    
    ChatTextParser *parser = [[ChatTextParser alloc] init];
    parser.emoticonArray = [EmojiHelper share].emojiGroups;
    parser.emotionSize = CGSizeMake(20.f, 20.f);
    parser.alignFont = [UIFont systemFontOfSize:16.f];
    parser.alignment = YYTextVerticalAlignmentBottom;
    self.textView.textParser = parser;
    
    //设置textView 固定行高
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    mod.fixedLineHeight = 15.0f;
    self.textView.linePositionModifier = mod;
}


/**
 重置聊天工具栏按钮的状态
 */
- (void)resetChatBarButtonStatus {
    self.faceButton.selected = self.moreButton.selected = self.voiceOrKeyboardButton.selected = NO;
}

#pragma mark - UIButton's response
//工具栏上的按钮的点击事件处理
- (void)handleButtonAction:(UIButton *)sender {
    ChatShowingView showType = ChatShowingNoneView;
    BOOL selected = sender.selected;
    [self resetChatBarButtonStatus];/**< 重置按钮状态*/
    sender.selected = !selected;
    if (sender == self.voiceOrKeyboardButton) {//左侧语音和键盘切换的按钮点击事件
        self.textView.hidden = sender.selected;
        self.recordButton.hidden = !sender.selected;
        showType = sender.selected ? ChatShowingNoneView : ChatShowingKeyboard;
    } else if (sender == self.faceButton) {//表情按钮点击事件
        self.recordButton.hidden = YES;
        self.textView.hidden = NO;
        showType = sender.selected ? ChatShowingFaceView : ChatShowingKeyboard;
    } else if (sender == self.moreButton) {//更多选项的加号点击事件
        self.recordButton.hidden = YES;
        self.textView.hidden = NO;
        showType = sender.selected ? ChatShowingOtherView : ChatShowingKeyboard;
    }
    
    if (self.chatBarDelegate && [self.chatBarDelegate respondsToSelector:@selector(chatBarShowViewDidChanged:)]) {
        [self.chatBarDelegate chatBarShowViewDidChanged:showType];
    }
}

/**< 录音按钮--按下去*/
- (void)recordButtonTouchDown:(UIButton *)button {
    button.backgroundColor = kUIColorFromRGB(0xd3d3d3);
    [button setTitle:@"松开 结束" forState:UIControlStateNormal];
    self.recordType = ChatBarRecording;
}

/**< 录音按钮--按完按钮,录音完成*/
- (void)recordButtonTouchUpInside:(UIButton *)button {
    [button setTitle:@"按住 说话" forState:UIControlStateNormal];
    button.backgroundColor = CHATVIEW_BACKGROUND_COLOR;
    self.recordType = ChatBarRecordFinish;
}

/**< 录音按钮--手指移到按钮外,取消录音*/
- (void)recordButtonTouchUpOutside:(UIButton *)button {
    [button setTitle:@"按住 说话" forState:UIControlStateNormal];
    button.backgroundColor = CHATVIEW_BACKGROUND_COLOR;
    self.recordType = ChatBarRecordCancel;
}

/**< 录音按钮--手指从外部移进按钮区域*/
- (void)recordButtonTouchDragEnter:(UIButton *)button {
    [button setTitle:@"松开 结束" forState:UIControlStateNormal];
    self.recordType = ChatBarRecordDragEnter;
}

/**< 录音按钮--手指从按钮内部移出去*/
- (void)recordButtonTouchDragExit:(UIButton *)button {
    [button setTitle:@"松开 取消" forState:UIControlStateNormal];
    self.recordType = ChatBarRecordDragExit;
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView {
    
}

//文本将要改变
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length) {
            ChatTextMessage *textMessage = [[ChatTextMessage alloc] initWithContent:textView.text state:ChatMessageStateSending owner:ChatOwnerSelf chatMode:ChatModeSingle];
            
            textView.attributedText = nil;
            if (self.chatBarDelegate && [self.chatBarDelegate respondsToSelector:@selector(chatBarSendTextMessage:)]) {
                [self.chatBarDelegate chatBarSendTextMessage:textMessage];
            }
        } else {
            NSLog(@"不能发送空消息");
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Getters
- (UIButton *)voiceOrKeyboardButton {
    if (!_voiceOrKeyboardButton) {
        _voiceOrKeyboardButton = [[UIButton alloc] init];
        [_voiceOrKeyboardButton setImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        [_voiceOrKeyboardButton setImage:[UIImage imageNamed:@"icon_keyboard"] forState:UIControlStateSelected];
        [_voiceOrKeyboardButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceOrKeyboardButton;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [YYTextView new];
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.returnKeyType = UIReturnKeySend;//设置右下角return按键为发送
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.hidden = YES;
        _recordButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
        [_recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        [_recordButton addTarget:self action:@selector(recordButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [_recordButton addTarget:self action:@selector(recordButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    }
    return _recordButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [[UIButton alloc] init];
        [_faceButton setImage:[UIImage imageNamed:@"chat_bar_face_normal"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"icon_keyboard"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
