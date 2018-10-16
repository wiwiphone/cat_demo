//
//  CategoryCell.m
//  XianMao
//
//  Created by simon cai on 11/12/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "DataSources.h"

@interface CategoryTableViewCell ()

@property(nonatomic,retain) UIImageView *iconView;
@property(nonatomic,retain) UILabel *cateNameLbl;
@property(nonatomic,retain) CALayer *bottomBorder;

@end

@implementation CategoryTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([CategoryTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 51.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)imageName title:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[CategoryTableViewCell class]];
    if (imageName) [dict setObject:imageName forKey:@"imageName"];
    if (title) [dict setObject:title forKey:@"title"];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:self.iconView];
        
        self.cateNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.cateNameLbl.font = [UIFont systemFontOfSize:16.f];
        self.cateNameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        [self.contentView addSubview:self.cateNameLbl];
        
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.borderColor = [UIColor colorWithHexString:@"F7F7F7"].CGColor;
        self.bottomBorder.borderWidth = 1.f;
        [self.contentView.layer addSublayer:self.bottomBorder];

    }
    return self;
}

- (void)dealloc
{
    self.iconView = nil;
    self.cateNameLbl = nil;
    [self.bottomBorder removeFromSuperlayer];
    self.bottomBorder = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(15, (self.contentView.bounds.size.height-self.imageView.image.size.height)/2, self.imageView.image.size.width, self.imageView.image.size.height);
    
    CGFloat X = self.imageView.frame.origin.x+self.imageView.bounds.size.width+15;
    self.cateNameLbl.frame = CGRectMake(X, 0, self.contentView.bounds.size.width-X, self.contentView.bounds.size.height);
    
    self.bottomBorder.frame = CGRectMake(X, self.contentView.bounds.size.height-1, self.cateNameLbl.bounds.size.width, 1);
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        [dict stringValueForKey:@"imageName"];
        self.imageView.image = [UIImage imageNamed:[dict stringValueForKey:@"imageName"]];
        self.cateNameLbl.text = [dict stringValueForKey:@"title"];
    }
}

@end


