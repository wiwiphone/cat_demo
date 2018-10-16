//
//  SearchSiftGradeCell.m
//  XianMao
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchSiftGradeCell.h"

@interface SearchSiftGradeCell ()


@end

@implementation SearchSiftGradeCell


+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SearchSiftGradeCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 7;
    
    SearchSiftGradeDescVo *gradeDescVo = dict[@"gradeDescVo"];
    
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.font = [UIFont boldSystemFontOfSize:15.f];
    lbl1.text = gradeDescVo.gradeValueDesc;
    [lbl1 sizeToFit];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:15.f];
    lbl.text = gradeDescVo.detailDesc;
    
//    CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-16*2-lbl1.width-12, CGFLOAT_MAX)];
//    height += size.height;
//    height += 7;

     NSArray *arr = [gradeDescVo.detailDesc componentsSeparatedByString:@"\n"];
    CGFloat margin = 14;
    for (int i = 0; i < arr.count; i++) {
        NSString *desc = arr[i];
        UILabel *gradeDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(45, 14, 0, 0)];
        gradeDescLbl.text = desc;
        gradeDescLbl.font = [UIFont systemFontOfSize:15.f];
        gradeDescLbl.textColor = [UIColor colorWithHexString:@"888888"];
        gradeDescLbl.numberOfLines = 0;
        [gradeDescLbl sizeToFit];
        gradeDescLbl.frame = CGRectMake(45, margin, kScreenWidth-45-16, gradeDescLbl.height);
        
        margin += gradeDescLbl.height;
    }
    height += margin+7;
    
    return height;
}

+ (NSMutableDictionary *)buildCellDict:(SearchSiftGradeDescVo *)gradeDescVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SearchSiftGradeCell class]];
    if (gradeDescVo) {
        [dict setObject:gradeDescVo forKey:@"gradeDescVo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    
    for (UILabel *lbl in self.contentView.subviews) {
        if ([lbl isKindOfClass:[UILabel class]]) {
            [lbl removeFromSuperview];
        }
    }
    
    SearchSiftGradeDescVo *gradeDescVo = dict[@"gradeDescVo"];
    
    UILabel *gradeTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 0, 0)];
    gradeTitleLbl.text = gradeDescVo.gradeValueDesc;
    gradeTitleLbl.font = [UIFont boldSystemFontOfSize:15.f];
    gradeTitleLbl.textColor = [UIColor colorWithHexString:@"333333"];
    [gradeTitleLbl sizeToFit];
    gradeTitleLbl.frame = CGRectMake(16, 14, gradeTitleLbl.width, gradeTitleLbl.height);
    [self.contentView addSubview:gradeTitleLbl];
    
     NSArray *arr = [gradeDescVo.detailDesc componentsSeparatedByString:@"\n"];
    CGFloat margin = 14;
    for (int i = 0; i < arr.count; i++) {
        NSString *desc = arr[i];
        UILabel *gradeDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(45, 14, 0, 0)];
        gradeDescLbl.text = desc;
        gradeDescLbl.font = [UIFont systemFontOfSize:15.f];
        gradeDescLbl.textColor = [UIColor colorWithHexString:@"888888"];
        gradeDescLbl.numberOfLines = 0;
        [gradeDescLbl sizeToFit];
        gradeDescLbl.frame = CGRectMake(45, margin, kScreenWidth-45-16, gradeDescLbl.height);
        [self.contentView addSubview:gradeDescLbl];
        
        margin += gradeDescLbl.height;
    }
    
    
}

@end
