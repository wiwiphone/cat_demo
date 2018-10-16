//
//  GoodsLikesTableViewCell.m
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsLikesTableViewCell.h"

#import "DataSources.h"
#import "User.h"


@interface GoodsLikesTableViewCell ()

@property(nonatomic,strong) XMWebImageView *avatarView;
@property(nonatomic,strong) UILabel *nickNameLbl;
@property(nonatomic,strong) CALayer *rightArrow;
@property(nonatomic,strong) CALayer *bottomLine;

@end

@implementation GoodsLikesTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsLikesTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 71.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(User*)user
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsLikesTableViewCell class]];
    if (user)[dict setObject:user forKey:[self cellKeyForGoodsLikedUser]];
    return dict;
}

+ (NSString*)cellKeyForGoodsLikedUser {
    return @"user";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatarView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 42/2;
        _avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.clipsToBounds = YES;
        [self.contentView addSubview:_avatarView];
        
        _nickNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _nickNameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _nickNameLbl.font = [UIFont systemFontOfSize:15.f];
        _nickNameLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nickNameLbl];
        
        _rightArrow = [CALayer layer];
        _rightArrow.contents = (id)[DataSources rightArrowImage].CGImage;
        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _avatarView.frame = CGRectNull;
    _nickNameLbl.frame = CGRectNull;
    _rightArrow.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginLeft = 15.f;
    _avatarView.frame = CGRectMake(marginLeft, (self.contentView.height-42)/2, 42, 42);
    
    marginLeft += self.avatarView.width;
    marginLeft += 16.f;
    
    _rightArrow.frame = CGRectMake(self.contentView.width-15-[DataSources rightArrowImage].size.width, (self.contentView.height-[DataSources rightArrowImage].size.height)/2, [DataSources rightArrowImage].size.width, [DataSources rightArrowImage].size.height);
    
    _nickNameLbl.frame = CGRectMake(marginLeft, 0, _rightArrow.frame.origin.x-20-marginLeft, self.contentView.height);
    _bottomLine.frame = CGRectMake(72, self.contentView.height-1.f, self.contentView.width-72, 1);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    id obj = [dict objectForKey:[[self class] cellKeyForGoodsLikedUser]];
    if ([obj isKindOfClass:[User class]]) {
        User *user = (User*)obj;
//        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[DataSources globalPlaceHolderSeller] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        }];
        
        [self.avatarView setImageWithURL:user.avatarUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
        
        self.nickNameLbl.text = user.userName;
        [self setNeedsLayout];
    }
}

@end


