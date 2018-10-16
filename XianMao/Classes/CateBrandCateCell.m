//
//  CateBrandCateCell.m
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateBrandCateCell.h"
#import "Command.h"
#import "URLScheme.h"
#import "SearchViewController.h"

@interface CateBrandCateCell ()

@property (nonatomic, strong) CommandButton *cateBtn;
@property (nonatomic, strong) CommandButton *cateBtn2;

@end

@implementation CateBrandCateCell

-(CommandButton *)cateBtn2{
    if (!_cateBtn2) {
        _cateBtn2 = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_cateBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cateBtn2.titleLabel.font = [UIFont systemFontOfSize:17.f];
        _cateBtn2.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
    }
    return _cateBtn2;
}

-(CommandButton *)cateBtn{
    if (!_cateBtn) {
        _cateBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_cateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cateBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        _cateBtn.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
    }
    return _cateBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([CateBrandCateCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 70.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(CateNewInfo *)cateInfo andBCateNewInfo2:(CateNewInfo *)cateInfo2
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[CateBrandCateCell class]];
    if (cateInfo)[dict setObject:cateInfo forKey:[self cellDictKeyForTitle]];
    if (cateInfo2) {
        [dict setObject:cateInfo2 forKey:[self cellDictKeyForTitle1]];
    }
    return dict;
}

+ (NSString*)cellDictKeyForTitle {
    return @"cateInfo";
}

+ (NSString*)cellDictKeyForTitle1 {
    return @"cateInfo2";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.cateBtn];
        [self.contentView addSubview:self.cateBtn2];
        
        self.cateBtn.handleClickBlock = ^(CommandButton *sender){
            if (sender.cateInfo.redirect_uri != nil) {
                [URLScheme locateWithRedirectUri:sender.cateInfo.redirect_uri andIsShare:NO];
            } else {
                SearchViewController *searchVC = [[SearchViewController alloc] init];
                searchVC.searchKeywords = sender.cateInfo.categoryName;
                [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
            }
        };
        
        self.cateBtn2.handleClickBlock = ^(CommandButton *sender){
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
    [super layoutSubviews];
    
    [self.cateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_centerX).offset(-6);
    }];
    
    [self.cateBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_centerX).offset(6);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    CateNewInfo *cateInfo = dict[@"cateInfo"];
    CateNewInfo *cateInfo2 = dict[@"cateInfo2"];
    
    if (cateInfo) {
        self.cateBtn.hidden = NO;
        [self.cateBtn setTitle:cateInfo.categoryName forState:UIControlStateNormal];
        [self.cateBtn sd_setImageWithURL:[NSURL URLWithString:cateInfo.categoryBackImage] forState:UIControlStateNormal];
        self.cateBtn.cateInfo = cateInfo;
    } else {
        self.cateBtn.hidden = YES;
    }
    
    if (cateInfo2) {
        self.cateBtn2.hidden = NO;
        [self.cateBtn2 setTitle:cateInfo2.categoryName forState:UIControlStateNormal];
        [self.cateBtn2 sd_setImageWithURL:[NSURL URLWithString:cateInfo2.categoryBackImage] forState:UIControlStateNormal];
        self.cateBtn2.cateInfo = cateInfo2;
    } else {
        self.cateBtn2.hidden = YES;
    }
    
}

@end
