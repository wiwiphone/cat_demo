//
//  PasswordView.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PasswordView.h"
#import "UIInsetCtrls.h"

#define TITLE_HEIGHT 46

@interface PasswordView()<UITextFieldDelegate>
{
    CGFloat angle;
}

@property (nonatomic, strong) UIView * PasswordAlert, *line;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIInsetTextField * passwordTf;
@property (nonatomic, strong) UIImageView * circle;




@end

@implementation PasswordView

-(instancetype)init
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        [self drawView];
    }
    return self;
}


-(void)drawView
{
    if (!_PasswordAlert) {
        _PasswordAlert = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-400, kScreenWidth, 400)];
        _PasswordAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:1];
        [self addSubview:self.PasswordAlert];
        
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(0, 0, TITLE_HEIGHT, TITLE_HEIGHT)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_PasswordAlert addSubview:_closeBtn];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, TITLE_HEIGHT)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"95989a"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_PasswordAlert addSubview:_titleLabel];
        
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, TITLE_HEIGHT, kScreenWidth, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [_PasswordAlert addSubview:_line];
        
        
        _passwordTf = [[UIInsetTextField alloc] initWithFrame:CGRectMake(50, TITLE_HEIGHT+20, kScreenWidth-100, 40) rectInsetDX:10 rectInsetDY:0];
        _passwordTf.layer.borderWidth = 0.5;
        _passwordTf.layer.borderColor = [UIColor colorWithHexString:@"95989a"].CGColor;
        _passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTf.delegate = self;
        _passwordTf.secureTextEntry = YES;
        [_PasswordAlert addSubview:self.passwordTf];
        
        _circle = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 200, 100, 100)];
        _circle.image = [UIImage imageNamed:@"semi-circle"];
        _circle.contentMode = UIViewContentModeCenter;
//        _circle.layer.masksToBounds = YES;
//        _circle.layer.cornerRadius = 50;
//        _circle.backgroundColor = [UIColor blackColor];
        [_PasswordAlert addSubview:_circle];
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //每一秒执行一次 误差1秒
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0.3 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
        self.circle.transform = endAngle;
        angle += 2; [self startAnimation];

        if (!_stop) {
            //取消计时器
            //必须设置几时去关闭的条件  计时器才能运行
            dispatch_source_cancel(timer);
        }
    });
    //开始计时器
    dispatch_resume(timer);
    
    if (self.textFileDidEndedit) {
        self.textFileDidEndedit(textField.text);
    }
    
}
-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.circle.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    angle += 2;
    [self startAnimation];
}



- (void)dismiss {
    self.textFileDidEndedit = nil;
    [_passwordTf resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [_passwordTf becomeFirstResponder];
}

#pragma mark -
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}

@end
