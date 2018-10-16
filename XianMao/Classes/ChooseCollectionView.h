//
//  ChooseCollectionView.h
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsEditableInfo.h"
@interface ChooseCollectionView : UICollectionView

-(void)upDataArr:(NSMutableArray *)dataArr editInfo:(AttrEditableInfo *)attrInfo;

@end
