//
//  PublishSelectHeaderView.h
//  XianMao
//
//  Created by 阿杜 on 16/3/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishGoodsViewController.h"

@protocol PublishSelectHeaderViewDelegate <NSObject>

- (void)headerViewTapAction:(NSInteger)tag;

@end

@interface PublishSelectHeaderView : UIView

@property (nonatomic, strong) NSArray *dataArr;
-(void)updateWithArr:(NSArray *)arr;

@property(nonatomic, weak)id<PublishSelectHeaderViewDelegate>delegate;


@end


@interface PublishHeaderCellView : UIView

@property (nonatomic, strong) NSDictionary *dataDic;

@property(nonatomic,strong) PublishSelectableItem *selectableItem;
//+ (NSMutableDictionary*)buildCellDict:(PublishSelectableItem*)item;
//+ (NSString*)cellKeyForSelectableItem;
- (void)updateWithDict:(NSDictionary*)dict;

- (void)setupUI;

@end