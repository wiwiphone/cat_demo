//
//  RreshenShowView.m
//  AutoAdLabelScroll
//
//  Created by WJH on 16/11/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RreshenShowView.h"
#import "BlackView.h"


@interface RreshenShowView()

@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * dayLbl;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * rreshenBtn;
@property (nonatomic, strong) GoodsInfo * goodsInfo;
@property (nonatomic, strong) BlackView * blackView;

@end

@implementation RreshenShowView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _blackView = [[BlackView alloc] init];
        _blackView.frame = self.bounds;
        self.blackView.alpha = 0.3;
        [self addSubview:self.blackView];
        [self drawView];
        
        WEAKSELF;
        self.blackView.dissMissBlackView = ^(){
            [weakSelf dismiss];
        };
    }
    
    return self;
}


-(void)drawView{
    
    
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.center = self.center;
        [self addSubview:self.containerView];

        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.containerView addSubview:self.closeBtn];

        
        _dayLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dayLbl.backgroundColor = [UIColor colorWithHexString:@"333333"];
        _dayLbl.textColor = [UIColor whiteColor];
        _dayLbl.textAlignment = NSTextAlignmentCenter;
        _dayLbl.font = [UIFont systemFontOfSize:20];
        _dayLbl.layer.masksToBounds = YES;
        _dayLbl.layer.cornerRadius = 35;
        [_containerView addSubview:self.dayLbl];

        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _title.font = [UIFont systemFontOfSize:13];
        _title.adjustsFontSizeToFitWidth = YES;
        _title.numberOfLines = 0;
        NSString * text = @"宝贝还有30天展示时间, 到期会自动下架, 您可以通过[立即擦亮]重新获得30天展示, 已下架宝贝也可以通过重新上架再次开卖.";
        _title.text = text;
        NSMutableAttributedString *attStrSupplier = [[NSMutableAttributedString alloc]initWithString:text];
        NSMutableParagraphStyle *styleSupplier = [[NSMutableParagraphStyle alloc]init];
        [styleSupplier setLineSpacing:5.0f];
        
        [attStrSupplier addAttribute:NSParagraphStyleAttributeName value:styleSupplier range:NSMakeRange(0,text.length)];
        
        _title.attributedText =attStrSupplier;
        [_title sizeToFit];
        [_containerView addSubview:self.title];

        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"知道了" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];



        _rreshenBtn = [[UIButton alloc] init];
        [_rreshenBtn setTitle:@"立即擦亮" forState:UIControlStateNormal];
        [_rreshenBtn setTitleColor:[UIColor colorWithHexString:@"f4433e"] forState:UIControlStateNormal];
        _rreshenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _rreshenBtn.layer.borderWidth = 1;
        _rreshenBtn.layer.borderColor = [UIColor colorWithHexString:@"f4433e"].CGColor;
        [_rreshenBtn addTarget:self action:@selector(rreshenBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_containerView addSubview:self.cancelBtn];
        [_containerView addSubview:self.rreshenBtn];
        
       
        
        
    }
}


-(void)cancelBtnClick{
    
    [self dismiss];
}

-(void)rreshenBtnClick{
    
    if (self.handleRreshenBlcok) {
        self.handleRreshenBlcok(self.goodsInfo);
    }
}

- (void)getGoodsInfo:(GoodsInfo *)goodsInfo{
    if (goodsInfo) {
        _goodsInfo = goodsInfo;
        self.dayLbl.text = [NSString stringWithFormat:@"%ld天",(long)goodsInfo.surplusDay];
    }
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.containerView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
        self.containerView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*320, 220));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.right.equalTo(self.containerView.mas_right);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.centerY.equalTo(self.containerView.mas_top);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(60);
        make.left.equalTo(self.containerView.mas_left).offset(26);
        make.right.equalTo(self.containerView.mas_right).offset(-26);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-24);
        make.left.equalTo(self.containerView.mas_left).offset(26);
        make.width.mas_equalTo(kScreenWidth/375*128);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.rreshenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-24);
        make.right.equalTo(self.containerView.mas_right).offset(-26);
        make.width.mas_equalTo(kScreenWidth/375*128);
        make.height.mas_equalTo(40);
    }];
}

@end
