//
//  IdleCollectionViewCell.h
//  XianMao
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureItem.h"

@interface IdleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XMWebImageView *imageView;
-(void)getPictureItem:(PictureItem *)item;

@end
