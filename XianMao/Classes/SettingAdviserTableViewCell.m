//
//  SettingAdviserTableViewCell.m
//  XianMao
//
//  Created by WJH on 16/12/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SettingAdviserTableViewCell.h"

@implementation SettingAdviserTableViewCell
{
    UILabel *_statusLbl;
    UILabel *_remindLbl;
    UISwitch *_newsSwith;
    CALayer * _bottomLine;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SettingAdviserTableViewCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 44.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SettingAdviserTableViewCell class]];
    if (title)[dict setObject:title forKey:@"title"];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _statusLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLbl.backgroundColor = [UIColor clearColor];
        _statusLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _statusLbl.font = [UIFont systemFontOfSize:13.f];
        [_statusLbl sizeToFit];

        _newsSwith = [[UISwitch alloc] initWithFrame:CGRectZero];
        _newsSwith.on = YES;
        _newsSwith.onTintColor = [DataSources colorf9384c];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
        
        [_newsSwith addTarget:self action:@selector(didNotificationSettingClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_newsSwith];
        
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    NSString *title = [dict stringValueForKey:@"title"];
    _statusLbl.text = title;
    NSNumber * swithStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"swithStatus"];
    _newsSwith.on = [swithStatus boolValue];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    _newsSwith.frame = CGRectMake(self.contentView.width - 60, 15.0-8, 60,30);
    [_statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _bottomLine.frame = CGRectMake(15, self.contentView.height-1, self.contentView.width-30, 1);
}

- (void)didNotificationSettingClick:(UISwitch *)sw
{
    NSNumber * swithStatus = [NSNumber numberWithBool:sw.on];
    [[NSUserDefaults standardUserDefaults] setObject:swithStatus forKey:@"swithStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"adviserSwithStatusNotification" object:swithStatus];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adviserSwithStatusNotification" object:nil];
}

@end
