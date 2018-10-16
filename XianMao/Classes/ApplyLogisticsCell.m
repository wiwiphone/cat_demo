//
//  ApplyLogisticsCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ApplyLogisticsCell.h"
#import "Masonry.h"
#import "Command.h"

@implementation ApplyLogisticsCell


-(UILabel *)LogisticsCompany
{
    if (!_LogisticsCompany) {
        _LogisticsCompany = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, kScreenWidth/375*80, 27)];
        _LogisticsCompany.font = [UIFont systemFontOfSize:13.0f];
        _LogisticsCompany.textColor = [UIColor colorWithHexString:@"d3d3d3"];
        _LogisticsCompany.text = @"*  物流公司";
    }
    return _LogisticsCompany;
}

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ApplyLogisticsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait
{
    CGFloat height = 40;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ApplyLogisticsCell class]];
    return dict;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.LogisticsCompany];
        
        _LogisticsBtnisTouch = NO;
        _LogisticsBtnTouchID = 0;
        //快递方法
        NSArray * expressName = @[@"顺丰速运",@"EMS"];
        for (int i = 0; i < 2; i ++) {
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMaxX(self.LogisticsCompany.frame)+2)+i*(kScreenWidth/375*127+12), CGRectGetMinY(self.LogisticsCompany.frame), kScreenWidth/375*127, 27)];
            [button setTitle:expressName[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
            button.tag = 10 + i;
            [self.contentView addSubview:button];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

-(void)buttonClick:(UIButton *)sender
{
    _LogisticsBtnisTouch = YES;
    UIButton * btn1 = (UIButton *)sender;
    UIButton * button = (UIButton *)[self viewWithTag:_LogisticsBtnTouchID];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if (_LogisticsBtnTouchID > 0) {
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [btn1 setBackgroundColor:[UIColor whiteColor]];
    if (btn1.tag == _LogisticsBtnTouchID) {
        btn1.backgroundColor = [UIColor colorWithHexString:@"434342"];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        
    }else{
        btn1.backgroundColor = [UIColor colorWithHexString:@"434342"];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _LogisticsBtnTouchID = (int)btn1.tag;
    }
    
    if (self.logistics) {
        self.logistics(sender.titleLabel.text);
    }
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    
}

@end
