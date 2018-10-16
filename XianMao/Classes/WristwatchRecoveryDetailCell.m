//
//  WristwatchRecoveryDetailCell.m
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WristwatchRecoveryDetailCell.h"
#import "Masonry.h"

@interface WristwatchRecoveryDetailCell ()

//@property (nonatomic, strong) UIImageView *dialImageView;
//@property (nonatomic, strong) UILabel *dialLbl;
//@property (nonatomic, strong) UILabel *dialContentLbl;

@property (nonatomic, strong) UIImageView *strapImageView;
@property (nonatomic, strong) UILabel *strapLbl;
@property (nonatomic, strong) UILabel *strapContentLbl;

@end

@implementation WristwatchRecoveryDetailCell

-(UILabel *)strapContentLbl{
    if (!_strapContentLbl) {
        _strapContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _strapContentLbl.textColor = [UIColor colorWithHexString:@"aeaeae"];
        _strapContentLbl.font = [UIFont systemFontOfSize:12.f];
        _strapContentLbl.numberOfLines = 0;
        [_strapContentLbl sizeToFit];
        _strapContentLbl.text = @"";
    }
    return _strapContentLbl;
}

-(UILabel *)strapLbl{
    if (!_strapLbl) {
        _strapLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _strapLbl.textColor = [UIColor colorWithHexString:@"090909"];
        _strapLbl.font = [UIFont systemFontOfSize:14.f];
        [_strapLbl sizeToFit];
        _strapLbl.text = @"";
    }
    return _strapLbl;
}

-(UIImageView *)strapImageView{
    if (!_strapImageView) {
        _strapImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _strapImageView.image = [UIImage imageNamed:@"WristwatchRecovery_Strap"];
    }
    return _strapImageView;
}

//-(UILabel *)dialContentLbl{
//    if (!_dialContentLbl) {
//        _dialContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _dialContentLbl.textColor = [UIColor colorWithHexString:@"aeaeae"];
//        _dialContentLbl.font = [UIFont systemFontOfSize:12.f];
//        _dialContentLbl.numberOfLines = 0;
//        [_dialContentLbl sizeToFit];
//        _dialContentLbl.text = @"收货90天后，可申请原价回购（收取5%手续费和一定折损费）";
//    }
//    return _dialContentLbl;
//}
//
//-(UILabel *)dialLbl{
//    if (!_dialLbl) {
//        _dialLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _dialLbl.textColor = [UIColor colorWithHexString:@"090909"];
//        _dialLbl.font = [UIFont systemFontOfSize:14.f];
//        [_dialLbl sizeToFit];
//        _dialLbl.text = @"表盘¥9000";
//    }
//    return _dialLbl;
//}
//
//-(UIImageView *)dialImageView{
//    if (!_dialImageView) {
//        _dialImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _dialImageView.image = [UIImage imageNamed:@"WristwatchRecovery_Dial"];
//        [_dialImageView sizeToFit];
//    }
//    return _dialImageView;
//}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WristwatchRecoveryDetailCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 72.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsFittings *)fitting
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WristwatchRecoveryDetailCell class]];
    if (fitting)[dict setObject:fitting forKey:[self cellDictKeyForTitle]];
    return dict;
}

+ (NSString*)cellDictKeyForTitle {
    return @"fitting";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.dialImageView];
//        [self.contentView addSubview:self.dialLbl];
//        [self.contentView addSubview:self.dialContentLbl];
        
        [self.contentView addSubview:self.strapImageView];
        [self.contentView addSubview:self.strapLbl];
        [self.contentView addSubview:self.strapContentLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.dialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(12);
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//    }];
//    
//    [self.dialLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.dialImageView.mas_top);
//        make.left.equalTo(self.dialImageView.mas_right).offset(12);
//    }];
//    
//    [self.dialContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.dialImageView.mas_bottom);
//        make.left.equalTo(self.dialImageView.mas_right).offset(12);
//        make.right.equalTo(self.contentView.mas_right).offset(-36);
//    }];
    
    [self.strapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.width.equalTo(@49);
        make.height.equalTo(@49);
    }];
    
    [self.strapLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strapImageView.mas_top);
        make.left.equalTo(self.strapImageView.mas_right).offset(12);
    }];
    
    [self.strapContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strapLbl.mas_bottom).offset(8);
        make.left.equalTo(self.strapImageView.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-36);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    GoodsFittings *fitting = dict[@"fitting"];
    
    [self.strapImageView sd_setImageWithURL:[NSURL URLWithString:fitting.pic] placeholderImage:[UIImage imageNamed:@"WristwatchRecovery_Strap"]];
    if (fitting.name) {
        self.strapLbl.text = [NSString stringWithFormat:@"%@ %.2f", fitting.name, fitting.price];
    }
    if (fitting.info) {
        self.strapContentLbl.text = fitting.info;
    }
    
    
}

@end
