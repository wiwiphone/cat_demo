//
//  TagsPopView.h
//  XianMao
//
//  Created by 阿杜 on 16/3/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tagsPopViewDelegate <NSObject>

- (void)dissmiss;

@end

@interface TagsPopView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel     *headLB;
@property (nonatomic, strong) UIView      *footerView;
@property (nonatomic, strong) NSArray     *authArr;
@property (nonatomic, weak) id<tagsPopViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame tagsArr:(NSMutableArray *)tagsArr;

@end


@class UserTagInfo;
@interface TagsPopCell : UITableViewCell
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *myLabel;

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updataWithTag:(UserTagInfo *)tag;
@end