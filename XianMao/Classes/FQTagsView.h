//
//  FQTagsView.h
//  XianMao
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagListModel.h"

typedef void(^reloadServeTagTable)(TagListModel *listModel, NSInteger tagIndex, NSArray *tagList);

@interface FQTagsView : UIView

@property (nonatomic, copy) reloadServeTagTable serveTagTable;

@end
