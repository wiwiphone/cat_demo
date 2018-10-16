//
//  MoneyReceiveCell.m
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MoneyReceiveCell.h"
#import "Command.h"
#import "CardViewController.h"
#import "URLScheme.h"
#import "DZ_ScaleCircle.h"

@interface MoneyReceiveCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) CommandButton *seeCardBtn;
@property (nonatomic, strong) CommandButton *shareFriendBtn;
@property (nonatomic, strong) DZ_ScaleCircle *scaleView;

@end

@implementation MoneyReceiveCell

//-(DZ_ScaleCircle *)scaleView{
//    if (!_scaleView) {
//        _scaleView = [[DZ_ScaleCircle alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, (170-100)/2+10, 100, 100)];
//        //  四个区域的颜色
//        _scaleView.firstColor = [UIColor colorWithHexString:@"ff752b"];
//        //  四个区域所占的比例
//        _scaleView.firstScale = 1;
//        //  线宽
//        _scaleView.lineWith = 3;
//        //  未填充颜色
//        _scaleView.unfillColor = [UIColor lightGrayColor];
//        //  动画时长
//        _scaleView.animation_time = 2;
//        _scaleView.centerLable.textColor = [UIColor colorWithHexString:@"ff752b"];
//    }
//    return _scaleView;
//}

-(CommandButton *)shareFriendBtn{
    if (!_shareFriendBtn) {
        _shareFriendBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_shareFriendBtn setTitle:@"分享App给好友" forState:UIControlStateNormal];
        [_shareFriendBtn setTitleColor:[UIColor colorWithHexString:@"457fb9"] forState:UIControlStateNormal];
        _shareFriendBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_shareFriendBtn sizeToFit];
    }
    return _shareFriendBtn;
}

-(CommandButton *)seeCardBtn{
    if (!_seeCardBtn) {
        _seeCardBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_seeCardBtn setTitle:@"查看卡券" forState:UIControlStateNormal];
        _seeCardBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_seeCardBtn setTitleColor:[UIColor colorWithHexString:@"ff752b"] forState:UIControlStateNormal];
        _seeCardBtn.layer.cornerRadius = 5;
        _seeCardBtn.layer.masksToBounds = YES;
        _seeCardBtn.layer.borderColor = [UIColor colorWithHexString:@"ff752b"].CGColor;
        _seeCardBtn.layer.borderWidth = 1.f;
    }
    return _seeCardBtn;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _titleLbl.text = @"我累计赚到";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([MoneyReceiveCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 170;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(InvitationVo *)invationVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[MoneyReceiveCell class]];
    if (invationVo)[dict setObject:invationVo forKey:@"invationVo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.seeCardBtn];
        [self.contentView addSubview:self.shareFriendBtn];
        
        self.seeCardBtn.handleClickBlock = ^(CommandButton *sender){
            CardViewController *viewController = [[CardViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.shareFriendBtn.handleClickBlock = ^(CommandButton *sender){
            UIImage *image = [UIImage imageNamed:@"AppIcon_120"];
            [[CoordinatingController sharedInstance] shareWithTitle:@"给你看个买卖奢侈品的App，很不错哟~"
                                                              image:image
                                                                url:kAppShareUrl
                                                            content:@"权威鉴定、快速出货、奢品顾问、超值特卖。\n爱丁猫·会买奢侈品·Just take it"];
        };
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.seeCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.width.equalTo(@58);
        make.height.equalTo(@20);
    }];
    
    [self.shareFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    InvitationVo *invationVo = dict[@"invationVo"];
    
    [self.scaleView removeFromSuperview];
    self.scaleView = [[DZ_ScaleCircle alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, (170-100)/2+10, 100, 100)];
    //  四个区域的颜色
    self.scaleView.firstColor = [UIColor colorWithHexString:@"ff752b"];
    //  四个区域所占的比例
    self.scaleView.firstScale = 1;
    //  线宽
    self.scaleView.lineWith = 3;
    //  未填充颜色
    self.scaleView.unfillColor = [UIColor lightGrayColor];
    //  动画时长
    self.scaleView.animation_time = 2;
    self.scaleView.centerLable.textColor = [UIColor colorWithHexString:@"ff752b"];
    [self.contentView addSubview:self.scaleView];
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%ld",invationVo.totalRewardMoney]];
    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:@"￥"].location, [[noteStr string] rangeOfString:@"￥"].length);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:redRangeTwo];
    [self.scaleView.centerLable setAttributedText:noteStr];
    self.scaleView.centerLable.format = @"￥%d";
    [self.scaleView.centerLable countFrom:1 to:invationVo.totalRewardMoney withDuration:2.0];
//    [cell.priceLabel sizeToFit];
}

@end
