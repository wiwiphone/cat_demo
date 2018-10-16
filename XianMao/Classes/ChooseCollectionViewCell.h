//
//  ChooseCollectionViewCell.h
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsEditableInfo.h"

@interface ChooseCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger attr_id;
-(void)getData:(AttrEditableInfo *)attrInfo;
@end
