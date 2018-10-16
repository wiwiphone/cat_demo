//
//  SupportCell.m
//  XianMao
//
//  Created by WJH on 16/12/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SupportCell.h"
#import "WebViewController.h"

@interface SupportCell()

@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIImageView * arrowIcon;

@end

@implementation SupportCell

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jian"]];
    }
    return _icon;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor colorWithHexString:@"434342"];
        _title.text = @"本品支持爱丁猫鉴定服务";
        [_title sizeToFit];
    }
    return _title;
}

-(UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_new"]];
    }
    return _arrowIcon;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SupportCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 50.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SupportCell class]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.arrowIcon];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WebViewController * webView = [[WebViewController alloc] init];
    webView.url = @"http://activity.aidingmao.com/share/page/1091";
    [[CoordinatingController sharedInstance] pushViewController:webView animated:YES];
}

- (void)updateCellWithDict:(NSDictionary*)dict{
    
}

@end
