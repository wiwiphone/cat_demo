//
//  SaleStateCollectionViewCell.m
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SaleStateCollectionViewCell.h"

@interface SaleStateCollectionViewCell ()

@end

@implementation SaleStateCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.saleStateController = [[SaleStateTableViewController alloc] init];
        [self.contentView addSubview:self.saleStateController.view];
        
    }
    return self;
}

@end
