//
//  CateBrandCateHeaderCell.m
//  XianMao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateBrandCateHeaderCell.h"
#import "Command.h"
#import "URLScheme.h"
#import "SearchViewController.h"

@interface CateBrandCateHeaderCell ()

@property (nonatomic, strong) CommandButton *titleBtn;

@end

@implementation CateBrandCateHeaderCell

-(CommandButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_titleBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleBtn.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
        _titleBtn.layer.borderWidth = 1.f;
    }
    return _titleBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([CateBrandCateHeaderCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 70.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(CateNewInfo *)cateInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[CateBrandCateHeaderCell class]];
    
    if (cateInfo) {
        [dict setObject:cateInfo forKey:@"cateInfo"];
    }
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleBtn];
        
        self.titleBtn.handleClickBlock = ^(CommandButton *sender){
            if (sender.cateInfo.redirect_uri != nil) {
                [URLScheme locateWithRedirectUri:sender.cateInfo.redirect_uri andIsShare:NO];
            } else {
                SearchViewController *searchVC = [[SearchViewController alloc] init];
                searchVC.searchKeywords = sender.cateInfo.categoryName;
                [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
            }
        };
    }
    return self;
}

-(void)layoutSubviews{
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@92);
        make.height.equalTo(@28);
    }];
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)//限制最大高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    CateNewInfo *cateInfo = dict[@"cateInfo"];
    self.titleBtn.cateInfo = cateInfo;
    [self.titleBtn setTitle:cateInfo.categoryName forState:UIControlStateNormal];
    [self.titleBtn setImage:[UIImage imageNamed:@"CateBrandRightJian"] forState:UIControlStateNormal];
    
    CGSize labelSize = [self sizeWithString:cateInfo.categoryName font:[UIFont systemFontOfSize:15.f]];
    
    CGFloat imageW = 10;
    CGFloat labelW = labelSize.width;
    
    self.titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelW, 0, -labelW);
    self.titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW);
}

@end
