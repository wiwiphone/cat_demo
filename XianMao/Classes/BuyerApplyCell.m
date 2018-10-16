//
//  BuyerApplyCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BuyerApplyCell.h"


@implementation BuyerApplyCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BuyerApplyCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict{
    getLogsModel * model = dict[@"getLogsModel"];
    NSDictionary *dic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f], NSFontAttributeName, nil];
    
    CGRect rect  =  [model.message boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return  rect.size.height+50;
  
}



+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BuyerApplyCell class]];
    return dict;
}

+ (NSMutableDictionary*)buildCellDict:(getLogsModel *)getLogsModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BuyerApplyCell class]];
    if (getLogsModel) {
        [dict setObject:getLogsModel forKey:@"getLogsModel"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    getLogsModel * model = dict[@"getLogsModel"];
    if (model.brief) {
        self.buyerApplyLbl.text = model.brief;
    }
    if (model.message) {
        self.timeOutLbl.text = model.message;
    }
}

-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//        _containerView.layer.cornerRadius = 3;
    }
    return _containerView;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _line;
}

-(UILabel *)buyerApplyLbl
{
    if (!_buyerApplyLbl) {
        _buyerApplyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _buyerApplyLbl.font = [UIFont systemFontOfSize:14];
        _buyerApplyLbl.textColor = [UIColor colorWithHexString:@"262626"];
    }
    return _buyerApplyLbl;
}

-(UILabel *)timeOutLbl
{
    if (!_timeOutLbl) {
        _timeOutLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeOutLbl.font = [UIFont systemFontOfSize:12];
        _timeOutLbl.textColor = [UIColor colorWithHexString:@"262626"];
        _timeOutLbl.numberOfLines = 0;
    }
    return _timeOutLbl;
   
}



-(UIImageView *)triangleView
{
    if (!_triangleView) {
        _triangleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _triangleView.image = [UIImage imageNamed:@"white_triangle"];
        
    }
    return _triangleView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.line];
        [self.containerView addSubview:self.buyerApplyLbl];
        [self.containerView addSubview:self.timeOutLbl];
        [self.contentView addSubview:self.triangleView];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    [self.buyerApplyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.left.equalTo(self.containerView.mas_left).offset(23);
        make.right.equalTo(self.containerView.mas_right).offset(-23);
        make.height.mas_equalTo(@42);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyerApplyLbl.mas_bottom);
        make.left.equalTo(self.buyerApplyLbl.mas_left);
        make.right.equalTo(self.buyerApplyLbl.mas_right);
        make.height.mas_equalTo(@1);
    }];
    
    [self.timeOutLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.left.equalTo(self.line.mas_left).offset(5);
        make.width.equalTo(self.line.mas_width).offset(-10);
    }];
   
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.containerView.mas_right).offset(-6);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        
    }];
}
@end
