//
//  GoodsGradeHUDView.m
//  XianMao
//
//  Created by Marvin on 17/3/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GoodsGradeHUDView.h"


#define ORIGINFRAMEY kScreenHeight/2

@interface GoodsGradeHUDView()

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * descLbl;

@end

@implementation GoodsGradeHUDView

-(instancetype)init
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        [self drawView];
    }
    return self;
}


- (void)drawView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(40, ORIGINFRAMEY, kScreenWidth-80, 200)];
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.alpha = 0.8;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10;
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(40, ORIGINFRAMEY, _contentView.width, 38)];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textAlignment = NSTextAlignmentCenter;

        
        _descLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLbl.textColor = [UIColor whiteColor];
        _descLbl.font = [UIFont systemFontOfSize:15];
        _descLbl.textAlignment = NSTextAlignmentLeft;
        _descLbl.numberOfLines = 0;
        
        [self addSubview:self.contentView];
        [self addSubview:self.title];
        [self addSubview:self.descLbl];
        
    }
}



- (void)getGradeTag:(GoodsGradeTag *)gradeTag{
    _title.text = gradeTag.value;
    
    _descLbl.text = gradeTag.desc;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_descLbl.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];//行距的大小
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _descLbl.text.length)];
    _descLbl.attributedText = attributedString;
    
    _descLbl.frame = CGRectMake(50, ORIGINFRAMEY+38+10, kScreenWidth-100, 38);
    [_descLbl sizeToFit];
    _descLbl.frame = CGRectMake(50, ORIGINFRAMEY+38+10, kScreenWidth-100, _descLbl.height);
    
    _contentView.frame = CGRectMake(40, ORIGINFRAMEY, kScreenWidth-80, 40+_descLbl.height + 30);
    
}


+ (GoodsGradeHUDView *)show{
    GoodsGradeHUDView * gradeHUD = [[GoodsGradeHUDView alloc] init];
    gradeHUD.alpha = 0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:gradeHUD];
    [UIView animateWithDuration:.3 animations:^{
        gradeHUD.alpha = 1;
    }];
    
    return gradeHUD;
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
