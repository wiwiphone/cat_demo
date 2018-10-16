//
//  RecoverBrandCell.m
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverBrandCell.h"
#import "Masonry.h"

@interface RecoverBrandCell ()

@end

@implementation RecoverBrandCell

-(BrandLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[BrandLabel alloc] initWithFrame:CGRectZero];
//        _nameLabel.font = [UIFont systemFontOfSize:13];
        [_nameLabel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _nameLabel.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _nameLabel.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _nameLabel.userInteractionEnabled = NO;
        
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverBrandCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [self rowHeightForPortrait];
}

+ (NSMutableDictionary*)buildCellDict:(RecoveryItem*)item andPreference:(RecoveryPreference *)preference
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverBrandCell class]];
    if (item)[dict setObject:item forKey:@"item"];
    if (preference)[dict setObject:preference forKey:@"preference"];
    return dict;
}

-(NSString *)itemForKey{
    return @"item";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        [self.contentView addSubview:self.nameLabel];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCell) name:@"chooseCell" object:nil];
    }
    return self;
}

-(void)chooseCell{
    self.nameLabel.layer.borderWidth = 1.0f;
    self.nameLabel.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    RecoveryItem *item = dict[[self itemForKey]];
    NSLog(@"%@", item.title);
//    self.nameLabel.text = item.title;
    [self.nameLabel setTitle:item.title forState:UIControlStateNormal];
    
    [self.contentView setNeedsDisplay];
}

@end

@implementation BrandLabel

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//- (void)drawTextInRect:(CGRect)rect {
//    //文字距离上下左右边框都有10单位的间隔
//    CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height - 20);
//    [super drawTextInRect:newRect];
//}

@end
