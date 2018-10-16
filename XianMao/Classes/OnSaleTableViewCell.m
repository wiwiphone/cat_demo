//
//  OnSaleTableViewCell.m
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "OnSaleTableViewCell.h"
#import "GoodsInfo.h"
#import "RecoveryGoodsDetail.h"

#import "Command.h"
#import "DataSources.h"

#import "GoodsStatusMaskView.h"
#import "NSDate+Additions.h"
#import "URLScheme.h"
#import "WCAlertView.h"

@interface OnSaleTableViewCell ()
//@property(nonatomic,strong) CALayer *topLine;
@property(nonatomic,strong) UILabel *timestampLbl;
@property (nonatomic, strong) CommandButton * markButton;
@property(nonatomic,strong) XMWebImageView *thumbView;
@property(nonatomic,strong) GoodsStatusMaskView *statusView;
@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) UILabel *gradeLbl;
@property(nonatomic,strong) UILabel *shopPriceLbl;
@property(nonatomic,strong) CALayer *topLine;
@property(nonatomic,strong) UILabel *buybackLbl;
@property(nonatomic,strong) CommandButton *buybackBtn;
@property(nonatomic,strong) CALayer *middleLine;
@property(nonatomic,weak)  CommandButton *refreshBtn;
@property(nonatomic,weak)  CommandButton *deleteBtn;
@property(nonatomic,strong) CommandButton *onsaleBtn;
@property(nonatomic,strong) CommandButton *editBtn;
@property(nonatomic,strong) CommandButton *applyOffSaleBtn;

@property(nonatomic,strong) CALayer *bottomLine;

@property(nonatomic,strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) RecoveryGoodsDetail *goodsDetail;
@property (nonatomic, strong) RecoveryGoodsVo *goodsVO;
@property (nonatomic, assign) CGFloat marginTop;

@end

@implementation OnSaleTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OnSaleTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 180.f;
    rowHeight += 27;
    GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if (goodsInfo.evaluateStat && [goodsInfo.evaluateStat.statDescription length]>0) {
        rowHeight += 44;
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OnSaleTableViewCell class]];
    if (goodsInfo)[dict setObject:goodsInfo forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSMutableDictionary*)buildRecoverCellDict:(RecoveryGoodsDetail*)goodsDetail{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OnSaleTableViewCell class]];
    if (goodsDetail)[dict setObject:goodsDetail forKey:@"goodsDetail"];
    //    [dict setObject:[NSNumber numberWithBool:NO] forKey:[self cellDictKeyForSeleted]];
    
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"goodsInfo";
}

+ (NSString*)cellDictKeyForGoodsDetail {
    return @"goodsDetail";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        _topLine = [CALayer layer];
//        _topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
//        [self.contentView.layer addSublayer:_topLine];
        
        _timestampLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timestampLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _timestampLbl.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_timestampLbl];
        
        _markButton = [[CommandButton alloc] init];
        [_markButton setImage:[UIImage imageNamed:@"questionmark"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.markButton];
        
        _scrollLabel = [[ScrollLabelView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, kScreenWidth/2-40, 40)];

        [self.contentView addSubview:self.scrollLabel];
        
        _thumbView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _thumbView.userInteractionEnabled = YES;
        _thumbView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _thumbView.clipsToBounds = YES;
        [self.contentView addSubview:_thumbView];
        
        _statusView = [[GoodsStatusMaskView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_statusView];
        _statusView.hidden = YES;
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _nameLbl.font = [UIFont systemFontOfSize:15.f];
        _nameLbl.numberOfLines = 0;
        [self.contentView addSubview:_nameLbl];
        
        _gradeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _gradeLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _gradeLbl.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_gradeLbl];
        
        _shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _shopPriceLbl.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_shopPriceLbl];
        
        _topLine = [CALayer layer];
        _topLine.hidden = YES;
        _topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_topLine];
        
        _buybackLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _buybackLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _buybackLbl.font = [UIFont systemFontOfSize:12.f];
        _buybackLbl.hidden = YES;
        [self.contentView addSubview:_buybackLbl];
        
        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_small"];
        _buybackBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _buybackBtn.hidden = YES;
        [_buybackBtn setImage:rightArrow forState:UIControlStateNormal];
        [_buybackBtn setTitle:@"回购详情" forState:UIControlStateNormal];
        [_buybackBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _buybackBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        CGSize size = [[_buybackBtn titleForState:UIControlStateNormal] sizeWithFont:_buybackBtn.titleLabel.font];
        _buybackBtn.frame = CGRectMake(0, 0, size.width+12+rightArrow.size.width, 40);
        //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
        _buybackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_buybackBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 0, -size.width)];
        [_buybackBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, rightArrow.size.width+4)];
        _buybackBtn.layer.masksToBounds = YES;
        _buybackBtn.layer.cornerRadius = 3;
        _buybackBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        _buybackBtn.layer.borderWidth = 1;
        [self.contentView addSubview:_buybackBtn];
        
        _middleLine = [CALayer layer];
        _middleLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_middleLine];
        
        CommandButton *refreshBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [refreshBtn setTitle:@"擦亮" forState:UIControlStateNormal];
        [refreshBtn setTitle:@"已擦亮" forState:UIControlStateSelected];
        [refreshBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        [refreshBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateSelected];
        refreshBtn.backgroundColor = [UIColor whiteColor];
        refreshBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        refreshBtn.layer.borderWidth = 1.f;
        refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        refreshBtn.layer.masksToBounds = YES;
        refreshBtn.layer.cornerRadius = 3;
        [self.contentView addSubview:refreshBtn];
        _refreshBtn = refreshBtn;
        
        CommandButton *deleteBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        deleteBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        deleteBtn.layer.borderWidth = 1.f;
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.layer.cornerRadius = 3;
        [self.contentView addSubview:deleteBtn];
        _deleteBtn = deleteBtn;
        
        
        _onsaleBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_onsaleBtn setTitle:@"下架商品" forState:UIControlStateSelected];
        [_onsaleBtn setTitle:@"再次上架" forState:UIControlStateNormal];
        [_onsaleBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _onsaleBtn.backgroundColor = [UIColor whiteColor];
        _onsaleBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        _onsaleBtn.layer.borderWidth = 1.f;
        _onsaleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _onsaleBtn.hidden = YES;
        _onsaleBtn.layer.masksToBounds = YES;
        _onsaleBtn.layer.cornerRadius = 3;
        [self.contentView addSubview:_onsaleBtn];

        _editBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _editBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _editBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        _editBtn.layer.borderWidth = 1.f;
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 3;
        [self.contentView addSubview:_editBtn];
        
        _applyOffSaleBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_applyOffSaleBtn setTitle:@"申请下架" forState:UIControlStateNormal];
        [_applyOffSaleBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _applyOffSaleBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _applyOffSaleBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        _applyOffSaleBtn.layer.borderWidth = 1.f;
        _applyOffSaleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _applyOffSaleBtn.layer.masksToBounds = YES;
        _applyOffSaleBtn.layer.cornerRadius = 3;
        [self.contentView addSubview:_applyOffSaleBtn];
        
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _middleLine.hidden = YES;
        _applyOffSaleBtn.hidden = YES;
        
        WEAKSELF;
        
        _markButton.handleClickBlock = ^(CommandButton * sender){
            
            if (weakSelf.handleRreshenBlock) {
                weakSelf.handleRreshenBlock(weakSelf.goodsInfo);
            }
        };
        
        _applyOffSaleBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleApplyOffSaleBlock) {
                weakSelf.handleApplyOffSaleBlock(weakSelf.goodsInfo);
            }
        };
        _editBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleEditBlock) {
                weakSelf.handleEditBlock(weakSelf.goodsInfo, weakSelf.goodsDetail);
            }
        };
        _onsaleBtn.handleClickBlock = ^(CommandButton *sender) {
            if (sender.isSelected) {
//                NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.goodsVO.exprTime/1000];
//                NSString *time = [NSString stringWithFormat:@"%ld", [date minute]];
                NSString *title = [NSString string];
                NSLog(@"%@, %@", weakSelf.goodsInfo, weakSelf.goodsVO);
                if (weakSelf.goodsVO) {
                    title = [NSString stringWithFormat:@"确认下架？下架后需要%ld小时后才能再次上架", (long)weakSelf.goodsVO.offSaleFixTime];
                } else {
                    title = [NSString stringWithFormat:@"确认下架?"];
                }
                
                [WCAlertView showAlertWithTitle:@"提示" message:title customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                    if (buttonIndex == 0) {
                        
                    } else {
                        if (weakSelf.handleOffSaleBlock) {
                            weakSelf.handleOffSaleBlock(weakSelf.goodsInfo, weakSelf.goodsVO);
                        }
                    }
                    
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            } else {
                if (weakSelf.handleOnSaleBlock) {
                    weakSelf.handleOnSaleBlock(weakSelf.goodsInfo, weakSelf.goodsVO);
                }
            }
        };
        _refreshBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleRefreshBlock) {
                weakSelf.handleRefreshBlock(weakSelf.goodsInfo);
            }
        };
        _buybackBtn.handleClickBlock = ^(CommandButton *sender) {
            [URLScheme locateWithRedirectUri:weakSelf.goodsInfo.evaluateStat.redirectUri andIsShare:YES];
        };
        _deleteBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleDeleteBlock) {
                if (weakSelf.goodsVO) {
                    weakSelf.handleDeleteBlock(weakSelf.goodsVO.goodsSn);
                } else if (weakSelf.goodsInfo) {
                     weakSelf.handleDeleteBlock(weakSelf.goodsInfo.goodsId);
                }
            }
        };
    }
    return self;
}

-(void)getIsChatCome:(NSInteger)isChatCome{
    if (isChatCome == 1) {
        _onsaleBtn.hidden = YES;
        [_editBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _editBtn.backgroundColor = [UIColor whiteColor];
        _editBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        _editBtn.layer.borderWidth = 1.f;
        _editBtn.userInteractionEnabled = NO;
    } else {
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _editBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _editBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        _editBtn.layer.borderWidth = 1.f;
//        _onsaleBtn.hidden = NO;
        _editBtn.userInteractionEnabled = YES;
    }
}

- (void)dealloc {
//    _topLine = nil;
    _timestampLbl = nil;
    _thumbView = nil;
    _nameLbl = nil;
    _gradeLbl = nil;
    _shopPriceLbl = nil;
    _middleLine = nil;
    _refreshBtn = nil;
    _applyOffSaleBtn = nil;
    _bottomLine = nil;
    _deleteBtn = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    _topLine.frame = CGRectZero;
    _timestampLbl.frame = CGRectZero;
    _thumbView.frame = CGRectZero;
    _nameLbl.frame = CGRectZero;
    _gradeLbl.frame = CGRectZero;
    _shopPriceLbl.frame = CGRectZero;
    _middleLine.hidden = YES;
    _middleLine.frame = CGRectZero;
    _refreshBtn.hidden = YES;
    _deleteBtn.hidden = YES;
    _applyOffSaleBtn.hidden = YES;
    _applyOffSaleBtn.frame = CGRectZero;
    _bottomLine.frame = CGRectZero;
    _statusView.hidden = YES;
    _markButton.hidden = YES;
    _scrollLabel.hidden = YES;
    _topLine.hidden = YES;
    _buybackLbl.hidden = YES;
    _buybackBtn.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginLeft = 15.f;
    CGFloat marginTop = 0.f;
//    _topLine.frame = CGRectMake(0, 0, self.contentView.width, 1);
//    marginTop += 1;
    
    
    
    marginTop += 17.f;
    [_timestampLbl sizeToFit];
    _timestampLbl.frame = CGRectMake(marginLeft, marginTop, self.contentView.width-30, _timestampLbl.height);
    marginTop += _timestampLbl.height;
    
    [_markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
//    _scrollLabel.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2-40, 40);

    marginTop += 15.f;
    _thumbView.frame = CGRectMake(marginLeft, marginTop, 80.f, 80.f);
    
    marginLeft += 80.f;
    marginLeft += 14.f;
    
    _nameLbl.frame = CGRectMake(marginLeft, marginTop, self.contentView.width-marginLeft-15, 0);
    [_nameLbl sizeToFit];
    _nameLbl.frame = CGRectMake(marginLeft, marginTop, self.contentView.width-marginLeft-15, _nameLbl.height);
    
    marginTop += _thumbView.height;
    
    [_gradeLbl sizeToFit];
    _gradeLbl.frame = CGRectMake(marginLeft, marginTop-_gradeLbl.height, _gradeLbl.width, _gradeLbl.height);
    
    [_shopPriceLbl sizeToFit];
    _shopPriceLbl.frame = CGRectMake(self.contentView.width-15-_shopPriceLbl.width, marginTop-_shopPriceLbl.height, _shopPriceLbl.width, _shopPriceLbl.height);
    
    marginLeft += 30;
    
    marginTop += 14.5f;
    
    if (![_buybackLbl isHidden]) {
        _topLine.frame = CGRectMake(0, marginTop, self.contentView.width, 1);
        marginTop += 1;
        
        _buybackBtn.frame = CGRectMake(self.contentView.width-15-_buybackBtn.width,  marginTop+(44-_buybackBtn.height)/2, _buybackBtn.width,_buybackBtn.height);
        if ([_buybackBtn isHidden]) {
            _buybackLbl.frame = CGRectMake(15, marginTop, self.contentView.width-30, 44);
        } else {
            _buybackLbl.frame = CGRectMake(15, marginTop, _buybackBtn.left-15-10, 44);
        }
        
        marginTop += 44;
    }
    
    marginTop += 20.f;
    _middleLine.frame = CGRectMake(0, marginTop, self.contentView.width, 1);
    marginTop += 1;
    
    marginTop += 12.f;
    self.marginTop = marginTop;
    _applyOffSaleBtn.frame = CGRectMake(self.contentView.width-15-64, marginTop, 64, 24);
    _editBtn.frame = CGRectMake(self.contentView.width-15-64, marginTop, 64, 24);
    _onsaleBtn.frame = CGRectMake(_editBtn.left-10-64, marginTop, 64, 24);
    _refreshBtn.frame = CGRectMake(_onsaleBtn.left-10-64, marginTop, 64, 24);
    if (_onsaleBtn.hidden == YES) {
        _deleteBtn.frame = CGRectMake(_editBtn.left-10-64, _marginTop, 64, 24);
    } else {
        _deleteBtn.frame = CGRectMake(_onsaleBtn.left-10-64, marginTop, 64, 24);
    }
    _bottomLine.frame = CGRectMake(0, self.contentView.height-1, self.contentView.width, 1);
    
    _statusView.frame = _thumbView.frame;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    RecoveryGoodsDetail *goodsDetail = [dict objectForKey:@"goodsDetail"];
    GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if (goodsDetail) {
        _goodsDetail = goodsDetail;
        _goodsInfo = nil;
        RecoveryGoodsVo *goodsVO = goodsDetail.recoveryGoodsVo;
        self.goodsVO = goodsVO;
        MainPic *mainPic = goodsVO.mainPic;
        HighestBidVo *highesBidVO = goodsDetail.highestBidVo;
        self.timestampLbl.text = goodsVO.updatetime>0?[NSDate stringForTimestampSince1970:goodsVO.updatetime]:@"未知";
        _nameLbl.text = goodsVO.goodsName;
        [_thumbView setImageWithURL:mainPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        if (highesBidVO) {
            _shopPriceLbl.text = [NSString stringWithFormat:@"当前最高报价 %.2f",highesBidVO.price];
        } else {
            _shopPriceLbl.text = @"无人报价";
        }
        _gradeLbl.hidden = YES;
        
        if ([goodsVO isConsignGoods]) {
            _applyOffSaleBtn.hidden = NO;
            _editBtn.hidden = YES;
            _onsaleBtn.hidden = YES;
            _refreshBtn.hidden = YES;
            _markButton.hidden = YES;
            _deleteBtn.hidden = YES;
            _scrollLabel.hidden = YES;
        } else {
            _applyOffSaleBtn.hidden = YES;
            _editBtn.hidden = NO;
            if ([goodsVO isOnSales]||[goodsVO isNotOnSales]) {
                _onsaleBtn.hidden = NO;
                _onsaleBtn.selected = [goodsVO isOnSales];
                
                if ([goodsVO isOnSales]) {
                    
                    if(goodsVO.is_valid) {
                        _refreshBtn.hidden = YES;
                        _markButton.hidden = YES;
                        _deleteBtn.hidden = YES;
                        _scrollLabel.hidden = YES;
                    } else {
                        _refreshBtn.hidden = YES;
                        _markButton.hidden = YES;
                        _scrollLabel.hidden = YES;
                        _deleteBtn.hidden = NO;
                    }
                    
//                    _refreshBtn.hidden = YES;
//                    _deleteBtn.hidden = YES;
                } else {
                    _refreshBtn.hidden = YES;
                    _markButton.hidden = YES;
                    _scrollLabel.hidden = YES;
                    _deleteBtn.hidden = NO;
                }
            } else {
                _onsaleBtn.hidden = YES;
                _refreshBtn.hidden = YES;
                _markButton.hidden = YES;
                _scrollLabel.hidden = YES;
                _deleteBtn.hidden = YES;
            }
            
            //            if ([goodsInfo isOnSale]
            //                && [[NSDate date] timeIntervalSince1970]-goodsInfo.modifyTime/1000>12*60*60) {
            //                _refreshBtn.hidden = NO;
            //            } else {
            //                //_refreshBtn.hidden = YES;
            //            }
        }
        
        _topLine.hidden = YES;
        _buybackLbl.hidden = YES;
        _buybackBtn.hidden = YES;
        
    } else if (goodsInfo) {
        _goodsInfo = goodsInfo;
        _goodsVO = nil;
        self.timestampLbl.text = goodsInfo.modifyTime>0?[NSDate stringForTimestampSince1970:goodsInfo.modifyTime]:@"未知";
        
        if (goodsInfo.isRefresh) {
            _refreshBtn.selected = YES;
            _refreshBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        }else{
            _refreshBtn.selected = NO;
            _refreshBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        }
        
        NSString * dayString = [NSString stringWithFormat:@"%ld天展示时间",goodsInfo.surplusDay];
        _scrollLabel.titleArray = @[dayString,@"排名更加靠前",dayString];
        
        _nameLbl.text = goodsInfo.goodsName;
        _shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",goodsInfo.shopPrice];
        _gradeLbl.text = [NSString stringWithFormat:@"成色：%@", goodsInfo.gradeTag.name?goodsInfo.gradeTag.name:@"未知"];
        
        [_thumbView setImageWithURL:goodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        _middleLine.hidden = NO;
        
        _statusView.hidden = [goodsInfo isOnSale];
        _statusView.statusString = goodsInfo.statusDescription;
        
        if ([goodsInfo isConsignGoods]) {
            _applyOffSaleBtn.hidden = NO;
            _editBtn.hidden = YES;
            _onsaleBtn.hidden = YES;
            _refreshBtn.hidden = YES;
            _markButton.hidden = YES;
            _deleteBtn.hidden = YES;
            _scrollLabel.hidden = YES;
        } else {
            _applyOffSaleBtn.hidden = YES;
            _editBtn.hidden = NO;
            if ([goodsInfo isOnSale]||[goodsInfo isNotOnSale]) {
                if(goodsInfo.isValid) {
                    _onsaleBtn.hidden = NO;
                } else {
                    _onsaleBtn.hidden = YES;
                }
                
                _onsaleBtn.selected = [goodsInfo isOnSale];
                
                if ([goodsInfo isOnSale]) {
                    if(goodsInfo.isValid) {
                        _refreshBtn.hidden = NO;
                        _markButton.hidden = NO;
                        _scrollLabel.hidden = NO;
                        _deleteBtn.hidden = YES;
                    } else {
                        _refreshBtn.hidden = YES;
                        _markButton.hidden = YES;
                        _scrollLabel.hidden = YES;
                        _deleteBtn.hidden = NO;
                    }
//                    _refreshBtn.hidden = NO;
//                    _deleteBtn.hidden = YES;
                } else {
                    _refreshBtn.hidden = YES;
                    _markButton.hidden = YES;
                    _scrollLabel.hidden = YES;
                    _deleteBtn.hidden = NO;
                }
            } else {
                _onsaleBtn.hidden = YES;
                
                _refreshBtn.hidden = YES;
                _markButton.hidden = YES;
                _scrollLabel.hidden = YES;
                _deleteBtn.hidden = YES;
            }
            
//            if ([goodsInfo isOnSale]
//                && [[NSDate date] timeIntervalSince1970]-goodsInfo.modifyTime/1000>12*60*60) {
//                _refreshBtn.hidden = NO;
//            } else {
//                //_refreshBtn.hidden = YES;
//            }
        }
        
        _topLine.hidden = YES;
        _buybackLbl.hidden = YES;
        _buybackBtn.hidden = YES;
        
        if (goodsInfo.evaluateStat && [goodsInfo.evaluateStat.statDescription length]>0) {
            _topLine.hidden = NO;
            _buybackLbl.hidden = NO;
            _buybackLbl.text = goodsInfo.evaluateStat.statDescription;
            
            if (goodsInfo.evaluateStat && [goodsInfo.evaluateStat.redirectUri length]>0) {
                _buybackBtn.hidden = NO;
                if ([goodsInfo.evaluateStat.redirectDesc length]>0) {
                    [_buybackBtn setTitle:goodsInfo.evaluateStat.redirectDesc forState:UIControlStateNormal];
                } else {
                    [_buybackBtn setTitle:@"回收详情" forState:UIControlStateNormal];
                }
                
                UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_small"];
                CGSize size = [[_buybackBtn titleForState:UIControlStateNormal] sizeWithFont:_buybackBtn.titleLabel.font];
                _buybackBtn.frame = CGRectMake(0, 0, size.width+12+rightArrow.size.width, 40);
                //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
                _buybackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [_buybackBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 0, -size.width)];
                [_buybackBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, rightArrow.size.width+4)];
            }
        }
        
        [self setNeedsLayout];
    }
}


@end

@implementation LockedOrSoldTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([LockedOrSoldTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 180.f;
    rowHeight += 27;
//    GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
//    if (goodsInfo.evaluateStat && [goodsInfo.evaluateStat.statDescription length]>0) {
//        rowHeight += 44;
//    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[LockedOrSoldTableViewCell class]];
    if (goodsInfo)[dict setObject:goodsInfo forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if (goodsInfo) {
        self.goodsInfo = goodsInfo;
        
        self.timestampLbl.text = goodsInfo.modifyTime>0?[NSDate stringForTimestampSince1970:goodsInfo.modifyTime]:@"未知";
        
        self.nameLbl.text = goodsInfo.goodsName;
        self.shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",goodsInfo.shopPrice];
        self.gradeLbl.text = [NSString stringWithFormat:@"成色：%@", goodsInfo.gradeTag.value?goodsInfo.gradeTag.value:@"未知"];
        
        [self.thumbView setImageWithURL:goodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        self.middleLine.hidden = NO;
        
        self.statusView.hidden = [goodsInfo isOnSale];
        self.statusView.statusString = goodsInfo.statusDescription;
        
        self.applyOffSaleBtn.hidden = YES;
        self.editBtn.hidden = NO;
        self.onsaleBtn.hidden = YES;
        self.refreshBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        
        [self.editBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        WEAKSELF;
        self.editBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleGoodsOrdersBlock) {
                weakSelf.handleGoodsOrdersBlock(weakSelf.goodsInfo.goodsId);
            }
        };
        
        [self setNeedsLayout];
    }
}

@end


@implementation OnSaleTableViewCellPublished

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OnSaleTableViewCellPublished class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 180.f;
    rowHeight += 27;
    
    GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
        if ([goodsInfo isInAuditStatus]) {
            
        } else {
            rowHeight = rowHeight-69;
        }
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OnSaleTableViewCellPublished class]];
    if (goodsInfo)[dict setObject:goodsInfo forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.shopPriceLbl.hidden = YES;
        self.gradeLbl.textColor = [UIColor colorWithHexString:@"e01111"];
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if (goodsInfo) {
        self.goodsInfo = goodsInfo;
        
        self.timestampLbl.text = goodsInfo.modifyTime>0?[NSDate stringForTimestampSince1970:goodsInfo.modifyTime]:@"未知";
        
        self.nameLbl.text = goodsInfo.goodsName;
//        self.shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",goodsInfo.shopPrice];
//        self.gradeLbl.text = [NSString stringWithFormat:@"成色：%@", goodsInfo.gradeTag.value?goodsInfo.gradeTag.value:@"未知"];
        
        [self.thumbView setImageWithURL:goodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        self.gradeLbl.text = [goodsInfo auditStatusDescription];
        
        self.statusView.hidden = [goodsInfo isOnSale];
        self.statusView.statusString = goodsInfo.statusDescription;
        
        self.middleLine.hidden = ![goodsInfo isInAuditStatus];
        self.applyOffSaleBtn.hidden = YES;
        self.editBtn.hidden = ![goodsInfo isInAuditStatus];
        self.onsaleBtn.hidden = YES;
        self.refreshBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        
        self.topLine.hidden = YES;
        self.buybackLbl.hidden = YES;
        self.buybackBtn.hidden = YES;
        
        [self setNeedsLayout];
    }
}

@end


@implementation SelectOnSaleTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SelectOnSaleTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 180.f;
    rowHeight = rowHeight-35;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SelectOnSaleTableViewCell class]];
    if (goodsInfo)[dict setObject:goodsInfo forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if (goodsInfo) {
        self.goodsInfo = goodsInfo;
        
        self.timestampLbl.text = goodsInfo.modifyTime>0?[NSDate stringForTimestampSince1970:goodsInfo.modifyTime]:@"未知";
        
        self.nameLbl.text = goodsInfo.goodsName;
        //        self.shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",goodsInfo.shopPrice];
        //        self.gradeLbl.text = [NSString stringWithFormat:@"成色：%@", goodsInfo.gradeTag.value?goodsInfo.gradeTag.value:@"未知"];
        
        [self.thumbView setImageWithURL:goodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        self.gradeLbl.text = [goodsInfo auditStatusDescription];
        
        self.statusView.hidden = [goodsInfo isOnSale];
        self.statusView.statusString = goodsInfo.statusDescription;
        
        self.middleLine.hidden = YES;
        self.applyOffSaleBtn.hidden = YES;
        self.editBtn.hidden = YES;
        self.onsaleBtn.hidden = YES;
        self.refreshBtn.hidden = YES;
        self.deleteBtn.hidden = NO;
        
        self.topLine.hidden = YES;
        self.buybackLbl.hidden = YES;
        self.buybackBtn.hidden = YES;
        
        [self setNeedsLayout];
    }
}


@end




