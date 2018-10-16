//
//  RXRotateButtonOverlayView.m
//  XianMao
//
//  Created by WJH on 17/2/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "RXRotateButtonOverlayView.h"
#import "ImageAndTitleVerticalButton.h"
#import "OverlayTapDetectingView.h"
#import "AssessViewController.h"

static CGFloat btnWidth = 80.0f;
static CGFloat btnOffsetY = 90.0;
static CGFloat mainBtnWidth = 43;

@interface RXRotateButtonOverlayView()

@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIButton* mainBtn;
@property (nonatomic, strong) NSMutableArray* btns;
@property (nonatomic, strong) UITapGestureRecognizer* tap;
@property (nonatomic, strong) OverlayTapDetectingView* tapDetectingView;
@property (nonatomic, strong) UIView *darkView;

@end

@implementation RXRotateButtonOverlayView


- (instancetype)init
{
    if (self=[super init]) {

    }
    return self;
}


- (void)builtInterface
{
    [self removeGestureRecognizer:self.tap];
    [self addGestureRecognizer:self.tap];
    //clear dynamic behaviours
    [self.animator removeAllBehaviors];
    //clear btns
    [self.btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.btns removeAllObjects];
    [self.tapDetectingView removeFromSuperview];
    //解决iOS7和iOS11.2崩溃问题
    [self.darkView removeFromSuperview];
    
    self.darkView = [[UIView alloc] initWithFrame:self.bounds];
    self.darkView.backgroundColor = [UIColor blackColor];
    self.darkView.alpha = 0.85f;
    [self addSubview:self.darkView];
    //
    //add new Btns
    if (self.titles.count > 0) {


        for (int i = 0; i < self.titles.count; i++) {
            UIView* v = nil;
            NSString * title = [self.titles objectAtIndex:i];
            if ((self.titleImages.count == self.titles.count) &&
                (self.titles.count == self.subTitles.count)) {
                NSUInteger index = [self.titles indexOfObject:title];
                v = [self addBtnWithTitle:title andTitleImage:[self.titleImages objectAtIndex:index] subTitle:[self.subTitles objectAtIndex:i]];
            }else{
                v = [self addBtnWithTitle:title];
            }
            v.tag = 20170228+i;
            [self.btns addObject:v];
        }
        [self addSubview:self.mainBtn];
    }

    //addTapDetectingView估价
    if (!_tapDetectingView) {
        _tapDetectingView = [[OverlayTapDetectingView alloc] initWithFrame:CGRectMake(20, 80, kScreenWidth-40, 66)];
        _tapDetectingView.layer.masksToBounds = YES;
        _tapDetectingView.layer.cornerRadius = 5;
        [self addSubview:_tapDetectingView];
    }
    WEAKSELF;
    _tapDetectingView.handleSingleTapDetected =^(TapDetectingView *view, UIGestureRecognizer *recognizer){

        [UIView animateWithDuration:0.0001 animations:^{
            AssessViewController * viewController = [[AssessViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        } completion:^(BOOL finished) {
            [weakSelf dismiss];
        }];
    };
}



#pragma mark - public
//show the overlay
- (void)show
{
    [self builtInterface];
    [UIView animateWithDuration:.3 animations:^{
        self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
    
    NSInteger count = self.btns.count;
    CGFloat space = 0;
    space = ([UIScreen mainScreen].bounds.size.width - count * (kScreenWidth/375* btnWidth) ) / (count + 1 );
    [self.animator removeAllBehaviors];
    for (int i = 0; i< count; i++) {
        
        CGPoint buttonPoint=  CGPointMake((i + 1)* (space ) + (i+0.5) * (kScreenWidth/375* btnWidth), [UIScreen mainScreen].bounds.size.height - btnOffsetY * 2);
        UISnapBehavior *sna = [[UISnapBehavior alloc]initWithItem:[self.btns objectAtIndex:i] snapToPoint:buttonPoint];
        sna.damping = .5;
        [self.animator addBehavior:sna];
    }
}

//dismiss the overlay
- (void)dismiss
{
    [UIView animateWithDuration:.3 animations:^{
        self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI / 180.0);
    }];
    
    NSInteger count = self.btns.count;
    CGPoint point = self.mainBtn.center;
    [self.animator removeAllBehaviors];
    for (int i = 0; i< count; i++) {
        UIView* v = [self.btns objectAtIndex:i];
        [UIView animateWithDuration:.2 animations:^{
            [v setAlpha:0];
        }];
        UISnapBehavior *sna = [[UISnapBehavior alloc]initWithItem:v snapToPoint:point];
        sna.damping = .9;
        [self.animator addBehavior:sna];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

#pragma mark - action

- (void)selectBtnAction:(UITapGestureRecognizer*)gesture
{
    UIButton* btn = (UIButton*)gesture.view;
    
    switch (btn.tag) {
        case 20170228:{ //寄卖
            if ([self.delegate respondsToSelector:@selector(pushPublishNofm)]) {
                [self.delegate pushPublishNofm];
            }
            break;
        }
            
        case 20170229:{//自己卖
            if ([self.delegate respondsToSelector:@selector(pushPublishRecovery)]) {
                [self.delegate pushPublishRecovery];
            }
            break;
        }
        case 20170230:{//草稿箱
            if ([self.delegate respondsToSelector:@selector(pushPublishDraft)]) {
                [self.delegate pushPublishDraft];
            }
            break;
        }
        default:
            break;
    }
    
}



- (void)clickedSelf:(id)sender
{
    [self dismiss];
}
- (void)btnClicked:(id)sender
{
    [self dismiss];
}

#pragma mark - private
- (UIView*)addBtnWithTitle:(NSString*)title andTitleImage:(NSString*)imageName subTitle:(NSString *)subTitle
{
    
    ImageAndTitleVerticalButton *view = [[ImageAndTitleVerticalButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - (kScreenWidth/375* btnWidth) / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, (kScreenWidth/375* btnWidth), (kScreenWidth/375* btnWidth))];
    view.subTitle.text = subTitle;
    view.titleLabel.textColor = [UIColor whiteColor];
    [view setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [view setTitle:title forState:UIControlStateNormal];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:view];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnAction:)]];
    return view;
}

- (UIView*)addBtnWithTitle:(NSString*)title
{
    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - (kScreenWidth/375* btnWidth) / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, (kScreenWidth/375* btnWidth), (kScreenWidth/375* btnWidth))];
    view.titleLabel.textColor = [UIColor whiteColor];
    view.backgroundColor = [UIColor yellowColor];
    [view setTitle:title forState:UIControlStateNormal];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = (kScreenWidth/375* btnWidth) / 2.0;
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:view];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnAction:)]];
    return view;
}


#pragma mark - getter & setter
- (UITapGestureRecognizer *)tap
{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSelf:)];
    }
    return _tap;
}

- (UIDynamicAnimator *)animator
{
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}
- (UIButton *)mainBtn
{
    if (_mainBtn == nil) {
        _mainBtn = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - mainBtnWidth/2, [[UIScreen mainScreen] bounds].size.height - mainBtnWidth-4, mainBtnWidth, mainBtnWidth)];
        [_mainBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_mainBtn.layer setCornerRadius:mainBtnWidth / 2.0];
        UIImage* image = [UIImage imageNamed:@"Publish_Tabbar_Cebter"];
        [_mainBtn setImage:image forState:UIControlStateNormal];
    }
    return _mainBtn;
}

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (void)setTitles:(NSArray *)titles
{
    self.btns = [NSMutableArray array];
    _titles = [NSArray arrayWithArray:titles];
}

- (void)setTitleImages:(NSArray *)titleImages
{
    self.btns = [NSMutableArray array];
    _titleImages = [NSArray arrayWithArray:titleImages];
}

- (void)setSubTitles:(NSArray *)subTitles{
    self.btns = [NSMutableArray array];
    _subTitles = [NSArray arrayWithArray:subTitles];
}

@end
