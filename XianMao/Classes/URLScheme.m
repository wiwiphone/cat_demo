//
//  URLScheme.m
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "URLScheme.h"

#import "CoordinatingController.h"
#import "WebViewController.h"
#import "ConsignmentViewController.h"
#import "UserHomeViewController.h"
#import "FollowsViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsListViewController.h"
#import "NSString+Addtions.h"
#import "ActionSheet.h"

#import "SearchViewController.h"
#import "BrandViewController.h"
#import "BonusListViewController.h"
#import "BoughtCollectionViewController.h"
#import "InformationViewController.h"

#import "OnSaleViewController.h"
#import "SoldViewController.h"
#import "BoughtViewController.h"
#import "BoughtCollectionViewController.h"
#import "DataListViewController.h"
#import "MySaleViewController.h"
#import "RecoverCollectionViewController.h"
#import "SoldCollectionViewController.h"
#import "MatchViewController.h"
#import "RecoverGoodsController.h"

#import "ExploreViewController.h"
#import "RecommendViewController.h"

#import "ForumPostListViewController.h"
#import "ForumPostDetailViewController.h"


#import "NSString+URLEncoding.h"

#import "WCAlertView.h"

#import "UIActionSheet+Blocks.h"
#import "InviteViewController.h"

#import "NoticeViewController.h"

#import "Session.h"

#import "Constants.h"


#import "ChatViewController.h"

#import "Session.h"

#import "RecoverDetailViewController.h"
#import "InsureViewController.h"
#import "OfferedViewController.h"
#import "ConsultantViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "VerifyViewController.h"
#import "SaleStateViewController.h"
#import "UnfinishViewController.h"

#import "DiscoveryViewController.h"
#import "CardViewController.h"
#import "CateBrandViewController.h"
#import "ScanCodePaymentViewController.h"
#import "NSString+AES.h"
#import "MineIncomeViewController.h"
#import "SeekToPurchasePublishController.h"

@implementation URLScheme

//用户首页：aidingmao://user/home/?userid=%d
//粉丝：aidingmao://user/fans/?userid=%d
//关注：aidingmao://user/followings/?userid=%d
//购物券：aidingmao://bonus/quan/?code=%@
//详情：aidingmao://goods/detail/?goodsid=%@
//搜索：aidingmao://search/list/?title=%@&query_key=%@&query_value=%@
//分享：aidingmao://app/share/?params=%@
//
//在售：aidingmao://goods/onsale/?userid=%d   [可不传uid]
//已售：aidingmao://goods/sold/?userid=%d   [可不传uid]
//已发待审核：aidingmao://goods/published/?userid=%d [可不传uid]
//已买：aidingmao://goods/bought/?userid=%d [可不传uid]

//aidingmao://datalist/?module=%@&path=%@params=%@&title=%@ [新增：数据展示使用首页的布局]

//aidingmao://fqlpay/?result=1 或者 0

//aidingmao://brandlist?title=xxx&&params=xxxx
//aidingmao://forumTopic?topic_id=XXX&title=XXX
//aidingmao://forumPost?topic_id=XXX&post_id=XXX

//aidingmao://chat?user_id=xxx&msg=yyy

//aidingmao://recovery/goods_detail?xxx

+ (NSDictionary*)locatorMap
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"UserHomeViewController",@"aidingmao://user/home",
                                 @"FollowsViewController",@"aidingmao://user/fans",
                                 @"FollowsViewController",@"aidingmao://user/followings",
                                 @"GoodsDetailViewControllerContainer",@"aidingmao://goods/detail",
                                 @"GoodsListViewController",@"aidingmao://goods/list",
                                 @"RecoverCollectionViewController",@"aidingmao://brand/list",
                                 @"SearchViewController",@"aidingmao://search/list",
                                 @"BonusCodeConvertController",@"aidingmao://bonus/quan",
                                 @"CardViewController",@"aidingmao://bonus/quanList",
                                 
                                 @"SoldCollectionViewController",@"aidingmao://goods/onsale",
                                 @"SoldCollectionViewController",@"aidingmao://goods/sold",
                                 @"SoldCollectionViewController",@"aidingmao://goods/published",
                                 //支付页面协议修改
                                 @"BoughtCollectionViewController",@"aidingmao://goods/bought",
                                 
                                 @"DataListViewController",@"aidingmao://datalist/",
                                 
                                 @"ExploreViewController",@"aidingmao://explore/",
                                 @"FollowingsViewController",@"aidingmao://feedsFollowingList/",
                                 @"FeedsViewController",@"aidingmao://feedsLatestList/",
                                 @"InviteViewController",@"aidingmao://reward",
                                 
                                 @"NoticeViewControllerPresented",@"aidingmao://notice",
                                 @"ForumPostListViewController",@"aidingmao://forumTopic",
                                 @"ForumPostListViewController",@"aidingmao://forumTopic2", //for 上传图片“回收”
                                 @"ForumPostDetailViewController",@"aidingmao://forumPost",
                                 @"ConsignmentViewController",@"aidingmao://publish/commission",
                                 @"ExploreBrandViewController",@"aidingmao://brandlist",
                                 @"MineIncomeViewController",@"aidingmao://wallet",
                                 @"ChatViewController",@"aidingmao://chat",
                                 
//                                 @"RecoverDetailViewController",@"aidingmao://recovery/goods_detail",
                                 @"OfferedViewController",@"aidingmao://recovery/goods_detail",
                                 @"InsureViewController",@"aidingmao://recovery/bid_page",
                                 @"OfferedViewController",@"aidingmao://recovery/bid_detail",
                                 @"MatchViewController",@"aidingmao://recovery/matcher",
                                 @"RecoverGoodsController",@"aidingmao://recovery/list",
                                 @"ConsultantViewController",@"aidingmao://adviser/list",
                                 @"MainViewController",@"aidingmao://launch",
                                 @"ChatViewController",@"aidingmao://adviser/bing",
                                 @"VerifyViewController", @"aidingmao://user/consign",
                                 @"DiscoveryViewController", @"aidingmao://feeds",
                                 @"CateBrandViewController", @"aidingmao://searchType",
                                 @"ScanCodePaymentViewController", @"aidingmao://service_pay",
                                 @"SeekToPurchasePublishController",@"aidingmao://seekgoods",
//                                 @"UnfinishViewController", @"aidingmao://user/consign",
                                 @"InformationViewController",@"aidingmao://message/activity",
                                 nil];
    
    
    return dict;
}

+ (NSInteger)parseMySaleSelectAtIndex:(NSString*)redirectUri
{
    NSInteger selectAtIndex = 1;
    if ([redirectUri containsString:@"aidingmao://goods/onsale"]) {
        selectAtIndex = 1;
    }
    else if ([redirectUri containsString:@"aidingmao://goods/sold"]) {
        selectAtIndex = 2;
    }
    else if ([redirectUri containsString:@"aidingmao://goods/published"]) {
        selectAtIndex = 0;
    }
    return selectAtIndex;
}

+ (BOOL)locateWithRedirectUri:(NSString*)redirectUri andIsShare:(BOOL)share
{
//    NSString *str = @"aidingmao://forumTopic?topic_id=1&title=全部求购";
//    redirectUri = [str URLEncodedString];
    
//    NSString *str = @"aidingmao://brandlist?title=全部求购";
//    redirectUri = [str URLEncodedString];
    
    BOOL handled = [self locateWithRedirectUriImpl:redirectUri andIsShare:share];
    if (!handled) {
        //过滤
        if ([redirectUri hasPrefix:kURLSchemeAidingmao] && ![redirectUri hasPrefix:@"aidingmao://safepay"] && ![redirectUri isEqualToString:@"aidingmao://"]) {
            //请升级客户端版本
            [WCAlertView showAlertWithTitle:@""
                                    message:@"当前版本不支持该功能，请升级到最新版本"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if (buttonIndex == 0) {
                                 
                             } else {
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
                             }
                         } cancelButtonTitle:@"忽略" otherButtonTitles:@"确定", nil];
        }
    }
    return handled;
}

+ (BOOL)locateWithRedirectUriImpl:(NSString*)redirectUri andIsShare:(BOOL)share{
    
    return [self locateWithRedirectUriImpl:redirectUri andIsShare:share isScanCode:NO];
}

+ (BOOL)locateWithRedirectUriImpl:(NSString*)redirectUri
                       andIsShare:(BOOL)share
                       isScanCode:(BOOL)isScanCode{
    NSString *redirectUriTemp = redirectUri;//[[redirectUri URLDecodedString] URLEncodedString];
    if ([redirectUriTemp length]>0) {
        redirectUri = redirectUriTemp;
    }
    
    BOOL handled = NO;
    if ([redirectUri mag_isEmpty]) {
        return handled;
    }
    if ([redirectUri hasPrefix:kURLSchemeAidingmao]) {
        handled = [self locate:redirectUri];
    }
    if (!handled) {
        NSRange range = [redirectUri rangeOfString:kURLSchemeHttpURL];
        if (range.location != NSNotFound) {
            if ([redirectUri rangeOfString:kURLSchemeHttpURL].length>0) {
                NSMutableString *locateUrlString = [[NSMutableString alloc] initWithString:redirectUri];
                [locateUrlString replaceCharactersInRange:range withString:kURLSchemeAidingmao];
                handled = [self locate:locateUrlString];
            }
        }
        if (!handled) {
            range = [redirectUri rangeOfString:kURLSchemeHttpsURL];
            if (range.location != NSNotFound) {
                if ([redirectUri rangeOfString:kURLSchemeHttpsURL].length>0) {
                    NSMutableString *locateUrlString = [[NSMutableString alloc] initWithString:redirectUri];
                    [locateUrlString replaceCharactersInRange:range withString:kURLSchemeAidingmao];
                    handled = [self locate:locateUrlString];
                }
            }
        }
        if (!handled) {
            NSRange rangeS = [redirectUri rangeOfString:@"https://"];
            NSRange range = [redirectUri rangeOfString:@"http://"];
            if (range.location != NSNotFound || rangeS.location != NSNotFound) {
                
                NSRange rangeShared = [redirectUri rangeOfString:kURLSchemeHttpURLShared];
                NSRange rangeHtml = [redirectUri rangeOfString:@".html"];
                if (rangeShared.location!=NSNotFound && rangeHtml.location!=NSNotFound
                    && rangeHtml.location>rangeShared.location+rangeShared.length) {
                    NSString *goodsId = [redirectUri substringWithRange:NSMakeRange(rangeShared.location+rangeShared.length,rangeHtml.location-(rangeShared.location+rangeShared.length))];
                    
                    GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
                    viewController.goodsId = goodsId;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                    handled = YES;
                }
                
                if (!handled) {
                    rangeShared = [redirectUri rangeOfString:kURLSchemeHttpURLM];
                    rangeHtml = [redirectUri rangeOfString:@".html"];
                    if (rangeShared.location!=NSNotFound && rangeHtml.location!=NSNotFound
                        && rangeHtml.location>rangeShared.location+rangeShared.length) {
                        NSString *goodsId = [redirectUri substringWithRange:NSMakeRange(rangeShared.location+rangeShared.length,rangeHtml.location-(rangeShared.location+rangeShared.length))];
                        
                        GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
                        viewController.goodsId = goodsId;
                        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                        handled = YES;
                    }
                }
                if (!handled) {
                    NSRange rangeUserHomeUrl = [redirectUri rangeOfString:kURLUserHomePrefix];
                    if (rangeUserHomeUrl.location!= NSNotFound && rangeUserHomeUrl.length<redirectUri.length) {
                        NSString *userId = [redirectUri substringWithRange:NSMakeRange(rangeUserHomeUrl.location+rangeUserHomeUrl.length,redirectUri.length-(rangeUserHomeUrl.location+rangeUserHomeUrl.length))];
                        if (userId.length>0 && [userId isNumeric]) {
                            UserHomeViewController *viewController = [[UserHomeViewController alloc] init];
                            viewController.userId = [userId integerValue];
                            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            handled = YES;
                        }
                    }
                }
                
                if (!handled) {
                    WebViewController *viewController = [[WebViewController alloc] init];
                    viewController.url = redirectUri;
                    viewController.isShare = ([redirectUri containsString:@"hideShare"] ? NO : YES);
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                    handled = YES;
                }
            }
        }
        
        if (!handled && isScanCode) {
            if (![redirectUri hasPrefix:kURLSchemeAidingmao]) {
                [WCAlertView showAlertWithTitle:@"提示" message:[NSString stringWithFormat:@"已识别此二维码内容为:\n%@",redirectUri] customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMissScanCodeViewCtrl" object:nil];
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                handled = YES;
            }
        }
    }
    return handled;

    
}



+ (BOOL)locateWithHtml5Url:(NSString*)urlString andIsShare:(BOOL)share
{
    if ([urlString mag_isEmpty]) {
        return NO;
    }
    
    NSRange range = [urlString rangeOfString:kURLSchemeAidingmao];
    if (range.length>0) {
        return [self locate:urlString];
    } else {
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.url = urlString;
        viewController.isShare = ([urlString containsString:@"hideShare"] ? NO : YES);
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        return YES;
    }
    return NO;
    
}

+ (BOOL)locate:(NSString*)urlString
{
    NSString *redirectUriTemp = [[urlString URLDecodedString] URLEncodedString];
    if ([redirectUriTemp length]>0) {
        urlString = redirectUriTemp;
    }
    
    BOOL handled = NO;
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *query = url.query;
    NSString *locatorUrl = [NSString stringWithFormat:@"%@://%@%@",url.scheme,url.host,url.path];
    NSString *className = [[self locatorMap] objectForKey:locatorUrl];
    
    if (className && [className length]>0) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        id object = [[NSClassFromString(className) alloc] init];
        NSLog(@"%@", object);
        if ([object isKindOfClass:[UserHomeViewController class]] && [params objectForKey:@"userid"]) {
            NSInteger userId = [[params objectForKey:@"userid"] integerValue];
            UserHomeViewController *viewController = (UserHomeViewController*)object;
            viewController.userId = userId;
            [[Session sharedInstance] client:HomeChosenUserHomeRegionCode data:@{@"userId":@(userId)}];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[FollowsViewController class]]) {
            NSInteger userId = [[params objectForKey:@"userid"] integerValue];
            BOOL isFans = [urlString rangeOfString:@"fans"].length>0;
            FollowsViewController *viewController = (FollowsViewController*)object;
            viewController.isFans = isFans;
            viewController.userId = userId;
            
            if (isFans) {
                [[Session sharedInstance] client:MineFansViewCode data:@{@"userId":@(userId)}];
            } else {
               [[Session sharedInstance] client:MineAttentionViewCode data:@{@"userId":@(userId)}];
            }
            
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
#pragma mark tomorrow go on
        else if ([object isKindOfClass:[GoodsDetailViewControllerContainer class]] && [params objectForKey:@"goodsid"]) {
            NSString *goodsId = [params valueForKey:@"goodsid"] ;
            GoodsDetailViewControllerContainer *viewController = (GoodsDetailViewControllerContainer*)object;
            viewController.goodsId = goodsId;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[BrandViewController class]]) {
            BrandViewController *viewController = (BrandViewController*)object;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[SearchViewController class]]) {
            NSString *paramsJsonData = [params valueForKey:@"param"];
            SearchViewController *viewController = (SearchViewController*)object;
            SearchFilterItem *item = [[SearchFilterItem alloc] init];
            viewController.queryKey = [item fromRedirectUri:urlString];
            viewController.filterItem = item;
            if ([paramsJsonData length]>0) {
                viewController.queryKVItemsArray = [SearchViewController createQueryFilterKVs:[paramsJsonData URLDecodedString]];
            }
            handled = YES;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            
        }
        else if ([object isKindOfClass:[BonusCodeConvertController class]]) {
            BonusCodeConvertController *viewController = (BonusCodeConvertController*)object;
            NSString *code = [params valueForKey:@"code"] ;
            viewController.code = code;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[CardViewController class]]) {
            CardViewController *viewController = (CardViewController*)object;
            NSInteger index = [params integerValueForKey:@"type"];
            if (index == 0) {
                viewController.segmentControl.selectedSegmentIndex = 0;
            } else {
                viewController.segmentControl.selectedSegmentIndex = 1;
            }
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[RecoverGoodsController class]]) {
            RecoverGoodsController *viewController = (RecoverGoodsController*)object;
            
            [[Session sharedInstance] client:RecoveryGoodsViewCode data:nil];
            
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[BoughtCollectionViewController class]]) {
            BoughtCollectionViewController *viewController = (BoughtCollectionViewController*)object;
            
            [[Session sharedInstance] client:MineBoughtViewCode data:nil];
            
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[SoldCollectionViewController class]]) {
            SoldCollectionViewController *viewController = (SoldCollectionViewController*)object;
            //传入localtorurl
//            viewController.selectAtIndex = [self parseMySaleSelectAtIndex:locatorUrl];
            [[Session sharedInstance] client:MineSoldViewCode data:nil];
            
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[DataListViewController class]]
                 && [params objectForKey:@"module"]
                 && [params objectForKey:@"path"]) {
            NSString *module = [[params valueForKey:@"module"]  URLDecodedString];
            NSString *path = [[params valueForKey:@"path"] URLDecodedString];
            NSString *title = [[params valueForKey:@"title"]  URLDecodedString];
            NSString *params_string = [params valueForKey:@"params"] ;
            BOOL is_separate = [[[params stringValueForKey:@"is_separate"] trim] isEqualToString:@"1"]?YES:NO;
            if ([module length]>0 && [path length]>0) {
                DataListViewController *viewController = (DataListViewController*)object;
                viewController.module = module;
                viewController.path = path;
                viewController.title = title;
                viewController.params = params_string;
                viewController.isNeedShowSeperator = is_separate;
                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                handled = YES;
            }
        }
        else if ([object isKindOfClass:[ExploreViewController class]]) {
            NSInteger tabIndex = [[params objectForKey:@"tab_index"] integerValue];
            ExploreViewController  *viewController = (ExploreViewController*)object;
            viewController.tabIndex = tabIndex;
            viewController.isShowBackBtn = YES;
            
            [[Session sharedInstance] client:CatalogueViewCode data:nil];
            
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[FeedsViewController class]]) {
            FeedsViewController  *viewController = (FeedsViewController*)object;
            NSString *title = [[params valueForKey:@"title"]  URLDecodedString];
            viewController.title = title;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[FollowingsViewController class]]) {
            FollowingsViewController  *viewController = (FollowingsViewController*)object;
            NSString *title = [[params valueForKey:@"title"] URLDecodedString];
            viewController.title = title;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[InviteViewController class]]) {
            InviteViewController  *viewController = (InviteViewController*)object;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[NoticeViewControllerPresented class]]) {
            if ([Session sharedInstance].isLoggedIn) {
                NoticeViewControllerPresented  *viewController = (NoticeViewControllerPresented*)object;
                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            }
            handled = YES;
        }
        else if ([object isKindOfClass:[ForumPostListViewController class]]) {
            NSInteger topic_id = [[params objectForKey:@"topic_id"] integerValue];
            NSString *title = [[params valueForKey:@"title"] URLDecodedString];
            ForumPostListViewController *viewController = (ForumPostListViewController*)object;
            viewController.title = title;
            viewController.topic_id = topic_id;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[ForumPostDetailViewController class]]) {
            //aidingmao://forumPost?topic_id=XXX&post_id=XXX
            NSInteger post_id = [[params objectForKey:@"post_id"] integerValue];
            ForumPostDetailViewController *viewController = (ForumPostDetailViewController*)object;
            viewController.post_id = post_id;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[ExploreBrandViewController class]]) {
            NSString *title = [[params valueForKey:@"title"]  URLDecodedString];
            NSString *params_string = [params valueForKey:@"params"] ;
            ExploreBrandViewController *viewController = (ExploreBrandViewController*)object;
            viewController.isShowTitleBar = YES;
            viewController.title = title;
            viewController.params = params_string;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[MineIncomeViewController class]]) {
            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:[CoordinatingController sharedInstance].visibleController completion:nil];
            if (isLoggedIn) {
                MineIncomeViewController *viewController = (MineIncomeViewController*)object;
                
                [[Session sharedInstance] client:MinePurseViewCode data:nil];
                
                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            }
            handled = YES;
        }
        else if ([object isKindOfClass:[ChatViewController class]]) {
            
            NSInteger user_id = [[params objectForKey:@"user_id"] integerValue];
            NSString *msg = [[params valueForKey:@"message"] URLDecodedString];
            NSInteger type = [[params objectForKey:@"type"] integerValue];
            if (user_id == 0) {
                NSInteger userId = [Session sharedInstance].currentUserId;
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"bind_adviser" parameters:@{@"user_id":[NSNumber numberWithInteger:userId]} completionBlock:^(NSDictionary *data) {
                    
                    AdviserPage *adviser = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                    [UserSingletonCommand chatWithUserHasWXNum:adviser.userId msg:[NSString stringWithFormat:@"%@", adviser.greetings] adviser:adviser nadGoodsId:nil];
                    
                } failure:nil queue:nil]];
            } else {
                [[Session sharedInstance] client:ChatViewCode data:@{@"userId":@(user_id)}];
                
                if (type == 1) {
                    [UserSingletonCommand chatWithUserJimai:user_id msg:msg isJimai:YES];
                }else{
                    [UserSingletonCommand chatWithUserFirst:user_id msg:msg];
                }
            }
            handled = YES;
        }
        else if ([object isKindOfClass:[OfferedViewController class]]) {
            NSString *goods_sn = [params objectForKey:@"goods_sn"];
//            RecoverDetailViewController *viewController = (RecoverDetailViewController*)object;
            OfferedViewController *viewController = (OfferedViewController *)object;
            viewController.goodID = goods_sn;
            
            [[Session sharedInstance] client:RecoveryGoodsDetailViewCode data:@{@"goodsId":goods_sn}];
            
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        
        else if ([object isKindOfClass:[InsureViewController class]]) {
            NSString *goods_sn = [params objectForKey:@"goods_sn"];
            NSNumber *userid = [params objectForKey:@"userid"];
            InsureViewController *viewController = (InsureViewController*)object;
            viewController.goodsID = goods_sn;
            viewController.userid = userid;
            viewController.index = 1;
            
            [[Session sharedInstance] client:RecoveryGoodsQuoteViewCode data:@{@"goodsId":goods_sn}];
            
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        
        else if ([object isKindOfClass:[OfferedViewController class]]) {
            NSString *goods_sn = [params objectForKey:@"goods_sn"];
//            NSNumber *userid = [params objectForKey:@"userid"];
            OfferedViewController *viewController = (OfferedViewController*)object;
            viewController.goodID = goods_sn;
//            viewController.userid = userid;
            [[Session sharedInstance] client:RecoveryGoodsDetailViewCode data:@{@"goodsId":goods_sn}];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        
        else if ([object isKindOfClass:[MatchViewController class]]) {
            NSString *goods_sn = [params objectForKey:@"goods_sn"];
            MatchViewController *viewController = (MatchViewController *)object;
            viewController.goods_id = goods_sn;
            [[Session sharedInstance] client:MatchViewCode data:@{@"goodsId":goods_sn}];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        
        else if ([object isKindOfClass:[ConsultantViewController class]]) {
            ConsultantViewController *viewController = (ConsultantViewController *)object;
            [[Session sharedInstance] client:MineConsultantViewCode data:nil];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        
        else if ([object isKindOfClass:[MainViewController class]]) {
            MainViewController *m = (MainViewController *)object;
            [UIApplication sharedApplication].keyWindow.rootViewController = m;
            [m setSelectedAtIndex:3];
            handled = YES;
        }
        
        else if ([object isKindOfClass:[VerifyViewController class]]) {
            NSInteger status = [params integerValueForKey:@"status"];
            if (status == 11 || status == 12 || status == 13 || status == 14) {
                if (status == 11) {
                    VerifyViewController *viewController = [[VerifyViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else if (status == 12) {
                    VerifyViewController *viewController = [[VerifyViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else if (status == 13 || status == 14) {
                    VerifyViewController *viewController = [[VerifyViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else {
                    VerifyViewController *viewController = [[VerifyViewController alloc] init];
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                }
                
            } else if (status == 21 || status == 22 || status == 23) {
                if (status == 21) {
                    SaleStateViewController *viewController = [[SaleStateViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else if (status == 22) {
                    SaleStateViewController *viewController = [[SaleStateViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else if (status == 23) {
                    SaleStateViewController *viewController = [[SaleStateViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else {
                    SaleStateViewController *viewController = [[SaleStateViewController alloc] init];
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                }
            } else if (status == 31 || status == 32 || status == 33) {
                if (status == 31) {
                    UnfinishViewController *viewController = [[UnfinishViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else if (status == 32) {
                    UnfinishViewController *viewController = [[UnfinishViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else if (status == 33) {
                    UnfinishViewController *viewController = [[UnfinishViewController alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
                    viewController.selectedIndexPath = indexPath;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                } else {
                    UnfinishViewController *viewController = [[UnfinishViewController alloc] init];
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                }
            }
            handled = YES;
        }
        else if ([object isKindOfClass:[DiscoveryViewController class]]) {
            DiscoveryViewController *viewController = (DiscoveryViewController *)object;
            viewController.urlStr = [params objectForKey:@"url"];
            NSString *titleText = [params objectForKey:@"title"];
            viewController.titleText = [titleText URLDecodedString];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        else if ([object isKindOfClass:[CateBrandViewController class]]) {
            CateBrandViewController *viewController = (CateBrandViewController *)object;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        //线下洗护支付
        else if ([object isKindOfClass:[ScanCodePaymentViewController class]]) {
            ScanCodePaymentViewController *controller = [[ScanCodePaymentViewController alloc] init];
            NSInteger userId;
            if ([params objectForKey:@"user_id"] == [NSNull null]) {
                NSString *enUserId = [[params objectForKey:@"param"] URLDecodedString];
                userId = [enUserId AES128EncryptWithKey:KEY_VALUE].integerValue;
            } else {
                userId = [params integerValueForKey:@"param"];
            }
            
            NSString *title = [[params objectForKey:@"title"] URLDecodedString];
            controller.topBarTitle = title;
            controller.userId = userId;
            [[CoordinatingController sharedInstance] pushViewController:controller animated:YES];
            handled = YES;
        }
        //全球找货
        else if ([object isKindOfClass:[SeekToPurchasePublishController class]]) {
            SeekToPurchasePublishController *viewController = [[SeekToPurchasePublishController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            handled = YES;
        }
        
        else if ([object isKindOfClass:[ConsignmentViewController class]]){
            ConsignmentViewController * viewController = [[ConsignmentViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        }
        
        else if ([object isKindOfClass:[InformationViewController class]]){
            [[CoordinatingController sharedInstance].mainViewController dismiss:YES];
            [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:3];
        }
    }
    else
    {
        if ([urlString rangeOfString:@"aidingmao://app/call"].length>0) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [query componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            
            NSString *phone = [params valueForKey:@"phonenumber"] ;
            if ([phone length]>0) {
                [UIActionSheet showInView:nil
                                withTitle:nil
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:@"拨打电话"
                        otherButtonTitles:nil //[NSArray arrayWithObjects:@"拨打客服电话", nil]
                                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                     if (buttonIndex == 0) {
                                         NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                     }
                                 }];
                
                handled = YES;
            }
        } else if ([urlString rangeOfString:@"aidingmao://app/share"].length > 0) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [query componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            
//            public static final String SHARE_TITLE = "share_title";
//            public static final String SHARE_CONTENT = "share_content";
//            public static final String SHARE_IMAGE = "share_image";
//            public static final String SHARE_URL = "share_url";
            
            NSString *title = [[params valueForKey:@"share_title"] URLDecodedString];
            NSString *desc = [[params valueForKey:@"share_content"] URLDecodedString];
            NSString *shareImageUrl = [[params valueForKey:@"share_image"] URLDecodedString];
            NSString *shareUrl = [[params valueForKey:@"share_url"] URLDecodedString];
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:shareImageUrl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                [[CoordinatingController sharedInstance] shareWithTitle:title image:image url:shareUrl content:desc];
            }];

            handled = YES;
            
        }
    }
    
    return handled;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dissMissScanCodeViewCtrl" object:nil];
}


@end



