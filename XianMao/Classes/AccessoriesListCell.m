//
//  AccessoriesListCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AccessoriesListCell.h"

@implementation AccessoriesListCell



+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([AccessoriesListCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict{
    //    getLogsModel * model = dict[@"getLogsModel"];
    //    NSDictionary *dic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f], NSFontAttributeName, nil];
    //
    //    CGRect rect  =  [model.message boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return  25;
    
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AccessoriesListCell class]];
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
    NSMutableDictionary * dict = [[super class] buildBaseCellDict:[AccessoriesListCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

+ (NSMutableDictionary*)buildCellDictWithList:(GoodsFittingsListModel *)GoodsFittingsListModel Andccessories:(NSString *)name;
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AccessoriesListCell class]];
    if (GoodsFittingsListModel) {
        [dict setObject:GoodsFittingsListModel forKey:@"GoodsFittingsListModel"];
    }
    
    if (name) {
        [dict setObject:name forKey:@"name"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    NSString * name = dict[@"name"];
    if (name) {
        self.accessories.text = name;
    }
    
    GoodsFittingsListModel * model = dict[@"GoodsFittingsListModel"];
    if (model.name) {
        self.accessoriesName.text = model.name;
    }
    
    if (model.number) {
        self.accessoriesCount.text = [NSString stringWithFormat:@"x%@",model.number];
    }
}





-(UILabel *)accessories
{
    if (!_accessories) {
        _accessories = [[UILabel alloc] init];
        _accessories.font = [UIFont systemFontOfSize:12.0f];
        _accessories.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _accessories;
}

-(UILabel *)accessoriesName
{
    if (!_accessoriesName) {
        _accessoriesName = [[UILabel alloc] init];
        _accessoriesName.font = [UIFont systemFontOfSize:12.0f];
        _accessoriesName.textColor = [UIColor colorWithHexString:@"000000"];

    }
    return _accessoriesName;
}

-(UILabel *)accessoriesCount
{
    if (!_accessoriesCount) {
        _accessoriesCount = [[UILabel alloc] init];
        _accessoriesCount.font = [UIFont systemFontOfSize:12.0f];
        _accessoriesCount.textColor = [UIColor colorWithHexString:@"000000"];
        _accessoriesCount.textAlignment = NSTextAlignmentRight;

    }
    return _accessoriesCount;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.accessories];
        [self.contentView addSubview:self.accessoriesName];
        [self.contentView addSubview:self.accessoriesCount];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:12.0f]; //HelveticaNeue一定要用这个名字
//    _goodsLbl.font = fnt;
//    CGSize size = [_goodsLbl.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
//    CGFloat nameW = size.width;
//    
//    [self.goodsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(14);
//        make.left.equalTo(self.contentView.mas_left).offset(14);
//        make.size.mas_equalTo(CGSizeMake(nameW, 15));
//    }];
    
    [self.accessories mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(15);
    }];
    
    [self.accessoriesName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accessories.mas_top);
        make.left.equalTo(self.accessories.mas_right).offset(14);
        make.height.mas_equalTo(15);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
    }];
    
    [self.accessoriesCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accessoriesName.mas_top);
        make.left.equalTo(self.accessoriesName.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.height.mas_equalTo(15);
    }];
    
}

@end
