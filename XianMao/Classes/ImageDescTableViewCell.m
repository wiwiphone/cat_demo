//
//  ImageDescTableViewCell.m
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ImageDescTableViewCell.h"

@interface ImageDescGroupTitleTableViewCell ()
@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UIImageView *expandIconView;
@end

@implementation ImageDescGroupTitleTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ImageDescGroupTitleTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44;//kScreenWidth*44.f/320.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(ImageDescGroup*)imageDescGroup {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ImageDescGroupTitleTableViewCell class]];
    if (imageDescGroup)[dict setObject:imageDescGroup forKey:[self cellDictKeyForImageDescGroup]];
    return dict;
}

+ (NSString*)cellDictKeyForImageDescGroup {
    return @"imageDescGroup";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _titleLbl.numberOfLines = 1;
        _titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLbl];
        
        UIImage *expandIcon = [UIImage imageNamed:@"title_expand_icon"];
        _expandIconView = [[UIImageView alloc] initWithImage:expandIcon];
        _expandIconView.backgroundColor = [UIColor clearColor];
        _expandIconView.hidden = YES;
        [self.contentView addSubview:_expandIconView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLbl.frame = CGRectNull;
    self.expandIconView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLbl.frame = CGRectMake(15, 0, kScreenWidth-30, self.contentView.height);
    _expandIconView.frame = CGRectMake(kScreenWidth-15-_expandIconView.width, (self.contentView.height-_expandIconView.height)/2, _expandIconView.width, _expandIconView.height);
    
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        ImageDescGroup *imageDescGroup = [dict objectForKey:[[self class] cellDictKeyForImageDescGroup]];
        if ([imageDescGroup isKindOfClass:[ImageDescGroup class]]) {
            
            if (imageDescGroup.isExpandable) {
                _expandIconView.hidden = NO;
                if (imageDescGroup.isExpanded) {
                    _expandIconView.image = [UIImage imageNamed:@"title_expand_icon"];
                } else {
                    _expandIconView.image = [UIImage imageNamed:@"title_unexpand_icon"];
                }
            } else {
                _expandIconView.hidden = YES;
            }
            _titleLbl.text = imageDescGroup.title;
            
            [self setNeedsLayout];
        }
    }
}

@end


@interface ImageDescTableViewCell ()
@property(nonatomic,strong) XMWebImageView *picView;
@property(nonatomic,strong) UILabel *picDescLbl;
@end

@implementation ImageDescTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ImageDescTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        ImageDescDO *imageDescDO = [dict objectForKey:[[self class] cellDictKeyForImageDescDO]];
        if ([imageDescDO isKindOfClass:[ImageDescDO class]]) {
            if ([imageDescDO.picItem.picUrl length]>0 && imageDescDO.picItem.width>0 && imageDescDO.picItem.height>0) {
                height += imageDescDO.picItem.height * kScreenWidth/imageDescDO.picItem.width;
            }
            if ([imageDescDO.picItem.picDescription length]>0) {
                if (height>0) {
                    height += 15;
                }
                CGSize size = [imageDescDO.picItem.picDescription sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
             
                height += size.height;
                height += 15;
            }
        }
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(ImageDescDO*)imageDescDO
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ImageDescTableViewCell class]];
    if (imageDescDO)[dict setObject:imageDescDO forKey:[self cellDictKeyForImageDescDO]];
    return dict;
}

+ (NSString*)cellDictKeyForImageDescDO {
    return @"imageDescDO";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _picView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _picView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_picView];
        
        _picDescLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _picDescLbl.font = [UIFont systemFontOfSize:12.f];
        _picDescLbl.textColor = [UIColor colorWithHexString:@"666666"];
        _picDescLbl.numberOfLines = 0;
        [self.contentView addSubview:_picDescLbl];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.picView.frame = CGRectNull;
    self.picDescLbl.frame = CGRectNull;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginTop = 0.f;
    _picView.frame = CGRectMake(0, 0, kScreenWidth, self.picView.height);
    marginTop += _picView.height;
    
    if ([_picDescLbl.text length]>0) {
        if (marginTop>0) {
            marginTop += 15;
        }
        _picDescLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, 0);
        [_picDescLbl sizeToFit];
        _picDescLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, _picDescLbl.height);
        marginTop += 15;
    }
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        ImageDescDO *imageDescDO = [dict objectForKey:[[self class] cellDictKeyForImageDescDO]];
        if ([imageDescDO isKindOfClass:[ImageDescDO class]]) {
            
            _picDescLbl.text = imageDescDO.picItem.picDescription;
            
            CGFloat height= 0.f;
            if ([imageDescDO.picItem.picUrl length]>0 && imageDescDO.picItem.width>0 && imageDescDO.picItem.height>0) {
                height = imageDescDO.picItem.height * kScreenWidth/imageDescDO.picItem.width;
            }
            self.picView.frame = CGRectMake(0, 0, kScreenWidth, height);
            
            [self.picView setImageWithURL:imageDescDO.picItem.picUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, kScreenWidth*height/320*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
            
            [self setNeedsLayout];
        }
    }
}

@end





