//
//  PublishPromptCell.m
//  yuncangcat
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PublishPromptCell.h"

@interface PublishPromptCell ()

@property (nonatomic, strong) UILabel *promptLbl;

@end

@implementation PublishPromptCell

-(UILabel *)promptLbl{
    if (!_promptLbl) {
        _promptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _promptLbl.font = [UIFont systemFontOfSize:12.f];
        _promptLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        [_promptLbl sizeToFit];
    }
    return _promptLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishPromptCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 20.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellText:(NSString *)text;
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishPromptCell class]];
    if (text && text.length > 0) {
        [dict setObject:text forKey:@"text"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.contentView addSubview:self.promptLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView.mas_centerX);
//        make.centerY.equalTo(self.contentView.mas_centerY);
//    }];
    
    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSString *textStr = dict[@"text"];
    self.promptLbl.text = textStr;
}

@end
