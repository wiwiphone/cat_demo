//
//  SettingsViewController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"

@interface SettingsViewController : BaseViewController

@end


@interface SettingsTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;

+ (NSMutableDictionary*)buildCellDict:(NSString*)title;
+ (NSMutableDictionary*)buildCellDictWithRightArrow:(NSString*)title;
+ (NSMutableDictionary*)buildCellDictWithRightArrowAndSubTitle:(NSString*)title icon:(NSString*)icon subTitle:(NSString*)subTitle;

- (void)updateCellWithDict:(NSDictionary*)dict;
@end

@interface SettingsNotificationTableViewCell : SettingsTableViewCell

@end

@interface SettingsLogoutTableViewCell : SettingsTableViewCell

@end

@interface SettingsSegTableViewCell : SettingsTableViewCell
@property(nonatomic,strong) NSDictionary *dict;
@end

