//
//  ConsignOrderTableViewCell.m
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ConsignOrderTableViewCell.h"
#import "ConsignOrder.h"
#import "DataSources.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ConsignOrderTableViewCell ()

@property(nonatomic,strong) CALayer *topLineLayer;
@property(nonatomic,strong) UILabel *createTimeLbl;
@property(nonatomic,strong) UILabel *statusLbl;
@property(nonatomic,strong) XMWebImageView *picView;
@property(nonatomic,strong) CALayer *rightArrow;
@property(nonatomic,strong) CALayer *bottomLineLayer;

@property(nonatomic,strong) NSArray *picList;

@end

@implementation ConsignOrderTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ConsignOrderTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 150;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(ConsignOrder*)order {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ConsignOrderTableViewCell class]];
    if (order)[dict setObject:order forKey:[self cellDictKeyForConsignOrder]];
    return dict;
}

+ (NSString*)cellDictKeyForConsignOrder {
    return @"order";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _topLineLayer = [CALayer layer];
        _topLineLayer.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"].CGColor;
        [self.contentView.layer addSublayer:_topLineLayer];
        
        _createTimeLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _createTimeLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _createTimeLbl.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_createTimeLbl];
        
        _statusLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _statusLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _statusLbl.font = [UIFont systemFontOfSize:13.f];
        _statusLbl.numberOfLines = 0;
        _statusLbl.contentMode = UIViewContentModeTopLeft;
        [self.contentView addSubview:_statusLbl];
        
        _picView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _picView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _picView.userInteractionEnabled = YES;
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.clipsToBounds = YES;
        [self.contentView addSubview:_picView];
        
        
        UIImage *rightArrowImage = [UIImage imageNamed:@"right_arrow.png"];
        _rightArrow = [CALayer layer];
        _rightArrow.contents = (id)[rightArrowImage CGImage];
        _rightArrow.frame = CGRectMake(0, 0, rightArrowImage.size.width, rightArrowImage.size.height);
        [self.contentView.layer addSublayer:_rightArrow];
        
        _bottomLineLayer = [CALayer layer];
        _bottomLineLayer.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"].CGColor;
        [self.contentView.layer addSublayer:_bottomLineLayer];
        
        WEAKSELF;
        _picView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            for (NSString *url in weakSelf.picList) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:url]; // 图片路径
                photo.srcImageView = weakSelf.picView;
                [photos addObject:photo];
            }
            
            if ([photos count]>0){
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.photos = photos; // 设置所有的图片
                browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
                [browser show];
            }
        };
    }
    return self;
}

- (void)dealloc {
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _createTimeLbl.frame = CGRectNull;
    _statusLbl.frame = CGRectNull;
    _picView.frame = CGRectNull;
    _bottomLineLayer.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _topLineLayer.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 1);
    [_createTimeLbl sizeToFit];
    _createTimeLbl.frame = CGRectMake(15, 18.5f, self.contentView.bounds.size.width-30, _createTimeLbl.bounds.size.height);
    _picView.frame = CGRectMake(15, self.contentView.bounds.size.height-80.f-20.f, 80.f, 80.f);
    _rightArrow.frame = CGRectMake(self.contentView.bounds.size.width-23-_rightArrow.bounds.size.width, self.contentView.bounds.size.height-54-_rightArrow.bounds.size.height, _rightArrow.bounds.size.width, _rightArrow.bounds.size.height);
    
    _bottomLineLayer.frame = CGRectMake(0, self.contentView.height-1, self.contentView.width, 1);
    
    CGFloat statusLblX = _picView.left+_picView.width+15.f;
    CGFloat statusLblW = _rightArrow.frame.origin.x-25-statusLblX;
    _statusLbl.width = statusLblW;
    [_statusLbl sizeToFit];
    _statusLbl.frame = CGRectMake(statusLblX,_picView.top, statusLblW, _statusLbl.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    ConsignOrder *order = [dict objectForKey:[[self class] cellDictKeyForConsignOrder]];
    if (order) {
        _picList = order.picList;
        if ([order picList].count > 0) {
            NSString *url = [[order picList] objectAtIndex:0];
//            [_picView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            }];
            
            [_picView setImageWithURL:url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        }
        _createTimeLbl.text = [NSDate stringForTimestampSince1970:order.createTime];
        
        for (NSInteger i=0;i<[order.statusIems count];i++) {
            NSDictionary *dict = [order.statusIems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([dict consignOrderStatus] == order.status) {
                    _statusLbl.text = [dict consignOrderSummary];
                    NSString *labelText = [NSString stringWithFormat:@"状态：%@",dict.consignOrderSummary];
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"985F65"] range:NSMakeRange(labelText.length-dict.consignOrderSummary.length, [dict.consignOrderSummary length])];
                    _statusLbl.attributedText = attributedString;
                    break;
                }
            }
        }
        
        [self setNeedsLayout];
    }
}

@end
