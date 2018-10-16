//
//  TitleTableViewCell.h
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol TitleTableViewCellDelegate <NSObject>

@optional
-(void)sheetQuaView;

@end

@interface TitleTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(NSString *)title andPrompTitle:(NSString *)promptTitle;
- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, weak) id <TitleTableViewCellDelegate> titleDelegate;

@end
