//
//  GoodsAboutDescCell.m
//  XianMao
//
//  Created by WJH on 16/10/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsAboutDescCell.h"

@interface GoodsAboutDescCell ()

@property (nonatomic, strong) UILabel *Lbl;

@end

@implementation GoodsAboutDescCell

-(UILabel *)Lbl{
    if (!_Lbl) {
        _Lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _Lbl.font = [UIFont systemFontOfSize:14.f];
        _Lbl.textColor = [UIColor colorWithHexString:@"999999"];
        _Lbl.numberOfLines = 0;
        [_Lbl sizeToFit];
    }
    return _Lbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsAboutDescCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    NSString *contentText = dict[@"contentText"];
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:14.f];
    lbl.numberOfLines = 0;
    lbl.text = contentText;
    lbl.frame = CGRectMake(12, 12, kScreenWidth-24, 30);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:lbl.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];//行距的大小
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lbl.text.length)];
    lbl.attributedText = attributedString;
    [lbl sizeToFit];
    lbl.frame = CGRectMake(50, 12, kScreenWidth-24, lbl.height);
    height += (lbl.height + 24);
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)contentText
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsAboutDescCell class]];
    if (contentText)[dict setObject:contentText forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"contentText";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.Lbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    if (dict[@"contentText"]) {
        NSString *contentText = dict[@"contentText"];
        self.Lbl.text = contentText;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.Lbl.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:10];//行距的大小
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.Lbl.text.length)];
        self.Lbl.attributedText = attributedString;
    }
}

@end
