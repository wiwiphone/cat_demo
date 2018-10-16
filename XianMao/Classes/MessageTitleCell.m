//
//  MessageTitleCell.m
//  XianMao
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MessageTitleCell.h"

@interface MessageTitleCell ()

@property (nonatomic, strong) UILabel *messageTitleLbl;
@property (nonatomic, strong) UIView *shuView;
@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation MessageTitleCell

-(UILabel *)numLbl{
    if (!_numLbl) {
        _numLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLbl.font = [UIFont systemFontOfSize:13.f];
        _numLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_numLbl sizeToFit];
    }
    return _numLbl;
}

-(UILabel *)messageLbl{
    if (!_messageLbl) {
        _messageLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLbl.font = [UIFont systemFontOfSize:13.f];
        _messageLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_messageLbl sizeToFit];
        _messageLbl.text = @"Message";
    }
    return _messageLbl;
}

-(UIView *)shuView{
    if (!_shuView) {
        _shuView = [[UIView alloc] initWithFrame:CGRectZero];
        _shuView.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    }
    return _shuView;
}

-(UILabel *)messageTitleLbl{
    if (!_messageTitleLbl) {
        _messageTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageTitleLbl.font = [UIFont systemFontOfSize:13.f];
        _messageTitleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_messageTitleLbl sizeToFit];
        _messageTitleLbl.text = @"留言";
    }
    return _messageTitleLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([MessageTitleCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 50;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[MessageTitleCell class]];
    if (detailInfo) {
        [dict setObject:detailInfo forKey:@"detailInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.messageTitleLbl];
        [self.contentView addSubview:self.shuView];
        [self.contentView addSubview:self.messageLbl];
        [self.contentView addSubview:self.numLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.messageTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    [self.shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.messageTitleLbl.mas_right).offset(8);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
        make.width.equalTo(@1);
    }];
    
    [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.shuView.mas_right).offset(8);
    }];
    
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.messageLbl.mas_right).offset(8);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsDetailInfo *detailInfo = dict[@"detailInfo"];
    self.numLbl.text = [NSString stringWithFormat:@"(%ld)", detailInfo.comment_num];
    
}

@end
