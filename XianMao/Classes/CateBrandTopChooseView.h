//
//  CateBrandTopChooseView.h
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showCateOrBrandView)(NSInteger index); //1 是cate  2 是brand

@interface CateBrandTopChooseView : UIView

@property (nonatomic, copy) showCateOrBrandView showCateBrandView;
-(void)getIndex:(NSInteger)index; //按钮编号

@end
