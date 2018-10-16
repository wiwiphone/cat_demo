//
//  NeedsCollectionViewCell.h
//  XianMao
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeedsAttachmentVo.h"

@interface NeedsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XMWebImageView *imageView;
-(void)getNeedsAttrmendVo:(NeedsAttachmentVo *)NeedsAttachmentVo;

@end
