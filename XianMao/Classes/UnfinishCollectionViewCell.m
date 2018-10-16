//
//  UnfinishCollectionViewCell.m
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "UnfinishCollectionViewCell.h"

@implementation UnfinishCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.unfinishController = [[UnfinishTableViewController alloc] init];
        [self.contentView addSubview:self.unfinishController.view];
        
    }
    return self;
}

@end
