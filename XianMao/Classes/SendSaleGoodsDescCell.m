//
//  SendSaleGoodsDescCell.m
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendSaleGoodsDescCell.h"
#import "SendSaleVo.h"
#import "NSDate+Category.h"

@interface SendSaleGoodsDescCell()

@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic, strong) UILabel * descLbl;
@property (nonatomic, strong) UILabel * time;
@property (nonatomic, strong) UIView * line;

@end

@implementation SendSaleGoodsDescCell

- (UILabel *)descLbl{
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.font = [UIFont systemFontOfSize:14];
        _descLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_descLbl sizeToFit];
        _descLbl.numberOfLines = 0;
    }
    return _descLbl;
}

-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:13];
        _time.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_time sizeToFit];
    }
    return _time;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _line;
}

- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"bg_mid"];
    }
    return _containerView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SendSaleGoodsDescCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 50;
    SendSaleVo * sendVo = [dict objectForKey:@"sendVo"];
    NSDictionary *Tdic  = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f],NSFontAttributeName, nil];
    CGRect  rect  = [sendVo.goodsDesc boundingRectWithSize:CGSizeMake(kScreenWidth/375*300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    rowHeight += rect.size.height;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendSaleGoodsDescCell class]];
    if (sendVo) {
        [dict setObject:sendVo forKey:@"sendVo"];
    }
    return dict;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.descLbl];
        [self.containerView addSubview:self.time];
        [self.containerView addSubview:self.line];
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    SendSaleVo * sendVo = [dict objectForKey:@"sendVo"];
    
    if (sendVo) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sendVo.createtime/1000];
        self.time.text = [NSString stringWithFormat:@"%@",[date XMformattedDateDescription]];
        self.descLbl.text = sendVo.goodsDesc;
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
    
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.left.equalTo(self.containerView.mas_left).offset(18);
        make.right.equalTo(self.containerView.mas_right).offset(-18);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-10);
        make.right.equalTo(self.containerView.mas_right).offset(-18);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.left.equalTo(self.containerView.mas_left).offset(15);
        make.right.equalTo(self.containerView.mas_right).offset(-15);
        make.height.mas_equalTo(@0.5);
    }];
}

@end
