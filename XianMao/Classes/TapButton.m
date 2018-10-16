//
//  TapButton.m
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TapButton.h"

@interface TapButton()

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) XMWebImageView * image;
@property (nonatomic, copy) NSString * imageName;
@property (nonatomic, copy) NSString * selectedImageName;

@end

@implementation TapButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _image = [[XMWebImageView alloc] init];
        _image.userInteractionEnabled = NO;
        _title = [[UILabel alloc] init];
        _title.userInteractionEnabled = NO;
        _title.font = [UIFont systemFontOfSize:13];
        _title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _title.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        [_title sizeToFit];
        [self addSubview:self.image];
        [self addSubview:self.title];
    }
    return self;
}


-(void)setSeclecting:(BOOL)Seclecting
{
    if (Seclecting) {
        [_image setImageWithURL:self.selectedImageName XMWebImageScaleType:XMWebImageScale100x100];
        self.title.textColor = [UIColor colorWithHexString:[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KIdle_SiftTitleColor_S]]?[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KIdle_SiftTitleColor_S]]:@"f9384c"];
    }else{
        self.title.textColor = [UIColor colorWithHexString:[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KIdle_SiftTitleColor_N]]?[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@%ld", SKIN,KIdle_SiftTitleColor_N]]:@"1a1a1a"];
        [_image setImageWithURL:self.imageName XMWebImageScaleType:XMWebImageScale100x100];
    }
}


- (void)loadWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    if (imageName && selectedImageName) {
        self.imageName = imageName;
        self.selectedImageName = selectedImageName;
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(12);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.image.mas_bottom).offset(8);
        }];
        [_image setImageWithURL:imageName XMWebImageScaleType:XMWebImageScale100x100];
        
        
        _title.text = title;
        
    }else{
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        _title.text = title;
    }
}

@end
