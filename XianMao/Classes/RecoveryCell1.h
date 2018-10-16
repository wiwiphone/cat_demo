//
//  RecoveryCell1.h
//  XianMao
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RecoveryCell1 : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict;

-(void)setTitleText1:(NSString *)titleStr andImageName:(NSString *)imageName;

@property (nonatomic, copy) NSString *subStr;
@end



