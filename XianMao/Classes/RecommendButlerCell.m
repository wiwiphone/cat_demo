//
//  RecommendButlerCell.m
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecommendButlerCell.h"
#import "DataSources.h"
#import "Masonry.h"
#import "AdviserPage.h"
#import "Session.h"

@interface RecommendButlerCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *butlerName;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) AdviserPage *viserPage;

@end

@implementation RecommendButlerCell

-(UIButton *)chatButton{
    if (!_chatButton) {
        _chatButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chatButton setTitle:@"为您服务" forState:UIControlStateNormal];
        [_chatButton setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];
        _chatButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _chatButton.layer.borderColor = [UIColor colorWithHexString:@"b3b3b3"].CGColor;
        _chatButton.layer.borderWidth = 0.5;
        _chatButton.layer.masksToBounds = YES;
        _chatButton.layer.cornerRadius = 3;
    }
    return _chatButton;
}

-(UILabel *)butlerName{
    if (!_butlerName) {
        _butlerName = [[UILabel alloc] initWithFrame:CGRectZero];
        _butlerName.font = [UIFont systemFontOfSize:14.f];
        _butlerName.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        [_butlerName sizeToFit];
    }
    return _butlerName;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 23;
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendButlerCell class]);
    });
    return __reuseIdentifier;
}
+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 61;
    return rowHeight;
}
+ (NSMutableDictionary*)buildCellDict:(AdviserPage *)viserPage;
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecommendButlerCell class]];
    if (viserPage) {
        [dict setObject:viserPage forKey:@"viserPage"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.butlerName];
        [self.contentView addSubview:self.chatButton];
        
        [self.chatButton addTarget:self action:@selector(clickChatBtn) forControlEvents:UIControlEventTouchUpInside];
        [self setUpUI];
    }
    return self;
}

-(void)clickChatBtn{
    NSDictionary *data = @{@"userId":[NSNumber numberWithInteger:self.viserPage.userId]};
    [ClientReportObject clientReportObjectWithViewCode:MineConsultantViewCode regionCode:ChatViewCode referPageCode:ChatViewCode andData:data];
    [UserSingletonCommand chatWithUserFirst:self.viserPage.userId msg:[NSString stringWithFormat:@"%@", self.viserPage.greetings]];
}

-(void)setUpUI{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@46);
        make.height.equalTo(@46);
    }];
    
    [self.butlerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    AdviserPage *viserPage = dict[@"viserPage"];
    self.viserPage = viserPage;
    [self.iconImageView setImageWithURL:viserPage.avatar XMWebImageScaleType:XMWebImageScale480x480];
    self.butlerName.text = viserPage.username;
}

@end
