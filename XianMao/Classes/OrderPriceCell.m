//
//  OrderPriceCell.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderPriceCell.h"
#import "Masonry.h"
#import "NetworkAPI.h"
#import "Command.h"
#import "Session.h"

@interface OrderPriceCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *priceLbl;

@property (nonatomic, strong) CommandButton *contectBtn;
@property (nonatomic, strong) CommandButton *seeJinDu;
@property (nonatomic, strong) CommandButton *btn1;
@property (nonatomic, strong) CommandButton *questionBtn;
@end

@implementation OrderPriceCell

-(CommandButton *)questionBtn{
    if (!_questionBtn) {
        _questionBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_questionBtn setTitle:@"转账支付" forState:UIControlStateNormal];
        _questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_questionBtn setTitleColor:[UIColor colorWithHexString:@"3c3c3c"] forState:UIControlStateNormal];
        _questionBtn.layer.borderColor = [UIColor colorWithHexString:@"3c3c3c"].CGColor;
        _questionBtn.layer.borderWidth = 1;
        
    }
    return _questionBtn;
}

-(CommandButton *)btn1{
    if (!_btn1) {
        _btn1 = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_btn1 setTitleColor:[UIColor colorWithHexString:@"3c3c3c"] forState:UIControlStateNormal];
        _btn1.layer.borderColor = [UIColor colorWithHexString:@"3c3c3c"].CGColor;
        _btn1.layer.borderWidth = 1;
        
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_btn1 addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btn1.titleLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _btn1;
}

-(UIButton *)seeJinDu{
    if (!_seeJinDu) {
        _seeJinDu = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_seeJinDu setTitleColor:[UIColor colorWithHexString:@"3c3c3c"] forState:UIControlStateNormal];
        _seeJinDu.layer.borderColor = [UIColor colorWithHexString:@"3c3c3c"].CGColor;
        _seeJinDu.layer.borderWidth = 1;
        
        _seeJinDu.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_seeJinDu addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _seeJinDu.titleLabel.font = [UIFont systemFontOfSize:12.f];
        
    }
    return _seeJinDu;
}

-(void)buttonClick
{
    if ([self.delegate respondsToSelector:@selector(seeBuyBackJinDu)]) {
        [self.delegate seeBuyBackJinDu];
    }
}

-(UIButton *)contectBtn{
    if (!_contectBtn) {
        _contectBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_contectBtn setTitleColor:[UIColor colorWithHexString:@"3c3c3c"] forState:UIControlStateNormal];
        _contectBtn.layer.borderColor = [UIColor colorWithHexString:@"3c3c3c"].CGColor;
        _contectBtn.layer.borderWidth = 1;
        
        _contectBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        
        _contectBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        
    }
    return _contectBtn;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:14.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"f54e49"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        [_titleLbl sizeToFit];
        _titleLbl.text = @"实付金额";
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderPriceCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    OrderInfo *orderInfo = dict[@"orderInfo"];
    CGFloat height = 80.f;
    //    if (orderInfo.orderStatus == 0) {
    //        if (orderInfo.payStatus == 0) {
    //            if (orderInfo.payWay == PayWayOffline) {
    //                height = 48.f;
    //            } else {
    //                height = 80.f;
    //            }
    //        } else if (orderInfo.payStatus == 1) {
    //            height = 80.f;
    //        } else if (orderInfo.payStatus == 2) {
    //
    //            if (orderInfo.shippingStatus == 0) {
    //                if (orderInfo.payWay != PayWayOffline) {
    //                    if (orderInfo.securedStatus==0) {
    //                        if (orderInfo.refund_enable || orderInfo.refund_status==1) {
    //                            if (orderInfo.refund_enable) {
    //                                if (orderInfo.tradeType == 4) {
    //                                    height = 80.f;
    //
    //                                } else {
    //                                    height = 80.f;
    //                                }
    //                            } else if (orderInfo.refund_status==1) {
    //                                height = 80.f;
    //                            }
    //
    //                        } else {
    //                            height = 80.f;
    //                        }
    //
    //                    } else {
    //                        height = 80.f;
    //                    }
    //                }
    //                //联系卖家、顾问
    //            } else if (orderInfo.shippingStatus == 1) {
    //                //                if (orderInfo.payWay != PayWayOffline) {
    //                //                    [self.seeJinDu setTitle:@"···" forState:UIControlStateNormal];
    //                //                    self.seeJinDu.hidden = NO;
    //                //                    self.seeJinDu.handleClickBlock = ^(CommandButton *sender) {
    //                //                        if (weakSelf.handleOrderActionMoreBlock) {
    //                //                            weakSelf.handleOrderActionMoreBlock(orderInfo,2);
    //                //                        }
    //                //                    };
    //                //                }
    //
    //                if (orderInfo.buttonStats == 1) {//1申请退货 2查看退货进度 3申请回购 4查看回购进度
    //                    height = 80.f;
    //
    //                }
    //
    //                height = 80.f;
    //                //联系顾问
    //            }
    //        }
    //    } else if (orderInfo.orderStatus == 9) { //退货完成
    //        if (orderInfo.buttonStats == 0) {
    //            height = 80.f;
    //        } else {
    //            height = 48.f;
    //        }
    //    } else if (orderInfo.orderStatus == 8) { //回购完成
    //        if (orderInfo.buttonStats == 0) {
    //            height = 80.f;
    //        } else {
    //            height = 48.f;
    //        }
    //    } else {
    //
    //        if (orderInfo.buttonStats == 2) {
    //            height = 80.f;
    //        } else if (orderInfo.buttonStats == 3) {
    //            height = 80.f;
    //
    //        } else if (orderInfo.buttonStats == 4) {
    //            height = 80.f;
    //        } else {
    //            height = 48.f;
    //        }
    //    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(OrderInfo *)orderInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderPriceCell class]];
    if (dict) {
        [dict setObject:orderInfo forKey:@"orderInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.priceLbl];
        
        [self.contentView addSubview:self.seeJinDu];
        [self.contentView addSubview:self.contectBtn];
        [self.contentView addSubview:self.btn1];
        
        self.seeJinDu.hidden = YES;
        self.contectBtn.hidden = YES;
        self.btn1.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.contectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.width.equalTo(@64);
        make.height.equalTo(@24);
    }];
    
    [self.seeJinDu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
        make.right.equalTo(self.contectBtn.mas_left).offset(-10);
        make.width.equalTo(@64);
        make.height.equalTo(@24);
    }];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
        make.right.equalTo(self.seeJinDu.mas_left).offset(-10);
        make.width.equalTo(@64);
        make.height.equalTo(@24);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    WEAKSELF;
    
    [self.contentView addSubview:self.questionBtn];
    
    self.seeJinDu.hidden = YES;
    self.contectBtn.hidden = YES;
    self.btn1.hidden = YES;
    OrderInfo *orderInfo = dict[@"orderInfo"];
    if (orderInfo.orderStatus == 0) {
        if (orderInfo.payStatus == 0) {
            if (orderInfo.payWay == PayWayOffline) {
                
            } else {
                
                [self.contectBtn setTitle:@"付款" forState:UIControlStateNormal];
                self.contectBtn.hidden = NO;
                self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                    if (weakSelf.handleOrderActionPayBlock) {
                        weakSelf.handleOrderActionPayBlock(orderInfo.orderId,orderInfo.payWay,orderInfo);
                    }
                };
                //                if (orderInfo.logic_type == RETURNGOODS) {
                //                    [self.seeJinDu setTitle:@"联系顾问" forState:UIControlStateNormal];
                //                    self.seeJinDu.hidden = NO;
                //                    self.seeJinDu.handleClickBlock = ^(CommandButton *sender){
                //                        if (weakSelf.handleOrderActionChatBlock) {
                //                            weakSelf.handleOrderActionChatBlock(orderInfo.sellerId,orderInfo,1);
                //                        }
                //                    };
                //                } else {
                //                if (orderInfo.buttonStats == 0 && orderInfo.repurchase_status > 0) {
                //                    [self.seeJinDu setTitle:@"退货进度" forState:UIControlStateNormal];
                //                    self.seeJinDu.hidden = NO;
                //                    self.seeJinDu.handleClickBlock = ^(CommandButton *sender){
                //                        if (weakSelf.handleOrderActionChatBlock) {
                //                            weakSelf.handleOrderActionChatBlock(orderInfo.sellerId,orderInfo,0);
                //                        }
                //                    };
                //                }
                
                //                }
            }
        } else if (orderInfo.payStatus == 1) {
            [self.contectBtn setTitle:@"继续支付" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            self.contectBtn.handleClickBlock = ^(CommandButton *sender) {
                [MobClick event:@"click_payment"];
                if (weakSelf.handleOrderActionPayBlock) {
                    weakSelf.handleOrderActionPayBlock(orderInfo.orderId,orderInfo.payWay,orderInfo);
                }
            };
        } else if (orderInfo.payStatus == 2) {
            
            if (orderInfo.shippingStatus == 0) {
                if (orderInfo.payWay != PayWayOffline) {
                    if (orderInfo.securedStatus==0) {
                        if (orderInfo.refund_enable || orderInfo.refund_status==1) {
                            if (orderInfo.refund_enable) {
                                if (orderInfo.tradeType == 4) {
                                    [self.contectBtn setTitle:@"我要发货" forState:UIControlStateNormal];
                                    self.contectBtn.hidden = NO;
                                    self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                                        if (weakSelf.handleOrderActionSendBlock) {
                                            weakSelf.handleOrderActionSendBlock(orderInfo);
                                        }
                                    };
                                    
                                } else {
                                    
                                    if (orderInfo.user.userId == [Session sharedInstance].currentUserId) {
                                        [self.contectBtn setTitle:@"我要发货" forState:UIControlStateNormal];
                                        self.contectBtn.hidden = NO;
                                        self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                                            if (weakSelf.handleOrderActionSendBlock) {
                                                weakSelf.handleOrderActionSendBlock(orderInfo);
                                            }
                                        };
                                    }else{
                                        [self.contectBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
                                        self.contectBtn.hidden = NO;
                                        self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                                            if (weakSelf.handleOrderActionRemindShippingGoodsBlock) {
                                                weakSelf.handleOrderActionRemindShippingGoodsBlock(orderInfo);
                                            }
                                        };
                                    }
                                }
                                if (orderInfo.user.userId != [Session sharedInstance].currentUserId) {
                                    [self.seeJinDu setTitle:@"申请退款" forState:UIControlStateNormal];
                                    self.seeJinDu.hidden = NO;
                                    self.seeJinDu.handleClickBlock = ^(CommandButton *sender){
                                        if (weakSelf.handleOrderActionApplyRefundBlock) {
                                            weakSelf.handleOrderActionApplyRefundBlock(orderInfo);
                                        }
                                    };
                                }
                            } else if (orderInfo.refund_status==1) {
                                [self.contectBtn setTitle:@"撤销退款" forState:UIControlStateNormal];
                                self.contectBtn.hidden = NO;
                                self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                                    if (weakSelf.handleOrderActionCancelRefundBlock) {
                                        weakSelf.handleOrderActionCancelRefundBlock(orderInfo);
                                    }
                                };
                            }
                            
                        } else {
                            [self.contectBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
                            self.contectBtn.hidden = NO;
                            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                                if (weakSelf.handleOrderActionRemindShippingGoodsBlock) {
                                    weakSelf.handleOrderActionRemindShippingGoodsBlock(orderInfo);
                                }
                            };
                        }
                        
                    } else {
                        
                        if (orderInfo.logic_type == 2 || orderInfo.logic_type == 3) {
                            
                            //                            if (orderInfo.securedStatus == ) {
                            //
                            //                            }
                            
                        } else {
                            [self.contectBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                            self.contectBtn.hidden = NO;
                            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                                if (weakSelf.handleOrderActionLogisticsBlock) {
                                    weakSelf.handleOrderActionLogisticsBlock(orderInfo.orderId);
                                }
                            };
                        }
                    }
                }
                //联系卖家、顾问
            } else if (orderInfo.shippingStatus == 1) {
                //                if (orderInfo.payWay != PayWayOffline) {
                //                    [self.seeJinDu setTitle:@"···" forState:UIControlStateNormal];
                //                    self.seeJinDu.hidden = NO;
                //                    self.seeJinDu.handleClickBlock = ^(CommandButton *sender) {
                //                        if (weakSelf.handleOrderActionMoreBlock) {
                //                            weakSelf.handleOrderActionMoreBlock(orderInfo,2);
                //                        }
                //                    };
                //                }
                if (orderInfo.repurchase_status > 0) {
                    [self.seeJinDu setTitle:@"退货进度" forState:UIControlStateNormal];
                    self.seeJinDu.hidden = NO;
                    self.seeJinDu.handleClickBlock = ^(CommandButton *sender){
                        if (weakSelf.handleOrderActionrefundGoodsProgress) {
                            weakSelf.handleOrderActionrefundGoodsProgress(orderInfo);
                        }
                    };
                } else {
                    if (orderInfo.buttonStats == 1 && orderInfo.logic_type == RETURNGOODS) {//1申请退货 2查看退货进度 3申请回购 4查看回购进度
                        [self.btn1 setTitle:@"申请退货" forState:UIControlStateNormal];
                        self.btn1.hidden = NO;
                        
                        self.btn1.handleClickBlock = ^(CommandButton *sender){
                            if (weakSelf.handleOrderActionrefundGoods) {
                                weakSelf.handleOrderActionrefundGoods(orderInfo);
                            }
                        };
                    }
                }
                
                if (orderInfo.securedStatus == 3) {
                    [self.contectBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    self.contectBtn.hidden = NO;
                    
                    self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                        if (weakSelf.handleOrderActionLogisticsBlock) {
                            weakSelf.handleOrderActionLogisticsBlock(orderInfo.orderId);
                        }
                    };
                }

                if ((orderInfo.repurchase_status == 0  && orderInfo.sellerId == orderInfo.buyerId) || (orderInfo.repurchase_status == 5 && orderInfo.sellerId == orderInfo.buyerId)) {
                    [self.contectBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    self.contectBtn.hidden = NO;
                    self.contectBtn.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.handleOrderActionConfirmReceivingBlock) {
                            weakSelf.handleOrderActionConfirmReceivingBlock(orderInfo.orderId);
                        }
                    };
                }
            }
        }
    } else if (orderInfo.orderStatus == 9) { //退货完成
        if (orderInfo.buttonStats == 0) {
            [self.contectBtn setTitle:@"退货进度" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                if (weakSelf.handleOrderActionrefundGoodsProgress) {
                    weakSelf.handleOrderActionrefundGoodsProgress(orderInfo);
                }
            };
        }
    } else if (orderInfo.orderStatus == 8) { //回购完成
        if (orderInfo.buttonStats == 0) {
            [self.contectBtn setTitle:@"回购进度" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                if (weakSelf.handleOrderActionApplyProgress) {
                    weakSelf.handleOrderActionApplyProgress(orderInfo);
                }
            };
        }
    } else if (orderInfo.orderStatus == 7) {
        
        if (orderInfo.buttonStats == 0) {
            [self.contectBtn setTitle:@"回购进度" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                if (weakSelf.handleOrderActionApplyProgress) {
                    weakSelf.handleOrderActionApplyProgress(orderInfo);
                }
            };
        }
        
        
        
    } else if(orderInfo.orderStatus == 1){
        [self.contectBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        self.contectBtn.hidden = NO;
        
        self.contectBtn.handleClickBlock = ^(CommandButton *sender){
            if (weakSelf.handleOrderActionLogisticsBlock) {
                weakSelf.handleOrderActionLogisticsBlock(orderInfo.orderId);
            }
        };
        
        //洗护门店订单联系客服
        if (orderInfo.tradeType == 9) {
            [self.contectBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            
            self.contectBtn.handleClickBlock = ^(CommandButton * sender){
                
                if (weakSelf.handleOrderActionServiceBlock) {
                    weakSelf.handleOrderActionServiceBlock(orderInfo);
                }
                
            };
        }
        
        
    }else{
        
        if (orderInfo.buttonStats == 2) {
            [self.contectBtn setTitle:@"退货进度" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            
            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                if (weakSelf.handleOrderActionrefundGoodsProgress) {
                    weakSelf.handleOrderActionrefundGoodsProgress(orderInfo);
                }
            };
            
            
            
        } else if (orderInfo.buttonStats == 3) {
            [self.contectBtn setTitle:@"申请回购" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            
            
            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                if (weakSelf.handleOrderActionApplyReturn) {
                    weakSelf.handleOrderActionApplyReturn(orderInfo);
                }
            };
            
        } else if (orderInfo.buttonStats == 4) {
            [self.contectBtn setTitle:@"回购进度" forState:UIControlStateNormal];
            self.contectBtn.hidden = NO;
            
            
            self.contectBtn.handleClickBlock = ^(CommandButton *sender){
                if (weakSelf.handleOrderActionApplyProgress) {
                    weakSelf.handleOrderActionApplyProgress(orderInfo);
                }
            };
            
            
            
            
        }
    }
    
    if (orderInfo.payTipVo) {
        if (self.seeJinDu.hidden == YES) {
            [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
                make.right.equalTo(self.contectBtn.mas_left).offset(-10);
                make.width.equalTo(@64);
                make.height.equalTo(@24);
            }];
        } else if (self.btn1.hidden == YES) {
            [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
                make.right.equalTo(self.seeJinDu.mas_left).offset(-10);
                make.width.equalTo(@64);
                make.height.equalTo(@24);
            }];
        } else {
            [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
                make.right.equalTo(self.btn1.mas_left).offset(-10);
                make.width.equalTo(@64);
                make.height.equalTo(@24);
            }];
        }
    }
    
    self.questionBtn.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleQuestionBlock) {
            weakSelf.handleQuestionBlock(orderInfo);
        }
    };
    
    self.priceLbl.text = [NSString stringWithFormat:@"¥%.2f", orderInfo.actual_pay];
}

@end
