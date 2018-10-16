//
//  TagView.h
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferenceInJson.h"

typedef void(^dismissTagView)(NSInteger index);
typedef void(^pushFondController)();

@interface TagView : UIView

@property (nonatomic, copy) dismissTagView dismissTagViewBlock;
@property (nonatomic, copy) pushFondController pushFondControllerBlock;
-(void)clickAllBtn;
-(void)getPreferenceArr:(NSMutableArray *)preInJsonArr;
@end
