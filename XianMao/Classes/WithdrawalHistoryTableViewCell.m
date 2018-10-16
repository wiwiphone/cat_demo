//
//  WithdrawalHistoryTableViewCell.m
//  XianMao
//
//  Created by darren on 15/1/27.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "WithdrawalHistoryTableViewCell.h"

@interface WithdrawalHistoryTableViewCell() {
    UIImageView *_imageView;
    
    UILabel *_timeLabel;
    UILabel *_nameLabel;
    UILabel *_statusLabel;
    UILabel *_amoutLabel;
}

@end

@implementation WithdrawalHistoryTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WithdrawalHistoryTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 81.f;
    return height;
}


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _placeholderImage = [UIImage imageNamed:@"payicon_ali"];
        _imageView = [[UIImageView alloc] init];
        _imageView.image = _placeholderImage;
        _imageView.frame = CGRectMake(20, 20, 20, 20);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = _imageView.frame.size.width / 2.f;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        _nameLabel.font = [UIFont systemFontOfSize:16.f];
        _nameLabel.textColor = [UIColor colorWithHexString:@"333"];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        _amoutLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        _amoutLabel.backgroundColor = [UIColor clearColor];
        _amoutLabel.textColor = [UIColor lightGrayColor];
        _amoutLabel.textAlignment = NSTextAlignmentRight;
        _amoutLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_amoutLabel];
        
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];

        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = [UIColor lightGrayColor];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_statusLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(66, 0, self.contentView.frame.size.width, 1)];
        _lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

+ (NSMutableDictionary*)buildCellDict:(WithdrawalInfo*)withdrawalInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WithdrawalHistoryTableViewCell class]];
    if (withdrawalInfo)[dict setObject:withdrawalInfo forKey:[self cellKeyForWithdrawalInfo]];
    
    return dict;

}

+ (NSString*)cellKeyForWithdrawalInfo {
    return @"withdrawal";
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float marginTop = 20.f;
    _imageView.frame = CGRectMake(20.f, 19.f, 40.f, 40.f);
    _nameLabel.frame = CGRectMake(_imageView.frame.size.width +_imageView.origin.x+ 10, marginTop, 150, 16);
    _amoutLabel.frame = CGRectMake(_nameLabel.frame.size.width + _nameLabel.origin.x, marginTop +2.f,
                                   self.frame.size.width - 15 - _nameLabel.origin.x - _nameLabel.frame.size.width,
                                   15.f);
    marginTop += _nameLabel.frame.size.height;
    marginTop += 14.f;
    
    _timeLabel.frame = CGRectMake(_nameLabel.origin.x, marginTop, _nameLabel.width, 12.f);
    
    _statusLabel.frame = CGRectMake(_amoutLabel.origin.x, marginTop-2, _amoutLabel.frame.size.width,12.f);
    
}


- (void)updateCellWithDict:(NSDictionary *)dict {
    WithdrawalInfo *withdrawalInfo = (WithdrawalInfo*)[dict objectForKey:[[self class] cellKeyForWithdrawalInfo]];
    if ([withdrawalInfo isKindOfClass:[WithdrawalInfo class]])
    {
        if (withdrawalInfo.type == 0) {
            _imageView.image = [UIImage imageNamed:@"record_alipay"];
            _nameLabel.text = @"提现到支付宝";
        } else {
            _imageView.image = [UIImage imageNamed:@"placeholder_seller"];
            _nameLabel.text = @"用户到微信";
        }
        _amoutLabel.text = [NSString stringWithFormat:@"- %.2f",withdrawalInfo.amount];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:withdrawalInfo.createtime/1000 ];//[NSDate date];
       
        _timeLabel.text = [NSDate stringFromDate:date withFormat:@"yyyy-MM-dd"];

        _statusLabel.text = withdrawalInfo.messsage;
        
        [self setNeedsLayout];
    }
}

@end


@interface AccountLogTableViewCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UILabel *amoutLabel;
@property (nonatomic, weak)  UIView *lineView;
@end

@implementation AccountLogTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([AccountLogTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 81.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(AccountLogVo*)accountLogVo cellIndex:(NSInteger)index
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AccountLogTableViewCell class]];
    if (accountLogVo)[dict setObject:accountLogVo forKey:[self cellKeyForAccountLog]];
    [dict setObject:[NSNumber numberWithInteger:index] forKey:[self cellKeyForIndex]];
    return dict;
}

+ (NSString*)cellKeyForAccountLog {
    return @"accountLogVo";
}

+ (NSString*)cellKeyForIndex {
    return @"cellKeyForIndex";
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectNull];
        iconView = [[UIImageView alloc] init];
        iconView.frame = CGRectMake(20, 20, 20, 20);
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = iconView.frame.size.width / 2.f;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        _iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        nameLabel.font = [UIFont systemFontOfSize:16.f];
        nameLabel.textColor = [UIColor colorWithHexString:@"333"];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        _nameLabel = nameLabel;
        
        UILabel *amoutLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        amoutLabel.backgroundColor = [UIColor clearColor];
        amoutLabel.textColor = [UIColor lightGrayColor];
        amoutLabel.textAlignment = NSTextAlignmentRight;
        amoutLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:amoutLabel];
        _amoutLabel = amoutLabel;
        
        // Initialization code
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
        
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont systemFontOfSize:12];
        statusLabel.textColor = [UIColor lightGrayColor];
        statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:statusLabel];
        _statusLabel = statusLabel;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(66, 0, self.contentView.frame.size.width, 1)];
        lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        [self.contentView addSubview:lineView];
        _lineView = lineView;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float marginTop = 20.f;
    _iconView.frame = CGRectMake(20.f, 19.f, 40.f, 40.f);
    _nameLabel.frame = CGRectMake(_iconView.frame.size.width +_iconView.origin.x+ 10, marginTop, 150, 16);
    _amoutLabel.frame = CGRectMake(_nameLabel.frame.size.width + _nameLabel.origin.x, marginTop +2.f,
                                   self.frame.size.width - 15 - _nameLabel.origin.x - _nameLabel.frame.size.width,
                                   15.f);
    marginTop += _nameLabel.frame.size.height;
    marginTop += 14.f;
    
    _timeLabel.frame = CGRectMake(_nameLabel.origin.x, marginTop, _nameLabel.width, 12.f);
    
    _statusLabel.frame = CGRectMake(_amoutLabel.origin.x, marginTop-2, _amoutLabel.frame.size.width,12.f);
    
    _lineView.frame = CGRectMake(66, 0, self.contentView.frame.size.width, 0.5f);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    NSInteger index = [[dict objectForKey:[[self class] cellKeyForIndex]] integerValue];
    AccountLogVo *accountLogVo = (AccountLogVo*)[dict objectForKey:[[self class] cellKeyForAccountLog]];
    if ([accountLogVo isKindOfClass:[AccountLogVo class]])
    {
        WEAKSELF;
        _lineView.hidden = index==0?YES:NO;
        
        weakSelf.iconView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [_iconView sd_setImageWithURL:[NSURL URLWithString:accountLogVo.icon_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.iconView.backgroundColor = [UIColor clearColor];
        }];
        _nameLabel.text = accountLogVo.title;
        _amoutLabel.text = accountLogVo.amount_text;
//        _amoutLabel.text = [NSString stringWithFormat:@"¥ %.2f",(double)accountLogVo.amount_cent/100.f];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:accountLogVo.createtime/1000 ];//[NSDate date];
        _timeLabel.text = [NSDate stringFromDate:date withFormat:@"yyyy-MM-dd"];
        
        _statusLabel.text = accountLogVo.subtitle;
        
        [self setNeedsLayout];
    }
}

@end
