//
//  PublishDescriptionCell.h
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^textViewReturnText)(NSString *textViewText);

@interface PublishDescriptionCell : BaseTableViewCell

@property (nonatomic, copy) textViewReturnText returnText;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSArray *)goodsDesc andDesc:(NSString *)desc;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
