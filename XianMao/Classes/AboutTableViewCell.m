//
//  AboutTableViewCell.m
//  XianMao
//
//  Created by darren on 15/1/23.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "AboutTableViewCell.h"
#import "DataSources.h"

@interface AboutTableViewCell()

@property(nonatomic,retain) UILabel *titleLbl;
@property(nonatomic,retain) UIImageView *arrowView;
@property(nonatomic,retain) CALayer *bottomBorder;

@end

@implementation AboutTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([AboutTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 60;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AboutTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    return dict;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    NSString *title = [dict stringValueForKey:@"title"];
    if (title) {
        self.titleLbl.text = title;
    }
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.arrowView.bounds;
    frame.origin.x = self.contentView.bounds.size.width-15-self.arrowView.bounds.size.width;
    frame.origin.y = (self.contentView.bounds.size.height-self.arrowView.bounds.size.height)/2;
    self.arrowView.frame = frame;
    
    self.titleLbl.frame = CGRectMake(25, 0, self.arrowView.frame.origin.x-15-25,self.contentView.bounds.size.height);
    
    self.bottomBorder.frame = CGRectMake(0, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width, 1);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = [UIColor colorWithHexString:@"000"];
        self.titleLbl.font = [UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:self.titleLbl];
        
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_new"]];
        [self addSubview:self.arrowView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.borderColor = [UIColor colorWithHexString:@"fafafa"].CGColor;
        self.bottomBorder.borderWidth = 1.f;
        [self.contentView.layer addSublayer:self.bottomBorder];
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
