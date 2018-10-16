//
//  ApplyGoodsBranchCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BuybackOrderModel.h"
#import "GoodsFittingsListModel.h"
#import "GoodsLossFittingsListModel.h"
@interface ApplyGoodsBranchCell : BaseTableViewCell


@property (nonatomic,strong) XMWebImageView * branchTopImageView;
@property (nonatomic,strong) XMWebImageView * branchDownImageView;
@property (nonatomic,strong) UILabel * branchOneLbl;
@property (nonatomic,strong) UILabel * branchDescLbl;
@property (nonatomic,strong) UILabel * chargeLbl;
@property (nonatomic,strong) UILabel * branchTwoLbl;
@property (nonatomic,strong) UILabel * branchTwoDescLbl;


+ (CGFloat)rowHeightForPortrait;
+ (NSString *)reuseIdentifier;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsFittingsListModel *)GoodsFittingsListModel;
+ (NSMutableDictionary*)buildCellDictWithList:(GoodsLossFittingsListModel *)GoodsLossFittingsListModel;
@end
