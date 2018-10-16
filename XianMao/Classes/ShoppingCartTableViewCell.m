//
//  ShoppingCartTableViewCell.m
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"
#import "ShoppingCartItem.h"
#import "GoodsInfo.h"
#import "Command.h"

#import "DataSources.h"

@interface ShoppingCartTableViewCell ()

@property(nonatomic,strong) UIButton *selectedBtn;
@property(nonatomic,strong) XMWebImageView *thumbView;
@property(nonatomic,strong) UILabel *maskView;
@property(nonatomic,strong) UILabel *goodsNameLbl;
@property(nonatomic,strong) UILabel *approveTagDescLbl;
@property(nonatomic,strong) UILabel *shopPriceLbl;
@property(nonatomic,strong) CALayer *bottomLine;
@property(nonatomic,strong) UIView *marketLine;
@property(nonatomic,strong) UILabel *changePrice;
@property(nonatomic,strong) TapDetectingImageView * delBtn;
@property(nonatomic,strong) ShoppingCartItem *item;
@property(nonatomic,strong) UIView * containerView;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong) UILabel *loseLbl;
@property(nonatomic,strong) UILabel *marketlbl;

@end

@implementation ShoppingCartTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ShoppingCartTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 110;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem*)item {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ShoppingCartTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForShoppingCartItem]];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:[self cellDictKeyForSeleted]];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:[self cellDictKeyForInEdit]];
    return dict;
}

+ (NSString*)cellDictKeyForShoppingCartItem {
    return @"item";
}

+ (NSString*)cellDictKeyForSeleted {
    return @"seleted";
}

+ (NSString *)cellDictKeyForInEdit
{
    return @"delbtn";
}

//+ (NSString*)cellDictKeyForSeletedInEditMode {
//    return @"seletedInEditMode";
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _selectedBtn = [[UIButton alloc] initWithFrame:CGRectNull];
        [_selectedBtn setImage:[UIImage imageNamed:@"shopping_cart_uncgoose_new"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"shopping_cart_choosed_new"] forState:UIControlStateSelected];
        [_selectedBtn addTarget:self action:@selector(handleSelected:) forControlEvents:UIControlEventTouchUpInside];
        _selectedBtn.backgroundColor = [DataSources globalClearColor];
        [self.contentView addSubview:_selectedBtn];
        
        _thumbView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _thumbView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _thumbView.userInteractionEnabled  =YES;
        _thumbView.clipsToBounds = YES;
        _thumbView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_thumbView];
        
        _loseLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _loseLbl.text = @"失效";
        _loseLbl.layer.masksToBounds = YES;
        _loseLbl.layer.cornerRadius = 3;
        _loseLbl.textColor = [UIColor whiteColor];
        _loseLbl.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
        _loseLbl.font = [UIFont systemFontOfSize:10];
        _loseLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_loseLbl];

        
        _maskView = [[UILabel alloc] initWithFrame:CGRectNull];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _maskView.font = [UIFont systemFontOfSize:14.f];
        _maskView.hidden = YES;
        _maskView.text = @"已失效";
        _maskView.textAlignment = NSTextAlignmentCenter;
        _maskView.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_maskView];
        
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _goodsNameLbl.font = [UIFont systemFontOfSize:12.f];
        _goodsNameLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _goodsNameLbl.textAlignment = NSTextAlignmentLeft;
        _goodsNameLbl.numberOfLines = 2;
        [_goodsNameLbl sizeToFit];
        [self.contentView addSubview:_goodsNameLbl];
        
        _approveTagDescLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _approveTagDescLbl.font = [UIFont systemFontOfSize:14.f];
        _approveTagDescLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        [_approveTagDescLbl sizeToFit];
        [self.contentView addSubview:_approveTagDescLbl];
        
        _shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _shopPriceLbl.font = [UIFont systemFontOfSize:14.f];
        _shopPriceLbl.textColor = [DataSources colorf9384c];
        [_shopPriceLbl sizeToFit];
        [self.contentView addSubview:_shopPriceLbl];
        
        _marketlbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketlbl.font = [UIFont systemFontOfSize:14.f];
        _marketlbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_marketlbl sizeToFit];
        [self.contentView addSubview:_marketlbl];
        
        _changePrice = [[UILabel alloc] init];
        _changePrice.font = [UIFont systemFontOfSize:10.0f];
        _changePrice.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_changePrice sizeToFit];
        [self.contentView addSubview:self.changePrice];
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
    
        self.bottomLine = [CALayer layer];
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:self.bottomLine];
        
        self.marketLine = [[UIView alloc] init];
        self.marketLine.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
        [self.marketlbl addSubview:self.marketLine];
        
        _delBtn = [[TapDetectingImageView alloc] initWithFrame:CGRectZero];
        _delBtn.image = [UIImage imageNamed:@"shopping_cart_delBtn"];
        WEAKSELF;
        _delBtn.handleSingleTapDetected = ^(TapDetectingImageView * view,UIGestureRecognizer * tgr){
            
            if (weakSelf.delGoodsBlock) {
                weakSelf.delGoodsBlock(weakSelf,weakSelf.index);
            }
        };
        [self.contentView addSubview:self.delBtn];
        
        
    }
    return self;
}

- (void)dealloc {
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    _selectedBtn.frame = CGRectNull;
    _thumbView.frame = CGRectNull;
    _maskView.frame = CGRectNull;
    _goodsNameLbl.frame = CGRectNull;
    _approveTagDescLbl.frame = CGRectNull;
    _shopPriceLbl.frame = CGRectNull;
    _bottomLine.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginLeft = 0.f;
    
    _selectedBtn.frame = CGRectMake(marginLeft, 0, 40, self.contentView.bounds.size.height);
    marginLeft += _selectedBtn.bounds.size.width;
    
    _thumbView.frame = CGRectMake(marginLeft, (self.contentView.bounds.size.height-86)/2, 86, 86);
    _maskView.frame = _thumbView.frame;
    marginLeft += _thumbView.bounds.size.width;
    marginLeft += 14.f;
    
    [self.loseLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thumbView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(7);
        make.right.equalTo(self.thumbView.mas_left).offset(-7);
    }];
    
    [self.shopPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thumbView.mas_bottom);
        make.left.equalTo(self.thumbView.mas_right).offset(8);
    }];
    
    [self.approveTagDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thumbView.mas_bottom);
        make.left.equalTo(self.thumbView.mas_right).offset(14);
    }];
    
    [self.goodsNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thumbView.mas_top);
        make.left.equalTo(self.thumbView.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
    [self.changePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbView.mas_right).offset(8);
        make.bottom.equalTo(self.shopPriceLbl.mas_top).offset(-8);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thumbView.mas_centerY);
        make.left.equalTo(self.thumbView.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.height.mas_equalTo(15);
    }];
    
    [self.marketlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopPriceLbl.mas_centerY);
        make.left.equalTo(self.shopPriceLbl.mas_right).offset(18);
    }];
    
    [self.marketLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.marketlbl.mas_centerY);
        make.left.and.right.equalTo(self.marketlbl);
        make.height.equalTo(@1);
    }];
    
    _bottomLine.frame = CGRectMake(12, self.contentView.bounds.size.height-0.5f, self.contentView.bounds.size.width-12, 0.5f);

}

- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index {
    
    self.index = index;
    
    id obj = [dict objectForKey:[[self class] cellDictKeyForShoppingCartItem]];
    BOOL isSeleted = [dict boolValueForKey:[[self class] cellDictKeyForSeleted] defaultValue:NO];
    //BOOL isSeletedInEditMode = [dict boolValueForKey:[[self class] cellDictKeyForSeletedInEditMode] defaultValue:NO];
    if ([obj isKindOfClass:[ShoppingCartItem class]]) {
        ShoppingCartItem *item = (ShoppingCartItem*)obj;
        self.item = item;
        //self.contentView.backgroundColor = isSeletedInEditMode?[UIColor colorWithHexString:@"F3F3F3"]:[UIColor whiteColor];
        
        _selectedBtn.selected = isSeleted;
        
        if ([item isOnSale]) {
            _loseLbl.hidden = YES;
            _selectedBtn.hidden = NO;
        }else{
            _loseLbl.hidden = NO;
            _selectedBtn.hidden = YES;
        }
        
        _maskView.text = [item statusDescription];
        
        _goodsNameLbl.text = item.goodsName;
//        _approveTagDescLbl.text = [NSString stringWithFormat:@"%@",item.gradeTag.name];
        _shopPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",item.shopPrice];
        if (item.marketPrice > 0) {
            _marketlbl.hidden = NO;
            _marketLine.hidden = NO;
            _marketlbl.text = [NSString stringWithFormat:@"%.2f",item.marketPrice];
        }else{
            _marketlbl.hidden = YES;
            _marketLine.hidden = YES;
        }
        if ((item.last_shop_price - item.shopPrice) > 0) {
            _changePrice.text = [NSString stringWithFormat:@"降价了%.2f",(item.last_shop_price - item.shopPrice)];
            _changePrice.textColor = [UIColor colorWithHexString:@"f4433e"];
        }else if ((item.last_shop_price - item.shopPrice) == 0){
            _changePrice.hidden = YES;
        }else if ((item.last_shop_price - item.shopPrice) < 0){

            _changePrice.hidden = YES;
        }else{
            _changePrice.hidden = NO;
        }
        
        if ([GoodsInfo goodsStatusIsOnSale:item.status]) {
            _maskView.hidden = YES;
        } else {
            _maskView.hidden = NO;
        }

        [_thumbView setImageWithURL:item.thumbUrl placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale480x480];
        BOOL isEditing = [dict boolValueForKey:[[self class] cellDictKeyForInEdit] defaultValue:YES];
        _delBtn.hidden = isEditing;
        _shopPriceLbl.hidden = !isEditing;
        
        int j = 0;
        for (UILabel *lbl in self.containerView.subviews) {
            if (lbl.tag == j+10000) {
                [lbl removeFromSuperview];
            }
            j++;
        }
        CGFloat margin = 0;
        for (int i = 0; i < item.serviceGiftList.count; i++) {
            NSString *titile = item.serviceGiftList[i];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
            lbl.tag = i+10000;
            lbl.font = [UIFont systemFontOfSize:9.f];
            lbl.textColor = [UIColor whiteColor];
            lbl.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = titile;
            [lbl sizeToFit];
            [self.containerView addSubview:lbl];
            lbl.frame = CGRectMake(margin, 0, lbl.width+4, lbl.height+4);
            margin += lbl.width+5;
            if (margin > self.containerView.width) {
                break;
            }
        }
        
    }
    [self setNeedsLayout];
}

- (void)handleSelected:(UIButton*)sender
{
    if (_selectedHandlerBlock) {
        _selectedHandlerBlock(self, self.index);
    }
}

@end


@implementation ShoppingCartSegCell


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ShoppingCartSegCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 0.5;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem*)item {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ShoppingCartSegCell class]];
    return dict;
}

+ (NSString*)cellDictKeyForShoppingCartItem {
    return @"item";
}

+ (NSString*)cellDictKeyForSeleted {
    return @"seleted";
}

//+ (NSString*)cellDictKeyForSeletedInEditMode {
//    return @"seletedInEditMode";
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
        
    }
    return self;
}


//- (void)prepareForReuse {
//    [super prepareForReuse];
//    self.contentView.backgroundColor = [UIColor grayColor];
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//}

//- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index {
//    
////    [self setNeedsLayout];
//}

@end
