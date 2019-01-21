//
//  ChatFaceView.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/29.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatFaceView.h"
#import "EmojiHelper.h"

static const NSInteger kSystemEmojiOnePageCount = 23;/**< 不算删除按钮的话,每页有23个小表情*/
static const NSInteger kLineCounts = 3;/**< 表情行数为3行*/
static const NSInteger kColumnCounts = 8;/**< 表情列数为8列*/

@interface ChatFaceSystemCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *emoticon;
@property (nonatomic, strong) UIImageView *emojiImageView;
@property (nonatomic, assign) BOOL isDelete;

- (void)configWithImage:(UIImage *)image;

@end

@implementation ChatFaceSystemCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

//初始化
- (void)setUp {
    [self.contentView addSubview:self.emojiImageView];
    [self.emojiImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(32.f);
        make.height.equalTo(32.f);
        make.center.equalTo(self.contentView);
    }];
}

- (void)configWithImage:(UIImage *)image {
    if (self.isDelete) {
        self.emojiImageView.image = [[EmojiHelper share] imageNamed:@"999"];//删除键
    } else {
        self.emojiImageView.image = image;
    }
}

- (UIImageView *)emojiImageView {
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] init];
        _emojiImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _emojiImageView;
}

@end

@protocol FaceCollectionViewDelegate <UICollectionViewDelegate>

- (void)emotionDidSelectedCell:(ChatFaceSystemCell *)cell;

@end

@interface ChatFaceCollectionView : UICollectionView

@property (nonatomic, strong) UIImageView *magnifierBackground;//表情放大镜的背景
@property (nonatomic, strong) UIImageView *magnifierContent;//表情放大镜内容
@property (nonatomic, strong) ChatFaceSystemCell *currentMagnifierCell;//当前戴了放大镜模式的cell

@end

@implementation ChatFaceCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.clipsToBounds = NO;
        self.canCancelContentTouches = NO;//在touche move的时候,collectionview不会跟着手指左右滚动
        self.multipleTouchEnabled = NO;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.magnifierBackground];
    [self setUpGesture];
}

//添加手势
- (void)setUpGesture {
    /**< 添加轻点手势*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureResponse:)];
    [self addGestureRecognizer:tap];
    
    /**< 添加长按手势*/
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureResponse:)];
    longPress.minimumPressDuration = 0.2;
    [self addGestureRecognizer:longPress];
    
    /**< 添加拖拽手势*/
    
}

//根据手势单击的点获取cell
- (ChatFaceSystemCell *)cellForTouches:(UIGestureRecognizer *)touch {
    CGPoint point = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    return indexPath ? (ChatFaceSystemCell *)[self cellForItemAtIndexPath:indexPath] : nil;
}

//长按表情显示放大镜
- (void)showMagnifierWithCell:(ChatFaceSystemCell *)cell {
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    self.magnifierBackground.centerX = CGRectGetMidX(rect);
    self.magnifierBackground.bottom = CGRectGetMaxY(rect) - 9;
    self.magnifierBackground.hidden = NO;
    
    self.magnifierContent.image = cell.emojiImageView.image;
    _magnifierContent.size = CGSizeMake(self.magnifierContent.image.size.width, self.magnifierContent.image.size.height);
    self.magnifierContent.centerX = self.magnifierBackground.image.size.width / 2;
}

//隐藏放大镜
- (void)hideMagnifier {
    self.magnifierBackground.hidden = YES;
}

#pragma mark - 手势事件
//轻点事件的响应
- (void)tapGestureResponse:(UITapGestureRecognizer *)tapGR {
    if ([self.delegate respondsToSelector:@selector(emotionDidSelectedCell:)]) {
        ChatFaceSystemCell *cell = [self cellForTouches:tapGR];
        if (cell) {
            [(id<FaceCollectionViewDelegate>)self.delegate emotionDidSelectedCell:cell];
        }
    }
}

//长按事件的响应
- (void)longPressGestureResponse:(UILongPressGestureRecognizer *)longPressGR {
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
        [self longPressBegan:longPressGR];
    } else if (longPressGR.state == UIGestureRecognizerStateChanged) {
        [self longPressChanged:longPressGR];
    } else if (longPressGR.state == UIGestureRecognizerStateEnded) {
        [self longPressEnded:longPressGR];
    } else if (longPressGR.state == UIGestureRecognizerStateCancelled) {
        [self longPressCancel:longPressGR];
    }
}


/**
 长按手势开始
 */
- (void)longPressBegan:(UIGestureRecognizer *)longPressGR {
    ChatFaceSystemCell *cell = [self cellForTouches:longPressGR];
    if (!cell.isDelete) {
        _currentMagnifierCell = cell;
        [self showMagnifierWithCell:cell];
    }
}

/**
 长按手势位置改变
 */
- (void)longPressChanged:(UIGestureRecognizer *)longPressGR {
    ChatFaceSystemCell *cell = [self cellForTouches:longPressGR];
    if (_currentMagnifierCell != cell && cell != nil) {//当前戴了放大镜的cell不在手势点击的cell上时,才会给cell戴上放大镜
        _currentMagnifierCell = cell;
        [self showMagnifierWithCell:cell];
    }
}

/**
 长按手势结束
 */
- (void)longPressEnded:(UIGestureRecognizer *)longPressGR {
    _currentMagnifierCell = nil;
    [self hideMagnifier];
}

/**
 长按手势取消
 */
- (void)longPressCancel:(UIGestureRecognizer *)longPressGR {
    [self hideMagnifier];
}

#pragma mark - Getters
- (UIImageView *)magnifierContent {
    if (!_magnifierContent) {
        _magnifierContent = [[UIImageView alloc] init];
        _magnifierContent.top = 10;
    }
    return _magnifierContent;
}

- (UIImageView *)magnifierBackground {
    if (!_magnifierBackground) {
        _magnifierBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
        [_magnifierBackground addSubview:self.magnifierContent];
        _magnifierBackground.hidden = YES;
    }
    return _magnifierBackground;
}

@end

@interface ChatFaceView () <UICollectionViewDelegate, UICollectionViewDataSource, FaceCollectionViewDelegate>

@property (nonatomic, strong) UIView *toolBar;//表情下面的工具栏
@property (nonatomic, strong) ChatFaceCollectionView *collectionView;//表情栏
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;//表情栏布局

@end

@implementation ChatFaceView

- (id)init {
    if (self = [super init]) {
        [self setUp];
        [self initToolBar];
    }
    return self;
}

- (void)setUp {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kChatViewHeight);
    [self addSubview:self.collectionView];
}

//初始化工具栏
- (void)initToolBar {
    [self addSubview:self.toolBar];
    
    //添加按钮
    UIButton *addButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButon setImage:[UIImage imageNamed:@"emoticon-add"] forState:UIControlStateNormal];
    addButon.frame = CGRectMake(0, 0, 35, 35);
    [self.toolBar addSubview:addButon];
    //竖线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(addButon.origin.x+addButon.size.width, (35-25)/2.0, 1, 25)];
    lineView1.backgroundColor = kUIColorFromRGB(0xe3e3e3);
    [self.toolBar addSubview:lineView1];
    
    
    //发送按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.size = CGSizeMake(60, 35);
    sendButton.right = self.toolBar.size.width;
    sendButton.top = 0;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    sendButton.backgroundColor = kUIColorFromRGB(0xf9f9f9);
    [self.toolBar addSubview:sendButton];
    //竖线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(sendButton.origin.x-1, (35-25)/2.0, 1, 25)];
    lineView2.backgroundColor = kUIColorFromRGB(0xe3e3e3);
    [self.toolBar addSubview:lineView2];
    
    //滚动的按钮背景
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lineView1.origin.x+lineView1.size.width, 0, self.bounds.size.width-addButon.size.width-lineView1.size.width-lineView2.size.width-sendButton.size.width, 35)];
    [self.toolBar addSubview:scrollView];
    
    //表情按钮
    UIButton *emoticonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emoticonButton setImage:[UIImage imageNamed:@"emoticon-system"] forState:UIControlStateNormal];
    emoticonButton.frame = CGRectMake(0, 0, 35, 35);
    [scrollView addSubview:emoticonButton];
    //竖线
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(emoticonButton.origin.x+emoticonButton.size.width, (35-25)/2.0, 1, 25)];
    lineView3.backgroundColor = kUIColorFromRGB(0xe3e3e3);
    [scrollView addSubview:lineView3];
    
    //gif按钮
    UIButton *gifButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gifButton setImage:[UIImage imageNamed:@"emoticon-custom"] forState:UIControlStateNormal];
    gifButton.frame = CGRectMake(lineView3.origin.x+lineView3.size.width, 0, 35, 35);
    [scrollView addSubview:gifButton];
    //竖线
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(gifButton.origin.x+gifButton.size.width, (35-25)/2.0, 1, 25)];
    lineView4.backgroundColor = kUIColorFromRGB(0xe3e3e3);
    [scrollView addSubview:lineView4];
}

/**
 表情横向排列算法
 原表情排列方式
  0  3  6  9 12 15 18 21
  1  4  7 10 13 16 19 22
  2  5  8 11 14 17 20 23
 期望表情排列方式
  0  1  2  3  4  5  6  7
  8  9 10 11 12 13 14 15
 16 17 18 19 20 21 22 23
 计算表情序号
 @param indexPath 原collectionview数据源序号
 @return 返回应获取的表情序号
 */
- (NSInteger)indexWithTransverseArrangement:(NSIndexPath *)indexPath {
    NSInteger lines = indexPath.item % kLineCounts;//行数
    NSInteger columns = indexPath.item / kLineCounts;//列数
    NSInteger index = kColumnCounts*lines + columns + kSystemEmojiOnePageCount * indexPath.section;
    return index;
}

#pragma mark - UICollectionViewDelegate & UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return ([EmojiHelper share].emojiGroups.count / kSystemEmojiOnePageCount) + ([EmojiHelper share].emojiGroups.count % kSystemEmojiOnePageCount ? 1 : 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kSystemEmojiOnePageCount + 1;
}

//根据算法让表情横向排列
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatFaceSystemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatFaceSystemCell" forIndexPath:indexPath];
    if (indexPath.item == kSystemEmojiOnePageCount) {
        cell.isDelete = YES;
        [cell configWithImage:nil];
    } else {
        cell.isDelete = NO;
        
        //计算横向排列的表情序号
        NSInteger index = [self indexWithTransverseArrangement:indexPath];
        /**< 判断当表情处在最后一页时,没有表情的部分用空白填充*/
        if (index < [EmojiHelper share].emojiGroups.count) {
            NSDictionary *dic = [EmojiHelper share].emojiGroups[index];
            cell.emoticon = dic;
            [cell configWithImage:dic[dic.allKeys[0]]];
        } else {
            [cell configWithImage:nil];
        }
    }

    return cell;
}

//表情的点击事件
- (void)emotionDidSelectedCell:(ChatFaceSystemCell *)cell {
    
    if (!cell.isDelete) {//选中的cell是表情
        if ([self.delegate respondsToSelector:@selector(didSelectEmotionText:)]) {
            [self.delegate didSelectEmotionText:cell.emoticon.allKeys[0]];
        }
    } else {//选中的cell是删除按钮
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDeleteCell)]) {
            [self.delegate didSelectDeleteCell];
        }
    }
}

#pragma mark - Getters
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat itemWidth = (self.bounds.size.width-10.f*2) / 8;
        CGFloat itemHeight = 50.f;
        
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _flowLayout;
}

- (ChatFaceCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[ChatFaceCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - (iPhoneX ? (35+34) : 35)) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = CHATVIEW_BACKGROUND_COLOR;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ChatFaceSystemCell class] forCellWithReuseIdentifier:@"ChatFaceSystemCell"];
    }
    return _collectionView;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                    self.collectionView.origin.y+self.collectionView.size.height,
                                                            self.bounds.size.width,
                                                            35)];
        _toolBar.backgroundColor = kUIColorFromRGB(0xfefefe);
    }
    return _toolBar;
}

@end
