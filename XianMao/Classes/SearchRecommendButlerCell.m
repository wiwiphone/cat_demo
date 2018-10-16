//
//  SearchRecommendButlerCell.m
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchRecommendButlerCell.h"
#import "Masonry.h"
#import "DataSources.h"
#import "NetworkManager.h"
#import "AdviserPage.h"
#import "Session.h"

@interface SearchRecommendButlerCell ()

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *butlerName;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) AdviserPage *adviserPage;
@end

@implementation SearchRecommendButlerCell

-(UIButton *)chatButton{
    if (!_chatButton) {
        _chatButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chatButton setTitle:@"马上聊" forState:UIControlStateNormal];
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

-(UIView *)leftLineView{
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftLineView.backgroundColor = [UIColor colorWithHexString:@"cacccd"];
    }
    return _leftLineView;
}

-(UIView *)rightLineView{
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightLineView.backgroundColor = [UIColor colorWithHexString:@"cacccd"];
    }
    return _rightLineView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        _titleLbl.text = @"没搜到想要的？找顾问帮忙";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SearchRecommendButlerCell class]);
    });
    return __reuseIdentifier;
}
+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 110;
    return rowHeight;
}
+ (NSMutableDictionary*)buildCellDict;
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SearchRecommendButlerCell class]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        WEAKSELF;
//        [self showLoadingView];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
            
            AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
            weakSelf.adviserPage = adviserPage;
            
            [weakSelf hideLoadingView];
            [weakSelf.contentView addSubview:self.leftLineView];
            [weakSelf.contentView addSubview:self.rightLineView];
            [weakSelf.contentView addSubview:self.titleLbl];
            
            [weakSelf.contentView addSubview:self.iconImageView];
            [weakSelf.contentView addSubview:self.butlerName];
            [weakSelf.contentView addSubview:self.chatButton];
            
            [weakSelf setUpUI];
            [weakSelf setData:adviserPage];
            [weakSelf.chatButton addTarget:self action:@selector(clickChatBtn) forControlEvents:UIControlEventTouchUpInside];
        } failure:^(XMError *error) {
            
        } queue:nil]];
    }
    return self;
}

-(void)clickChatBtn{
    NSDictionary *data = @{@"userId":[NSNumber numberWithInteger:self.adviserPage.userId]};
    [ClientReportObject clientReportObjectWithViewCode:MineConsultantViewCode regionCode:ChatViewCode referPageCode:ChatViewCode andData:data];
    [UserSingletonCommand chatWithUserFirst:self.adviserPage.userId msg:[NSString stringWithFormat:@"%@", self.adviserPage.greetings]];
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self];
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.backgroundColor = [UIColor whiteColor];
    //    [self bringTopBarToTop];
    return view;
}

-(void)setData:(AdviserPage *)adviser{
    [self.iconImageView setImageWithURL:adviser.avatar XMWebImageScaleType:XMWebImageScale480x480];
    self.butlerName.text = adviser.username;
    
}

-(void)setUpUI{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(17);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.right.equalTo(self.titleLbl.mas_left).offset(-11);
        make.left.equalTo(self.contentView.mas_left).offset(35);
        make.height.equalTo(@1);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(11);
        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.height.equalTo(@1);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(18);
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

@end
