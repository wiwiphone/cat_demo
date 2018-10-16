//
//  RecoveryCell2.h
//  XianMao
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RecoveryCell2 : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict;

-(void)setTitleText2:(NSString *)titleStr andImageName:(NSString *)imageName;

-(void)turnRightImage:(NSInteger)index;
@end
