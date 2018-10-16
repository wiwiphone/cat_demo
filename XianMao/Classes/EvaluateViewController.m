//
//  EvaluateViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/8/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "EvaluateViewController.h"
#import "HPGrowingTextView.h"
#import "ReturnHomeCtrlView.h"
#import "NSString+Addtions.h"
#import "BaseService.h"
#import "Error.h"

@interface EvaluateViewController ()

@property (nonatomic,strong) HPGrowingTextView * textView;
@property (nonatomic,strong) UIButton * submitBtn;


@end

@implementation EvaluateViewController


-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
        
    }
    return _submitBtn;
}


-(HPGrowingTextView *)textView{
    if (!_textView) {
        _textView = [[HPGrowingTextView alloc] init];
        _textView.placeholder = @"把你想要的功能或者任何建议告诉我们吧~我们的产品经理会仔细阅读每一条，并作为新版APP改进的重要参考。";
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.contentInset = UIEdgeInsetsMake(0, 6, 0, 8);
        _textView.isScrollable = NO;
        _textView.enablesReturnKeyAutomatically = NO;
        _textView.animateHeightChange = NO;
        _textView.autoRefreshHeight = NO;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.maxNumberOfLines = 8;
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"用户反馈"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.submitBtn];
    
    [self.submitBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self customUI];
}

-(void)show{
    
    NSString *content = [self.textView.text trim];
    if ([content length]>0) {
        WEAKSELF;
        [PlatformService post_feedback:content completion:^{
            ReturnHomeCtrlView * returHome = [[ReturnHomeCtrlView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [returHome show];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
        }];
    }
  
}

- (void)customUI {
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(1);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(260);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-24);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(40);
    }];
    
}





@end
