//
//  UserLikesTableViewCell.m
//  XianMao
//
//  Created by simon on 1/11/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "UserLikesTableViewCell.h"
#import "DataSources.h"
#import "GoodsInfo.h"

#import "Command.h"
#import "Session.h"
#import "GoodsStatusMaskView.h"

@interface UserLikesTableViewCell ()

@property(nonatomic,strong) XMWebImageView *thumbView;
@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) UILabel *gradeLbl;
@property(nonatomic,strong) UILabel *shopPriceLbl;
@property(nonatomic,strong) CommandButton *removeBtn;
@property(nonatomic,strong) CALayer *bottomLine;

@property(nonatomic,copy) NSString *goodsId;

@end

@implementation UserLikesTableViewCell {
    GoodsStatusMaskView *_statusView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserLikesTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 112.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo
{
    return [self buildCellDict:goodsInfo isInEditMode:NO];
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo isInEditMode:(BOOL)isInEditMode
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserLikesTableViewCell class]];
    if (goodsInfo)[dict setObject:goodsInfo forKey:[self cellKeyForUserLikesGoodsInfo]];
    [dict setObject:[NSNumber numberWithBool:isInEditMode] forKey:[self cellDictKeyForInEditMode]];
    return dict;
}

+ (NSString*)cellKeyForUserLikesGoodsInfo {
    return @"goods";
}

+ (NSString*)cellDictKeyForInEditMode {
    return @"isInEditMode";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _thumbView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _thumbView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _thumbView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbView.clipsToBounds = YES;
        _thumbView.userInteractionEnabled = YES;
        [self.contentView addSubview:_thumbView];
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _nameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _nameLbl.font = [UIFont systemFontOfSize:12.f];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.numberOfLines = 0;
        [self.contentView addSubview:_nameLbl];
        
        _gradeLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _gradeLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _gradeLbl.font = [UIFont systemFontOfSize:13.f];
        _gradeLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_gradeLbl];
        
        _shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _shopPriceLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _shopPriceLbl.font = [UIFont systemFontOfSize:13.f];
        _shopPriceLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_shopPriceLbl];
        
        _removeBtn = [[CommandButton alloc] initWithFrame:CGRectNull];
        _removeBtn.backgroundColor = [UIColor clearColor];
        [_removeBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_removeBtn];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
        
        WEAKSELF;
        _removeBtn.handleClickBlock = ^(CommandButton *sender) {
            [GoodsSingletonCommand unlikeGoods:weakSelf.goodsId];
        };
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _thumbView.frame = CGRectNull;
    _nameLbl.frame = CGRectNull;
    _gradeLbl.frame = CGRectNull;
    _shopPriceLbl.frame = CGRectNull;
    _removeBtn.frame = CGRectNull;
    _removeBtn.hidden = YES;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginTop = 16.f;
    CGFloat marginLeft = 15.f;
    CGFloat marginRight = 15.f;
    
    if (!_removeBtn.hidden) {
        _removeBtn.frame = CGRectMake(self.contentView.width-48.f, 0, 48.f, self.contentView.height);
        marginRight = 48.f;
    }
    
    _thumbView.frame = CGRectMake(marginLeft, marginTop, 80, 80);

    marginLeft += _thumbView.width;
    marginLeft += 14.f;
    
    _nameLbl.frame = CGRectMake(marginLeft, _thumbView.top, self.contentView.size.width-marginRight-marginLeft, 0);
    [_nameLbl sizeToFit];
    _nameLbl.frame = CGRectMake(marginLeft, _thumbView.top, self.contentView.size.width-marginRight-marginLeft, _nameLbl.height);
    
    
    [_gradeLbl sizeToFit];
    _gradeLbl.frame = CGRectMake(marginLeft, _thumbView.bottom-_gradeLbl.height, _gradeLbl.width, _gradeLbl.height);
    
    [_shopPriceLbl sizeToFit];
    _shopPriceLbl.frame = CGRectMake(self.contentView.width-marginRight-_shopPriceLbl.width, _thumbView.bottom-_shopPriceLbl.height, _shopPriceLbl.width, _shopPriceLbl.height);
    
    _bottomLine.frame = CGRectMake(0, self.contentView.height-1.f, self.contentView.width, 1);
    
    _statusView.frame = _thumbView.frame;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    GoodsInfo *goodsInfo = (GoodsInfo*)[dict objectForKey:[[self class] cellKeyForUserLikesGoodsInfo]];
    if ([goodsInfo isKindOfClass:[GoodsInfo class]])
    {
        BOOL isInEditMode = [dict boolValueForKey:[[self class] cellDictKeyForInEditMode] defaultValue:NO];
        
//        [_thumbView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.thumbUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        }];
        
        [_thumbView setImageWithURL:goodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale160x160];
        
        _nameLbl.text = goodsInfo.goodsName;
        _gradeLbl.text = [NSString stringWithFormat:@"成色：%@",(goodsInfo.gradeTag&&goodsInfo.gradeTag.name)?goodsInfo.gradeTag.name:@""];
        _shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",goodsInfo.shopPrice];
        _removeBtn.hidden = !isInEditMode;
        
        _goodsId = goodsInfo.goodsId;
        
        
        if (![goodsInfo isOnSale]) {
            if (!_statusView) {
                _statusView = [[GoodsStatusMaskView alloc] init];
                [self addSubview:_statusView];
            }
            _statusView.hidden = NO;
            _statusView.statusString = goodsInfo.statusDescription;
        } else {
            _statusView.hidden = YES;
        }
        
        [self setNeedsLayout];
    }
}


@end







