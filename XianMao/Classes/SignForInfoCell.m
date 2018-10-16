//
//  SignForInfoCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SignForInfoCell.h"

@implementation SignForInfoCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SignForInfoCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict{
    getLogsModel * model = dict[@"getLogsModel"];
    NSDictionary *dic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f], NSFontAttributeName, nil];
    
    CGRect rect  =  [model.message boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return  rect.size.height+60;
    
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SignForInfoCell class]];
    return dict;
}

+ (NSMutableDictionary*)buildCellDict:(getLogsModel *)getLogsModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SignForInfoCell class]];
    if (getLogsModel) {
        [dict setObject:getLogsModel forKey:@"getLogsModel"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    getLogsModel * model = dict[@"getLogsModel"];
    
    if (model.brief) {
        self.signForInfoLbl.text = model.brief;
    }
    if (model.message) {
        self.signForLbl.text = model.message;
    }
}

-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"434342"];
//        _containerView.layer.cornerRadius = 3;
    }
    return _containerView;
}

-(UILabel *)signForInfoLbl
{
    if (!_signForInfoLbl) {
        _signForInfoLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _signForInfoLbl.font = [UIFont systemFontOfSize:14];
        _signForInfoLbl.textColor = [UIColor whiteColor];
    }
    return _signForInfoLbl;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}

-(UILabel *)signForLbl
{
    if (!_signForLbl) {
        _signForLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _signForLbl.font = [UIFont systemFontOfSize:12];
        _signForLbl.textColor = [UIColor whiteColor];
        _signForLbl.numberOfLines = 0;
        [_signForLbl sizeToFit];
    }
    return _signForLbl;
}

-(UIView *)triangleView
{
    if (!_triangleView) {
        _triangleView = [[UIView alloc] initWithFrame:CGRectZero];
        _triangleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_triangle"]];
    }
    return _triangleView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.signForInfoLbl];
        [self.containerView addSubview:self.line];
        [self.containerView addSubview:self.signForLbl];
        [self.contentView addSubview:self.triangleView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    [self.signForInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.left.equalTo(self.containerView.mas_left).offset(23);
        make.right.equalTo(self.containerView.mas_right).offset(-23);
        make.height.mas_equalTo(@43);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signForInfoLbl.mas_bottom);
        make.left.equalTo(self.signForInfoLbl.mas_left);
        make.right.equalTo(self.signForInfoLbl.mas_right);
        make.height.mas_equalTo(@1);
    }];
    
    [self.signForLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.left.equalTo(self.line.mas_left).offset(5);
        make.width.equalTo(self.line.mas_width).offset(-10);
    }];
    
    
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.containerView.mas_left);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
}
@end
