//
//  WithdrawalHistoryTableViewCell.h
//  XianMao
//
//  Created by darren on 15/1/27.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wallet.h"
#import "BaseTableViewCell.h"
#import "NSDate+Additions.h"

@interface WithdrawalHistoryTableViewCell : BaseTableViewCell
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) double tradeAmount;
@property (nonatomic, strong)  UIView *lineView;

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
//+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
+ (NSMutableDictionary*)buildCellDict:(WithdrawalInfo*)withdrawalInfo;
+ (NSString*)reuseIdentifier;
- (void)updateCellWithDict:(NSDictionary *)dict;
@end


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#import "AccountLogVo.h"

@interface AccountLogTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(AccountLogVo*)accountLogVo cellIndex:(NSInteger)index;

@end


