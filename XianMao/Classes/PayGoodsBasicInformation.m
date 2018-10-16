//
//  PayGoodsBasicInformation.m
//  XianMao
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayGoodsBasicInformation.h"
#import "UIInsetCtrls.h"

@interface PayGoodsBasicInformation () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *postageTitleLbl;
@property (nonatomic, strong) UILabel *postageContentLbl;
@property (nonatomic, strong) UILabel *goodsPriceTitleLbl;
@property (nonatomic, strong) UILabel *goodsPriceContentLbl;
@property (nonatomic, strong) UIInsetTextField *leaveMessageView;

@property (nonatomic, strong) ShoppingCartItem *item;
@end

@implementation PayGoodsBasicInformation

-(UIInsetTextField *)leaveMessageView{
    if (!_leaveMessageView) {
        _leaveMessageView = [[UIInsetTextField alloc] initWithFrame:CGRectZero];
        _leaveMessageView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _leaveMessageView.placeholder = @"给卖家留言（150字以内）";
        _leaveMessageView.font = [UIFont systemFontOfSize:14.f];
        _leaveMessageView.delegate = self;
    }
    return _leaveMessageView;
}

-(UILabel *)goodsPriceContentLbl{
    if (!_goodsPriceContentLbl) {
        _goodsPriceContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsPriceContentLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _goodsPriceContentLbl.font = [UIFont systemFontOfSize:13.f];
        [_goodsPriceContentLbl sizeToFit];
    }
    return _goodsPriceContentLbl;
}

-(UILabel *)goodsPriceTitleLbl{
    if (!_goodsPriceTitleLbl) {
        _goodsPriceTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsPriceTitleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _goodsPriceTitleLbl.font = [UIFont systemFontOfSize:15.f];
        _goodsPriceTitleLbl.text = @"商品金额：";
        [_goodsPriceTitleLbl sizeToFit];
    }
    return _goodsPriceTitleLbl;
}

-(UILabel *)postageContentLbl{
    if (!_postageContentLbl) {
        _postageContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _postageContentLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _postageContentLbl.font = [UIFont systemFontOfSize:15.f];
        _postageContentLbl.text = @"包邮";
        [_postageContentLbl sizeToFit];
    }
    return _postageContentLbl;
}

-(UILabel *)postageTitleLbl{
    if (!_postageTitleLbl) {
        _postageTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _postageTitleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _postageTitleLbl.font = [UIFont systemFontOfSize:15.f];
        _postageTitleLbl.text = @"邮费：";
        [_postageTitleLbl sizeToFit];
    }
    return _postageTitleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PayGoodsBasicInformation class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 150.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellItem:(ShoppingCartItem *)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PayGoodsBasicInformation class]];
    if (item)[dict setObject:item forKey:@"item"];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.postageTitleLbl];
        [self.contentView addSubview:self.postageContentLbl];
        [self.contentView addSubview:self.goodsPriceTitleLbl];
        [self.contentView addSubview:self.goodsPriceContentLbl];
        [self.contentView addSubview:self.leaveMessageView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageEndEdit) name:@"messageEndEdit" object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"messageEndEdit" object:nil];
}

-(void)messageEndEdit{
    [self.leaveMessageView endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.item.message = self.leaveMessageView.text;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.postageTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.postageContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.postageTitleLbl.mas_centerY);
    }];
    
    [self.goodsPriceTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.postageTitleLbl.mas_bottom).offset(15);
        make.left.equalTo(self.postageTitleLbl.mas_left);
    }];
    
    [self.goodsPriceContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.postageContentLbl.mas_right);
        make.centerY.equalTo(self.goodsPriceTitleLbl.mas_centerY);
    }];
    
    [self.leaveMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsPriceTitleLbl.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.height.equalTo(@65);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    ShoppingCartItem *item = dict[@"item"];
    self.item = item;
    self.goodsPriceContentLbl.text = [NSString stringWithFormat:@"¥%.2f", item.shopPrice];
}

@end
