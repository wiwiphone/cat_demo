//
//  RecoverGoodsListCollectionCell.m
//  XianMao
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverGoodsListCollectionCell.h"
#import "RecoverLisdTableViewController.h"

@interface RecoverGoodsListCollectionCell ()



@end

@implementation RecoverGoodsListCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.listTableViewController = [[RecoverLisdTableViewController alloc] init];
        [self.contentView addSubview:self.listTableViewController.view];
        
    }
    return self;
}

@end
