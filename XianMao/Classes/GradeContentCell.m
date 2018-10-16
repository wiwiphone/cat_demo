//
//  GradeContentCell.m
//  yuncangcat
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GradeContentCell.h"

@interface GradeContentCell ()

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) UIButton * gradeTitle;
@property (nonatomic, strong) UIImageView * selectIcon;

@end

@implementation GradeContentCell

-(UIButton *)gradeTitle{
    if (!_gradeTitle) {
        _gradeTitle = [[UIButton alloc] init];
        _gradeTitle.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_gradeTitle setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        [_gradeTitle sizeToFit];
    }
    return _gradeTitle;
}

-(UIImageView *)selectIcon{
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc] init];
        _selectIcon.image = [UIImage imageNamed:@"selectIcon_new"];
    }
    return _selectIcon;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GradeContentCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    
    NSArray *arr = dict[@"arr"];
    height += (arr.count * 15) + ((arr.count + 1) * 13);
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray *)arr
                       gradeValueDesc:(NSString *)gradeValueDesc
                                grade:(NSString *)grade
                        gradeDescInfo:(GradeDescInfo *)gradeDescInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GradeContentCell class]];
    if (arr) {
        [dict setObject:arr forKey:@"arr"];
    }
    
    if (gradeValueDesc) {
        [dict setObject:gradeValueDesc forKey:[GradeContentCell cellDictKeyForGradeValueDesc]];
    }
    if (grade) {
        [dict setObject:grade forKey:@"grade"];
    }
    if (gradeDescInfo) {
        [dict setObject:gradeDescInfo forKey:@"gradeDescInfo"];
    }
    return dict;
}

+ (NSString *)cellDictKeyForGradeValueDesc{
    NSString * key = @"gradeValueDesc";
    return key;
}

+ (NSString *)cellDictKeyForGradeDescInfo{
    NSString * key = @"gradeDescInfo";
    return key;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.selectIcon];
        self.selectIcon.hidden = YES;
        [self.contentView addSubview:self.gradeTitle];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.gradeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(6.5);
        make.left.equalTo(self.contentView.mas_left).offset(18);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSArray *arr = dict[@"arr"];
    
    NSString * gradeValueDesc  = [dict objectForKey:@"gradeValueDesc"];
    NSString * grade = [dict objectForKey:@"grade"];
    GradeDescInfo *gradeDescInfo = [dict objectForKey:@"gradeDescInfo"];
    
    [self.gradeTitle setTitle:[NSString stringWithFormat:@"%@",gradeDescInfo.gradeValueDesc] forState:UIControlStateNormal];
    if ([grade isEqualToString:gradeValueDesc]) {
        self.selectIcon.hidden = NO;
    } else {
        self.selectIcon.hidden = YES;
    }
    
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < arr.count; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(45, 13, kScreenWidth, 13)];
        lbl.text = arr[i];
        lbl.textColor = [UIColor colorWithHexString:@"999999"];
        lbl.font = [UIFont systemFontOfSize:14];
        [lbl sizeToFit];
        lbl.frame = CGRectMake(45, ((i+1)*13)+(i*15), kScreenWidth-90, lbl.height);
        lbl.tag = 20170112+i;
        [self.contentView addSubview:lbl];
    }

}

@end
