//
//  RecommendSiftTitleView.m
//  XianMao
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecommendSiftTitleView.h"

@interface RecommendSiftTitleView () <UIScrollViewDelegate>

@property (nonatomic, strong) RecommendInfo *recommendInfo;

@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGFloat selectedTitlesWidth;
@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation RecommendSiftTitleView

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [UIColor clearColor];//colorWithHexString:@"ebebeb"
    }
    return _bottomLineView;
}

-(UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = [UIColor clearColor];
    }
    return _topLineView;
}

-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc] init];
    }
    return _titleArr;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    }
    return _lineView;
}

-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
}

-(void)getRecommendInfo:(RecommendInfo *)recommendInfo andTag:(NSInteger)tag{
    if (self.subviews.count == 0) {
        [self.btnArr removeAllObjects];
        WEAKSELF;
        CGFloat margin = 25;
        self.recommendInfo = recommendInfo;
        [self addSubview:self.topLineView];
        [self addSubview:self.bottomLineView];
        [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@1);
        }];
        
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@1);
        }];
        [self addSubview:self.scrollView];
        for (int i = 0; i < recommendInfo.list.count; i++) {
            RedirectInfo *followDic = recommendInfo.list[i];
            [self.titleArr addObject:followDic.title];
            CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectZero];
            [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
            [btn setTitle:followDic.title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
            [btn sizeToFit];
            btn.tag = i + 100;
            if (btn.tag == tag) {
                [UIView animateWithDuration:0.25 animations:^{
                    btn.selected = YES;
                    btn.frame = CGRectMake(margin, self.height/2-btn.height/2, btn.width + 10, btn.height);
                    weakSelf.lineView.frame = CGRectMake(btn.left-5, self.height-3, btn.width+20, 2);
                }];
            } else {
                btn.selected = NO;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                btn.frame = CGRectMake(margin, self.height/2-btn.height/2, btn.width + 10, btn.height);
            }];
            margin += (btn.width+10);
            margin += 10;
            //        }
            btn.recommendUrl = followDic.url;
            [self.btnArr addObject:btn];
            btn.handleClickBlock = ^(CommandButton *sender){
                
            };
            
        }
        [self getButtonsWidthWithTitles:self.titleArr];
        [self.scrollView addSubview:self.lineView];
        
        self.scrollView.contentSize = CGSizeMake(margin, self.height);
    }
}

-(void)clickBtn:(CommandButton *)sender{
    WEAKSELF;
//    [weakSelf scrollTitleLabelSelectededCenter:sender];
    
    for (int i = 0; i < self.btnArr.count; i++) {
        CommandButton *btnA = self.btnArr[i];
        sender.selected = YES;
        if (sender.tag == btnA.tag) {
            
        } else {
            btnA.selected = NO;
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.lineView.frame = CGRectMake(sender.left-5, self.height-3, sender.width+10, 2);
    }];
    
    if (weakSelf.handleRecommendBtn) {
        weakSelf.handleRecommendBtn(sender);
    }
    //                CGFloat offsetX = sender.width + 50 - kScreenWidth * 0.5;
    //                NSLog(@"%.2f", offsetX);
    //                CGFloat offsetMax = _selectedTitlesWidth - kScreenWidth + 10;
    //                if (offsetX < 0 || offsetMax < 0) {
    //                    offsetX = 0;
    //                } else if (offsetX > offsetMax){
    //                    offsetX = offsetMax;
    //                }
    //
    //                if (index >= 0 && index < recommendInfo.list.count / 2) {
    //                    [self.scrollView setContentOffset:CGPointMake(-10, 0) animated:YES];
    //                } else {
    //                }
}

/** 滚动标题选中居中 */
- (void)scrollTitleLabelSelectededCenter:(CommandButton *)btn {
    if (self.scrollView.contentSize.width > kScreenWidth) {
        CGFloat offsetX = btn.center.x - kScreenWidth * 0.5;
        
        if (offsetX < 0) offsetX = 0;
        CGFloat maxOffsetX = self.scrollView.contentSize.width - kScreenWidth;
        
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    _selectedTitlesWidth = 0;
    for (NSString *title in titles)
    {
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} context:nil].size;
        CGFloat eachButtonWidth = size.width + 20.f;
        _selectedTitlesWidth += eachButtonWidth;
        NSNumber *width = [NSNumber numberWithFloat:eachButtonWidth];
        [widths addObject:width];
    }
    if (_selectedTitlesWidth < kScreenWidth) {
        [widths removeAllObjects];
        NSNumber *width = [NSNumber numberWithFloat:kScreenWidth / titles.count];
        for (int index = 0; index < titles.count; index++) {
            [widths addObject:width];
        }
    }
    return widths;
}

@end
