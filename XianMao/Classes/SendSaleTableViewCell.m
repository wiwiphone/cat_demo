//
//  SendSaleTableViewCell.m
//  XianMao
//
//  Created by WJH on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendSaleTableViewCell.h"
#import "Command.h"
#import "PictureItem.h"
#import "NSDate+Category.h"
#import "ActionVo.h"

@interface SendSaleTableViewCell()

@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic, strong) UILabel * consignorName;
@property (nonatomic, strong) UILabel * goodsStatus;
@property (nonatomic, strong) XMWebImageView * goodsImageView;
@property (nonatomic, strong) UILabel * goodsName;
@property (nonatomic, strong) UILabel * goodsPrice;
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UILabel * time;
@property (nonatomic, strong) UILabel * operationStatus;
@property (nonatomic, strong) XMWebImageView * portrait;
@property (nonatomic, strong) SendSaleVo * sendVo;


@end

@implementation SendSaleTableViewCell


- (XMWebImageView *)goodsImageView{
    if (!_goodsImageView) {
        _goodsImageView = [[XMWebImageView alloc] init];
        _goodsImageView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _goodsImageView;
}

- (XMWebImageView *)portrait{
    if (!_portrait) {
        _portrait = [[XMWebImageView alloc] init];
        _portrait.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _portrait.layer.masksToBounds = YES;
        _portrait.layer.cornerRadius = 9;
    }
    return _portrait;
}

- (UILabel *)consignorName{
    if (!_consignorName) {
        _consignorName = [self createBlackLabelWithFont:12];
        [_consignorName sizeToFit];
    }
    return _consignorName;
}

- (UILabel *)goodsStatus{
    if (!_goodsStatus) {
        _goodsStatus = [self createLightGrayLabelWithFont:13];
    }
    return _goodsStatus;
}

- (UILabel *)goodsName{
    if (!_goodsName) {
        _goodsName = [self createBlackLabelWithFont:13];
        _goodsName.numberOfLines = 2;
    }
    return _goodsName;
}

- (UILabel *)goodsPrice{
    if (!_goodsPrice) {
        _goodsPrice = [self createBlackLabelWithFont:12];
    }
    return _goodsPrice;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"jimai"];
    }
    return _icon;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _line;
}

- (UILabel *)time{
    if (!_time) {
        _time = [self createLightGrayLabelWithFont:14];
    }
    return _time;
}

- (UILabel *)operationStatus{
    if (!_operationStatus) {
        _operationStatus = [self createLightGrayLabelWithFont:14];
    }
    return _operationStatus;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SendSaleTableViewCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    
    CGFloat rowHeight = 200;
    return rowHeight;
}


+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendSaleTableViewCell class]];
    if (sendVo) {
        [dict setObject:sendVo forKey:[SendSaleTableViewCell cellKeyForsendVo]];
    }
    return dict;
}

+ (NSString *)cellKeyForsendVo{
    return @"sendVo";
}

- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.userInteractionEnabled = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _containerView.layer.shadowOffset = CGSizeMake(1,2);
        _containerView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
        _containerView.layer.shadowRadius = 3;//阴影半径，默认3
        _containerView.layer.cornerRadius = 8;
        _containerView.layer.shadowPath = [[UIBezierPath
                                                    bezierPathWithRect:_containerView.bounds] CGPath];
    }
    return _containerView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor  = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.containerView];
        
        [self.containerView addSubview:self.portrait];
        [self.containerView addSubview:self.consignorName];
        [self.containerView addSubview:self.goodsStatus];
        [self.containerView addSubview:self.goodsImageView];
        [self.containerView addSubview:self.goodsName];
        [self.containerView addSubview:self.goodsPrice];
        [self.containerView addSubview:self.icon];
        [self.containerView addSubview:self.line];
        [self.containerView addSubview:self.time];
        [self.containerView addSubview:self.operationStatus];

    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    
    SendSaleVo *sendVo = [dict objectForKey:[SendSaleTableViewCell cellKeyForsendVo]];
    if (sendVo) {
        _sendVo = sendVo;
        
        self.consignorName.text = sendVo.themeName;
        [self.portrait setImageWithURL:sendVo.themeAvatar XMWebImageScaleType:XMWebImageScale40x40];
        self.goodsStatus.text = sendVo.sdesc;
        self.goodsName.text = sendVo.title;
        self.goodsPrice.text = [NSString stringWithFormat:@"¥ %.2f",sendVo.userHopePrice];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sendVo.createtime/1000];
        self.time.text = [NSString stringWithFormat:@"%@",[date XMformattedDateDescription]];
        self.operationStatus.text = sendVo.statusDesc;
        if (sendVo.attachment.count > 0) {
            PictureItem * pic = [sendVo.attachment  objectAtIndex:0];
            [self.goodsImageView setImageWithURL:pic.picUrl XMWebImageScaleType:XMWebImageScale160x160];
        }
        
        
        for (UIView *view in self.containerView.subviews) {
            if ([view isKindOfClass:[CommandButton class]]) {
                [view removeFromSuperview];
            }
        }
        NSArray * array = [sendVo returnActionsButtons];
        CGFloat btnWidth = kScreenWidth/375*100;
        CGFloat btnFrameY = 200-35;
        for (int i = 0; i < array.count; i++) {
            CommandButton * button = [self createActionButton];
            ActionVo * actionVo = [ActionVo createWithDict:[array objectAtIndex:i]];
            button.actionVo = actionVo;
            button.frame = CGRectMake(kScreenWidth-20-(i+1)*(btnWidth+10), btnFrameY, btnWidth, 24);
            [button setTitle:actionVo.title forState:UIControlStateNormal];
            [self.containerView addSubview:button];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

}

- (void)buttonClick:(CommandButton *)button{
    
    switch (button.actionVo.status) {
        case TO_CONSIGMENT:{
            if (self.handleActionToConsigmentBlcok) {
                self.handleActionToConsigmentBlcok(self.sendVo.consigmentSn);
            }
            break;
        }
        case SEE_LOGISTICS:{
            if (self.handleActionSeeLogisticsBlcok) {
                self.handleActionSeeLogisticsBlcok(self.sendVo);
            }
            break;
        }
        case CONTACT_APPRAISER:{
            if (self.handleActionContactAppraiserBlcok) {
                self.handleActionContactAppraiserBlcok(self.sendVo.estimatorId);
            }
            break;
        }
        case SEE_GOODS_DETAIL:{
            if (self.handleActionSeeGoodsDetailBlcok) {
                self.handleActionSeeGoodsDetailBlcok(self.sendVo.goodsSn);
            }
            break;
        }
        case CONFIRM_RECEIPT:{
            if (self.handleActionConfirmReceiptBlcok) {
                self.handleActionConfirmReceiptBlcok();
            }
            break;
        }
        case CONFIRM_DELLETE:{
            if (self.handleActionConfirmDeleteBlcok) {
                self.handleActionConfirmDeleteBlcok(self.sendVo.ID);
            }
            break;
        }
        default:
            break;
    }
}


- (UILabel *)createBlackLabelWithFont:(CGFloat)font{
    UILabel * lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    lbl.font = [UIFont systemFontOfSize:font];
    [lbl sizeToFit];
    return lbl;
}

- (UILabel *)createLightGrayLabelWithFont:(CGFloat)font{
    UILabel * lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    lbl.font = [UIFont systemFontOfSize:font];
    [lbl sizeToFit];
    return lbl;
}

- (CommandButton *)createActionButton{
    CommandButton * button = [[CommandButton alloc] init];
    [button setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
    button.layer.borderWidth = 1;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 12;
    return button;
}

- (void)layoutSubviews{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(10);
        make.left.equalTo(self.containerView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.consignorName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portrait.mas_top);
        make.bottom.equalTo(self.portrait.mas_bottom);
        make.left.equalTo(self.portrait.mas_right).offset(8);
    }];
    
    [self.goodsStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portrait.mas_top);
        make.bottom.equalTo(self.portrait.mas_bottom);
        make.right.equalTo(self.containerView.mas_right).offset(-12);
    }];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portrait.mas_bottom).offset(9);
        make.left.equalTo(self.containerView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(15);
        make.top.equalTo(self.goodsImageView.mas_top);
        make.right.equalTo(self.containerView.mas_right).offset(-80);
    }];
    
    [self.goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.right.equalTo(self.containerView.mas_right).offset(-10);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsPrice.mas_right);
        make.left.equalTo(self.goodsImageView.mas_left);
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(@0.5);
    }];

    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_left);
        make.top.equalTo(self.line.mas_bottom).offset(10);
    }];
    
    [self.operationStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(10);
        make.right.equalTo(self.goodsPrice.mas_right);
    }];

}

@end
