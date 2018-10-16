//
//  InformationCell.m
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "InformationCell.h"
#import "NSDate+Category.h"


@interface InformationCell()

@property (nonatomic,strong) XMWebImageView * icon;
@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UILabel * detail;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UIView * line;

@end

@implementation InformationCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([InformationCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSString *)title{
    CGFloat height = 70.f;
    return height;
}


+ (NSMutableDictionary*)buildCellDict:(NoticesModel *)model
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[InformationCell class]];
    if (model) {
        [dict setObject:model forKey:@"model"];
    }
    return dict;
}

+(NSString *)cellForkey
{
    NSString * str = @"model";
    return str;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    NoticesModel * model = dict[@"model"];
    self.model = model;
    if (model.icon_url) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    }
    
    if (model.name) {
        self.title.text = model.name;
    }
    
    if (model.NEWNotice.brief) {
        self.detail.text = model.NEWNotice.brief;
    }
    
    if (model.NEWNotice.sendtime) {
        
//        NSDate *datNew = [NSDate dateWithTimeIntervalSince1970:[model.NEWNotice.sendtime doubleValue]/1000.0];
//        NSString * timeStr = [datNew formattedDateDescription];
        self.time.text = [NSString stringWithFormat:@"%@",[model formattedDateDescription]];
    }
    
    if (model.noticecountl > 0) {
        self.numlbl.text = [NSString stringWithFormat:@"%ld",(long)model.noticecountl];
        self.numlbl.hidden = NO;
    } else {
        self.numlbl.hidden = YES;
    }
    
}

-(UILabel *)numlbl{
    if (!_numlbl) {
        _numlbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _numlbl.layer.cornerRadius = 17/2;
        _numlbl.backgroundColor = [UIColor colorWithHexString:@"e83828"];
        _numlbl.font = [UIFont systemFontOfSize:11.f];
        _numlbl.textColor = [UIColor colorWithHexString:@"ffffff"];
        _numlbl.textAlignment = NSTextAlignmentCenter;
        _numlbl.clipsToBounds = YES;
        _numlbl.hidden = YES;
    }
    return _numlbl;
}


-(XMWebImageView *)icon
{
    if (!_icon) {
        _icon = [[XMWebImageView alloc] init];
    }
    return _icon;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor colorWithHexString:@"434342"];
        [_title sizeToFit];
        _title.numberOfLines = 1;
    }
    return _title;
}

-(UILabel *)detail
{
    if (!_detail) {
        _detail = [[UILabel alloc] init];
        _detail.font = [UIFont systemFontOfSize:13];
        _detail.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        [_detail sizeToFit];
        _detail.numberOfLines = 1;
    }
    return _detail;
}


-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:10];
        _time.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        [_time sizeToFit];
        _time.numberOfLines = 1;
    }
    return _time;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detail];
        [self.contentView addSubview:self.line];
        [self.icon addSubview:self.numlbl];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.icon.mas_centerY).offset(-2
                                                          );
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.width.mas_equalTo(150);
    }];
    
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.top.equalTo(self.icon.mas_centerY).offset(5);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    if (!self.numlbl.hidden) {
        [self.numlbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_top);
            make.right.equalTo(self.icon.mas_right);
            make.size.mas_equalTo(CGSizeMake(17, 17));
            
        }];
    }
    
    
}



@end
