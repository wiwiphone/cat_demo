//
//  BrandTableViewCell.m
//  XianMao
//
//  Created by simon on 2/13/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BrandTableViewCell.h"
#import "XMWebImageView.h"

@implementation BrandTableViewCell {
    BrandItemView *_itemView1;
    BrandItemView *_itemView2;
    
    CALayer *_middleLine;
    CALayer *_bottomLine;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BrandTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = ( 90.f * kScreenWidth ) / 320.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray*)redirectItems {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BrandTableViewCell class]];
    if (redirectItems)[dict setObject:redirectItems forKey:[self cellKeyForedRidrectItems]];
    return dict;
}

+ (NSString*)cellKeyForedRidrectItems {
    return @"redirectItems";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _itemView1 = [[BrandItemView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:_itemView1];
        
        _itemView2 = [[BrandItemView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:_itemView2];
        
        _middleLine = [CALayer layer];
        _middleLine.backgroundColor = [UIColor blackColor].CGColor;//[UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_middleLine];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor blackColor].CGColor;//[UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
        
        WEAKSELF;
        _itemView1.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.handleFilterItemTapDetected) {
                weakSelf.handleFilterItemTapDetected(((BrandItemView*)view).redirectInfo);
            }
        };
        _itemView2.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.handleFilterItemTapDetected) {
                weakSelf.handleFilterItemTapDetected(((BrandItemView*)view).redirectInfo);
            }
        };
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _itemView1.hidden = YES;
    _itemView2.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    _middleLine.frame = CGRectMake(self.width/2, 0, 0.5f, self.contentView.height);
    _bottomLine.frame = CGRectMake(0, self.contentView.height-0.5f, self.contentView.width, 0.5f);
    
    _itemView1.frame = CGRectMake(0, 0, self.contentView.width/2, self.contentView.height);
    _itemView2.frame = CGRectMake(self.contentView.width/2, 0, self.contentView.width/2, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    NSArray *redirectItems = [dict objectForKey:[[self class] cellKeyForedRidrectItems]];
    if ([redirectItems isKindOfClass:[NSArray class]]) {
        
        for (NSInteger i=0;i<redirectItems.count;i++) {
            RedirectInfo *item = [redirectItems objectAtIndex:i];
            if (i==0) {
                [_itemView1 updateWithRedirectInfo:item];
                _itemView1.hidden = NO;
            } else {
                [_itemView2 updateWithRedirectInfo:item];
                _itemView2.hidden = NO;
            }
        }
    }
    
    [self setNeedsLayout];
}

@end


@interface BrandItemView ()
@property(nonatomic,strong) XMWebImageView *iconView;
@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UILabel *subTitleLbl;
@end

@implementation BrandItemView {
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:_titleLbl];
        
        _subTitleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _subTitleLbl.font = [UIFont systemFontOfSize:10.f];
        _subTitleLbl.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        [self addSubview:_subTitleLbl];
        
        _iconView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.clipsToBounds = YES;
        [self addSubview:_iconView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLbl.frame = CGRectMake(0, 0, self.width-20, 0);
    _subTitleLbl.frame = CGRectMake(0, 0, self.width-20, 0);
    [_titleLbl sizeToFit];
    [_subTitleLbl sizeToFit];
    
    CGFloat marginTop = (self.height-(_titleLbl.height+_subTitleLbl.height+3))/2;
    _titleLbl.frame = CGRectMake(self.width-10-_titleLbl.width, marginTop, _titleLbl.width, _titleLbl.height);
    marginTop += _titleLbl.height;
    marginTop += 3;
    _subTitleLbl.frame = CGRectMake(self.width-10-_subTitleLbl.width, marginTop, _subTitleLbl.width, _subTitleLbl.height);
    
    _iconView.frame = self.bounds;
}

- (void)updateWithRedirectInfo:(RedirectInfo*)item;
{
    self.redirectInfo = item;
    
    [_iconView setImageWithURL:item.imageUrl  placeholderImage:nil size:CGSizeMake(kScreenWidth, ( 90.f * kScreenWidth ) / 320.f*2) progressBlock:^(NSInteger receivedSize, NSInteger expectedSize) {
    } succeedBlock:^(UIImage *image, SDImageCacheType cacheType) {
        
    } failedBlock:nil];
    
//    
//    [_iconView setImageWithURL:item.imageUrl placeholderImage:nil size:CGSizeMake(kScreenWidth/2, 90) progressBlock:nil succeedBlock:nil failedBlock:nil];
    
    _titleLbl.text = item.title;
    _subTitleLbl.text = item.subTitle;
    
    [self setNeedsLayout];
}

@end




