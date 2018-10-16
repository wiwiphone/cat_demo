//
//  MineCateNewView.m
//  XianMao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineCateNewView.h"
#import "Masonry.h"
#import "Command.h"
#import "RecoverCollectionViewController.h"
#import "SoldCollectionViewController.h"
#import "BoughtCollectionViewController.h"
#import "DidPriceViewController.h"
#import "ConsultantViewController.h"
#import "WCAlertView.h"
#import "URLScheme.h"
#import "WebViewController.h"
#import "AboutViewController.h"
#import "SendSaleViewController.h"
#import "RecoverCollectionViewController.h"
#import "Session.h"

@interface MineCateNewView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *MineCellID = @"MineCellID";
@implementation MineCateNewView

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth/4-1, kScreenWidth/4-0.5-14);
        layout.minimumInteritemSpacing = 0.5;
        layout.minimumLineSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MineCellID];
        [self addSubview:self.collectionView];
        
        [self setUpUI];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MineCellID forIndexPath:indexPath];
    
    VerticalCommandButton *cateViewBtn = [[VerticalCommandButton alloc] initWithFrame:cell.bounds];
    cateViewBtn.backgroundColor = [UIColor whiteColor];
    cateViewBtn.tag = indexPath.item + 1;
//    NSMutableString *imageName = [[NSMutableString alloc] initWithFormat:@"MineCate_New_MF%ld", indexPath.item];
    NSString *imageName = [[NSString alloc] init];
    NSString *name = [NSString string];
    switch (indexPath.item) {
        case 0:
            name = @"客服电话";
            imageName = @"Mine_Phone_MF";
            break;
        case 1:
            name = @"在线客服";
            imageName = @"Mine_OnLine_MF";
            break;
        case 2:
            name = @"帮助中心";
            imageName = @"Mine_Help_MF";
            break;
        case 3:
            name = @"意见反馈";
            imageName = @"Mine_Feedback_MF";
            break;
        case 4:
            name = @"寄卖";
            imageName = @"Mine_SendSale_MF";
            break;
        case 5:
            name = @"回收";
            imageName = @"Mine_Recovery_MF_New";
            break;
        default:
            break;
    }
    if (indexPath.item <= 5) {
        cateViewBtn.contentAlignmentCenter = YES;
        cateViewBtn.imageTextSepHeight = 6;
        [cateViewBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [cateViewBtn setTitle:name forState:UIControlStateNormal];
        [cateViewBtn setTitleColor:[UIColor colorWithHexString:@"636363"] forState:UIControlStateNormal];
        cateViewBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        cateViewBtn.handleClickBlock = ^(CommandButton *sender) {
            NSLog(@"%ld", sender.tag);
//            if (sender.tag == 1) {
//                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineOnSaleViewCode referPageCode:MineOnSaleViewCode andData:nil];
//                RecoverCollectionViewController *viewController = [[RecoverCollectionViewController alloc] init];
//                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//            } else if (sender.tag == 2) {
//                [MobClick event:@"click_on_sell_from_mine"];
//                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineSoldViewCode referPageCode:MineSoldViewCode andData:nil];
//                //        MySaleViewController *viewController = [[MySaleViewController alloc] init];
//                SoldCollectionViewController *viewController = [[SoldCollectionViewController alloc] init];
//                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//            } else if (sender.tag == 3) {
//                [MobClick event:@"click_my_belongs_from_mine"];
//                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:nil];
//                BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
//                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//            } else if (sender.tag == 4) {
//                [MobClick event:@"click_my_belongs_from_mine"];
//                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineOfferedViewCode referPageCode:MineOfferedViewCode andData:nil];
//                //ADD code
//                DidPriceViewController *viewController = [[DidPriceViewController alloc] init];
//                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//            } else if (sender.tag == 5) {
//                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineConsultantViewCode referPageCode:MineConsultantViewCode andData:nil];
//                ConsultantViewController *viewController = [[ConsultantViewController alloc] init];
//                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//            }
            
            if (sender.tag == 1) {
                [WCAlertView showAlertWithTitle:@"拨打客服电话" message:kCustomServicePhoneDisplay customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    if (buttonIndex == 0) {
                        
                    } else {
                        [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:CallCustomerRegionCode referPageCode:NoReferPageCode andData:nil];
                        NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            } else if (sender.tag == 2) {
                
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"em_user" parameters:nil completionBlock:^(NSDictionary *data) {
                    EMAccount *emAccount = [[EMAccount alloc] initWithDict:data[@"emUser"]];
                    [[Session sharedInstance] setUserKEFUEMAccount:emAccount];
                    [UserSingletonCommand chatWithGroup:emAccount isShowDownTime:YES message:@"亲爱的，有什么可以帮您？" isKefu:YES];
                } failure:^(XMError *error) {
                    
                } queue:nil]];
                
            } else if (sender.tag == 3) {
                [MobClick event:@"click_manage_help_center"];
                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineWebViewCode referPageCode:MineWebViewCode andData:nil];
                WebViewController *viewController = [[WebViewController alloc] init];
                viewController.title = @"帮助中心";
                viewController.url = @"http://activity.aidingmao.com/share/page/351";
                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            } else if (sender.tag == 4) {
                [ClientReportObject clientReportObjectWithViewCode:MineViewCode regionCode:MineFeedbackViewCode referPageCode:MineFeedbackViewCode andData:nil];
                FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            } else if (sender.tag == 5) {
                SendSaleViewController *viewController = [[SendSaleViewController alloc] init];
                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            } else if (sender.tag == 6) {
                RecoverCollectionViewController *recoveryController = [[RecoverCollectionViewController alloc] init];
                recoveryController.type = 1;
                recoveryController.segmentIndex = 1;
                [[CoordinatingController sharedInstance] pushViewController:recoveryController animated:YES];
            }
            
        };
    }
    [cell.contentView addSubview:cateViewBtn];
    
    return cell;
}

-(void)setUpUI{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
