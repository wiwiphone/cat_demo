//
//  AccessoriesListCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsFittingsListModel.h"

@interface AccessoriesListCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * accessories;
@property (nonatomic,strong) UILabel * accessoriesName;
@property (nonatomic,strong) UILabel * accessoriesCount;


+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDictWithList:(GoodsFittingsListModel *)GoodsFittingsListModel Andccessories:(NSString *)name;;

@end
