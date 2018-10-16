//
//  GoodsDetailStoryCell.m
//  XianMao
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsDetailStoryCell.h"
#import "GoodsInfo.h"
#import "GoodsGalleryGridCell.h"
#import "DataSources.h"

@interface GoodsDetailStoryCell ()

@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UILabel *summaryLbl;
@property (nonatomic, strong) GoodsInfo *goodsInfo;

@end

@implementation GoodsDetailStoryCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailStoryCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    NSObject *obj = [dict objectForKey:[self cellDictKeyForGoodsInfo]];
    if ([obj isKindOfClass:[GoodsInfo class]]) {
        GoodsInfo *item = (GoodsInfo*)obj;
        height = [GoodsDetailStoryCell calculateHeightAndLayoutSubviews:nil item:item];
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailStoryCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"item";
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"282828"];
        

        _summaryLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _summaryLbl.textColor = [UIColor colorWithHexString:@"999999"];//[UIColor colorWithHexString:@"999999"];
        _summaryLbl.font = [UIFont systemFontOfSize:13.f];
//        _summaryLbl.numberOfLines = 0;
        [self.contentView addSubview:_summaryLbl];
        


    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    

//    _summaryLbl.frame = CGRectZero;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [[self class] calculateHeightAndLayoutSubviews:self item:nil];
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(GoodsDetailStoryCell*)cell item:(GoodsInfo*)goodsInfo
{
    CGFloat marginTop = 0.f;
    
    
    CGSize summarySize = CGSizeZero;
    NSString *summary = goodsInfo?goodsInfo.summary:cell.summaryLbl.text;
    if ([summary length]>0) {
        marginTop += 5;
        summarySize = [summary sizeWithFont:[UIFont systemFontOfSize:14.f]
                          constrainedToSize:CGSizeMake(kScreenWidth-50,MAXFLOAT)
                              lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"----------%.2f", summarySize.height);
        if (cell) {
            cell.summaryLbl.frame = CGRectMake(20, marginTop, kScreenWidth-40, summarySize.height);
            cell.summaryLbl.numberOfLines = 0;
        }
        
        marginTop += summarySize.height;
        marginTop += 10.f;
    }

    return marginTop;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
            
            self.goodsInfo = goodsInfo;
            
            _summaryLbl.text = goodsInfo.summary;
//            _summaryLbl.numberOfLines = 0;
            [self setNeedsLayout];
        }
    }
}

@end
