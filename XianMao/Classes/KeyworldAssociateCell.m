//
//  KeyworldAssociateCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "KeyworldAssociateCell.h"

@interface KeyworldAssociateCell()
@property (nonatomic,strong) UILabel * keyworlds;

@end

@implementation KeyworldAssociateCell

-(UILabel *)keyworlds
{
    if (!_keyworlds) {
        _keyworlds = [[UILabel alloc] init];
        _keyworlds.textColor = [UIColor colorWithHexString:@"999999"];
        _keyworlds.font = [UIFont systemFontOfSize:15];
        [_keyworlds sizeToFit];
    }
    return _keyworlds;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.keyworlds];
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([KeyworldAssociateCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 42;
    
    return height;
}

+(NSString *)cellDictKeyForKeyworlds
{
    return @"keyworlds";
}


+(NSMutableDictionary *)buildCellDict:(NSString *)keyworlds searchKeyworlds:(NSString *)searchKeyworlds
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[KeyworldAssociateCell class]];
    if (keyworlds) {
        [dict setObject:keyworlds forKey:[KeyworldAssociateCell cellDictKeyForKeyworlds]];
    }
    
    if (searchKeyworlds) {
        [dict setObject:searchKeyworlds forKey:@"searchKeyworlds"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    NSString * keyworld = [dict objectForKey:[KeyworldAssociateCell cellDictKeyForKeyworlds]];
    NSString * searchKeyworlds = [dict objectForKey:@"searchKeyworlds"];
    if (keyworld) {
        _keyworlds.text = keyworld;
    }
    
    if (searchKeyworlds) {
        
        if([_keyworlds.text rangeOfString:[NSString stringWithFormat:@"%@",searchKeyworlds]].location !=NSNotFound)
        {
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_keyworlds.text]];
            NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",searchKeyworlds]];
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
            
            _keyworlds.attributedText=hintString;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.keyworldsDidSelected) {
        self.keyworldsDidSelected(self.keyworlds.text);
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.keyworlds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(30);
    }];
}

@end
