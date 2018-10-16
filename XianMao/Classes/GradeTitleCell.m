//
//  GradeTitleCell.m
//  yuncangcat
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GradeTitleCell.h"
#import "XMWebImageView.h"

@interface GradeTitleCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *chooseImageView;

@end

@implementation GradeTitleCell

-(UIImageView *)chooseImageView{
    if (!_chooseImageView) {
        _chooseImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _chooseImageView.image = [UIImage imageNamed:@"Publish_IsHasChoose"];
        [_chooseImageView sizeToFit];
    }
    return _chooseImageView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"ffffff"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GradeTitleCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 42.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)data andGrade:(NSString *)grade
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GradeTitleCell class]];
    if (data) {
        [dict setObject:data forKey:@"title"];
    }
    if (grade) {
        [dict setObject:grade forKey:@"grade"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"434342"];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.chooseImageView];
        self.chooseImageView.hidden = YES;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSString *title = dict[@"title"];
    NSString *grade = dict[@"grade"];
    self.titleLbl.text = title;
    if ([grade isEqualToString:title]) {
        self.chooseImageView.hidden = NO;
    } else {
        self.chooseImageView.hidden = YES;
    }
}

@end
