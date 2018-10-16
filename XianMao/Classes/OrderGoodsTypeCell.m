//
//  OrderGoodsTypeCell.m
//  XianMao
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderGoodsTypeCell.h"
#import "Masonry.h"
#import "NSDate+Category.h"

@interface OrderGoodsTypeCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *timeLbl;
@end

@implementation OrderGoodsTypeCell

-(UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:14];
        _timeLbl.textColor = [UIColor colorWithHexString:@"363636"];
        [_timeLbl sizeToFit];
    }
    return _timeLbl;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
    }
    return _rightImageView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"363636"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 10;
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderGoodsTypeCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo {
    CGFloat height = 30.f;
    return height;
}

+ (NSMutableDictionary*)buildCellTitle:(NSString *)title imageName:(NSString *)imageName isHTTP:(NSNumber *)isYes orderInfo:(OrderInfo *)orderInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderGoodsTypeCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    if (imageName) {
        [dict setObject:imageName forKey:@"imageName"];
    }
    if (isYes) {
        [dict setObject:isYes forKey:@"isYes"];
    }
    if (orderInfo) {
        [dict setObject:orderInfo forKey:@"orderInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.timeLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(8);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSString *title = dict[@"title"];
    NSString *imageName = dict[@"imageName"];
    NSNumber *isHttP = dict[@"isYes"];
    OrderInfo *orderInfo = dict[@"orderInfo"];
    if ([isHttP isEqual:@1]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    } else {
        self.iconImageView.image = [UIImage imageNamed:imageName];
    }
    self.titleLbl.text = title;
    
    
    
    if (orderInfo.logic_type == RETURNGOODS && orderInfo.orderStatus == 1 && orderInfo.orderStatus != 8) {
        self.timeLbl.hidden = NO;
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSTimeInterval currTime = [dat timeIntervalSince1970]*1000;
        
        if (currTime - orderInfo.finish_time <= 90*24*60*60*1000.0 && orderInfo.orderStatus == 1) {
            
            NSString *timeStamp = [NSString stringWithFormat:@"%lld",orderInfo.finish_time];
            NSString * dateString = [self dateWithString:timeStamp andTimeInterval:24*60*60*90];
            _timeLbl.text = [NSString stringWithFormat:@"%@之后可回购",dateString];
        } else {
            
            NSString *timeStamp = [NSString stringWithFormat:@"%lld",orderInfo.finish_time];
            NSString * dateString = [self dateWithString:timeStamp andTimeInterval:24*60*60*365];
            _timeLbl.text = [NSString stringWithFormat:@"%@之前可回购",dateString];
        }
    }else {
        self.timeLbl.hidden = YES;
    }
    
    if (orderInfo.repurchase_status != 0) {
        self.timeLbl.hidden = YES;
    } else {
        self.timeLbl.hidden = NO;
    }
    
}


-(NSString *)dateWithString:(NSString *)string andTimeInterval:(int)TimeInterval
{
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:([string doubleValue] / 1000.0)];
    NSDate * date1 = [time dateByAddingTimeInterval:TimeInterval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * dateString = [formatter stringFromDate:date1];
    return dateString;
}


@end
