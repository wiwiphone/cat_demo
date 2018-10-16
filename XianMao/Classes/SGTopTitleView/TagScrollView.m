//
//  SGTopTitleView.m
//  SGTopTitleViewExample
//
//  Created by Sorgle on 16/8/24.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "TagScrollView.h"
#import "UIView+SGExtension.h"
#import "TapButton.h"
#import "TagListModel.h"

#define labelTextFontSize [UIFont systemFontOfSize:14]
#define labelFontOfSize [UIFont systemFontOfSize:17]
#define selectedTitleAndIndicatorViewColor [UIColor colorWithHexString:@"333333"]

@interface TagScrollView ()
/** 静止标题Label */
@property (nonatomic, strong) UILabel *staticTitleLabel;
/** 滚动标题Label */
@property (nonatomic, strong) UILabel *scrollTitleLabel;
/** 选中标题时的Label */
@property (nonatomic, strong) UILabel *selectedTitleLabel;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) TapButton * tapButton;
@property (nonatomic, strong) TapButton * selectTapButton;
/** 存入所有标题按钮 */
@property (nonatomic, strong) NSMutableArray *storageAlltitleBtn_mArr;
@property (nonatomic, strong) NSMutableArray *selectedLbl;
/** 临时button用来转换button的点击状态 */
@property (nonatomic, strong) TapButton *temp_btn;
@end

@implementation TagScrollView

/** label之间的间距(滚动时TitleLabel之间的间距) */
static CGFloat const labelMargin = 15;
/** 图文tag之间的间距(滚动时tag之间的间距) */
static CGFloat const tagMargin = 25;
/** 指示器的高度 */
static CGFloat const indicatorHeight = 2;

- (NSMutableArray *)storageAlltitleBtn_mArr {
    if (!_storageAlltitleBtn_mArr) {
        _storageAlltitleBtn_mArr = [NSMutableArray array];
    }
    return _storageAlltitleBtn_mArr;
}

- (NSMutableArray *)allTitleLabel {
    if (_allTitleLabel == nil) {
        _allTitleLabel = [NSMutableArray array];
    }
    return _allTitleLabel;
}

-(NSMutableArray *)selectedLbl{
    if (!_selectedLbl) {
        _selectedLbl = [[NSMutableArray alloc] init];
    }
    return _selectedLbl;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

+ (instancetype)topTitleViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


#pragma mark - - - 重写静止标题数组的setter方法
- (void)setStaticTitleArr:(NSArray *)staticTitleArr {
    _staticTitleArr = staticTitleArr;
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = self.frame.size.width;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelW = scrollViewWidth / self.staticTitleArr.count;
    CGFloat labelH = self.frame.size.height - indicatorHeight * 0.5;
    
    for (NSInteger j = 0; j < self.staticTitleArr.count; j++) {
        // 创建静止时的标题Label
        self.staticTitleLabel = [[UILabel alloc] init];
        _staticTitleLabel.userInteractionEnabled = YES;
        _staticTitleLabel.text = self.staticTitleArr[j];
        _staticTitleLabel.textAlignment = NSTextAlignmentCenter;
        _staticTitleLabel.tag = j;
        
        // 设置高亮文字颜色
        _staticTitleLabel.highlightedTextColor = selectedTitleAndIndicatorViewColor;
        
        // 计算staticTitleLabel的x值
        labelX = j * labelW;
        
        _staticTitleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 添加到titleLabels数组
        [self.allTitleLabel addObject:_staticTitleLabel];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(staticTitleClick:)];
        [_staticTitleLabel addGestureRecognizer:tap];
        
        // 默认选中第0个label
        if (j == 0) {
            [self staticTitleClick:tap];
        }
        
        [self addSubview:_staticTitleLabel];
    }
    
    // 取出第一个子控件
    UILabel *firstLabel = self.subviews.firstObject;
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
    _indicatorView.SG_height = indicatorHeight;
    _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
    [self addSubview:_indicatorView];
    
    
    // 指示器默认在第一个选中位置
    // 计算TitleLabel内容的Size
    CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
    _indicatorView.SG_width = labelSize.width;
    _indicatorView.SG_centerX = firstLabel.SG_centerX;
}

/** staticTitleClick的点击事件 */
- (void)staticTitleClick:(UITapGestureRecognizer *)tap {
    // 0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self staticTitleLabelSelecteded:selLabel];
    
    // 2.代理方法实现
    NSInteger index = selLabel.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGTopTitleView:didSelectTitleAtIndex:)]) {
        [self.delegate_SG SGTopTitleView:self didSelectTitleAtIndex:index];
    }
}

/** 静止标题选中颜色改变以及指示器位置变化 */
- (void)staticTitleLabelSelecteded:(UILabel *)label {
    // 取消高亮
    _selectedTitleLabel.highlighted = NO;
    
    // 颜色恢复
    _selectedTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    label.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    // 高亮
    label.highlighted = YES;
    
    _selectedTitleLabel = label;
    
    // 改变指示器位置
    [UIView animateWithDuration:0.20 animations:^{
        // 计算内容的Size
        CGSize labelSize = [self sizeWithText:_selectedTitleLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - indicatorHeight)];
        self.indicatorView.SG_width = labelSize.width;
        self.indicatorView.SG_centerX = label.SG_centerX;
    }];
}

#pragma mark - - - 重写滚动标题数组的setter方法
- (void)setScrollTitleArr:(NSArray *)scrollTitleArr {
    _scrollTitleArr = scrollTitleArr;
    
    CGFloat labelX = 12;
    CGFloat labelY = 6;
    CGFloat labelH = self.frame.size.height - indicatorHeight * 0.5;
    
    if (!scrollTitleArr) {
        return;
    }
    for (NSUInteger i = 0; i < self.scrollTitleArr.count; i++) {
        
        TagListModel *listModel = [[TagListModel alloc] initWithJSONDictionary:self.scrollTitleArr[i]];
        /** 创建滚动时的标题Label */
        self.scrollTitleLabel = [[UILabel alloc] init];
        _scrollTitleLabel.userInteractionEnabled = YES;
        _scrollTitleLabel.text = listModel.title;
        _scrollTitleLabel.textAlignment = NSTextAlignmentCenter;
        _scrollTitleLabel.tag = i;
        _scrollTitleLabel.font = [UIFont systemFontOfSize:14];
        _scrollTitleLabel.textColor = selectedTitleAndIndicatorViewColor;
        _scrollTitleLabel.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _scrollTitleLabel.layer.masksToBounds = YES;
        _scrollTitleLabel.layer.cornerRadius = 3;
        _scrollTitleLabel.layer.borderWidth = 0.5;
        _scrollTitleLabel.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        // 设置高亮文字颜色
//        _scrollTitleLabel.highlightedTextColor = selectedTitleAndIndicatorViewColor;
        
        // 计算内容的Size
        CGSize labelSize = [self sizeWithText:_scrollTitleLabel.text font:labelTextFontSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
        // 计算内容的宽度
        CGFloat labelW = labelSize.width + 2 * labelMargin;
        
        _scrollTitleLabel.frame = CGRectMake(labelX, labelY, labelW-10, labelH-12);
        
        // 计算每个label的X值
        labelX = labelX + labelW;
        
        // 添加到titleLabels数组
        [self.allTitleLabel addObject:_scrollTitleLabel];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTitleClick:)];
        [_scrollTitleLabel addGestureRecognizer:tap];
        
        // 默认选中第0个label
//        if (i == 0) {
//            [self scrollTitleClick:tap];
//        }
        
        [self addSubview:_scrollTitleLabel];
    }
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth+12, self.frame.size.height);
    
    // 取出第一个子控件
//    UILabel *firstLabel = self.subviews.firstObject;
    
    // 添加指示器
//    self.indicatorView = [[UIView alloc] init];
//    _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
//    _indicatorView.SG_height = indicatorHeight;
//    _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
//    [self addSubview:_indicatorView];
    
    
    // 指示器默认在第一个选中位置
    // 计算TitleLabel内容的Size
//    CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
//    _indicatorView.SG_width = labelSize.width;
//    _indicatorView.SG_centerX = firstLabel.SG_centerX;
}

-(void)setScrollTagArr:(NSArray *)scrollTagArr
{
    _scrollTagArr = scrollTagArr;
    
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = self.frame.size.height - indicatorHeight * 0.5;
    
    for (NSUInteger i = 0; i < self.scrollTagArr.count; i++) {
        TagListModel * tagModel = [self.scrollTagArr objectAtIndex:i];
        self.tapButton = [[TapButton alloc] init];
        _tapButton.userInteractionEnabled = YES;
        _tapButton.tag = i;

        //CGSize labelSize = [self sizeWithText:tagModel.title font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, labelH)];
        //CGFloat labelW = labelSize.width + 2 * tagMargin;
        
        CGFloat labelW = kScreenWidth/5;
        _tapButton.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [_tapButton loadWithTitle:tagModel.title imageName:tagModel.logoUrl selectedImageName:tagModel.selectedLogoUrl];
        labelX = labelX + labelW;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTitleClickTwo:)];
        [_tapButton addGestureRecognizer:tap];

        if (i == 0) {
            [self scrollTitleClickTwo:tap];
        }
        [self.storageAlltitleBtn_mArr addObject:_tapButton];
        [self addSubview:_tapButton];
    }
    

    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);

    TapButton *firstLabel = self.subviews.firstObject;

    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = [UIColor colorWithHexString:[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KIdle_SiftBottomLineColor]]?[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KIdle_SiftBottomLineColor]]:@"f9384c"];
    _indicatorView.SG_height = indicatorHeight;
    _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
    [self addSubview:_indicatorView];
    
    if (self.scrollTagArr.count > 0) {
        TagListModel * tagModel = [self.scrollTagArr objectAtIndex:0];
        CGSize labelSize = [self sizeWithText:tagModel.title font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, labelH)];
        _indicatorView.SG_width = labelSize.width + tagMargin;
        _indicatorView.SG_centerX = firstLabel.SG_centerX;
    }
}

/** tagButton的点击事件 */
- (void)scrollTitleClickTwo:(UITapGestureRecognizer *)tap {
    // 0.获取选中的label
    TapButton *selLabel = (TapButton *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self scrollTitleLabelSelectededTwo:selLabel];
    
    // 2.让选中的标题居中 (当contentSize 大于self的宽度才会生效)
    [self scrollTitleLabelSelectededCenterTwo:selLabel];
    NSInteger index = selLabel.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGTopTitleView:didSelectTitleAtIndex:)]) {
        [self.delegate_SG SGTopTitleView:self didSelectTitleAtIndex:index];
    }
}

/** scrollTitleClick的点击事件 */
- (void)scrollTitleClick:(UITapGestureRecognizer *)tap {

    UILabel *selLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self scrollTitleLabelSelecteded:selLabel];
    
    // 2.让选中的标题居中 (当contentSize 大于self的宽度才会生效)
    [self scrollTitleLabelSelectededCenter:selLabel];
    NSInteger index = selLabel.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGTopTitleView:didSelectTitleAtIndex:)]) {
        [self.delegate_SG SGTopTitleView:self didSelectTitleAtIndex:index];
    }
}

/** 滚动标题选中颜色改变以及指示器位置变化 */
- (void)scrollTitleLabelSelecteded:(UILabel *)label {
    _selectedTitleLabel.highlighted = NO;
    _selectedTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    _selectedTitleLabel.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    _selectedTitleLabel.layer.borderColor = [DataSources colorf9384c].CGColor;
    //多选
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.selectedLbl];
    
    if (self.selectedLbl.count > 0) {
        for (int i = 0; i < arr.count ; i++) {
            UILabel *lbl = arr[i];
            if (label == lbl) {
                label.highlighted = NO;
//                label.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                label.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
                [self.selectedLbl removeObject:lbl];
                break;
            } else {
                label.highlighted = YES;
//                label.backgroundColor = [UIColor colorWithHexString:@"999999"];
                label.layer.borderColor = [DataSources colorf9384c].CGColor;
                [self.selectedLbl addObject:label];
            }
        }
    } else {
        label.highlighted = YES;
//        label.backgroundColor = [UIColor colorWithHexString:@"999999"];
        label.layer.borderColor = [DataSources colorf9384c].CGColor;
        [self.selectedLbl addObject:label];
    }
    
    arr = self.selectedLbl;
    
//    if (label == _selectedTitleLabel) {
//        label.highlighted = NO;
//        label.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//        _selectedTitleLabel = nil;
//    } else {
//        label.highlighted = YES;
//        label.backgroundColor = [UIColor colorWithHexString:@"999999"];
//        _selectedTitleLabel = label;
//    }
    
    // 改变指示器位置
    if (_showsTitleBackgroundIndicatorStyle == YES) {
        [UIView animateWithDuration:0.20 animations:^{
            self.indicatorView.SG_width = label.SG_width - labelMargin;
            self.indicatorView.SG_centerX = label.SG_centerX;
        }];
    } else {
        [UIView animateWithDuration:0.20 animations:^{
            self.indicatorView.SG_width = label.SG_width - 2 * labelMargin;
            self.indicatorView.SG_centerX = label.SG_centerX;
        }];
    }
}

/** tagButton选中颜色改变以及指示器位置变化 */
- (void)scrollTitleLabelSelectededTwo:(TapButton *)tapButton {
    _selectTapButton.Seclecting = NO;
    tapButton.Seclecting = YES;
    _selectTapButton = tapButton;
    
    if (_showsTitleBackgroundIndicatorStyle == YES) {
        [UIView animateWithDuration:0.20 animations:^{
            self.indicatorView.SG_width = tapButton.SG_width - labelMargin;
            self.indicatorView.SG_centerX = tapButton.SG_centerX;
        }];
    } else {
        [UIView animateWithDuration:0.20 animations:^{
            self.indicatorView.SG_width = tapButton.SG_width - 2 * labelMargin;
            self.indicatorView.SG_centerX = tapButton.SG_centerX;
        }];
    }
}

/** 滚动标题选中居中 */
- (void)scrollTitleLabelSelectededCenter:(UILabel *)centerLabel {
    if (self.contentSize.width > kScreenWidth) {
        CGFloat offsetX = centerLabel.center.x - kScreenWidth * 0.5;
        
        if (offsetX < 0) offsetX = 0;
        CGFloat maxOffsetX = self.contentSize.width - kScreenWidth;
        
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}


/** tagButton滚动标题选中居中 */
- (void)scrollTitleLabelSelectededCenterTwo:(TapButton *)tapButton {
    if (self.contentSize.width > kScreenWidth) {
        CGFloat offsetX = tapButton.center.x - kScreenWidth * 0.5;
        
        if (offsetX < 0) offsetX = 0;
        CGFloat maxOffsetX = self.contentSize.width - kScreenWidth;
        
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}


#pragma mark - - - setter
- (void)setIsHiddenIndicator:(BOOL)isHiddenIndicator {
    if (isHiddenIndicator == YES) {
        [self.indicatorView removeFromSuperview];
    }
}

- (void)setTitleAndIndicatorColor:(UIColor *)titleAndIndicatorColor {
    _titleAndIndicatorColor = titleAndIndicatorColor;
    
    for (UIView *subViews in self.allTitleLabel) {
        UILabel *label = (UILabel *)subViews;
        label.highlightedTextColor = titleAndIndicatorColor;
    }
    _indicatorView.backgroundColor = titleAndIndicatorColor;
}

- (void)setShowsTitleBackgroundIndicatorStyle:(BOOL)showsTitleBackgroundIndicatorStyle {
    _showsTitleBackgroundIndicatorStyle = showsTitleBackgroundIndicatorStyle;
    
    if (showsTitleBackgroundIndicatorStyle == YES) {
        
        [self.indicatorView removeFromSuperview];
        
        // 取出第一个子控件
        UILabel *firstLabel = self.subviews.firstObject;
        
        // 添加指示器
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
        _indicatorView.SG_height = indicatorHeight;
        _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
        [self addSubview:_indicatorView];
        
        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        _indicatorView.SG_width = labelSize.width + labelMargin;
        _indicatorView.SG_centerX = firstLabel.SG_centerX;
        
        CGFloat indicatorViewHeight = 25;
        self.indicatorView.SG_height = indicatorViewHeight;
        self.indicatorView.SG_y = (self.frame.size.height - indicatorViewHeight) * 0.5;
    }
    
    self.indicatorView.alpha = 0.3;
    self.indicatorView.layer.cornerRadius = 5;
    self.indicatorView.layer.masksToBounds = YES;
}

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView {
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 防止下标越界引起程序崩溃
    if (index >= self.storageAlltitleBtn_mArr.count) {
        return;
    }
    
    // 2、把对应的标题选中
    TapButton *selectedBtn = self.storageAlltitleBtn_mArr[index];
    
    // 3、滚动时，改变标题选中
    [self scrollTitleLabelSelectededTwo:selectedBtn];
    [self scrollTitleLabelSelectededCenterTwo:selectedBtn];
}


@end





