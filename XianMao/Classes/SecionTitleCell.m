//
//  SecionTitleCell.m
//  XianMao
//
//  Created by 阿杜 on 16/6/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SecionTitleCell.h"

@implementation SecionTitleCell

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SecionTitleCell class]);
    });
    return __reuseIdentifier;

}

+(NSMutableDictionary *)buildCellTitle:(NSString *)title
{
    NSMutableDictionary * dict = [[super class] buildBaseCellDict:[SecionTitleCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

+(CGFloat)rowHeightForPortrait
{
    CGFloat height = 46;
    return height;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, kScreenWidth-28, 46)];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict[@"title"]) {
        self.titleLabel.text = dict[@"title"];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
  
}


@end
