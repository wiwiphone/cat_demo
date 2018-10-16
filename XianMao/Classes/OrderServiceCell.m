//
//  OrderServiceCell.m
//  XianMao
//
//  Created by WJH on 16/12/17.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderServiceCell.h"
#import "Command.h"
#import "WCAlertView.h"

@interface OrderServiceCell()

@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * descLbl;
@property (nonatomic, strong) UILabel * shopPrice;
@property (nonatomic, strong) UILabel * originalPrice;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) CommandButton * chooseBtn;

@property (nonatomic, strong) ShoppingCartItem *item;
@end

@implementation OrderServiceCell


-(CommandButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [[CommandButton alloc] init];
        [_chooseBtn setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
    }
    return _chooseBtn;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jian"]];
    }
    return _icon;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:13];
        [_title sizeToFit];
    }
    return _title;
}

-(UILabel *)shopPrice{
    if (!_shopPrice) {
        _shopPrice = [[UILabel alloc] init];
        _shopPrice.textColor = [UIColor colorWithHexString:@"434342"];
        _shopPrice.font = [UIFont systemFontOfSize:13];
        [_shopPrice sizeToFit];
    }
    return _shopPrice;
}

-(UILabel *)originalPrice{
    if (!_originalPrice) {
        _originalPrice = [[UILabel alloc] init];
        _originalPrice.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _originalPrice.font = [UIFont systemFontOfSize:13];
        [_originalPrice sizeToFit];
    }
    return _originalPrice;
}

-(UILabel *)descLbl{
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _descLbl.font = [UIFont systemFontOfSize:13];
        [_descLbl sizeToFit];
    }
    return _descLbl;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    }
    return _line;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.chooseBtn];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.descLbl];
        [self.contentView addSubview:self.shopPrice];
        [self.contentView addSubview:self.originalPrice];
        [self.originalPrice addSubview:self.line];
        
        self.chooseBtn.selected = YES;
        WEAKSELF;
        _chooseBtn.handleClickBlock =^(CommandButton * sender){
            if (sender.selected == YES) {
                [WCAlertView showAlertWithTitle:@"确认取消" message:@"取消有风险" customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                    if (buttonIndex == 0) {
                        weakSelf.item.isChooseJianD = 0;
                        weakSelf.item.isOnJianD = NO;
                    } else {
                        sender.selected = !sender.selected;
                        weakSelf.item.isChooseJianD = 1;
                        weakSelf.item.isOnJianD = YES;
                        if (weakSelf.deterSelected) {
                            weakSelf.deterSelected(sender.selected, weakSelf.item);
                        }
                    }
                    
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            } else {
                sender.selected = !sender.selected;
                weakSelf.item.isChooseJianD = 0;
                weakSelf.item.isOnJianD = NO;
                if (weakSelf.deterSelected) {
                    weakSelf.deterSelected(sender.selected, weakSelf.item);
                }
            }
        };
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
//    }];
//    
//    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.top.equalTo(self.contentView.mas_top).offset(15);
//    }];
//    
//    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.icon.mas_right).offset(3);
//        make.top.equalTo(self.contentView.mas_top).offset(14);
//    }];
//    
//    
//    [self.shopPrice mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.top.equalTo(self.contentView.mas_top).offset(14);
//    }];
//    
//    [self.originalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.shopPrice.mas_bottom);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
//    }];
//    
//    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.top.equalTo(self.shopPrice.mas_bottom);
//    }];
//
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.originalPrice.mas_left);
//        make.right.equalTo(self.originalPrice.mas_right);
//        make.centerY.equalTo(self.originalPrice.mas_centerY);
//        make.height.mas_equalTo(@1);
//    }];
    
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderServiceCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 60.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDictisNeedSelect:(BOOL)isNeedSelect andShoppingCar:(ShoppingCartItem *)item jdServiceVo:(JDServiceVo *)jdServiceVo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderServiceCell class]];
    [dict setObject:[NSNumber numberWithBool:isNeedSelect] forKey:@"isNeedSelect"];
    if (item) {
        [dict setObject:item forKey:@"item"];
    }
    if (jdServiceVo) {
        [dict setObject:jdServiceVo forKey:@"jdServiceVo"];
    }
    return dict;
}

- (void)updateCellWithDict:(NSDictionary*)dict{

    JDServiceVo *serciveVo = dict[@"jdServiceVo"];
    
    self.title.text = serciveVo.title;
    self.descLbl.text = serciveVo.message;
    self.shopPrice.text = [NSString stringWithFormat:@"¥%ld", serciveVo.fee];
    self.originalPrice.text = [NSString stringWithFormat:@"¥%ld", serciveVo.originFee];
    
    ShoppingCartItem *item = [dict objectForKey:@"item"];
    self.item = item;
    
    BOOL isNeedSelect = [dict boolValueForKey:@"isNeedSelect"];
    if (isNeedSelect) {
//        self.shopPrice.hidden = YES;
//        self.originalPrice.hidden = YES;
        self.chooseBtn.hidden = NO;
        if (item.isOnJianD) {
            self.chooseBtn.selected = NO;
            item.is_use_jdvo = 0;
        } else {
            self.chooseBtn.selected = YES;
            item.is_use_jdvo = 1;
        }
    }else{

//        self.shopPrice.hidden = NO;
//        self.originalPrice.hidden = NO;
        self.chooseBtn.hidden = YES;
    }
    [self setUpUI:isNeedSelect];
}

-(void)setUpUI:(BOOL)isNeedSelect{
    if (isNeedSelect) {
        [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(3);
            make.top.equalTo(self.contentView.mas_top).offset(14);
        }];
        
        
        [self.shopPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.chooseBtn.mas_left).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(14);
        }];
        
        [self.originalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shopPrice.mas_bottom);
            make.right.equalTo(self.chooseBtn.mas_left).offset(-10);
        }];
        
        [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.shopPrice.mas_bottom);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.originalPrice.mas_left);
            make.right.equalTo(self.originalPrice.mas_right);
            make.centerY.equalTo(self.originalPrice.mas_centerY);
            make.height.mas_equalTo(@1);
        }];
    } else {
        [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(3);
            make.top.equalTo(self.contentView.mas_top).offset(14);
        }];
        
        
        [self.shopPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView.mas_top).offset(14);
        }];
        
        [self.originalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shopPrice.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.shopPrice.mas_bottom);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.originalPrice.mas_left);
            make.right.equalTo(self.originalPrice.mas_right);
            make.centerY.equalTo(self.originalPrice.mas_centerY);
            make.height.mas_equalTo(@1);
        }];
    }
}

@end
