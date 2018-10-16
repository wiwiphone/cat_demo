//
//  EMChatGoodsBubbleView.m
//  XianMao
//
//  Created by darren on 15/4/8.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "EMChatGoodsBubbleView.h"

#define kGoodsImageBounds 58.f
#define kGoodsImageMarginLeft 3.f
#define kGoodsImageMarginTop 3.f
#define kGoodsTitleMarginTop 0.f

#define kGoodsTitleHeight 40.f
#define kGoodsPriceHeight 20.f

NSString *const kRouterEventGoodsBubbleTapEventName = @"kRouterEventGoodsBubbleTapEventName";

@interface EMChatGoodsBubbleView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation EMChatGoodsBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_priceLabel];
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    
    CGFloat height = 64.f;
    
    return CGSizeMake((kScreenWidth/3.f) *2, height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = CGRectMake(kGoodsImageMarginLeft, kGoodsImageMarginTop, kGoodsImageBounds, kGoodsImageBounds);
    frame.size.width -= BUBBLE_ARROW_WIDTH;

    if (!self.model.isSender) {
        frame.origin.x = kGoodsImageMarginLeft+BUBBLE_ARROW_WIDTH +2;
    }

    [self.imageView setFrame:frame];

    self.imageView.clipsToBounds = YES;
    [_priceLabel setFrame:CGRectMake(kGoodsImageBounds+frame.origin.x + kGoodsImageMarginLeft,
                                         kGoodsTitleHeight + kGoodsTitleMarginTop ,
                                         CGRectGetWidth(self.bounds)-kGoodsImageBounds-kGoodsImageMarginLeft -10,
                                         CGRectGetHeight(self.bounds)-kGoodsTitleHeight)];
    [_priceLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_priceLabel setFont:[UIFont systemFontOfSize:14.0f]];
    if (self.model.isSender) {
        _priceLabel.textColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor whiteColor];
    } else {
         _priceLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _titleLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    }

    [_titleLabel setFrame:CGRectMake(kGoodsImageBounds+frame.origin.x + 4,
                                        kGoodsTitleMarginTop,
                                         CGRectGetWidth(self.bounds)-kGoodsImageBounds-kGoodsImageMarginLeft -15,
                                         CGRectGetHeight(self.bounds)-kGoodsPriceHeight-kGoodsTitleMarginTop)];
    [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - setter

- (void)setModel:(EaseMessageModel *)model
{
    [super setModel:model];
    
    if ([model.message.ext integerValueForKey:@"type"] == 1) {
        NSDictionary *goodsDict = [model.message.ext objectForKey:@"goods"];
        if ([model.message.ext[@"goods"] isKindOfClass:[NSDictionary class]]) {
            goodsDict = model.message.ext[@"goods"];
        } else {
            goodsDict = [self dictionaryWithJsonString:model.message.ext[@"goods"]];
        }
        
        NSLog(@"%@", goodsDict);
        NSString *thumbUrl =[goodsDict objectForKey:@"thumb_url"];
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[UIImage imageNamed:@"chat_imageDownloadFail.png"]];
        
        _priceLabel.text = [NSString stringWithFormat:@"￥ %.2f元",[goodsDict doubleValueForKey:@"shop_price"]];
        
        _titleLabel.text = [goodsDict stringValueForKey:@"goods_name"];
        [_titleLabel sizeToFit];
        [_priceLabel sizeToFit];
        
    }
    
    
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    
    [self routerEventWithName:kRouterEventGoodsBubbleTapEventName
                     userInfo:@{KMESSAGEKEY:self.model}];
}


+(CGFloat)heightForBubbleWithObject:(EaseMessageModel *)object
{
//    CGSize retSize = object.size;
//    if (retSize.width == 0 || retSize.height == 0) {
//        retSize.width = MAX_SIZE;
//        retSize.height = MAX_SIZE;
//    }else if (retSize.width > retSize.height) {
//        CGFloat height =  MAX_SIZE / retSize.width  *  retSize.height;
//        retSize.height = height;
//        retSize.width = MAX_SIZE;
//    }else {
//        CGFloat width = MAX_SIZE / retSize.height * retSize.width;
//        retSize.width = width;
//        retSize.height = MAX_SIZE;
//    }
//    return 2 * BUBBLE_VIEW_PADDING + retSize.height;
    
    return 2 * BUBBLE_VIEW_PADDING +64.f ;
}


@end
