//
//  TabBarView.m
//  VoPai
//
//  Created by simon cai on 10/15/13.
//  Copyright (c) 2013 taobao.com. All rights reserved.
//

#import "TabBarView.h"
#import "Masonry.h"
#import "GuideView.h"
#import "Session.h"

@interface TabBarView () <TabBarButtonDelegate>

@property (nonatomic, strong) UIImageView *imageCenterView;
@property (nonatomic, assign) NSInteger seletedCount;

@end

@implementation TabBarView

- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame buttonDicts:(NSArray *)buttonDicts
{
    self = [super initWithFrame:frame];
    if (self) {
        self.seletedCount = 0;
        
        CALayer * topLine = [[CALayer alloc] init];
        topLine.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        topLine.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5);
        [self.layer addSublayer:topLine];

        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        CGFloat posX = 0.f;
		CGFloat width = self.bounds.size.width/[buttonDicts count];
        for (int i = 0; i < [buttonDicts count]; i++) {
            if ([[buttonDicts objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                TabBarButton *btn = [[TabBarButton alloc] initWithFrame:CGRectZero dict:[buttonDicts objectAtIndex:i]];
                btn.tag = i;
                btn.backgroundColor = [UIColor clearColor];
                btn.frame = CGRectMake(posX, 0, width, frame.size.height);
                btn.delegate = self;
                posX += width;
                [self addSubview:btn];
            }
        }
        [self setUpUI];
    }
    return self;
}

-(void)setButtonDicts:(NSArray *)buttonDicts{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.seletedCount = 0;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    CGFloat posX = 0.f;
    CGFloat width = self.bounds.size.width/[buttonDicts count];
    for (int i = 0; i < [buttonDicts count]; i++) {
        if ([[buttonDicts objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            TabBarButton *btn = [[TabBarButton alloc] initWithFrame:CGRectZero dict:[buttonDicts objectAtIndex:i]];
            btn.tag = i;
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(posX, 0, width, kBottomTabBarHeight);
            btn.delegate = self;
            posX += width;
            [self addSubview:btn];
        }
    }
    [self setUpUI];
}

-(void)setUpUI{

    NSArray *subviews = [self subviews];
    NSInteger index = 0;
    CGFloat posX = 0.f;
    CGFloat width = self.bounds.size.width/[subviews count];//self.bounds.size.width/[subviews count];//subView.count - 1 因为多添加了一个子控件 count比之前多了1 所以减一防止UI错乱 2016.3.25 Feng
    for (int i=0;i <[subviews count];i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[TabBarButton class]]) {
            TabBarButton *btn = (TabBarButton*)[subviews objectAtIndex:i];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(posX, 0, width, CGRectGetHeight(self.bounds));
            btn.delegate = self;
            posX += width;
            [self addSubview:btn];
            index+=1;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (CGFloat)realHeight {
    return self.bounds.size.height;
}

- (void)selectTabAtIndex:(NSInteger)index
{
    [self selectTabAtIndex:index selectedMethod:TabBarButtonSelected];
}

- (void)selectTabAtIndex:(NSInteger)index selectedMethod:(TabBarButtonSelectedMethod)selectedMethod
{
    BOOL isContinue = YES;
    
    if (index == 2) {
        
        if ([self.delegate respondsToSelector:@selector(catapultOptionView)]) {
            [self.delegate catapultOptionView];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:beforeSelectAtIndex:selectedMethod:)]) {
        isContinue = [self.delegate tabBarView:self beforeSelectAtIndex:index selectedMethod:selectedMethod];
    }
    
    if (isContinue) {
        BOOL isCheckableBtnOfCurIndex = NO;
        NSArray *subviews = [self subviews];
        for (int i=0;i <[subviews count];i++) {
            if ([[subviews objectAtIndex:i] isKindOfClass:[TabBarButton class]]) {
                TabBarButton *btn = (TabBarButton*)[subviews objectAtIndex:i];
                if (btn.tag == index) {
                    isCheckableBtnOfCurIndex = [btn isCheckableBtn];
                    if (!isCheckableBtnOfCurIndex) {
                        btn.selected = NO;
                    }
                    break;
                }
            }
        }
        if (isCheckableBtnOfCurIndex) {
            for (int i=0;i <[subviews count];i++) {
                if ([[subviews objectAtIndex:i] isKindOfClass:[TabBarButton class]]) {
                    TabBarButton *btn = (TabBarButton*)[subviews objectAtIndex:i];
                    btn.selected = (btn.tag==index)?YES:NO;
                }
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:didSelectAtIndex:selectedMethod:)]) {
            [self.delegate tabBarView:self didSelectAtIndex:index selectedMethod:selectedMethod];
        }
    }
}

- (void)handleTabBarButtonSingleTap:(TabBarButton*)btn
{
     [self selectTabAtIndex:btn.tag selectedMethod:TabBarButtonSelectedByClicked];
}

- (void)handleTabBarButtonDoubleTap:(TabBarButton*)btn
{
    [self selectTabAtIndex:btn.tag selectedMethod:TabBarButtonSelectedByDoubleClicked];
}

- (void)handleTabBarButtonLongPressed:(TabBarButton*)btn
{
    [self selectTabAtIndex:btn.tag selectedMethod:TabBarButtonSelectedByLongPressed];
}

- (NSArray*)tabBarButtonArray {
    return [self subviews];
}

@end
