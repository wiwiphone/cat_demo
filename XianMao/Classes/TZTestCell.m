//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZTestCell.h"
#import "UIView+Layout.h"

@implementation TZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.text = @"添加图片";
        [_titleLbl sizeToFit];
        [_imageView addSubview:_titleLbl];
//        UIImageView *iconImageView = [[UIImageView alloc] init];
        
        _promptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _promptLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _promptLbl.font = [UIFont systemFontOfSize:13.f];
        _promptLbl.text = @"更好卖的拍摄技巧";
        _promptLbl.numberOfLines = 0;
        [_promptLbl sizeToFit];
        [_imageView addSubview:_promptLbl];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        _deleteBtn.frame = CGRectMake(0, 0, 20, 20);
        _deleteBtn.clipsToBounds = NO;
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(7, 7, self.bounds.size.width-7, self.bounds.size.height-7);//CGRectMake(17, 15, (kScreenWidth-15*4)/3, (kScreenWidth-15*4)/3);
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageView.mas_centerX);
        make.bottom.equalTo(_imageView.mas_bottom).offset(-5);
    }];
    [_promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageView.mas_centerX).offset(3);
        make.centerY.equalTo(_imageView.mas_centerY);
        make.width.equalTo(@60);
    }];
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
