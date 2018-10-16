//
//  MineTableViewCel.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MineTableViewCell.h"
#import "DataSources.h"
#import "GuideView.h"

@interface MineTableViewCell ()

@property(nonatomic,retain) UIImageView *iconView;
@property(nonatomic,retain) UILabel *titleLbl;
@property(nonatomic,retain) UIImageView *arrowView;
@property(nonatomic,retain) CALayer *bottomBorder;
@property(nonatomic,assign) CGFloat bottomLinePaddingLeft;

@end

@implementation MineTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([MineTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 36;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)title icon:(NSString*)icon bottomLinePaddingLeft:(CGFloat)paddingLeft {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[MineTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    if (icon)[dict setObject:icon forKey:@"icon"];
    [dict setObject:[NSNumber numberWithFloat:paddingLeft] forKey:@"paddingLeft"];
    return dict;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[MineTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    return dict;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    NSString *title = [dict stringValueForKey:@"title"];
    
    if ([title length]>0) {
        self.titleLbl.text = title;
    }
    NSString *icon = [dict stringValueForKey:@"icon"];
    if ([icon length]>0) {
        _iconView.image = [UIImage imageNamed:icon];
        _iconView.frame = CGRectMake(0, 0, _iconView.image.size.width, _iconView.image.size.height);
        _iconView.hidden = NO;
    } else {
        _iconView.hidden = YES;
    }
    
    _bottomLinePaddingLeft = [dict floatValueForKey:@"paddingLeft" defaultValue:0];
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginLeft = 15;
    if (![_iconView isHidden]) {
        _iconView.frame = CGRectMake(marginLeft, (self.height-_iconView.height)/2, _iconView.width, _iconView.height);
        marginLeft += _iconView.width;
        marginLeft += 10;
    }
    
    CGRect frame = self.arrowView.bounds;
    frame.origin.x = self.contentView.bounds.size.width-15-self.arrowView.bounds.size.width;
    frame.origin.y = (self.contentView.bounds.size.height-self.arrowView.bounds.size.height)/2;
    self.arrowView.frame = frame;
    
    self.titleLbl.frame = CGRectMake(marginLeft, 0, self.arrowView.frame.origin.x-15-25,self.contentView.bounds.size.height);
    
    self.bottomBorder.frame = CGRectMake(_bottomLinePaddingLeft, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-_bottomLinePaddingLeft, 1);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.hidden = YES;
        [self addSubview:_iconView];
        
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        self.titleLbl.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:self.titleLbl];
        
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow_gray"]];
        [self addSubview:self.arrowView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.borderColor = [UIColor colorWithHexString:@"F7F7F7"].CGColor;
        self.bottomBorder.borderWidth = 1.f;
        [self.contentView.layer addSublayer:self.bottomBorder];
        
        _bottomLinePaddingLeft = 0;
    }
    return self;
}

- (void)dealloc
{
    self.titleLbl = nil;
    self.arrowView = nil;
    [self.bottomBorder removeFromSuperlayer];
    self.bottomBorder = nil;
}

@end

