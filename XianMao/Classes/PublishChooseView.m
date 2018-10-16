//
//  PublishChooseView.m
//  yuncangcat
//
//  Created by WJH on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishChooseView.h"
#import "Command.h"

@interface PublishChooseView()

@property (nonatomic, strong) TapDetectingImageView * PublishnewGoodsImage;
@property (nonatomic, strong) TapDetectingImageView * draftImage;
@property (nonatomic, strong) UILabel * label1;
@property (nonatomic, strong) UILabel * label2;
@property (nonatomic, strong) UIView * segLine;

@end

@implementation PublishChooseView

-(TapDetectingImageView *)PublishnewGoodsImage
{
    if (!_PublishnewGoodsImage) {
        _PublishnewGoodsImage = [[TapDetectingImageView alloc] init];
        _PublishnewGoodsImage.image = [UIImage imageNamed:@"newGoods"];
    }
    return _PublishnewGoodsImage;
}

-(TapDetectingImageView *)draftImage
{
    if (!_draftImage) {
        _draftImage = [[TapDetectingImageView alloc] init];
        _draftImage.image = [UIImage imageNamed:@"Drafts"];
    }
    return _draftImage;
}

-(UILabel *)label1
{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.font = [UIFont systemFontOfSize:15];
        _label1.textColor = [UIColor colorWithHexString:@"434342"];
        _label1.text = @"新的商品";
        [_label1 sizeToFit];
    }
    return _label1;
}

-(UILabel *)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.font = [UIFont systemFontOfSize:15];
        _label2.textColor = [UIColor colorWithHexString:@"434342"];
        _label2.text = @"草稿箱";
        [_label2 sizeToFit];
    }
    return _label2;
}

-(UIView *)segLine
{
    if (!_segLine) {
        _segLine = [[UIView alloc] init];
        _segLine.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
    }
    return _segLine;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"PublishChooseViewBg"];

        [self addSubview:self.PublishnewGoodsImage];
        [self addSubview:self.draftImage];
        [self addSubview:self.label1];
        [self addSubview:self.label2];
        [self addSubview:self.segLine];
        
        WEAKSELF;
        self.PublishnewGoodsImage.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.handlePublishNewGoods) {
                weakSelf.handlePublishNewGoods();
            };
        };
        
        self.draftImage.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.handleSaveDraft) {
                weakSelf.handleSaveDraft();
            };
        };
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.PublishnewGoodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(40/3);
        make.left.equalTo(self.mas_left).offset(95/3);
    }];
    
    [self.draftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PublishnewGoodsImage.mas_top);
        make.right.equalTo(self.mas_right).offset(-95/3);
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.PublishnewGoodsImage.mas_centerX);
        make.top.equalTo(self.PublishnewGoodsImage.mas_bottom).offset(0);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.draftImage.mas_centerX);
        make.top.equalTo(self.draftImage.mas_bottom).offset(0);
    }];
    
    [self.segLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(@1);
    }];
}

@end
