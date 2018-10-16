//
//  ConsignCateTableViewCell.m
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ConsignCateTableViewCell.h"
#import "Cate.h"

@interface ConsignCateTableViewCell ()

@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) UIImageView *selectedIconView;
@property(nonatomic,assign) BOOL isSelected;

@end

@implementation ConsignCateTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ConsignCateTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 65;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(Cate*)cate selected:(BOOL)selected {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ConsignCateTableViewCell class]];
    if (cate)[dict setObject:cate forKey:@"cate"];
    [dict setObject:[NSNumber numberWithBool:selected] forKey:@"selected"];
    return dict;
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    Cate *cate = [dict objectForKey:@"cate"];
    if (cate) {
        _nameLbl.text = cate.name;
        _isSelected = [[dict objectForKey:@"selected"] boolValue];
        _nameLbl.textColor = _isSelected?[UIColor whiteColor]:[UIColor colorWithHexString:@"181818"];
        _nameLbl.backgroundColor = _isSelected?[UIColor colorWithHexString:@"7fd000"]:[UIColor whiteColor];
        _selectedIconView.image = _isSelected?[UIImage imageNamed:@"sale_cate_selected"]:[UIImage imageNamed:@"sale_cate_unselect"];
    }
    [self setNeedsDisplay];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _isSelected = NO;
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _nameLbl.font = [UIFont systemFontOfSize:17.f];
        _nameLbl.textColor = _isSelected?[UIColor whiteColor]:[UIColor colorWithHexString:@"181818"];
        _nameLbl.backgroundColor = _isSelected?[UIColor colorWithHexString:@"7fd000"]:[UIColor whiteColor];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLbl];
        
        CGSize size = [UIImage imageNamed:@"sale_cate_selected"].size;
        _selectedIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self.contentView addSubview:_selectedIconView];
    }
    return self;
}

- (void)dealloc {
    _nameLbl = nil;
    _selectedIconView = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _nameLbl.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 50);
    
    _selectedIconView.frame = CGRectMake(self.contentView.bounds.size.width-20-_selectedIconView.bounds.size.width, (50-_selectedIconView.bounds.size.height)/2, _selectedIconView.bounds.size.width, _selectedIconView.bounds.size.height);
}

@end






