//
//  OwnHomeHeaderView.m
//  XianMao
//
//  Created by WJH on 17/3/2.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "OwnHomeHeaderView.h"
#import "SignatureView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface OwnHomeHeaderView()

@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) XMWebImageView * headPortraitImageView;
@property (nonatomic, strong) SignatureView * signatureView;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * statLbl;
@property (nonatomic, strong) UserDetailInfo * userDetailInfo;

@end

@implementation OwnHomeHeaderView


- (XMWebImageView *)headPortraitImageView{
    if (!_headPortraitImageView) {
        _headPortraitImageView = [[XMWebImageView alloc] init];
        _headPortraitImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headPortraitImageView.layer.borderWidth = 1;
        _headPortraitImageView.layer.masksToBounds = YES;
        _headPortraitImageView.layer.cornerRadius = (kScreenWidth/375*58)/2;
    }
    return _headPortraitImageView;
}

- (SignatureView *)signatureView{
    if (!_signatureView) {
        _signatureView = [[SignatureView alloc] init];
    }
    return _signatureView;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.textColor = [UIColor whiteColor];
        _userName.font = [UIFont boldSystemFontOfSize:38];
        [_userName sizeToFit];
    }
    return _userName;
}

- (UILabel *)statLbl{
    if (!_statLbl) {
        _statLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _statLbl.textColor = [UIColor whiteColor];
        _statLbl.font = [UIFont boldSystemFontOfSize:14];
        [_statLbl sizeToFit];
    }
    return _statLbl;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -150, kScreenWidth, 300)];
        _headerImageView.image = [UIImage imageNamed:@"userHeaderBg"];
        _headerImageView.userInteractionEnabled = YES;
        
    }
    return _headerImageView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.headerImageView];
        [self addSubview:self.signatureView];
        [self.headerImageView addSubview:self.headPortraitImageView];
        [self.headerImageView addSubview:self.userName];
        [self.headerImageView addSubview:self.statLbl];
        
        WEAKSELF;
        _headPortraitImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            // 1.封装图片数据
            User *user = [Session sharedInstance].currentUser;
            if ([user.avatarUrl length]>0) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:weakSelf.userDetailInfo.userInfo.avatarUrl]; // 图片路径
                photo.srcImageView = weakSelf.headPortraitImageView; // 来源于哪个UIImageView
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
                [photos addObject:photo];
                
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.isHaveGoodsDetailBtn = YES;
                browser.photos = photos; // 设置所有的图片
                [browser show];
            }
        };
        
    }
    return self;
}

- (void)updateWithUserInfo:(UserDetailInfo *)userDetailInfo{
    
    if (userDetailInfo) {
        _userDetailInfo = userDetailInfo;
        [self.headPortraitImageView setImageWithURL:userDetailInfo.userInfo.avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"] XMWebImageScaleType:XMWebImageScale160x160];
        
        [self.signatureView getSignatureText:userDetailInfo.userInfo.summary];
        self.userName.text = userDetailInfo.userInfo.userName;
        self.statLbl.text = [NSString stringWithFormat:@"粉丝 %ld  已售出 %ld",(long)userDetailInfo.userInfo.fansNum,(long)userDetailInfo.userInfo.soldNum];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImageView.mas_bottom).offset(-20);
        make.right.equalTo(self.headerImageView.mas_right).offset(-26);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*58, kScreenWidth/375*58));
    }];
    
    [self.signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom);
        make.left.equalTo(self.headerImageView.mas_left);
        make.right.equalTo(self.headerImageView.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(70);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.headPortraitImageView.mas_left).offset(-10);
    }];
    
    
    [self.statLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.headPortraitImageView.mas_left).offset(-10);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
    }];
}

+ (CGFloat)heightForOrientationPortrait:(User*)userInfo {

    NSString *str = @"这家伙很懒，什么都没有留下～";
    if ([userInfo.summary length]>0) {
        str = userInfo.summary;
    }
    NSDictionary *Tdic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil];
    CGRect  rect  = [str boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    return 150.f+rect.size.height+40;
}

@end
