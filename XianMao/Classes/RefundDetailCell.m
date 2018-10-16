//
//  RefundDetailCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RefundDetailCell.h"

@implementation RefundDetailCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RefundDetailCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait
{
    CGFloat height = 130;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RefundDetailCell class]];
    return dict;
}

+ (NSMutableDictionary*)buildCellDict:(orderReturnItemListModel *)orderReturnItemListModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RefundDetailCell class]];
    if (orderReturnItemListModel) {
    
        [dict setObject:orderReturnItemListModel forKey:@"orderReturnItemListModel"];
    }
    return dict;
}
-(void)updateCellWithDict:(NSDictionary *)dict
{
    orderReturnItemListModel * model = dict[@"orderReturnItemListModel"];
    if (model.status) {
        self.status = [model.refundPaymentStatus integerValue];
        //退款支付状态：0初始 1打款中 2成功 3失败
        if (self.status == 2) {
            [_refundSucState setBackgroundImage:[UIImage imageNamed:@"refundSuc"] forState:UIControlStateNormal];
            _refundSucLbl.text = @"退款成功";
        }else if (self.status == 1){
            [_refundSucState setBackgroundImage:[UIImage imageNamed:@"refunding"] forState:UIControlStateNormal];
            _refundSucLbl.text = @"退款中";
        }else if (self.status ==3){
            [_refundSucState setBackgroundImage:[UIImage imageNamed:@"refundFail"] forState:UIControlStateNormal];
            _refundSucLbl.text = @"退款失败";
        }
        
    }
    
    //退款时间
    if (model.createTime) {
        NSString *timeStamp = model.createTime;
        NSDate * time = [NSDate dateWithTimeIntervalSince1970:([timeStamp doubleValue] / 1000.0)];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd \nHH:mm:ss";
        NSString * dateString = [formatter stringFromDate:time];
        _ADMDate.text = dateString;
    }
    
    //到账时间
    if (model.refundTime) {
        NSString *timeStamp = model.refundTime;
        NSDate * time = [NSDate dateWithTimeIntervalSince1970:([timeStamp doubleValue] / 1000.0)];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd \nHH:mm:ss";
        NSString * dateString = [formatter stringFromDate:time];
        _refundSucDate.text = dateString;
    }
}

-(UIButton *)ADMRefundState
{
    if (!_ADMRefundState) {
        _ADMRefundState = [[UIButton alloc] initWithFrame:CGRectZero];
        [_ADMRefundState setBackgroundImage:[UIImage imageNamed:@"group-42"] forState:UIControlStateNormal];
    }
    return _ADMRefundState;
}


-(UIButton *)handleState
{
    if (!_handleState) {
        _handleState = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _handleState;
}

-(UIButton *)refundSucState
{
    if (!_refundSucState) {
        _refundSucState = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _refundSucState;
}

-(UILabel *)ADMRefundLbl
{
    if (!_ADMRefundLbl) {
        _ADMRefundLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _ADMRefundLbl.font = [UIFont systemFontOfSize:14.0f];
        _ADMRefundLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _ADMRefundLbl.textAlignment = NSTextAlignmentCenter;
        _ADMRefundLbl.text = @"爱丁猫退款";
        
    }
    return _ADMRefundLbl;
}

-(UILabel *)handleLbl
{
    if (!_handleLbl) {
        _handleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _handleLbl.font = [UIFont systemFontOfSize:14.0f];
        _handleLbl.textColor = [UIColor colorWithHexString:@"434342"];
    }
    return _handleLbl;
}

-(UILabel *)refundSucLbl
{
    if (!_refundSucLbl) {
        _refundSucLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundSucLbl.font = [UIFont systemFontOfSize:14.0f];
        _refundSucLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _refundSucLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _refundSucLbl;
}

-(UILabel *)ADMDate
{
    if (!_ADMDate) {
        _ADMDate = [[UILabel alloc] initWithFrame:CGRectZero];
        _ADMDate.font = [UIFont systemFontOfSize:10.0f];
        _ADMDate.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _ADMDate.textAlignment = NSTextAlignmentCenter;
        _ADMDate.numberOfLines = 0;
        [_ADMDate sizeToFit];
    }
    return _ADMDate;
}

-(UILabel *)handleDate
{
    if (!_handleDate) {
        _handleDate = [[UILabel alloc] initWithFrame:CGRectZero];
        _handleDate.font = [UIFont systemFontOfSize:10.0f];
        _handleDate.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _handleDate.numberOfLines = 0;
    }
    return _handleDate;
}

-(UILabel *)refundSucDate
{
    if (!_refundSucDate) {
        _refundSucDate = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundSucDate.font = [UIFont systemFontOfSize:10.0f];
        _refundSucDate.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _refundSucDate.textAlignment = NSTextAlignmentCenter;
        _refundSucDate.numberOfLines = 0;
        [_refundSucDate sizeToFit];
    }
    return _refundSucDate;
}

-(UILabel *)refundSucTime
{
    if (!_refundSucTime) {
        _refundSucTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundSucTime.font = [UIFont systemFontOfSize:10.0f];
        _refundSucTime.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _refundSucTime.textAlignment = NSTextAlignmentCenter;
    }
    return _refundSucTime;
}

-(UILabel *)ADMTime
{
    if (!_ADMTime) {
        _ADMTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _ADMTime.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _ADMTime.font = [UIFont systemFontOfSize:10.0f];
        _ADMTime.textAlignment = NSTextAlignmentCenter;
    }
    return _ADMTime;
}

-(UIView *)connectedLine
{
    if (!_connectedLine) {
        _connectedLine = [[UIView alloc] initWithFrame:CGRectZero];
        _connectedLine.backgroundColor = [UIColor colorWithHexString:@"434342"];
    }
    return _connectedLine;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.ADMRefundState];
        [self.contentView addSubview:self.ADMRefundLbl];
        [self.contentView addSubview:self.ADMDate];
//        [self.contentView addSubview:self.ADMTime];
        
        [self.contentView addSubview:self.refundSucState];
        [self.contentView addSubview:self.refundSucLbl];
        [self.contentView addSubview:self.refundSucDate];
//        [self.contentView addSubview:self.refundSucTime];
        
        [self.contentView addSubview:self.connectedLine];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.ADMRefundState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/375*90);
        make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth/375*270);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-90);
    }];
    
    [self.connectedLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.ADMRefundState.mas_centerY);
        make.left.equalTo(self.ADMRefundState.mas_right);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*200, 1));
    }];
    
    [self.refundSucState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.connectedLine.mas_right);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.ADMRefundLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ADMRefundState.mas_bottom).offset(25);
        make.center.equalTo(self.ADMRefundState.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-52);
    }];
    
    [self.ADMDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ADMRefundLbl.mas_bottom).offset(5);
        make.left.equalTo(self.ADMRefundLbl.mas_left);
        make.right.equalTo(self.ADMRefundLbl.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);

    }];
    
//    [self.ADMTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.ADMDate.mas_bottom);
//        make.center.equalTo(self.ADMDate.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(70, 11));
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-24);
//    }];
    
    [self.refundSucLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ADMRefundLbl.mas_top);
        make.center.equalTo(self.refundSucState.mas_centerX);
//        make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/375*250);
        make.left.equalTo(self.ADMRefundLbl.mas_right).offset(100);
        make.size.mas_equalTo(CGSizeMake(80, 15));
        make.bottom.equalTo(self.ADMRefundLbl.mas_bottom);

    }];
    
    [self.refundSucDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ADMDate.mas_top);
        make.bottom.equalTo(self.ADMDate.mas_bottom);
        make.center.equalTo(self.refundSucLbl.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 11));
    }];
    
//    [self.refundSucTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.ADMTime.mas_top);
//        make.bottom.equalTo(self.ADMTime.mas_bottom);
//        make.left.equalTo(self.refundSucDate.mas_left);
//        make.right.equalTo(self.refundSucDate.mas_right);
//    }];
    
}
@end
