//
//  OrderTimeCell.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderTimeCell.h"
#import "Masonry.h"

@interface OrderTimeCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UIButton *copyBtn;
@property (nonatomic, strong) UIButton *copyBtnWai;

@property (nonatomic, copy) NSString *str;
@end

@implementation OrderTimeCell

-(UIButton *)copyBtnWai{
    if (!_copyBtnWai) {
        _copyBtnWai = [[UIButton alloc] initWithFrame:CGRectZero];
        _copyBtnWai.backgroundColor = [UIColor clearColor];
    }
    return _copyBtnWai;
}

-(UIButton *)copyBtn{
    if (!_copyBtn) {
        _copyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _copyBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _copyBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _copyBtn.layer.borderWidth = 0.5;
    }
    return _copyBtn;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:14.f];
        _priceLbl.textColor = [UIColor blackColor];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor blackColor];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderTimeCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo {
    CGFloat height = 30.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSNumber *)price title:(NSString *)title isCopy:(BOOL)isCopy orderId:(NSString *)orderId
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderTimeCell class]];
    if (price) {
        [dict setObject:price forKey:@"price"];
    }
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    if (isCopy) {
        [dict setObject:[NSNumber numberWithBool:isCopy] forKey:@"isCopy"];
    }
    if (orderId) {
        [dict setObject:orderId forKey:@"orderId"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.priceLbl];
        [self.contentView addSubview:self.copyBtn];
        [self.contentView addSubview:self.copyBtnWai];
        
        [self.copyBtnWai addTarget:self action:@selector(clickCopyBtnWai) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickCopyBtnWai{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.str;
    [[CoordinatingController sharedInstance] showHUD:@"复制成功" hideAfterDelay:0.8];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.priceLbl.mas_left).offset(-5);
        make.height.equalTo(@14);
        make.width.equalTo(@26);
    }];
    
    [self.copyBtnWai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.priceLbl.mas_left).offset(-5);
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSString *orderId = dict[@"orderId"];
    self.str = orderId;
    self.titleLbl.text = dict[@"title"];
    if (orderId.length > 0) {
        self.priceLbl.text = orderId;
    } else {
        self.priceLbl.text = [NSString stringWithFormat:@"¥%@", dict[@"price"]];
    }
    
    NSNumber *num = dict[@"isCopy"];
    if ([num isEqualToNumber:@1]) {
        self.copyBtn.hidden = NO;
        self.copyBtnWai.hidden = NO;
    } else {
        self.copyBtn.hidden = YES;
        self.copyBtnWai.hidden = YES;
    }
}

@end
