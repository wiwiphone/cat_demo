//
//  HotCateView.m
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "HotCateView.h"
#import "CateVO.h"
#import "DataSources.h"

@interface HotCateView ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HotCateView

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)getData:(NSMutableArray *)dataArr{
    self.dataArr = dataArr;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        
        CateVO *cate = [[CateVO alloc] initWithJSONDictionary:dataArr[i]];
        
        XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(8+(i%3*((kScreenWidth-(8*4))/3+8)), 8+(i/3*((kScreenWidth-(8*4))/3+8)), ((kScreenWidth-(8*4))/3), ((kScreenWidth-(8*4))/3))];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        imageView.clipsToBounds = YES;
        [imageView setImageWithURL:cate.categoryBackImage XMWebImageScaleType:XMWebImageScale480x480];
        [self addSubview:imageView];
        
        CateHotButton *btn = [[CateHotButton alloc] initWithFrame:imageView.bounds];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:cate.categoryName forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:cate.categoryBackImage] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"e6e7e9"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        btn.cateId = cate.categoryId;
        btn.cateName = cate.categoryName;
        btn.redirect_uri = cate.redirect_uri;
        [btn addTarget:self action:@selector(clickCateBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:btn];
    }
}

-(void)clickCateBtn:(CateHotButton*)sender{
    if (self.clickHotCateBtn) {
        self.clickHotCateBtn(sender);
    }
}

@end
