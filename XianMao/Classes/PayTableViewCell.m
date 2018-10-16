//
//  PayTableViewCell.m
//  XianMao
//
//  Created by simon on 12/21/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "PayTableViewCell.h"
#import "ShoppingCartItem.h"

#import "DataSources.h"

#import "GoodsInfo.h"

@interface PayTableViewCell ()

@property(nonatomic,strong) XMWebImageView *thumbView;
@property(nonatomic,strong) UILabel *goodsNameLbl;
@property(nonatomic,strong) UILabel *approveTagDescLbl;
@property(nonatomic,strong) UILabel *shopPriceLbl;
@property(nonatomic,strong) CALayer *bottomLine;

@property(nonatomic,assign) NSInteger index;
@property (nonatomic, strong) UIImageView *determineImageView;
@property (nonatomic, strong) UIImageView *washImageView;

@end

@implementation PayTableViewCell

-(UIImageView *)washImageView{
    if (!_washImageView) {
        _washImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _washImageView.image = [UIImage imageNamed:@"Wrist_Determine"];
        [_washImageView sizeToFit];
    }
    return _washImageView;
}

-(UIImageView *)determineImageView{
    if (!_determineImageView) {
        _determineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _determineImageView.image = [UIImage imageNamed:@"Wrist_Determine"];
        [_determineImageView sizeToFit];
    }
    return _determineImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PayTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 102;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem*)item {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PayTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForShoppingCartItem]];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:[self cellDictKeyForSeleted]];
    return dict;
}

+ (NSString*)cellDictKeyForShoppingCartItem {
    return @"item";
}

+ (NSString*)cellDictKeyForSeleted {
    return @"seleted";
}

+ (NSString*)cellDictKeyForSeletedInEditMode {
    return @"seletedInEditMode";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor orangeColor];
        _thumbView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _thumbView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _thumbView.userInteractionEnabled  =YES;
        [self.contentView addSubview:_thumbView];
        
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _goodsNameLbl.font = [UIFont systemFontOfSize:15.f];
        _goodsNameLbl.textColor = [DataSources globalBlackColor];
        _goodsNameLbl.textAlignment = NSTextAlignmentLeft;
        _goodsNameLbl.numberOfLines = 1;
        [self.contentView addSubview:_goodsNameLbl];
        
        _approveTagDescLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _approveTagDescLbl.font = [UIFont systemFontOfSize:15.f];
        _approveTagDescLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        [self.contentView addSubview:_approveTagDescLbl];
        
        _shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _shopPriceLbl.font = [UIFont systemFontOfSize:14.f];
        _shopPriceLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        [self.contentView addSubview:_shopPriceLbl];
        
        [self.contentView addSubview:self.determineImageView];
        [self.contentView addSubview:self.washImageView];
        self.washImageView.hidden = YES;
        
        self.bottomLine = [CALayer layer];
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        [self.layer addSublayer:self.bottomLine];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWashImage:) name:@"showXihuIcon" object:nil];
    }
    return self;
}

-(void)showWashImage:(NSNotification *)notify{
    NSInteger isShow = ((NSNumber *)(notify.object)).integerValue;
    if (isShow == 1) {
        self.washImageView.hidden = NO;
    } else {
        self.washImageView.hidden = YES;
    }
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showXihuIcon" object:nil];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    _thumbView.frame = CGRectNull;
    _goodsNameLbl.frame = CGRectNull;
    _approveTagDescLbl.frame = CGRectNull;
    _shopPriceLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginLeft = 0.f;
    marginLeft += 15.f;
    
    _thumbView.frame = CGRectMake(marginLeft, (self.contentView.bounds.size.height-65)/2, 65, 65);
    marginLeft += _thumbView.bounds.size.width;
    marginLeft += 14.f;
    
    CGFloat height = _thumbView.frame.origin.y+_thumbView.bounds.size.height;
    
    [_shopPriceLbl sizeToFit];
    _shopPriceLbl.frame = CGRectMake(self.contentView.bounds.size.width-13-_shopPriceLbl.bounds.size.width, _thumbView.frame.origin.y, _shopPriceLbl.bounds.size.width, _shopPriceLbl.bounds.size.height);//height-_shopPriceLbl.bounds.size.height
    
    _goodsNameLbl.frame = CGRectMake(marginLeft, _thumbView.frame.origin.y+2, self.contentView.bounds.size.width-marginLeft-13, 0);
    [_goodsNameLbl sizeToFit];
    _goodsNameLbl.frame = CGRectMake(marginLeft, _thumbView.frame.origin.y+2, self.contentView.bounds.size.width-marginLeft-_shopPriceLbl.width, _goodsNameLbl.bounds.size.height);
    
    _approveTagDescLbl.frame = CGRectMake(marginLeft, _goodsNameLbl.bottom+7, _shopPriceLbl.frame.origin.x-15-marginLeft, _shopPriceLbl.bounds.size.height);
    
    self.determineImageView.frame = CGRectMake(marginLeft, _thumbView.bottom-self.determineImageView.height, self.determineImageView.width, self.determineImageView.height);
    self.washImageView.frame = CGRectMake(self.determineImageView.right + 6, _thumbView.bottom-self.washImageView.height, self.washImageView.width, self.washImageView.height);
    
    _bottomLine.frame = CGRectMake(12, self.contentView.bounds.size.height-0.5f, self.contentView.bounds.size.width-24, 0.5f);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    id obj = [dict objectForKey:[[self class] cellDictKeyForShoppingCartItem]];
    BOOL isSeletedInEditMode = [dict boolValueForKey:[[self class] cellDictKeyForSeletedInEditMode] defaultValue:NO];
    if ([obj isKindOfClass:[ShoppingCartItem class]]) {
        ShoppingCartItem *item = (ShoppingCartItem*)obj;
        
        self.contentView.backgroundColor = isSeletedInEditMode?[UIColor colorWithHexString:@"F3F3F3"]:[UIColor whiteColor];
        
        _goodsNameLbl.text = item.goodsName;
        if (item.gradeTag && [item.gradeTag.value length]>0) {
            _approveTagDescLbl.text = [NSString stringWithFormat:@"成色：%@",item.gradeTag.name];
        } else {
            _approveTagDescLbl.text = @" ";
        }
        _shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",item.shopPrice];
        
         [_thumbView setImageWithURL:item.thumbUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale480x480];
    }
    [self setNeedsLayout];
}

@end

