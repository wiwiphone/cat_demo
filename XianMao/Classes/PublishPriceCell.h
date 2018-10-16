//
//  PublishPriceCell.h
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^getPriceTextField)(UITextField *textField);

@interface PublishPriceCell : BaseTableViewCell

@property (nonatomic, copy) getPriceTextField priceTextField;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString *)yuanPrice diaohuoPrice:(NSString *)diaohuoPrice jianyiPrice:(NSString *)jianyiPrice;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
