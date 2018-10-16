//
//  BuyBackCell.m
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BuyBackCell.h"
#import "Masonry.h"
#import "RTLabel.h"

@interface BuyBackCell ()<RTLabelDelegate>

@property (nonatomic,strong) RTLabel * titleLbl;

@end

@implementation BuyBackCell

-(RTLabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[RTLabel alloc] initWithFrame:CGRectZero];
        _titleLbl.delegate = self;
        _titleLbl.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLbl.font = [UIFont systemFontOfSize:12.0f];

    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BuyBackCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict{
    
//    CGFloat height = 5.f;
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
//    lbl.font = [UIFont systemFontOfSize:12.f];
//    lbl.text = title;
//    lbl.numberOfLines = 0;
//    CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-28, CGFLOAT_MAX)];
//    
//    height += size.height;
//    height += 5;
    
    
    NSString *title = dict[@"title"];
    NSString *tempStr = @"\n";
    BOOL isAllEnter = YES;
    int count = 0;
    for (int i = 0; i<title.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *temp = [title substringWithRange:range];
        if ([temp isEqualToString:tempStr]) {
            isAllEnter = NO;
            count++;
        }
    }
    
    
    if (isAllEnter) {
        NSString *title = dict[@"title"];
        CGFloat height = 5.f;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.font = [UIFont systemFontOfSize:12.f];
        lbl.text = title;
        lbl.numberOfLines = 0;
        CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-28, CGFLOAT_MAX)];
        
        height += size.height;
        height += 5;
        return height;
    }else{
        return 35 * count;
    }
    
    
//    return height;
}


+ (NSMutableDictionary*)buildCellTitle:(NSString *)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BuyBackCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

+ (NSMutableDictionary*)buildCellTitle:(NSString *)title withColor:(UIColor *)color
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BuyBackCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    if (color) {
        [dict setObject:color forKey:@"color"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(self.contentView.mas_left).offset(14);
//        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    

    if (dict[@"title"]) {
        NSString *title = dict[@"title"];
        self.titleLbl.text = title;
    }
    if (dict[@"color"]) {
        self.titleLbl.textColor = dict[@"color"];
    }
}

#pragma mark - RTlabelDegate

-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    

    if (self.rtLabelSelect) {
        self.rtLabelSelect(url);
    }
}

@end
