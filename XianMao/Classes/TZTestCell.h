//
//  TZTestCell.h
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZTestCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *promptLbl;
@property (nonatomic, assign) NSInteger index;
- (UIView *)snapshotView;

@end

