//
//  SendsaleActionCell.m
//  XianMao
//
//  Created by WJH on 17/3/2.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendsaleActionCell.h"
#import "Command.h"

@interface SendsaleActionCell()
@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic, strong) SendSaleVo * sendVo;
@end

@implementation SendsaleActionCell


- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"bg_bottom"];
        _containerView.userInteractionEnabled = YES;
    }
    return _containerView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SendsaleActionCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 55;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendsaleActionCell class]];
    if (sendVo) {
        [dict setObject:sendVo forKey:[SendsaleActionCell cellKeyForsendVo]];
    }
    return dict;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
        [self.contentView addSubview:self.containerView];
    }
    return self;
}

+ (NSString *)cellKeyForsendVo{
    return @"sendVo";
}

- (void)updateCellWithDict:(NSDictionary*)dict{
    SendSaleVo * sendVo = [dict objectForKey:[SendsaleActionCell cellKeyForsendVo]];
    if (sendVo) {
        
        _sendVo = sendVo;
        
        for (UIView *view in self.containerView.subviews) {
            if ([view isKindOfClass:[CommandButton class]]) {
                [view removeFromSuperview];
            }
        }
        NSArray * array = [sendVo returnActionsButtons];
        CGFloat btnWidth = kScreenWidth/375*100;
        CGFloat btnFrameY = 30/2;
        for (int i = 0; i < array.count; i++) {
            CommandButton * button = [self createActionButton];
            ActionVo * actionVo = [ActionVo createWithDict:[array objectAtIndex:i]];
            button.actionVo = actionVo;
            button.frame = CGRectMake(kScreenWidth-25-(i+1)*(btnWidth+10), btnFrameY, btnWidth, 24);
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
                self.handleActionSeeGoodsDetailBlcok();
            }
            break;
        }
        case CONFIRM_RECEIPT:{
            if (self.handleActionConfirmReceiptBlcok) {
                self.handleActionConfirmReceiptBlcok();
            }
            break;
        }
        default:
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
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
@end
