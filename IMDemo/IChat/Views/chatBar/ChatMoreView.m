//
//  ChatMoreView.m
//  IMDemo
//
//  Created by 刘峰 on 2018/11/28.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatMoreView.h"
#import "ChatMoreItem.h"

@interface ChatMoreViewCollectionCell : UICollectionViewCell

@end

@implementation ChatMoreViewCollectionCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

//初始化
- (void)setUp {
    CGFloat itemWidth = 50.f;/**< 选项宽度*/
    CGFloat itemHeight = 50+8+12;/**< 选项高度*/
    CGFloat lineSpace = 15.0f;/**< 垂直间隔*/
    CGFloat interItemSpace = (self.bounds.size.width-4*itemWidth) / 5.f;/**< 水平间隔*/
    NSArray *imageNames = @[@"icon_color_picture", @"icon_color_photo", @"icon_color_video", @"icon_color_position"];
    NSArray *titleNames = @[@"照片", @"相机", @"视频", @"位置"];
    
    for (NSInteger i = 0; i < imageNames.count; i++) {
        ChatMoreItem *moreItem = [[ChatMoreItem alloc] init];
        [moreItem configMoreItemWithImageName:imageNames[i] andTitle:titleNames[i]];
        [self.contentView addSubview:moreItem];
        CGFloat startX = (itemWidth + interItemSpace) * (i%4) + interItemSpace;
        CGFloat startY = (itemHeight+lineSpace) * (i/4) + lineSpace;
        moreItem.moreItemType = i;
        [moreItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [moreItem makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(startX);
            make.top.equalTo(self.contentView).offset(startY);
            make.width.equalTo(itemWidth);
            make.height.equalTo(itemHeight);
        }];
    }
}

//按钮点击事件
- (void)buttonClick:(ChatMoreItem *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMoreItemSelectNotification object:@(sender.moreItemType)];
}

@end

@interface ChatMoreView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation ChatMoreView

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


/**
 初始化
 */
- (void)setUp {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kChatViewHeight);
    self.backgroundColor = CHATVIEW_BACKGROUND_COLOR;
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(0);
        make.centerX.equalTo(self);
    }];
}

//更新约束
- (void)updateConstraints {
    [super updateConstraints];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatMoreViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatMoreViewCollectionCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - Getters
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:177.f/255.f green:177.f/255.f blue:177.f/255.f alpha:1.0f];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:113.f/255.f green:113.f/255.f blue:113.f/255.f alpha:1.0f];
        _pageControl.numberOfPages = 1;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - 35);//每个itemsize
        _flowLayout.minimumLineSpacing = 0;//每个item的垂直间距
        _flowLayout.minimumInteritemSpacing = 0;//每个item的水平间距
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-35) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = CHATVIEW_BACKGROUND_COLOR;
        //注册cell
        [_collectionView registerClass:[ChatMoreViewCollectionCell class] forCellWithReuseIdentifier:@"ChatMoreViewCollectionCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

@end
