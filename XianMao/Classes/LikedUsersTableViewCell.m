//
//  LikedUsersTableViewCell.m
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "LikedUsersTableViewCell.h"
#import "User.h"
#import "GoodsTableViewCell.h"
#import "Masonry.h"

@interface LikedUsersTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *segBottomView;
@property (nonatomic, strong) UILabel *titleContentLbl;
@end

@implementation LikedUsersTableViewCell {
    GoodsLikedUsersView *_likedUsersView;
}

-(UIView *)segBottomView{
    if (!_segBottomView) {
        _segBottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _segBottomView.backgroundColor = [UIColor clearColor];//colorWithHexString:@"cdcdcd"
    }
    return _segBottomView;
}

-(UILabel *)titleContentLbl{
    if (!_titleContentLbl) {
        _titleContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleContentLbl.font = [UIFont systemFontOfSize:14.f];
        _titleContentLbl.textColor = [UIColor colorWithHexString:@"c3c3c3"];
        [_titleContentLbl sizeToFit];
        _titleContentLbl.text = @"丨Heart of people";
    }
    return _titleContentLbl;
}

-(UIView *)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightView.backgroundColor = [UIColor colorWithHexString:@"c9c9c9c"];
    }
    return _rightView;
}

-(UIView *)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _leftView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([LikedUsersTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [GoodsLikedUsersView heightForOrientationPortrait]+29 + 30 + 10;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)goodsId totalNum:(NSInteger)totalNum likedUsers:(NSArray*)likedUsers;
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[LikedUsersTableViewCell class]];
    if (goodsId)[dict setObject:goodsId forKey:[self cellDictKeyForGoodsId]];
    [dict setObject:[NSNumber numberWithInteger:totalNum] forKey:[self cellDictKeyForTotalNum]];
    if (likedUsers)[dict setObject:likedUsers forKey:[self cellDictKeyForLikedUsers]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsId {
    return @"goodsId";
}

+ (NSString*)cellDictKeyForTotalNum {
    return @"totalNum";
}

+ (NSString*)cellDictKeyForLikedUsers {
    return @"likedUsers";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _likedUsersView = [[GoodsLikedUsersView alloc] initWithFrame:CGRectNull];
        _likedUsersView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_likedUsersView];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        [self.contentView addSubview:self.segBottomView];
        [self.contentView addSubview:self.titleContentLbl];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_likedUsersView prepareForReuse];
    _likedUsersView.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLbl.frame = CGRectMake(25, 0, self.contentView.width-30, self.contentView.height);
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(12, 12, _titleLbl.width, _titleLbl.height);
    
    [self.titleContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right).offset(8);
        make.centerY.equalTo(self.titleLbl.mas_centerY);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleContentLbl.mas_bottom).offset(12);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
    
//    _likedUsersView.frame = CGRectMake(0, self.titleLbl.bottom + 15, self.contentView.width, [GoodsLikedUsersView heightForOrientationPortrait]);
    [_likedUsersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftView.mas_bottom).offset(12);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@([GoodsLikedUsersView heightForOrientationPortrait]));
    }];
    
    [self.segBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSString *goodsId = [dict stringValueForKey:[[self class] cellDictKeyForGoodsId]];
        NSInteger totalNum = [dict integerValueForKey:[[self class] cellDictKeyForTotalNum]];
        NSArray *likedUsers = [dict arrayValueForKey:[[self class] cellDictKeyForLikedUsers]];
        self.titleLbl.text = [NSString stringWithFormat:@"%ld人为此心动", totalNum];
        [_likedUsersView updateWithLikedUsers:goodsId totalNum:totalNum likedUsers:likedUsers];
        [self setNeedsLayout];
    }
}


@end
