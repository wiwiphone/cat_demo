//
//  BrandNewCell.m
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BrandNewCell.h"
#import "CateHotButton.h"
#import "Masonry.h"
#import "DataSources.h"
#import "SearchViewController.h"
#import "URLScheme.h"

@interface BrandNewCell ()

@property (nonatomic, strong) CateHotButton *leftButton;
@property (nonatomic, strong) CateHotButton *rightButton;

@property (nonatomic, strong) XMWebImageView *leftImageView;
@property (nonatomic, strong) XMWebImageView *rightImageView;

@end

@implementation BrandNewCell

-(XMWebImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _rightImageView.clipsToBounds = YES;
    }
    return _rightImageView;
}

-(XMWebImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _leftImageView.userInteractionEnabled = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _leftImageView.clipsToBounds = YES;
    }
    return _leftImageView;
}

-(CateHotButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [[CateHotButton alloc] initWithFrame:CGRectZero];
        _leftButton.backgroundColor = [UIColor redColor];
    }
    return _leftButton;
}

-(CateHotButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [[CateHotButton alloc] initWithFrame:CGRectZero];
        _rightButton.backgroundColor = [UIColor orangeColor];
    }
    return _rightButton;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BrandNewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 104.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(BrandVO *)brandVO andBrandVO2:(BrandVO *)BrandVO2
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BrandNewCell class]];
    if (brandVO)[dict setObject:brandVO forKey:[self cellDictKeyForTitle]];
    if (BrandVO2) {
        [dict setObject:BrandVO2 forKey:[self cellDictKeyForTitle1]];
    }
    return dict;
}

+ (NSString*)cellDictKeyForTitle {
    return @"brand";
}

+ (NSString*)cellDictKeyForTitle1 {
    return @"brand1";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.contentView addSubview:self.leftButton];
//        [self.contentView addSubview:self.rightButton];
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.rightImageView];
        
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.leftImageView.mas_right);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    BrandVO *brandLeft = dict[@"brand"];
    BrandVO *brandRight = dict[@"brand1"];
    if (brandLeft) {
        self.leftImageView.hidden = NO;
        [self.leftImageView setImageWithURL:brandLeft.brandBgPic XMWebImageScaleType:XMWebImageScale480x480];
    } else {
        self.leftImageView.hidden = YES;
    }
    
    if (brandRight) {
        self.rightImageView.hidden = NO;
        [self.rightImageView setImageWithURL:brandRight.brandBgPic XMWebImageScaleType:XMWebImageScale480x480];
    } else {
        self.rightImageView.hidden = YES;
    }
    
    self.leftImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
        
        if (brandLeft.redirect_uri != nil) {
            [URLScheme locateWithRedirectUri:brandLeft.redirect_uri andIsShare:NO];
        } else {
            SearchViewController *searchVC = [[SearchViewController alloc] init];
            searchVC.searchKeywords = brandLeft.brandName;
            [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
        }
    };
    
    self.rightImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
        if (brandRight.redirect_uri != nil) {
            [URLScheme locateWithRedirectUri:brandRight.redirect_uri andIsShare:NO];
        } else {
            SearchViewController *searchVC = [[SearchViewController alloc] init];
            searchVC.searchKeywords = brandRight.brandName;
            [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
        }
    };
}

@end
