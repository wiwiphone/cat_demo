//
//  IdleCollectionView.h
//  XianMao
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"

@interface IdleCollectionView : UICollectionView

-(void)getPicData:(NSArray *)picData andGoodsInfo:(GoodsInfo *)goodsInfo;
-(void)getPicData:(NSArray *)picData;
@end
