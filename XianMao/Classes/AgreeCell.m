//
//  AgreeCell.m
//  yuncangcat
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AgreeCell.h"
#import "TTTAttributedLabel.h"
#import "Command.h"

@interface AgreeCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *titleLbl;
@property (nonatomic, strong) CommandButton *agreeBtn;

@end

@implementation AgreeCell

-(CommandButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
    }
    return _agreeBtn;
}

-(TTTAttributedLabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:11.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"282828"];
        _titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLbl.userInteractionEnabled = YES;
        _titleLbl.linkAttributes = nil;
        _titleLbl.highlightedTextColor = [UIColor colorWithHexString:@"ac7e33"];
        [_titleLbl setText:@"已阅读并同意《爱丁猫商品售卖协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(mutableAttributedString.length-11,11);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"ac7e33"] CGColor] range:stringRange];
            return mutableAttributedString;
        }];
        _titleLbl.delegate = self;
        [_titleLbl addLinkToURL:[NSURL URLWithString:@"http://activity.aidingmao.com/share/page/63"] withRange:NSMakeRange([_titleLbl.text length]-11,11)];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([AgreeCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    return 20;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AgreeCell class]];
    
    return dict;
}



@end
