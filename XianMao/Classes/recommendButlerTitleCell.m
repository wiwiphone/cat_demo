//
//  recommendButlerTitleCell.m
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "recommendButlerTitleCell.h"
#import "Masonry.h"

@interface recommendButlerTitleCell ()

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation recommendButlerTitleCell

-(UIView *)leftLineView{
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftLineView.backgroundColor = [UIColor colorWithHexString:@"cacccd"];
    }
    return _leftLineView;
}

-(UIView *)rightLineView{
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightLineView.backgroundColor = [UIColor colorWithHexString:@"cacccd"];
    }
    return _rightLineView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        _titleLbl.text = @"拿不定主意？我们帮您推荐";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([recommendButlerTitleCell class]);
    });
    return __reuseIdentifier;
}
+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 45;
    return rowHeight;
}
+ (NSMutableDictionary*)buildCellDict;
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[recommendButlerTitleCell class]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.leftLineView];
        [self.contentView addSubview:self.rightLineView];
        [self.contentView addSubview:self.titleLbl];
        
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(17);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.right.equalTo(self.titleLbl.mas_left).offset(-11);
        make.left.equalTo(self.contentView.mas_left).offset(35);
        make.height.equalTo(@1);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(-11);
        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.height.equalTo(@1);
    }];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
