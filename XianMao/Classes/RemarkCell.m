//
//  RemarkCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RemarkCell.h"

@implementation RemarkCell



+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RemarkCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict{
//    getLogsModel * model = dict[@"getLogsModel"];
//    NSDictionary *dic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f], NSFontAttributeName, nil];
//    
//    CGRect rect  =  [model.message boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return  30;
    
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RemarkCell class]];
    return dict;
}

//+ (NSMutableDictionary*)buildCellDict:(getLogsModel *)getLogsModel
//{
//    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RemarkCell class]];
//    if (getLogsModel) {
//        [dict setObject:getLogsModel forKey:@"getLogsModel"];
//    }
//    return dict;
//}

+(NSMutableDictionary *)buildCellTitle:(NSString *)title
{
    NSMutableDictionary * dict = [[super class] buildBaseCellDict:[RemarkCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict[@"title"]) {
        self.remarkLabel.text = dict[@"title"];
    }
}



-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}


-(UIImageView *)imageview
{
    if (!_imageview) {
        _imageview =[[UIImageView alloc] init];
        _imageview.image = [UIImage imageNamed:@"verify_clock"];
    }
    return _imageview;
    
}

-(UILabel *)remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [UIColor colorWithHexString:@"808080"];
        _remarkLabel.font = [UIFont systemFontOfSize:12.0f];
        _remarkLabel.text = @"到账";
    }
    return _remarkLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.imageview];
        [self.containerView addSubview:self.remarkLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.containerView.mas_left).offset(5);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
    }];
    
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.left.equalTo(self.imageview.mas_right).offset(5);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}

@end
