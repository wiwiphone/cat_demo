//
//  EMChatGoodsCell.m
//  XianMao
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "EMChatGoodsCell.h"
#import "DataSources.h"
#import "Masonry.h"
#import "Command.h"
#import "ShoppingCartItem.h"
#import "PayViewController.h"
#import "SuccessfulPayViewController.h"
#import "BoughtCollectionViewController.h"

@interface EMChatGoodsCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *grandLbl;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) CommandButton *buyBtn;

@end

@implementation EMChatGoodsCell

-(CommandButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyBtn.backgroundColor = [DataSources colorf9384c];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 2;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBtn sizeToFit];
    }
    return _buyBtn;
}

-(UILabel *)grandLbl{
    if (!_grandLbl) {
        _grandLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _grandLbl.font = [UIFont systemFontOfSize:13.f];
        _grandLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];//🆚
        _grandLbl.numberOfLines = 0;
    }
    return _grandLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

-(UILabel *)goodsName{
    if (!_goodsName) {
        _goodsName = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsName.font = [UIFont systemFontOfSize:15.f];
        _goodsName.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _goodsName.numberOfLines = 0;
        [_goodsName sizeToFit];
    }
    return _goodsName;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:12.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _priceLbl.numberOfLines = 0;
    }
    return _priceLbl;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sendBtn setTitle:@"发送商品链接" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _sendBtn.layer.borderWidth = 0.5;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 2;
        _sendBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
    }
    return _sendBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.goodsName];
        [self.contentView addSubview:self.grandLbl];
        [self.contentView addSubview:self.priceLbl];
        [self.contentView addSubview:self.sendBtn];
        [self.contentView addSubview:self.buyBtn];
        [self.sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
        WEAKSELF;
        self.buyBtn.handleClickBlock = ^(CommandButton *sender){
            NSMutableArray *items = [[NSMutableArray alloc] init];
            [items addObject:[ShoppingCartItem createWithGoodsInfo:weakSelf.goodsInfo]];
            
            PayViewController *viewController = [[PayViewController alloc] init];
            viewController.items = items;
            viewController.goodsInfo = weakSelf.goodsInfo;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            
            viewController.handlePayDidFnishBlock = ^(BaseViewController *payViewController, NSInteger index) {
                if (index == 1) {
                    
                    [payViewController dismiss:NO];
                    
                    SuccessfulPayViewController *controller = [[SuccessfulPayViewController alloc] init];
                    controller.goodsId = weakSelf.goodsInfo.goodsId;
                    [[CoordinatingController sharedInstance] pushViewController:controller animated:YES];
                } else if (index == 0) {
                    if (weakSelf.gotoBoughtViewController) {
                        weakSelf.gotoBoughtViewController(payViewController);
                    }
//                    [payViewController dismiss];
                }
            };
        };
    }
    return self;
}

-(void)clickSendBtn{
    if (self.sendGoodsMessage) {
        self.sendGoodsMessage();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@74);
        make.height.equalTo(@74);
    }];
    
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(-10);
//        make.bottom.equalTo(self.contentView.mas_centerY).offset(10);
    }];
    
    [self.grandLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsName.mas_bottom).offset(5);
        make.left.equalTo(self.goodsName.mas_left);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsName.mas_left);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.width.equalTo(@66);
        make.height.equalTo(@20);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buyBtn.mas_left).offset(-12);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.width.equalTo(@90);
        make.height.equalTo(@20);
    }];
    
}

-(void)setGoodsInfo:(GoodsInfo *)goodsInfo{
    _goodsInfo = goodsInfo;
    self.goodsName.text = goodsInfo.goodsName;
    self.priceLbl.text = [NSString stringWithFormat:@"¥ %.2f", goodsInfo.shopPrice];
    [self.iconImageView setImageWithURL:goodsInfo.mainPicUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.grandLbl.text = goodsInfo.gradeTag.name;
}

@end
