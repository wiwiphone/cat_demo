//
//  GoodsTableViewCell.m
//  XianMao
//
//  Created by simon cai on 11/9/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "DataSources.h"

#import "GoodsInfo.h"
#import "User.h"

#import "CoordinatingController.h"

#import "Session.h"
#import "Command.h"
#import "UIButton+VerticalLayout.h"
#import "GoodsMemCache.h"
#import "URLScheme.h"
#import "NetworkAPI.h"

#import "NSString+Addtions.h"

@interface GoodsTableViewCell ()

@property(nonatomic,strong) GoodsSellerInfoView *sellerInfoView;
@property(nonatomic,strong) XMWebImageView *coverView;
@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) GoodsApproveTagsView *tagView;
@property(nonatomic,strong) UILabel *summaryLbl;
@property(nonatomic,strong) GoodsPricesView *pricesView;
@property(nonatomic,strong) GoodsLikedUsersView *likedUsersView;
@property(nonatomic,strong) GoodsActionButtonsView *actionButtonsView;

@property(nonatomic,assign) BOOL isConsignment;

@property(nonatomic,copy) NSString *goodsId;

@end

@implementation GoodsTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    NSObject *obj = [dict objectForKey:[self cellDictKeyForGoodsInfo]];
    if ([obj isKindOfClass:[GoodsInfo class]]) {
        GoodsInfo *item = (GoodsInfo*)obj;
        height = [GoodsTableViewCell calculateHeightAndLayoutSubviews:nil item:item];
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"item";
}

- (void)dealloc
{
    self.sellerInfoView = nil;
    self.coverView = nil;
    self.nameLbl = nil;
    self.tagView = nil;
    self.summaryLbl = nil;
    self.pricesView = nil;
    self.likedUsersView = nil;
    self.actionButtonsView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.sellerInfoView = [[GoodsSellerInfoView alloc] initWithFrame:CGRectNull];
        self.sellerInfoView.backgroundColor = [UIColor whiteColor];
//        self.sellerInfoView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.sellerInfoView];
        
        self.coverView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        self.coverView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        self.coverView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverView];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.nameLbl.textColor = [DataSources goodsNameTextColor];
        self.nameLbl.font = [DataSources goodsNameTextFont];
        self.nameLbl.numberOfLines = 0;
        [self.contentView addSubview:self.nameLbl];
        
        self.tagView = [[GoodsApproveTagsView alloc] initWithFrame:CGRectNull];
        self.tagView.hidden = YES;
        self.tagView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tagView];
        
        self.summaryLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.summaryLbl.textColor = [DataSources goodsSummaryTextColor];
        self.summaryLbl.font = [DataSources goodsSummaryTextFont];
        self.summaryLbl.numberOfLines = 0;
        [self.contentView addSubview:self.summaryLbl];
        
        self.pricesView = [[GoodsPricesView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:self.pricesView];
        
        self.likedUsersView = [[GoodsLikedUsersView alloc] initWithFrame:CGRectNull];
        self.likedUsersView.hidden = YES;
        self.likedUsersView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.likedUsersView];
        
        self.actionButtonsView = [[GoodsActionButtonsView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:self.actionButtonsView];
    }
    return self;
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(GoodsTableViewCell*)cell item:(GoodsInfo*)item
{
    CGFloat marginTop = 0.f;
    
    marginTop += 15.f;
    
    ///
    if (cell) {
        cell.sellerInfoView.frame = CGRectMake(0.f, marginTop, CGRectGetWidth(cell.contentView.bounds), [GoodsSellerInfoView heightForOrientationPortrait]);
    }
    marginTop += [GoodsSellerInfoView heightForOrientationPortrait];
    
    marginTop += 15.f;
    
    if (cell) {
        cell.coverView.frame = CGRectMake(0.f, marginTop, kScreenWidth, kScreenWidth);
    }
    marginTop += kScreenWidth;
    
    
    ///
    if (item && [item.goodsName length]>0) {
        CGSize goodsNameSize = [item.goodsName sizeWithFont:[DataSources goodsNameTextFont]
                                          constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                              lineBreakMode:NSLineBreakByWordWrapping];
        
        marginTop += 18.f;
        marginTop += goodsNameSize.height;
    }
    else if (cell && [cell.nameLbl.text length]>0) {
        
        CGSize goodsNameSize = [cell.nameLbl.text sizeWithFont:[DataSources goodsNameTextFont]
                                             constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                                 lineBreakMode:NSLineBreakByWordWrapping];
        marginTop += 18.f;
        cell.nameLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, goodsNameSize.height);
        marginTop += cell.nameLbl.height;
    }
    
    ///
    if (item && [item approveTagsCount]>0) {
        marginTop += 15;
        marginTop += [GoodsApproveTagsView heightForOrientationPortrait:item showTitle:NO];
    }
    else if (cell && !cell.tagView.hidden) {
        marginTop += 15;
        cell.tagView.frame = CGRectMake(0.f, marginTop, CGRectGetWidth(cell.contentView.bounds), cell.tagView.height);
        marginTop += cell.tagView.height;
    }
    
    
    ///
    if (cell && [cell.summaryLbl.text length]>0) {
        marginTop += 15;
        cell.summaryLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, 0);
        [cell.summaryLbl sizeToFit];
        cell.summaryLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, cell.summaryLbl.height);
        marginTop += cell.summaryLbl.height;
    } else if ([item.summary length]>0) {
        marginTop += 15;
        CGSize goodsSummarySize = [item.summary sizeWithFont:[DataSources goodsSummaryTextFont]
                                           constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                               lineBreakMode:NSLineBreakByWordWrapping];
        marginTop += goodsSummarySize.height;
        
    }
    
    ///
    marginTop += 18;
    if (cell) {
        cell.pricesView.frame = CGRectMake(0, marginTop, CGRectGetWidth(cell.contentView.bounds), [GoodsPricesView heightForOrientationPortrait]);
    }
    marginTop += [GoodsPricesView heightForOrientationPortrait];
    marginTop += 20;
    
//    ///
//    if (cell && !cell.likedUsersView.hidden) {
//        cell.likedUsersView.frame = CGRectMake(0, marginTop, CGRectGetWidth(cell.contentView.bounds), [GoodsLikedUsersView heightForOrientationPortrait]);
//        marginTop += cell.likedUsersView.height;
//        marginTop += 5;
//    } else if (item && [item likes].totalNum>0 && [[item likes].users count]>0) {
//        marginTop += [GoodsLikedUsersView heightForOrientationPortrait];
//        marginTop += 5;
//    }
    
    ///
    if (cell) {
        cell.actionButtonsView.frame = CGRectMake(0, marginTop, CGRectGetWidth(cell.contentView.bounds), [GoodsActionButtonsView heightForOrientationPortrait]);
    }
    marginTop += [GoodsActionButtonsView heightForOrientationPortrait];
    
    ///
    marginTop += 7;
    
    return marginTop;
}

- (void)prepareForReuse {
    self.sellerInfoView.frame = CGRectNull;
    [self.coverView.layer removeAllAnimations];
    self.coverView.frame = CGRectNull;
    self.nameLbl.text = nil;
    self.nameLbl.frame = CGRectNull;
    self.tagView.frame = CGRectNull;
    self.tagView.hidden = YES;
    self.summaryLbl.text = nil;
    self.summaryLbl.frame = CGRectNull;
    self.pricesView.frame = CGRectNull;
    self.likedUsersView.frame = CGRectNull;
    self.likedUsersView.hidden = YES;
    self.actionButtonsView.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self class] calculateHeightAndLayoutSubviews:self item:nil];
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    NSObject *obj = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if ([obj isKindOfClass:[GoodsInfo class]]) {
        GoodsInfo *goodsInfo = (GoodsInfo*)obj;
        
        self.goodsId = goodsInfo.goodsId;
        
        [self.sellerInfoView updateWithGoodsInfo:goodsInfo];
        //为适配iPhone6 和 plus 把图片尺寸设为750x750
        [self.coverView setImageWithURL:goodsInfo.mainPicUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        self.nameLbl.text = goodsInfo.goodsName;
        self.summaryLbl.text = goodsInfo.summary;
        
        [self.pricesView updateWithGoodsInfo:goodsInfo];
        
        self.tagView.hidden =[goodsInfo approveTagsCount]>0?NO:YES;
        [self.tagView updateWithGoodsInfo:goodsInfo showTitle:NO];
//        self.likedUsersView.hidden = [goodsInfo likes].totalNum>0&&[[goodsInfo likes].users count]>0?NO:YES;
//        [self.likedUsersView updateWithGoodsInfo:goodsInfo];
        
        [self.actionButtonsView updateWithGoodsInfo:goodsInfo withTitleAndNum:YES];
        
        [self setNeedsLayout];
    }
}


@end


//=============

@interface GoodsSellerInfoView ()

@property(nonatomic,retain) XMWebImageView *avatarView;
@property(nonatomic,retain) UIButton *nickNameLbl;
@property(nonatomic,retain) UIButton *timestampLbl;
@property(nonatomic,strong) UILabel *statLbl;
@property(nonatomic,retain) CommandButton *chatBtn;

@property(nonatomic,assign) NSInteger sellerId;
@property(nonatomic,copy) NSString *goodsId;

@property(nonatomic,strong) SellerTagsView *tagsView;

@end


@implementation GoodsSellerInfoView

+ (CGFloat)heightForOrientationPortrait {
    return 42.f;
}

- (void)dealloc
{
    self.avatarView = nil;
    self.nickNameLbl = nil;
    self.timestampLbl = nil;
    self.chatBtn = nil;
    self.statLbl = nil;
}

- (id)initWithFrame:(CGRect)frame showChatBtn:(BOOL)showChatBtn {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.avatarView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        self.avatarView.layer.masksToBounds=YES;
        self.avatarView.layer.cornerRadius=21;    //最重要的是这个地方要设成imgview高的一半
        self.avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarView.clipsToBounds = YES;
        [self addSubview:self.avatarView];
        
        self.nickNameLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        self.nickNameLbl.backgroundColor = [UIColor clearColor];
        [self.nickNameLbl setTitleColor:[DataSources feedsUserNickNameTextColor] forState:UIControlStateDisabled];
        self.nickNameLbl.titleLabel.font = [DataSources feedsUserNickNameTextFont];
        self.nickNameLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.nickNameLbl.enabled = NO;
        [self addSubview:self.nickNameLbl];
        
        _statLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _statLbl.font = [UIFont systemFontOfSize:12.f];
        _statLbl.textColor = [UIColor colorWithHexString:@"BBBBBB"];
        [self addSubview:_statLbl];
        
        self.timestampLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        self.timestampLbl.backgroundColor = [UIColor clearColor];
        [self.timestampLbl setTitleColor:[DataSources goodsOnSaleTimeTextColor] forState:UIControlStateDisabled];
        self.timestampLbl.titleLabel.font = [DataSources goodsOnSaleTimeTextFont];
        [self.timestampLbl setImage:[DataSources goodsOnSaleTimeImg] forState:UIControlStateDisabled];
        [self.timestampLbl setTitleEdgeInsets: UIEdgeInsetsMake(0, 5, 0, 0)];
        self.timestampLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.timestampLbl.enabled = NO;
        [self addSubview:self.timestampLbl];
        
        if (showChatBtn) {
            self.chatBtn = [[CommandButton alloc] initWithFrame:CGRectNull];
           // self.chatBtn.backgroundColor = [UIColor colorWithHexString:@"ff5858"];
            [self.chatBtn setBackgroundImage:[[UIImage imageNamed: @"btn_chat_big"] resizableImageWithCapInsets:UIEdgeInsetsMake(17,17,17,17) ] forState:UIControlStateNormal];
            self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            [self.chatBtn setTitleColor:[UIColor colorWithHexString:@"c7af7a"] forState:UIControlStateNormal];
            [self.chatBtn setTitle:@"聊  天" forState:UIControlStateNormal];
            self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [self addSubview:self.chatBtn];
            
            self.chatBtn.layer.masksToBounds=YES;
            self.chatBtn.layer.cornerRadius=30/2; //最重要的是这个地方要设成imgview高的一半
            
            WEAKSELF;
            self.chatBtn.handleClickBlock = ^(CommandButton *sender) {
                [MobClick event:@"click_chat_from_detail"];
                //[UserSingletonCommand chatWithUser:weakSelf.sellerId];
                [UserSingletonCommand chatBalance:weakSelf.goodsId];
            };
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame showChatBtn:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginLeft = 0.f;
    self.avatarView.frame = CGRectMake(15, (CGRectGetHeight(self.bounds)-42)/2, 42, 42);
    marginLeft += (self.avatarView.frame.origin.x+CGRectGetWidth(self.avatarView.bounds));
    marginLeft += 10;
    

    CGFloat marginRight = 15.f;
    if (self.chatBtn) {
        self.chatBtn.frame = CGRectMake(self.bounds.size.width-marginRight-80, (self.bounds.size.height-35)/2, 80, 35);
        marginRight += self.chatBtn.bounds.size.width;
        marginRight += 10.f;
    }
    
    CGFloat marginTop = 0.f;
    marginTop += 3.f;
    
    CGSize nickNameLblSize = [[self.nickNameLbl titleForState:UIControlStateDisabled] sizeWithFont:self.nickNameLbl.titleLabel.font constrainedToSize:CGSizeMake(kScreenWidth,MAXFLOAT)];
    
    self.nickNameLbl.frame = CGRectMake(marginLeft, marginTop, nickNameLblSize.width, nickNameLblSize.height);
    _tagsView.frame = CGRectMake(self.nickNameLbl.right+8, self.nickNameLbl.top+(nickNameLblSize.height-_tagsView.height)/2, _tagsView.width, _tagsView.height);
    
    if (_tagsView.right+15>kScreenWidth) {
        _tagsView.frame = CGRectMake(kScreenWidth-15-_tagsView.width, self.nickNameLbl.top+(nickNameLblSize.height-_tagsView.height)/2, _tagsView.width, _tagsView.height);
        self.nickNameLbl.frame = CGRectMake(marginLeft, marginTop, _tagsView.left-8-marginLeft, nickNameLblSize.height);
    }

    marginTop += CGRectGetHeight(self.nickNameLbl.bounds);
    marginTop += 8;
    
    
    _statLbl.frame = CGRectMake(marginLeft, marginTop, CGRectGetWidth(self.bounds)-marginRight-marginLeft, 0);
    [_statLbl sizeToFit];
    _statLbl.frame = CGRectMake(marginLeft, marginTop, CGRectGetWidth(self.bounds)-marginRight-marginLeft, _statLbl.height);
    
   self.timestampLbl.frame = CGRectMake(marginLeft, marginTop, CGRectGetWidth(self.bounds)-marginRight-marginLeft, 0);
    [self.timestampLbl sizeToFit];
    self.timestampLbl.frame = CGRectMake(marginLeft, marginTop, CGRectGetWidth(self.bounds)-marginRight-marginLeft, CGRectGetHeight(self.timestampLbl.bounds));
    
    //self.backgroundColor = [UIColor orangeColor];
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo {
    
    self.sellerId = goodsInfo.seller.userId;
    self.goodsId = goodsInfo.goodsId;
    
    if (goodsInfo.serviceType == 1) {
        [self.chatBtn setTitle:@"咨询客服" forState:UIControlStateNormal] ;
    } else {
        [self.chatBtn setTitle: @"联系卖家" forState:UIControlStateNormal];
    }
    
    [self.nickNameLbl setTitle:[goodsInfo seller].userName forState:UIControlStateDisabled];
    self.timestampLbl.hidden = NO;
    [self.timestampLbl setTitle:[GoodsInfo formattedDateDescription:goodsInfo.modifyTime] forState:UIControlStateDisabled];
    
//    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[goodsInfo seller].avatarUrl] placeholderImage:[DataSources globalPlaceHolderSeller] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//    }];
    
    [self.avatarView setImageWithURL:[goodsInfo seller].avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
    
    //self.frame = CGRectMake(0, 0, kScreenWidth, [[self class] heightForOrientationPortrait]);
    
    if (self.sellerId == [Session sharedInstance].currentUserId) {
        self.chatBtn.hidden = YES;
    }
    
    
    [self setNeedsLayout];
}

- (void)updateWithSellerInfo:(User*)seller {
    self.sellerId = seller.userId;
    
    [self.nickNameLbl setTitle:seller.userName forState:UIControlStateDisabled];
    
//    if ([seller isAuthSeller]) {
//        UIImage *verifiedIcon = [UIImage imageNamed:@"seller_tag_verified_small"];
//        
//        [self.nickNameLbl setImage:verifiedIcon forState:UIControlStateDisabled];
//        
//        CGSize nickNameLblSize = [seller.userName sizeWithFont:[DataSources feedsUserNickNameTextFont] constrainedToSize:CGSizeMake(self.nickNameLbl.width,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        [self.nickNameLbl setImageEdgeInsets:UIEdgeInsetsMake(0, nickNameLblSize.width-verifiedIcon.size.width+18, 0, 0)];
//        [self.nickNameLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, -verifiedIcon.size.width, 0, 0)];
//    } else {
//        [self.nickNameLbl setImage:nil forState:UIControlStateDisabled];
//        [self.nickNameLbl setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self.nickNameLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
    
    
    if ([Session sharedInstance].isLoggedIn && [Session sharedInstance].currentUserId==seller.userId) {
        [self.avatarView setImageWithURL:[Session sharedInstance].currentUser.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
    } else {
        [self.avatarView setImageWithURL:seller.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
    }
    
    self.timestampLbl.hidden = YES;
    self.chatBtn.hidden = YES;
    
    _statLbl.text = [NSString stringWithFormat:@"粉丝 %ld  商品 %ld  成交 %ld",(long)seller.fansNum,(long)seller.goodsNum,(long)seller.soldNum];
    
    
    if ([seller.authTags count]>0) {
        if (!_tagsView) {
            _tagsView = [[SellerTagsView alloc] initWithFrame:CGRectMake(0, 0, [SellerTagsView widthForOrientationPortrait:seller.authTags showTitle:NO], [SellerTagsView heightForOrientationPortrait:seller.authTags showTitle:NO])];
            [self addSubview:_tagsView];
        } else {
            _tagsView.frame = CGRectMake(0, 0, [SellerTagsView widthForOrientationPortrait:seller.authTags showTitle:NO], [SellerTagsView heightForOrientationPortrait:seller.authTags showTitle:NO]);
        }
        [_tagsView updateWithUserInfo:seller.authTags showTitle:NO];
        _tagsView.hidden = NO;
    } else {
        _tagsView.hidden = YES;
    }
    
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    self.timestampLbl.hidden = YES;
    self.chatBtn.hidden = YES;
    self.avatarView.image = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
    [MobClick event:@"click_person_from_feeds"];
    [[CoordinatingController sharedInstance] gotoUserHomeViewController:self.sellerId animated:YES];
}

@end


@interface GoodsSellerInfoViewForGoodsDetail ()
@property(nonatomic,strong) CommandButton *followBtn;
@end

@implementation GoodsSellerInfoViewForGoodsDetail

- (id)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *imageNormal = [UIImage imageNamed:@"Pay_New_N"];//[UIImage imageWithColor:[UIColor colorWithHexString:@"e2bb66"]];
        UIImage *imageSelected = [UIImage imageNamed:@"Pay_New_S"];//[UIImage imageWithColor:[UIColor whiteColor]];
        self.followBtn = [[CommandButton alloc] initWithFrame:CGRectNull];
//        self.followBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
//        self.followBtn.layer.masksToBounds = YES;
//        self.followBtn.layer.borderWidth = 1.0f;
//        self.followBtn.layer.cornerRadius = 5.f;
//        self.followBtn.layer.borderColor = [UIColor colorWithHexString:@"e2bb66"].CGColor;
//        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
//        [self.followBtn setTitle:@"取消关注" forState:UIControlStateSelected];
//        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.followBtn setTitleColor:[UIColor colorWithHexString:@"C7AF7A"] forState:UIControlStateSelected];
        [self.followBtn setBackgroundImage:[imageNormal stretchableImageWithLeftCapWidth:imageNormal.size.width/2 topCapHeight:imageNormal.size.height/2] forState:UIControlStateNormal];
        [self.followBtn setBackgroundImage:[imageSelected stretchableImageWithLeftCapWidth:imageSelected.size.width/2 topCapHeight:imageSelected.size.height/2] forState:UIControlStateSelected];
        [self addSubview:self.followBtn];
        
        
        WEAKSELF;
        _followBtn.handleClickBlock = ^(CommandButton *sender) {
            if ([sender isSelected]) {
                [UserSingletonCommand unfollowUser:weakSelf.sellerId];
            } else {
                [UserSingletonCommand followUser:weakSelf.sellerId];
            }
            
            [MobClick event:@"click_follow_from_detail"];
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.followBtn.frame = CGRectMake(self.width-15-43, 0, 47, 18);

}

- (void)updateWithSellerInfo:(User*)seller {
    [super updateWithSellerInfo:seller];
    self.followBtn.selected=!seller.isfollowing;
    
    if ([Session sharedInstance].currentUserId==seller.userId) {
        self.followBtn.hidden = YES;
    } else {
        self.followBtn.hidden = NO;
        
        if (seller.isfollowing) {
            self.followBtn.selected = YES;
//            if (seller.isfans) {
//                [self.followBtn setTitle:@"互相关注" forState:UIControlStateSelected];
//            } else {
//                [self.followBtn setTitle:@"取消关注" forState:UIControlStateSelected];
//            }
        } else {
            self.followBtn.selected = NO;
//            [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
    }
    
    [self setNeedsLayout];
}

- (void)handleSingleTap:(UITouch *)touch {
    [MobClick event:@"click_seller_from_detail"];
    [[CoordinatingController sharedInstance] gotoUserHomeViewController:self.sellerId animated:YES];
}

@end

@implementation SellerTagsView

+ (CGFloat)widthForOrientationPortrait:(NSArray*)tags showTitle:(BOOL)showTitle {
    CGFloat maxWidth = 0.f;
    if (showTitle) {
        if ([tags count]>0) {
            CGFloat X = 0.f;
            CGFloat Y = 0.f;
            for (NSInteger i=0;i<[tags count];i++) {
                UserTagInfo *tag = [tags objectAtIndex:i];
                
                CGFloat btnWidth = 0;
                NSString *name = tag.name;
                CGSize nameSize = [name sizeWithFont:[DataSources goodsTagTextFont]
                                   constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
                
                btnWidth += nameSize.width;
                
                btnWidth += 14.f;
                btnWidth += 10.f; //TitleEdgeInsets.Left
                
                if (btnWidth >0) {
                    if (X+btnWidth>kScreenWidth-30) {
                        X = 0.f;
                        Y += 14.f;
                        Y += 9.5f;
                        maxWidth = kScreenWidth-30;
                    }
                    if (X>0) {
                        X += 18.f;
                    }
                    X += btnWidth;
                }
            }
            if (maxWidth==0) {
                maxWidth = X;
            }
            return maxWidth;//;
        }
    } else {
        if ([tags count]>0) {
            CGFloat X = 0.f;
            CGFloat Y = 0.f;
            for (NSInteger i=0;i<[tags count];i++) {
                
                CGFloat btnWidth = 0;
                
                btnWidth += 14.f;
                
                if (X+btnWidth>kScreenWidth-30) {
                    X = 0.f;
                    Y += 14.f;
                    Y += 9.5f;
                    maxWidth = kScreenWidth-30;
                }
                if (btnWidth>0) {
                    if (X>0) {
                        X += 5.f;
                    }
                    X += btnWidth;
                }
            }
            if (maxWidth==0) {
                maxWidth = X;
            }
            return maxWidth;//;
        }
    }
    return 0.f;
}
+ (CGFloat)heightForOrientationPortrait:(NSArray*)tags showTitle:(BOOL)showTitle {
    NSLog(@"%@", tags);
    if (showTitle) {
        if ([tags count]>0) {
            CGFloat X = 0.f;
            CGFloat Y = 0.f;
            for (NSInteger i=0;i<[tags count];i++) {
                UserTagInfo *tag = [tags objectAtIndex:i];
                
                CGFloat btnWidth = 0;
                NSString *name = tag.name;
                CGSize nameSize = [name sizeWithFont:[DataSources goodsTagTextFont]
                                   constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
                
                btnWidth += nameSize.width;
                
                btnWidth += 14.f;
                btnWidth += 10.f; //TitleEdgeInsets.Left
                
                if (btnWidth >0) {
                    if (X+btnWidth>kScreenWidth-30) {
                        X = 0.f;
//                        Y += 14.f;
                        Y += 30.f;
                        Y += 9.5f;
                    }
                    X += btnWidth;
                    X += 18.f;
                }
            }
//            return Y+14.f;//;
            return Y + 30.f;
        }
    } else {
        if ([tags count]>0) {
            CGFloat X = 0.f;
            CGFloat Y = 0.f;
            for (NSInteger i=0;i<[tags count];i++) {
                
                CGFloat btnWidth = 0;
                
                btnWidth += 14.f;
                
                if (X+btnWidth>kScreenWidth-30) {
                    X = 0.f;
//                    Y += 14.f;
                    Y += 30.f;
                    Y += 9.5f;
                }
                if (btnWidth>0) {
                    X += btnWidth;
                    X += 5.f;
                }
            }
//            return Y+14.f;//;
            return Y + 30.f;
        }
    }
    return 0.f;
}
- (void)updateWithUserInfo:(NSArray*)tags showTitle:(BOOL)showTitle
{
    
    NSInteger count = [self.subviews count];
    for (NSInteger i=count;i<[tags count];i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectNull];
        [self addSubview:btn];
        [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 10.f, 0, 0)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.backgroundColor = [UIColor clearColor];
        btn.enabled = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    }
    
    for (NSInteger i=[tags count];i<[tags count];i++) {
        UIButton *btn = (UIButton*)[self.subviews objectAtIndex:i];
        btn.hidden = YES;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0, 0)];
    }
    
    if (showTitle) {
        CGFloat X = 0.f;
        CGFloat Y = 0.f;
        
        for (NSInteger i=0;i<[tags count];i++) {
            UserTagInfo *tag = [tags objectAtIndex:i];
            UIButton *btn = (UIButton*)[self.subviews objectAtIndex:i];
        
            
            NSString *name = tag.name;
            CGSize nameSize = [name sizeWithFont:[DataSources goodsTagTextFont]
                               constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                   lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat btnWidth = nameSize.width;
            
            [btn setImage:tag.icon forState:UIControlStateDisabled];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 8, 0, 0)];
            
            btnWidth += 14.f;
            btnWidth += 8.f; //TitleEdgeInsets.Left
            
            [btn setTitle:tag.name forState:UIControlStateDisabled];
            
            if (btnWidth > 0) {
                btn.hidden = NO;
                if (X+btnWidth>kScreenWidth-30) {
                    X = 0.f;
                    Y += 14.f;
                    Y += 9.5f;
                    btn.frame = CGRectMake(X, Y, btnWidth, 14.f);
                } else {
                    btn.frame = CGRectMake(X, Y, btnWidth, 14.f);
                }
                X += btnWidth;
                X += 18.f;
            }
        }
        
        self.frame = CGRectMake(0, 0, self.width, Y+14.f);
    } else {
        CGFloat X = 0.f;
        CGFloat Y = 0.f;
        
        for (NSInteger i=0;i<[tags count];i++) {
            UserTagInfo *tag = [tags objectAtIndex:i];
//            UIButton *btn = (UIButton*)[self.subviews objectAtIndex:i];
            UIButton *btn = [[UIButton alloc] init];
            [self addSubview:btn];
            
//            btn.backgroundColor = [UIColor brownColor];
            
            CGFloat btnWidth = 0;
            
            [btn setImage:tag.icon forState:UIControlStateNormal];
//            btnWidth += 14.f;
            btnWidth += 30;
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 0.f, 0, 0)];
            
            if (btnWidth > 0) {
                btn.hidden = NO;
                if (X+btn.width>kScreenWidth-30) {
                    X = 0.f;
                    Y += 14.f;
                    Y += 9.5f;
//                    btn.frame = CGRectMake(X, Y, btnWidth, 14.f);
                    btn.frame = CGRectMake(X, Y, btnWidth, 30.f);
                } else {
//                    btn.frame = CGRectMake(X, Y, btnWidth, 14.f);
                    btn.frame = CGRectMake(X, Y, btnWidth, 30.f);
                }
                X += btn.width;
                X += 5.f;
            }
        }
//        self.frame = CGRectMake(0, 0, self.width, Y+14.f);
        self.frame = CGRectMake(0, 0, self.width, Y + 30.f);
        //
        
    }
}

@end

@implementation GoodsApproveTagsView

+ (CGFloat)heightForOrientationPortrait:(GoodsInfo*)goodsInfo  {
    return [self heightForOrientationPortrait:goodsInfo showTitle:YES];
}

+ (CGFloat)heightForOrientationPortrait:(GoodsInfo*)goodsInfo showTitle:(BOOL)showTitle {
    if (showTitle) {
        NSArray *tags = [goodsInfo approveTags];
        if ([tags count]>0) {
            CGFloat X = 0.f;
            CGFloat Y = 0.f;
            for (NSInteger i=0;i<[tags count];i++) {
                ApproveTagInfo *tag = [tags objectAtIndex:i];

                CGFloat btnWidth = 0;
                NSString *name = tag.name;
                CGSize nameSize = [name sizeWithFont:[DataSources goodsTagTextFont]
                                   constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
                
                btnWidth += nameSize.width;
                
                if ([tag.iconUrl length]>0 || tag.localTagIcon!=nil) {
                    btnWidth += 22.f;
                    btnWidth += 10.f; //TitleEdgeInsets.Left
                }
                
                if (btnWidth >0) {
                    if (X+btnWidth>kScreenWidth-30) {
                        X = 0.f;
                        Y += 17.f;
                        Y += 9.5f;
                    }
                    X += btnWidth;
                    X += 18.f;
                }
            }
            return Y+17.f;//;
        }
    } else {
        NSArray *tags = [goodsInfo approveTags];
        if ([tags count]>0) {
            CGFloat X = 0.f;
            CGFloat Y = 0.f;
            for (NSInteger i=0;i<[tags count];i++) {
                ApproveTagInfo *tag = [tags objectAtIndex:i];
                CGFloat btnWidth = 0;
                if ([tag.iconUrl length]>0 || tag.localTagIcon!=nil) {
                    btnWidth += 22.f;
                }
                if (X+btnWidth>kScreenWidth-30) {
                    X = 0.f;
                    Y += 17.f;
                    Y += 9.5f;
                }
                if (btnWidth>0) {
                    X += btnWidth;
                    X += 5.f;
                }
            }
            return Y+17.f;//;
        }
    }
    return 0.f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo {
    [self updateWithGoodsInfo:goodsInfo showTitle:YES];
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo showTitle:(BOOL)showTitle {
    NSArray *tags = [goodsInfo approveTags];
    
    NSInteger count = [self.subviews count];
    for (NSInteger i=count;i<[tags count];i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectNull];
        [self addSubview:btn];
        [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 10.f, 0, 0)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        btn.backgroundColor = [UIColor clearColor];
        btn.enabled = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    }
    
    for (NSInteger i=[tags count];i<[self.subviews count];i++) {
        UIButton *btn = (UIButton*)[self.subviews objectAtIndex:i];
        btn.hidden = YES;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0, 0)];
    }
    
    if (showTitle) {
        CGFloat X = 15.f;
        CGFloat Y = 0.f;
        
        for (NSInteger i=0;i<[tags count];i++) {
            ApproveTagInfo *tag = [tags objectAtIndex:i];
            UIButton *btn = (UIButton*)[self.subviews objectAtIndex:i];
            
            NSString *name = tag.name;
            CGSize nameSize = [name sizeWithFont:[DataSources goodsTagTextFont]
                               constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                   lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat btnWidth = nameSize.width;
            
            if (tag.iconUrl && [tag.iconUrl length]>0) {
                [btn sd_setImageWithURL:[NSURL URLWithString:tag.iconUrl] forState:UIControlStateDisabled placeholderImage:[UIImage imageNamed:@"placeHolder_tag.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 10.f, 0, 0)];
                
                btnWidth += 22.f;
                btnWidth += 10.f; //TitleEdgeInsets.Left
            } else if (tag.localTagIcon) {
                [btn setImage:tag.localTagIcon forState:UIControlStateDisabled];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 10.f, 0, 0)];
                
                btnWidth += 22.f;
                btnWidth += 10.f; //TitleEdgeInsets.Left
            } else
            {
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 0.f, 0, 0)];
                
                btnWidth += 0.f;
                btnWidth += 0.f; //TitleEdgeInsets.Left
            }
            
            [btn setTitle:tag.name forState:UIControlStateDisabled];
            
            if (btnWidth > 0) {
                btn.hidden = NO;
                if (X+btnWidth>kScreenWidth-30) {
                    X = 15.f;
                    Y += 17.f;
                    Y += 9.5f;
                    btn.frame = CGRectMake(X, Y, btnWidth, 17);
                } else {
                    btn.frame = CGRectMake(X, Y, btnWidth, 17);
                }
                X += btnWidth;
                X += 18.f;
            }
        }
        
        self.frame = CGRectMake(0, 0, kScreenWidth, Y+17.f);
    } else {
        CGFloat X = 15.f;
        CGFloat Y = 0.f;
        
        for (NSInteger i=0;i<[tags count];i++) {
            ApproveTagInfo *tag = [tags objectAtIndex:i];
            UIButton *btn = (UIButton*)[self.subviews objectAtIndex:i];
            
            CGFloat btnWidth = 0;
            
            if (tag.iconUrl && [tag.iconUrl length]>0) {
                [btn sd_setImageWithURL:[NSURL URLWithString:tag.iconUrl] forState:UIControlStateDisabled placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
                btnWidth += 22.f;
            } else if (tag.localTagIcon) {
                [btn setImage:tag.localTagIcon forState:UIControlStateDisabled];
                btnWidth += 22.f;
            } else {
                btnWidth += 22.f;
            }
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 0.f, 0, 0)];
            
            if (btnWidth > 0) {
                btn.hidden = NO;
                if (X+btn.width>kScreenWidth-30) {
                    X = 15.f;
                    Y += 17.f;
                    Y += 9.5f;
                    btn.frame = CGRectMake(X, Y, btnWidth, 17);
                } else {
                    btn.frame = CGRectMake(X, Y, btnWidth, 17);
                }
                X += btn.width;
                X += 5.f;
            }
        }
        
        self.frame = CGRectMake(0, 0, kScreenWidth, Y+17.f);
    }
}

@end


@interface GoodsPricesView ()

@property(nonatomic,retain) UILabel *shopPriceLbl;
@property(nonatomic,retain) UILabel *marketPriceLbl;

@end

@implementation GoodsPricesView

+ (CGFloat)heightForOrientationPortrait
{
    return 22.f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.shopPriceLbl.font = [DataSources goodsShopPriceTextFont];
        self.shopPriceLbl.textColor = [DataSources goodsShopPriceTextColor];
        [self addSubview:self.shopPriceLbl];
        
        self.marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.marketPriceLbl.font = [DataSources goodsMarketPriceTextFont];
        self.marketPriceLbl.textColor = [DataSources goodsMarketPriceTextColor];
        [self addSubview:self.marketPriceLbl];
    }
    return self;
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo
{
    self.shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",goodsInfo.shopPrice];
    
    if (goodsInfo.marketPrice>0) {
        NSString *marketPrice = [NSString stringWithFormat:@"¥ %.2f",goodsInfo.marketPrice];
        NSString *marketPriceFullString =  [NSString stringWithFormat:@"原价：%@",marketPrice];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:marketPriceFullString];
        [attrString addAttribute:NSStrikethroughStyleAttributeName
                           value:[NSNumber numberWithInteger:NSUnderlinePatternSolid|NSUnderlineStyleSingle]
                           range:NSMakeRange(marketPriceFullString.length-marketPrice.length, marketPrice.length)];
        [attrString addAttribute:NSStrikethroughStyleAttributeName
                           value:[NSNumber numberWithInteger:NSUnderlinePatternSolid]
                           range:NSMakeRange(0, marketPriceFullString.length-marketPrice.length)];
        self.marketPriceLbl.attributedText = attrString;
        self.marketPriceLbl.hidden = NO;
    } else {
        self.marketPriceLbl.hidden = YES;
    }
    
    
    CGFloat marginLeft = 15.f;
    [self.shopPriceLbl sizeToFit];
    self.shopPriceLbl.frame = CGRectMake(marginLeft, 0, self.shopPriceLbl.bounds.size.width, self.shopPriceLbl.bounds.size.height);
    
    marginLeft += self.shopPriceLbl.bounds.size.width;
    marginLeft += 15.f;
    
    [self.marketPriceLbl sizeToFit];
    self.marketPriceLbl.frame = CGRectMake(marginLeft, [GoodsPricesView heightForOrientationPortrait]-self.marketPriceLbl.bounds.size.height-1, self.marketPriceLbl.bounds.size.width, self.marketPriceLbl.bounds.size.height);
    
    self.frame = CGRectMake(0, 0, kScreenWidth, [[self class] heightForOrientationPortrait]);
}

@end


@interface GoodsLikedUsersView ()

@property(nonatomic,copy) NSString *goodsId;

@end

@implementation GoodsLikedUsersView

+ (CGFloat)heightForOrientationPortrait {
    return 35.f+9.f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger maxCount = [GoodsLikedUsersView maxAvatarViews];
        NSInteger count = maxCount;
        for (int i=0;i<count;i++) {
            
            if (i==count-1) {
                UIButton *avatarBtn = [[UIButton alloc] initWithFrame:CGRectNull];
                avatarBtn.layer.masksToBounds=YES;
                avatarBtn.layer.cornerRadius=[GoodsLikedUsersView heightForOrientationPortrait]/2; //最重要的是这个地方要设成imgview高的一半
                avatarBtn.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
                avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [avatarBtn addTarget:self action:@selector(handleAvatarClicked:) forControlEvents:UIControlEventTouchUpInside];
                avatarBtn.backgroundColor = [DataSources goodsLikesNumBackgroundColor];
                [avatarBtn setTitle:@"" forState:UIControlStateNormal];
                [avatarBtn setImage:[UIImage imageNamed:@"goods_likes_user_more"] forState:UIControlStateNormal];
                avatarBtn.titleLabel.font = [DataSources goodsLikesNumFont];
                avatarBtn.titleLabel.textColor = [DataSources goodsLikesNumTextColor];
                [self addSubview:avatarBtn];
            } else {
                XMWebImageView *imgView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
                imgView.clipsToBounds = YES;
                imgView.layer.masksToBounds=YES;
                imgView.layer.cornerRadius=[GoodsLikedUsersView heightForOrientationPortrait]/2; //最重要的是这个地方要设成imgview高的一半
                imgView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.backgroundColor = [DataSources goodsLikesNumBackgroundColor];
                [self addSubview:imgView];
                
                imgView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
                     [[CoordinatingController sharedInstance] gotoUserHomeViewController:view.tag animated:YES];
                };
            }
        }
    }
    return self;
}

+ (NSInteger)maxAvatarViews
{
    CGFloat width = kScreenWidth-30.f;
    NSInteger count = width/([GoodsLikedUsersView heightForOrientationPortrait] + 9);
    return count;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *subViews = [self subviews];
    CGFloat X = 15.f;
    CGFloat width = self.bounds.size.height;
    CGFloat height = width;
    for (int i=0;i<[subViews count];i++) {
        UIView *view = [subViews objectAtIndex:i];
        view.frame = CGRectMake(X, 0, width, height);
        X += width;
        X += 15.f;
    }
}

- (void)dealloc
{
    NSArray *subViews = [self subviews];
    for (int i=0;i<[subViews count];i++) {
        UIView *view = [subViews objectAtIndex:i];
        [view removeFromSuperview];
    }
}

- (void)handleAvatarClicked:(UIButton*)sender
{
    if (sender.tag == -1) {
        [[CoordinatingController sharedInstance] gotoGoodsLikesViewController:self.goodsId animated:YES];
    } else {
        [[CoordinatingController sharedInstance] gotoUserHomeViewController:sender.tag animated:YES];
    }
}

- (void)prepareForReuse {
    
}

- (void)updateWithLikedUsers:(NSString*)goodsId totalNum:(NSInteger)totalNum likedUsers:(NSArray*)likedUsers;
{
    self.goodsId = goodsId;
    
    for (int i=0;i<[[self subviews] count]-1;i++) {
        UIView *btn = (UIView*)[[self subviews] objectAtIndex:i];
        btn.hidden = YES;
    }
    
    NSArray *subViews = [self subviews];
    if ([likedUsers count]>=[subViews count]-1) {
        for (int i=0;i<[subViews count]-1;i++) {
            User *user = (User*)[likedUsers objectAtIndex:i];
            XMWebImageView *btn = (XMWebImageView*)[subViews objectAtIndex:i];
            btn.hidden = NO;
            btn.tag = user.userId;
            [btn setImageWithURL:user.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
        }
        
        UIButton *btn = (UIButton*)[subViews objectAtIndex:[subViews count]-1];
        btn.hidden = NO;
        btn.tag = -1;
        if (totalNum<99) {
//            [btn setTitle:[NSString stringWithFormat:@"%ld",(long)totalNum] forState:UIControlStateNormal];
            [btn setTitle:@"..." forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"..." forState:UIControlStateNormal];
        }
    } else {
        for (int i=0;i<[subViews count];i++) {
            XMWebImageView *btn = (XMWebImageView*)[subViews objectAtIndex:i];
            if (i<[likedUsers count]) {
                User *user = (User*)[likedUsers objectAtIndex:i];
                btn.hidden = NO;
                btn.tag = user.userId;
                [btn setImageWithURL:user.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
            }  else {
                btn.hidden = YES;
            }
        }
    }
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo
{
    self.goodsId = goodsInfo.goodsId;
    
    for (int i=0;i<[[self subviews] count]-1;i++) {
        UIView *btn = (UIView*)[[self subviews] objectAtIndex:i];
        btn.hidden = YES;
    }
    
    NSInteger totoalNum = goodsInfo.stat.likeNum;
    NSArray *users = [goodsInfo likedUsers];
    NSArray *subViews = [self subviews];
    if ([users count]>=[subViews count]-1) {
        for (int i=0;i<[subViews count]-1;i++) {
            User *user = (User*)[users objectAtIndex:i];
            XMWebImageView *btn = (XMWebImageView*)[subViews objectAtIndex:i];
            btn.hidden = NO;
            btn.tag = user.userId;
//            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:user.avatarUrl] forState:UIControlStateNormal placeholderImage:[DataSources globalPlaceHolderLikesAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            }];
            
            [btn setImageWithURL:user.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
        }
        
        UIButton *btn = (UIButton*)[subViews objectAtIndex:[subViews count]-1];
        btn.hidden = NO;
        btn.tag = -1;
        if (totoalNum<99) {
            [btn setTitle:[NSString stringWithFormat:@"%ld",(long)totoalNum] forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"..." forState:UIControlStateNormal];
        }
    } else {
        for (int i=0;i<[subViews count];i++) {
            XMWebImageView *btn = (XMWebImageView*)[subViews objectAtIndex:i];
            if (i<[users count]) {
                User *user = (User*)[users objectAtIndex:i];
                btn.hidden = NO;
                btn.tag = user.userId;
                
//                NSString *url = [XMImageView imageUrlToQNImageUrl:user.avatarUrl isWebP:NO scaleType:XMImageScale80x80];
//                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[DataSources globalPlaceHolderLikesAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                }];
                
                [btn setImageWithURL:user.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
                
            }  else {
                btn.hidden = YES;
            }
        }
    }
}

@end


@interface GoodsActionButtonsView ()

@property(nonatomic,retain) UIButton *shareBtn;
@property(nonatomic,retain) CALayer *line1;
@property(nonatomic,retain) UIButton *commentBtn;
@property(nonatomic,retain) CALayer *line2;
@property(nonatomic,retain) UIButton *likeBtn;

@property(nonatomic,assign) BOOL alignLeft;

@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *shareImageUrl;
@property(nonatomic,copy)NSString *goodSName;

@property(nonatomic,assign) BOOL isPortraitDirection;

@end

@implementation GoodsActionButtonsView
{
    HTTPRequest *_request;
}


+ (CGFloat)heightForOrientationPortrait {
    return 30.f;
}


- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame alignLeft:NO];
}

- (id)initWithFrame:(CGRect)frame alignLeft:(BOOL)alignLeft {
    return [self initWithFrame:frame alignLeft:alignLeft isPortraitDirection:NO];
}

- (id)initWithFrame:(CGRect)frame alignLeft:(BOOL)alignLeft isPortraitDirection:(BOOL)isPortraitDirection {
    self = [super initWithFrame:frame];
    if (self) {
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        self.shareBtn.backgroundColor = [UIColor clearColor];
        self.shareBtn.titleLabel.font = [DataSources goodsActionButtonTextFont];
        [self.shareBtn setTitleColor:[DataSources goodsActionButtonTextColor] forState:UIControlStateNormal];
        [self.shareBtn setImage:[DataSources goodsShareImg] forState:UIControlStateNormal];
//        [self.shareBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, -40, 0, 0)];
//        [self.shareBtn setImageEdgeInsets: UIEdgeInsetsMake(0, -10, 0, 0)];
        [self.shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shareBtn];
        
        //        self.commentBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        //        self.commentBtn.backgroundColor = [UIColor clearColor];
        //        self.commentBtn.titleLabel.font = [DataSources goodsActionButtonTextFont];
        //        [self.commentBtn setTitleColor:[DataSources goodsActionButtonTextColor] forState:UIControlStateNormal];
        //        [self.commentBtn setImage:[DataSources goodsCommentImg] forState:UIControlStateNormal];
        //        [self.commentBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 5, 0, 0)];
        //        [self.commentBtn setImageEdgeInsets: UIEdgeInsetsMake(0, -5, 0, 0)];
        //        [self.commentBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:self.commentBtn];
        
        self.likeBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        self.likeBtn.backgroundColor = [UIColor clearColor];
        self.likeBtn.titleLabel.font = [DataSources goodsActionButtonTextFont];
        [self.likeBtn setTitleColor:[DataSources goodsActionButtonTextColor] forState:UIControlStateNormal];
        [self.likeBtn setImage:[DataSources goodsLikeImg] forState:UIControlStateNormal];
        [self.likeBtn setImage:[DataSources goodsLikedImg] forState:UIControlStateSelected];
        [self.likeBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.likeBtn setImageEdgeInsets: UIEdgeInsetsMake(0, -10, 0, 0)];
        [self.likeBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.likeBtn];
        
        //        self.line1 = [CALayer layer];
        //        self.line1.backgroundColor = [DataSources goodsActionButtonSepLineColor].CGColor;
        //        [self.layer addSublayer:self.line1];
        
        self.line2 = [CALayer layer];
        self.line2.backgroundColor = [DataSources goodsActionButtonSepLineColor].CGColor;
        [self.layer addSublayer:self.line2];
        
        self.isPortraitDirection = isPortraitDirection;
        
//        if (isPortraitDirection) {
//            [self.shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, -10, 0, 0)];
//            [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 10, 0, 0)];
//            
//            [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, -10, 0, 0)];
//            [self.likeBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 10, 0, 0)];
//        }
        
        [self.shareBtn setTitle:@"0" forState:UIControlStateNormal];
        [self.commentBtn setTitle:@"0" forState:UIControlStateNormal];
        [self.likeBtn setTitle:@"0" forState:UIControlStateNormal];
        
        self.alignLeft = alignLeft;
    }
    return self;
}

- (void)dealloc
{
    self.shareBtn = nil;
    self.line1 = nil;
    self.commentBtn = nil;
    self.line2 = nil;
    self.likeBtn = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width/2;
    
    CGFloat marginTop = 0.f;
    CGFloat marginLeft = 0.f;
    
   // if (self.alignLeft) {
        
        marginLeft = 0;
        self.shareBtn.frame = CGRectMake(marginLeft, marginTop, width, height);
    
        
        marginLeft += width;
        self.line2.frame = CGRectMake(marginLeft, (height-18)/2, 1, 18);
        
        self.likeBtn.frame = CGRectMake(marginLeft, marginTop, width, height);
    
//    if (self.isPortraitDirection) {
//        [self.shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, -10, 0, 0)];
//        [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(-19, 20.5, 0, 0)];
//        
//        [self.likeBtn setImageEdgeInsets:UIEdgeInsetsMake(-((self.likeBtn.width-[self.likeBtn imageForState:UIControlStateNormal].size.width)/2), 18.5, 0, 0)];
////        
//        [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, -10, 0, 0)];
////
//    }
    
    
    
    
//    } else {
//        marginLeft = self.bounds.size.width-width;
//        self.likeBtn.frame = CGRectMake(marginLeft, marginTop, width, height);
//        
//        self.line2.frame = CGRectMake(marginLeft, (height-18)/2, 1, 18);
//        
//        marginLeft -= width;
//        
//        self.shareBtn.frame = CGRectMake(marginLeft, marginTop, width, height);
//        marginLeft += width;
//    }
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo
{
    [self updateWithGoodsInfo:goodsInfo withTitleAndNum:NO];
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo withTitleAndNum:(BOOL)withTitleAndNum
{
    [_shareBtn setTitle:[GoodsInfo formatShareNum:goodsInfo withTitleAndNum:withTitleAndNum] forState:UIControlStateNormal];
    [_likeBtn setTitle:[GoodsInfo formatLikesNum:goodsInfo withTitleAndNum:withTitleAndNum] forState:UIControlStateNormal];
    
    _likeBtn.selected = [goodsInfo isLiked];
    
    _goodsId = goodsInfo.goodsId;
    _shareImageUrl = goodsInfo.mainPicUrl;
    if ([_shareImageUrl mag_isEmpty] && goodsInfo.gallaryItems && [goodsInfo.gallaryItems count] >0) {
        _shareImageUrl = ((GoodsGallaryItem *)[goodsInfo.gallaryItems objectAtIndex:0]).picUrl;
    }
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale480x480]]
                                                    options:SDWebImageCacheMemoryOnly
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    
                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
                                                   }];
    
    _goodSName = goodsInfo.goodsName;
    
    [self.shareBtn centerVertically];
    [self.likeBtn centerVertically];
}

- (void)share:(UIButton*)sender
{
    GoodsInfo *goods = [[GoodsMemCache sharedInstance] dataForKey:self.goodsId];
    UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                                        [SDWebImageManager lw_cacheKeyForURL:
                                         [NSURL URLWithString:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale480x480]]]];


    if (shareImage == nil) {
        shareImage = [self getImageFromURL:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale200x200]];
    }

    [[CoordinatingController sharedInstance] shareWithTitle:@"来自爱丁猫的分享"
                                                      image:shareImage
                                                        url:kURLGoodsDetailFormat(self.goodsId)
                                                    content:goods.goodsName];
    
    [MobClick event:@"click_share_from_feeds"];
    WEAKSELF
    
    _request = [[NetworkAPI sharedInstance] shareGoodsWith:self.goodsId completion:^(int shareNum) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
                                        if (goodsInfo) {
                                            goodsInfo.stat.shareNum = shareNum;
                                        }
                                        MBGlobalSendGoodsInfoChangedNotification(0,weakSelf.goodsId);
                                    });
                                    _$hideHUD();
                                } failure:^(XMError *error) {
                                    _$showHUD([error errorMsg], 0.8f);
                                }];

}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (void)like:(UIButton*)sender
{
    [MobClick event:@"click_like_from_feeds"];
    if ([self.likeBtn isSelected]) {
        [GoodsSingletonCommand unlikeGoods:self.goodsId];
    } else {
        [GoodsSingletonCommand likeGoods:self.goodsId];
    }
}

@end







