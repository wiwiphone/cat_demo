//
//  FollowsCell.m
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "FollowsTableViewCell.h"

#import "DataSources.h"
#import "User.h"

#import "CoordinatingController.h"
#import "Session.h"

@interface FollowsTableViewCell ()
@property(nonatomic,strong) XMWebImageView *avatarView;
@property(nonatomic,strong) UIButton *nickNameLbl;
@property(nonatomic,strong) UILabel *statLbl;
@property(nonatomic,strong) CALayer *bottomLine;
@property(nonatomic,strong) UIButton *followBtn;

@property(nonatomic,assign) NSInteger userId;
@end

@implementation FollowsTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([FollowsTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 72.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(User*)user
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[FollowsTableViewCell class]];
    if (user)[dict setObject:user forKey:[self cellKeyForFollowsUser]];
    return dict;
}

+ (NSString*)cellKeyForFollowsUser {
    return @"user";
}

- (void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = 42/2;
        self.avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        self.avatarView.clipsToBounds = YES;
        self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.avatarView];
        
        self.nickNameLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.nickNameLbl addTarget:self action:@selector(userHome:) forControlEvents:UIControlEventTouchUpInside];
        [self.nickNameLbl setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateDisabled];
        self.nickNameLbl.titleLabel.font = [UIFont systemFontOfSize:15.f];
        self.nickNameLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.nickNameLbl.enabled = NO;
        [self.contentView addSubview:self.nickNameLbl];
        
        self.statLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.statLbl.textColor = [UIColor colorWithHexString:@"B2B2B2"];
        self.statLbl.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:self.statLbl];

        UIImage *imageNormal = [UIImage imageWithColor:[UIColor colorWithHexString:@"333333"]];
        UIImage *imageSelected = [UIImage imageWithColor:[UIColor whiteColor]];
        self.followBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.followBtn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        self.followBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        self.followBtn.layer.masksToBounds = YES;
        self.followBtn.layer.borderWidth = 1.0f;
        self.followBtn.layer.cornerRadius = 2.f;
        self.followBtn.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitle:@"取消关注" forState:UIControlStateSelected];
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        [self.followBtn setBackgroundImage:[imageNormal stretchableImageWithLeftCapWidth:imageNormal.size.width/2 topCapHeight:imageNormal.size.height/2] forState:UIControlStateNormal];
        [self.followBtn setBackgroundImage:[imageSelected stretchableImageWithLeftCapWidth:imageSelected.size.width/2 topCapHeight:imageSelected.size.height/2] forState:UIControlStateSelected];
        [self.contentView addSubview:self.followBtn];
        
        self.bottomLine = [CALayer layer];
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:self.bottomLine];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.avatarView.frame = CGRectNull;
    self.nickNameLbl.frame = CGRectNull;
    self.statLbl.frame = CGRectNull;
    self.bottomLine.frame = CGRectNull;
    self.followBtn.frame = CGRectNull;
    self.followBtn.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginTop = 0.f;
    marginTop += 10.f;
    
    CGFloat marginLeft = 0;
    marginLeft += 15.f;
    
    self.avatarView.frame = CGRectMake(15, (self.contentView.bounds.size.height-42)/2, 42, 42);
    
    marginLeft += self.avatarView.bounds.size.width;
    marginLeft += 16.f;
    
    self.nickNameLbl.frame = CGRectMake(marginLeft, marginTop, self.contentView.bounds.size.width-75.f-marginLeft, 0);
    [self.nickNameLbl sizeToFit];
    self.nickNameLbl.frame = CGRectMake(marginLeft, marginTop, self.contentView.bounds.size.width-75.f-marginLeft, self.nickNameLbl.height);
    
    marginTop += self.nickNameLbl.height;
//    marginTop += 11.f;
    
    self.statLbl.frame = CGRectMake(marginLeft, marginTop, self.contentView.bounds.size.width-75.f-marginLeft, 0);
    [self.statLbl sizeToFit];
    self.statLbl.frame = CGRectMake(marginLeft, marginTop, self.contentView.bounds.size.width-75.f-marginLeft, self.statLbl.bounds.size.height);
    
    self.followBtn.frame = CGRectMake(self.contentView.bounds.size.width-10-74, (self.contentView.bounds.size.height-30)/2, 74, 29);
    
    self.bottomLine.frame = CGRectMake(72, self.contentView.bounds.size.height-1.f, self.contentView.bounds.size.width-72, 1);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    id obj = [dict objectForKey:[[self class] cellKeyForFollowsUser]];
    if ([obj isKindOfClass:[User class]]) {
        User *userInfo = (User*)obj;
        
//        [self.avatarView sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.avatarUrl] forState:UIControlStateNormal placeholderImage:[DataSources globalPlaceHolderSeller] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        }];
        
        [self.avatarView setImageWithURL:userInfo.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
        
        self.userId = userInfo.userId;
        
        [self.nickNameLbl setTitle:userInfo.userName forState:UIControlStateDisabled];
        
        self.statLbl.text = [NSString stringWithFormat:@"%ld 售出",(long)userInfo.soldNum];
        
        if ([Session sharedInstance].currentUserId==userInfo.userId) {
            self.followBtn.hidden = YES;
        } else {
            self.followBtn.hidden = NO;

            if (userInfo.isfollowing) {
                self.followBtn.selected = YES;
                [self.followBtn setTitle:@"取消关注" forState:UIControlStateSelected];
            } else {
                self.followBtn.selected = NO;
                if (userInfo.isfans) {
                    [self.followBtn setTitle:@"互相关注" forState:UIControlStateNormal];
                }else{
                    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
                }
            }
        }
        [self setNeedsLayout];
    }
}

- (void)userHome:(UIButton*)sender
{
    [[CoordinatingController sharedInstance] gotoUserHomeViewController:self.userId animated:YES];
}

- (void)follow:(UIButton*)sender
{
    if ([sender isSelected]) {
        [UserSingletonCommand unfollowUser:self.userId];
    } else {
        [UserSingletonCommand followUser:self.userId];
    }
}

@end


