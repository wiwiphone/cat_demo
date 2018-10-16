//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@interface SDCollectionViewCell ()

@end

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}

-(UILabel *)subTitleLbl{
    if (!_subTitleLbl) {
        _subTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLbl.font = [UIFont systemFontOfSize:11.f];
        _subTitleLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _subTitleLbl.tag = 1953;
        [_subTitleLbl sizeToFit];
    }
    return _subTitleLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _titleLbl.tag = 1953;
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupImageView];
        [self setupTitleLabel];
        
    }
    
    return self;
}

-(void)setIsMianView:(BOOL)isMianView{
    _isMianView = isMianView;
    for (UILabel *lbl in self.subviews) {
        if ([lbl isKindOfClass:[UILabel class]] && lbl.tag == 1953) {
            [lbl removeFromSuperview];
        }
    }
    if (isMianView) {
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.subTitleLbl];
        
        [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.subTitleLbl.mas_top).offset(-1);
            make.left.equalTo(self.subTitleLbl.mas_left);
        }];
    }
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        if (self.isMianView) {
            _imageView.frame = CGRectMake(0, 0, self.width, self.height-45);
        } else {
            _imageView.frame = self.bounds;
        }
        CGFloat titleLabelW = self.sd_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        
    }
}

@end
