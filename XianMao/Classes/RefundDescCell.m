//
//  RefundDescCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RefundDescCell.h"

@implementation RefundDescCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RefundDescCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait
{
    CGFloat height = 40;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RefundDescCell class]];
    return dict;
}

+ (NSMutableDictionary*)buildCellDict:(getrderReturnsModel *)getrderReturnsModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RefundDescCell class]];
    if (getrderReturnsModel) {
        [dict setObject:getrderReturnsModel forKey:@"getrderReturnsModel"];
    }
    return dict;
}


-(void)updateCellWithDict:(NSDictionary *)dict
{
    getrderReturnsModel * model = dict[@"getrderReturnsModel"];
    if (model.message) {
        self.refundDescLbl.text = [NSString stringWithFormat:@"%@",model.message];
    }
}

-(UILabel *)refundDescLbl
{
    if (!_refundDescLbl) {
        _refundDescLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundDescLbl.font = [UIFont systemFontOfSize:10.0f];
        _refundDescLbl.textColor = [UIColor grayColor];
    }
    return _refundDescLbl;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.refundDescLbl];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.refundDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 14, 0, 14));
    }];
}
@end
