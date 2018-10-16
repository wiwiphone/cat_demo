//
//  BaseTableViewCell.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewCellDelegate <NSObject>
@optional

@end

@interface BaseTableViewCell : UITableViewCell

@property(nonatomic,assign) id<BaseTableViewCellDelegate> delegate;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict index:(NSInteger)index;

+ (NSString*)dictKeyOfClsName;
+ (Class)clsTableViewCell:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildBaseCellDict:(Class)cls;

- (void)updateCellWithDict:(NSDictionary*)dict;
- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index;

@end
