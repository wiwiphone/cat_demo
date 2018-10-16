//
//  FollowsHeadView.m
//  XianMao
//
//  Created by 阿杜 on 16/8/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FollowsHeadView.h"

@interface FollowsHeadView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * searchTf;
@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation FollowsHeadView

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"search_wjh"];
    }
    return _imageView;
}

-(UITextField *)searchTf
{
    if (!_searchTf) {
        _searchTf = [[UITextField alloc] init];
        _searchTf.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
        _searchTf.layer.borderWidth = 1;
        _searchTf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 29)];
        _searchTf.leftViewMode = UITextFieldViewModeAlways;
        _searchTf.backgroundColor = [UIColor whiteColor];
        _searchTf.delegate = self;
    }
    return _searchTf;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self addSubview:self.searchTf];
        [self.searchTf addSubview:self.imageView];
    }
    return self;
}
-(void)getPlaceholderString:(BOOL)isFans
{
    _searchTf.placeholder = isFans?@"搜索我的粉丝":@"搜索我关注的";
    [_searchTf setValue:[UIColor colorWithHexString:@"bbbbbb"] forKeyPath:@"_placeholderLabel.textColor"];
    [_searchTf setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.SearchFunsOrFollows) {
        self.SearchFunsOrFollows(textField.text);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTf endEditing:YES];
    return YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.searchTf mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(29);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchTf.mas_centerY);
        make.left.equalTo(self.searchTf.mas_left).offset(10);
    }];
    
    
}

@end
