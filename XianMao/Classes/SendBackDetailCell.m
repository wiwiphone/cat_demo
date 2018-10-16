//
//  SendBackDetailCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "Masonry.h"
#import "SendBackDetailCell.h"

@implementation SendBackDetailCell

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SendBackDetailCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict{

    NSString *title = dict[@"title"];
    NSDictionary *dic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f], NSFontAttributeName, nil];
    
    CGRect rect  =  [title boundingRectWithSize:CGSizeMake(kScreenWidth/375*200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height +44;
    
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendBackDetailCell class]];
    return dict;
}

-(UILabel *)goodsLbl
{
    if (!_goodsLbl) {
        _goodsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsLbl.font = [UIFont systemFontOfSize:12.0f];
        _goodsLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _goodsLbl.adjustsFontSizeToFitWidth = YES;
    }
    
    return _goodsLbl;
}

-(UILabel *)goodsSeriesLbl
{
    if (!_goodsSeriesLbl) {
        _goodsSeriesLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsSeriesLbl.font = [UIFont systemFontOfSize:12.0f];
        _goodsSeriesLbl.numberOfLines = 0;
        [_goodsSeriesLbl sizeToFit];
        _goodsSeriesLbl.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _goodsSeriesLbl;
}

-(UILabel *)priceLbl
{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _priceLbl.font = [UIFont systemFontOfSize:12.0f];
        _priceLbl.textAlignment = NSTextAlignmentRight;
        [_priceLbl sizeToFit];
     
    }
    return _priceLbl;
}

-(UILabel *)goodsCount
{
    if (!_goodsCount) {
        _goodsCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsCount.textColor = [UIColor colorWithHexString:@"000000"];
        _goodsCount.font = [UIFont systemFontOfSize:12.0f];
        _goodsCount.textAlignment = NSTextAlignmentRight;
        

    }
    return _goodsCount;
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.goodsLbl];
        [self.contentView addSubview:self.goodsSeriesLbl];
        [self.contentView addSubview:self.goodsCount];
        [self.contentView addSubview:self.priceLbl];

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:12.0f]; //HelveticaNeue一定要用这个名字
    _goodsLbl.font = fnt;
    CGSize size = [@"腕表:" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    CGFloat nameW = size.width;
    
    [self.goodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(nameW, 15));
    }];
    
    [self.goodsSeriesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsLbl.mas_top);
        make.left.equalTo(self.goodsLbl.mas_right).offset(14);
        make.width.mas_equalTo(kScreenWidth/375*200);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsLbl.mas_top);
//        make.left.equalTo(self.goodsSeriesLbl.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.equalTo(self.goodsLbl.mas_bottom);
    }];
    
    [self.goodsCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLbl.mas_bottom);
        make.left.equalTo(self.goodsSeriesLbl.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.equalTo(self.priceLbl.mas_bottom).offset(15);
    }];
    

}


+ (NSMutableDictionary*)buildCellDict:(BuybackOrderModel *)model
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendBackDetailCell class]];
    if (model) {
        [dict setObject:model forKey:@"BuybackOrderModel"];
    }

    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{

    BuybackOrderModel * model = dict[@"BuybackOrderModel"];
    
    self.goodsLbl.text = @"腕表:";
    
    if (model.goodsName) {
        self.goodsSeriesLbl.text = model.goodsName;
    }
    if (model.count) {
        self.goodsCount.text = [NSString stringWithFormat:@"x%@",model.count];
    }
    if (model.realPrice) {
        self.priceLbl.text = [NSString stringWithFormat:@"¥%@",model.realPrice];
    }

}

@end
