//
//  ProtocolItemsCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ProtocolItemsCell.h"

@implementation ProtocolItemsCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ProtocolItemsCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    NSString *title = dict[@"items"];
    CGFloat height = 10.f;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.font = [UIFont systemFontOfSize:13.f];
    lbl.text = title;
    lbl.numberOfLines = 0;
    CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-28, CGFLOAT_MAX)];
    
    height += size.height;
    height += 10;
    return height;
}


+(NSMutableDictionary *)buildCellTitle:(NSString *)items
{
    NSMutableDictionary * dict = [[super class] buildBaseCellDict:[ProtocolItemsCell class]];
    if (items) {
        [dict setObject:items forKey:@"items"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict[@"items"]) {
        self.itemsLabel.text = dict[@"items"];
    }
    
}


-(UILabel *)itemsLabel
{
    if (!_itemsLabel) {
        _itemsLabel = [[UILabel alloc] init];
        _itemsLabel.font = [UIFont systemFontOfSize:13.0];
        _itemsLabel.numberOfLines = 0;
    }
    return _itemsLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemsLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.itemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}

@end
