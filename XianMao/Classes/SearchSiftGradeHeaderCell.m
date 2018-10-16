//
//  SearchSiftGradeHeaderCell.m
//  XianMao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchSiftGradeHeaderCell.h"
#import "Command.h"

@interface SearchSiftGradeHeaderCell ()

@property (nonatomic, strong) UILabel *gradeHeaderLbl;
@property (nonatomic, strong) UIImageView *bottomImageView;

@end

@implementation SearchSiftGradeHeaderCell

-(UIImageView *)bottomImageView{
    if (!_bottomImageView){
        _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bottomImageView sizeToFit];
    }
    return _bottomImageView;
}

-(UILabel *)gradeHeaderLbl{
    if (!_gradeHeaderLbl) {
        _gradeHeaderLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _gradeHeaderLbl.font = [UIFont systemFontOfSize:15.f];
        _gradeHeaderLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_gradeHeaderLbl sizeToFit];
    }
    return _gradeHeaderLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SearchSiftGradeHeaderCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 36.f;
    
    return height;
}

+ (NSMutableDictionary *)buildCellDict:(SearchSiftGradeVo *)gradeVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SearchSiftGradeHeaderCell class]];
    if (gradeVo) {
        [dict setObject:gradeVo forKey:@"gradeVo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.gradeHeaderLbl];
        [self.contentView addSubview:self.bottomImageView];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [self.gradeHeaderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    SearchSiftGradeVo *gradeVo = dict[@"gradeVo"];
    self.gradeHeaderLbl.text = gradeVo.categoryName;
    self.bottomImageView.image = [UIImage imageNamed:@"Search_Sift_Grade"];
    
}

@end
