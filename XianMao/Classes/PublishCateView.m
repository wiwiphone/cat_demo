//
//  PublishCateView.m
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishCateView.h"
#import "TipItemVo.h"
#import "PublishListView.h"

@interface PublishCateView ()

@property (nonatomic, strong) UILabel *cateTitleLbl;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PublishCateView

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"Publish_Prompt_JianJian"];
        [_imageView sizeToFit];
    }
    return _imageView;
}

-(UILabel *)cateTitleLbl{
    if (!_cateTitleLbl) {
        _cateTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _cateTitleLbl.font = [UIFont systemFontOfSize:14.f];
        _cateTitleLbl.textColor = [UIColor whiteColor];
        [_cateTitleLbl sizeToFit];
    }
    return _cateTitleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)getModel:(PhotoTipListVo *)tipListVo{
    CGFloat margin = 0;
    [self addSubview:self.cateTitleLbl];
    [self addSubview:self.imageView];
    self.cateTitleLbl.text = tipListVo.categoryName;
    [self.cateTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    margin += self.cateTitleLbl.height;
    margin += 10;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cateTitleLbl.mas_bottom).offset(10);
        make.centerX.equalTo(self.cateTitleLbl.mas_centerX);
    }];
    margin += self.imageView.height;
    margin += 20;
    margin += 20;
    
    CGFloat height = 0;
    for (int i = 0; i < tipListVo.tipItemList.count; i++) {
        TipItemVo * tipVo = [TipItemVo modelWithJSONDictionary:tipListVo.tipItemList[i]];
        UILabel *lbl = [[UILabel alloc] init];
        lbl.font = [UIFont systemFontOfSize:14.f];
        lbl.text = tipVo.tip;
        lbl.numberOfLines = 0;
        [lbl sizeToFit];
        CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX)];
        
        if (tipVo.picGuide.count < 5) {
            height = 70;
        } else {
            height = 150;
        }
        
        PublishListView *listView = [[PublishListView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, size.height+12+height)];
        listView.backgroundColor = [UIColor clearColor];
        [listView getTipModel:tipVo];
        [self addSubview:listView];
        
        margin += listView.height;
        margin += 30;
    }
}

@end
