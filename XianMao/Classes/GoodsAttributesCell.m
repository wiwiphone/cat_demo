//
//  GoodsAttributesCell.m
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsAttributesCell.h"
#import "CoordinatingController.h"

#import "GoodsDetailInfo.h"
#import "DataSources.h"
#import "URLScheme.h"
#import "Command.h"

@interface GoodsAttributeItemView : TapDetectingView
@property(nonatomic,strong) UILabel *attrNameLbl;
@property(nonatomic,strong) UILabel *attrValueLbl;
@property(nonatomic,strong) UIImageView *helpImgView;
//@property(nonatomic,strong) CALayer *bottomLine;
@property(nonatomic,copy) NSString *helpURL;
@end

@implementation GoodsAttributeItemView

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _attrNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _attrNameLbl.font = [UIFont systemFontOfSize:13.5f];
        _attrNameLbl.textColor  =[UIColor colorWithHexString:@"888888"];
        _attrNameLbl.numberOfLines = 1;
        [self addSubview:_attrNameLbl];
        
        _attrValueLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _attrValueLbl.font = [UIFont systemFontOfSize:12.f];
        _attrValueLbl.textColor  =[UIColor colorWithHexString:@"888888"];
        _attrValueLbl.numberOfLines = 0;
        [self addSubview:_attrValueLbl];
        
        _helpImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sale_icon_question"]];
        _helpImgView.userInteractionEnabled = YES;
//        [self addSubview:_helpImgView];
        
//        _bottomLine = [CALayer layer];
//        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"].CGColor;
//        [self.layer addSublayer:_bottomLine];
        
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            if ([weakSelf.helpURL length]>0) {
//                [URLScheme locateWithHtml5Url:weakSelf.helpURL andIsShare:YES];
            }
        };
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginToRight = 0;
    if ([_helpURL length]>0) {
        marginToRight = 17.f+15+5;
    }
    
    _attrNameLbl.frame = CGRectMake(15, 0, _attrNameLbl.width, self.height);
    _attrValueLbl.frame = CGRectMake(kScreenWidth-15-_attrValueLbl.width, 2, kScreenWidth-25.f-_attrNameLbl.width-15-15-marginToRight, self.height-2);

//    _bottomLine.frame = CGRectMake(_attrValueLbl.left, self.height-1, self.width-15-_attrValueLbl.left, 1);
    
//    _helpImgView.frame = CGRectMake(self.width-15-17, (self.height-17)/2, 17, 17);
}

- (void)updateWithAttrItem:(GoodsAttributeItem*)item attrNameWidth:(CGFloat)attrNameWidth hideBottomLine:(BOOL)hideBottomLine
{
    _attrNameLbl.text = item.attrName;
    NSLog(@"item.attrName  = %@",item.attrName);
    _attrNameLbl.frame = CGRectMake(25, 0, attrNameWidth, self.height);
    _attrValueLbl.text = item.attrValue;
    [_attrValueLbl sizeToFit];
    _attrValueLbl.frame = CGRectMake(kScreenWidth-15-_attrValueLbl.width, 2, _attrValueLbl.width, self.height-2);
//    _bottomLine.hidden = hideBottomLine;
    
    if ([item isKindOfClass:[GoodsAttributeItemWithHelpURL class]]) {
        _helpURL = ((GoodsAttributeItemWithHelpURL*)item).helpURL;
        _helpImgView.hidden = NO;
    } else {
        _helpURL = nil;
        _helpImgView.hidden = YES;
    }
    
    [self setNeedsDisplay];
}

+ (CGFloat)heightForOrientationPortrait:(GoodsAttributeItem*)attrItem attrNameWidth:(CGFloat)attrNameWidth
{
    CGFloat marginToRight = 0;
    if ([attrItem isKindOfClass:[GoodsAttributeItemWithHelpURL class]]) {
        marginToRight = 17.f+15+5;
    }
    CGFloat height = [attrItem.attrValue sizeWithFont:[UIFont systemFontOfSize:12.f]
                              constrainedToSize:CGSizeMake(kScreenWidth-25.f-attrNameWidth-15-15-marginToRight,MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping].height;
    if (height<31.f) {
        height = 31.f;
        if (height>24) {
            height = 31.f+8;
        }
    } else {
        height += 8;
    }
    return height;
}

@end



@interface GoodsAttributesCell ()
@property(nonatomic,strong) UIView *attrItemsView;
@property(nonatomic,strong) NSArray *attrItems;
@end

@implementation GoodsAttributesCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsAttributesCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    NSArray *items = [dict objectForKey:[self cellDictKeyForAttributeItems]];
    if ([items isKindOfClass:[NSArray class]]) {
        for (GoodsAttributeItem *item in items) {
            height += [GoodsAttributeItemView heightForOrientationPortrait:item attrNameWidth:[[dict objectForKey:[self cellDictKeyForAttrNameWidth]] floatValue]];
        }
    }
    height += 10;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray*)items
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsAttributesCell class]];
    if (items)[dict setObject:items forKey:[self cellDictKeyForAttributeItems]];
    UIFont *attrNameFont = [UIFont systemFontOfSize:13.5f];
    CGFloat attrNameWidth = 0;
    for (GoodsAttributeItem *item in items) {
        CGFloat width = [item.attrName sizeWithFont:attrNameFont
            constrainedToSize:CGSizeMake(kScreenWidth-25.f-15,MAXFLOAT)
                lineBreakMode:NSLineBreakByWordWrapping].width;
        if (width>attrNameWidth) {
            attrNameWidth = width;
        }
    }
    [dict setObject:[NSNumber numberWithFloat:attrNameWidth] forKey:[self cellDictKeyForAttrNameWidth]];
    return dict;
}

+ (NSString*)cellDictKeyForAttributeItems {
    return @"items";
}

+ (NSString*)cellDictKeyForAttrNameWidth {
    return @"attrNameWidth";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _attrItemsView = [[UIView alloc] initWithFrame:CGRectNull];
        _attrItemsView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_attrItemsView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.attrItemsView.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.attrItemsView.frame = self.contentView.bounds;
    
    CGFloat marginTop = 0.f;
    
    for (UIView *view in [self.attrItemsView subviews]) {
        if (![view isHidden]) {
            view.frame = CGRectMake(0, marginTop, kScreenWidth, view.height);
            marginTop += view.height;
        }
    }
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    CGFloat attrNameWidth = [[dict objectForKey:[[self class] cellDictKeyForAttrNameWidth]] floatValue];
    NSArray *attrItems = [dict objectForKey:[[self class] cellDictKeyForAttributeItems]];
    if ([attrItems isKindOfClass:[NSArray class]]) {
        
        NSInteger count = [self.attrItemsView subviews].count;
        for (NSInteger i=count;i<[attrItems count];i++) {
            GoodsAttributeItemView *itemView = [[GoodsAttributeItemView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            [self.attrItemsView addSubview:itemView];
        }
        
        for (UIView *view in [self.attrItemsView subviews]) {
            view.hidden = YES;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[attrItems count]];
        for (NSInteger i=0;i< [attrItems count];i++) {
            GoodsAttributeItem *attrItem = [attrItems objectAtIndex:i];
            if ([attrItem.attrName length]>0 && [attrItem.attrValue length]>0) {
                [array addObject:attrItem];
            }
        }
        
        for (NSInteger i=0;i< [array count];i++) {
            GoodsAttributeItem *attrItem = [array objectAtIndex:i];
            GoodsAttributeItemView *itemView = [[self.attrItemsView subviews] objectAtIndex:i];
            itemView.hidden = NO;
            itemView.frame = CGRectMake(0, 0, kScreenWidth, [GoodsAttributeItemView heightForOrientationPortrait:attrItem attrNameWidth:attrNameWidth]);
            [itemView updateWithAttrItem:attrItem attrNameWidth:attrNameWidth hideBottomLine:i==array.count-1?YES:NO];
            if (i<array.count-1) {
                UIView *segView = [[UIView alloc] initWithFrame:CGRectMake(15, itemView.bottom*(i+1), kScreenWidth - 30, 0)];
                segView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
                [self.contentView addSubview:segView];
            }
        }
        
        [self setNeedsLayout];
    }
}

+ (NSMutableAttributedString*)attrStringWithAttrItem:(GoodsAttributeItem*)attrItem {
    NSString *attrName = [NSString stringWithFormat:@"%@: ",attrItem.attrName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",attrName,attrItem.attrValue]];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, attrName.length)];
    return attrString;
}

@end




