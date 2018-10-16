//
//  SupportvalueCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SupportvalueCell.h"

@implementation SupportvalueCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SupportvalueCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    BuybackOrderModel * model = dict[@"BuybackOrderModel"];
//    UILabel *lbl = [[UILabel alloc] init];
//    lbl = [[UILabel alloc] initWithFrame:CGRectMake(7, 15, kScreenWidth-30, CGFLOAT_MAX)];
//    lbl.textColor = [UIColor colorWithHexString:@"fefefe"];
//    lbl.font = [UIFont systemFontOfSize:12];
//    lbl.numberOfLines = 0;
//    lbl.text = model.priceInfo;
//    [lbl sizeToFit];
//    
//    CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-28, CGFLOAT_MAX)];
//    CGFloat height = size.height;
    NSDictionary *dic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f], NSFontAttributeName, nil];
    
    CGRect rect  =  [model.priceInfo boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height+30;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SupportvalueCell class]];
    return dict;
}

+ (NSMutableDictionary*)buildCellDict:(BuybackOrderModel *)BuybackOrderModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SupportvalueCell class]];
    if (BuybackOrderModel) {
        [dict setObject:BuybackOrderModel forKey:@"BuybackOrderModel"];
    }
    return dict;
}


-(void)updateCellWithDict:(NSDictionary *)dict
{
    BuybackOrderModel * model = dict[@"BuybackOrderModel"];
    
    if (model.priceInfo) {
        _predictLbl.text = model.priceInfo;
    }
 
}

-(UILabel *)SupportLbl
{
    if (!_SupportLbl) {
        _SupportLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _SupportLbl.textColor = [UIColor colorWithHexString:@"3b3b3b"];
        _SupportLbl.font = [UIFont systemFontOfSize:14];
        _SupportLbl.text = @"退货将扣除本次到付保价费(运费+售价0.5%保费)";
        _SupportLbl.adjustsFontSizeToFitWidth = YES;
    }
    return _SupportLbl;
}



-(UILabel *)predictLbl
{
    if (!_predictLbl) {
        _predictLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _predictLbl.textColor = [UIColor colorWithHexString:@"fefefe"];
        _predictLbl.font = [UIFont systemFontOfSize:12];
        _predictLbl.numberOfLines = 0;
        
    }
    return _predictLbl;
}

-(UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectZero];
        _container.backgroundColor = [UIColor colorWithHexString:@"434342"];
    }
    return _container;
}

-(UIImageView *)triangle
{
    if (!_triangle) {
        _triangle = [[UIImageView alloc] initWithFrame:CGRectZero];
        _triangle.image = [UIImage imageNamed:@"black_triangle"];
        _triangle.transform = CGAffineTransformMakeRotation(90 *M_PI / 180.0);

    }
    return _triangle;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.SupportLbl];
        [self.contentView addSubview:self.container];
        [self.contentView addSubview:self.triangle];
        [self.container addSubview:self.predictLbl];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.SupportLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-55);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    
    [self.triangle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container.mas_top).offset(-7);
        make.left.equalTo(self.container.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.predictLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container.mas_top).offset(7);
        make.left.equalTo(self.container.mas_left).offset(15);
        make.right.equalTo(self.container.mas_right).offset(-15);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SupportLbl.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.equalTo(self.predictLbl.mas_bottom);
    }];

}
@end
