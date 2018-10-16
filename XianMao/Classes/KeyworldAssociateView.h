//
//  KeyworldAssociateView.h
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullRefreshTableView;

@protocol KeyworldAssociateView <NSObject>
@optional
- (void)doSearchWithKeyworlds:(NSString *)keyworlds;
- (void)keybordResignFirstResponder;

@end

@interface KeyworldAssociateView : UIView

@property (nonatomic, weak) id<KeyworldAssociateView> delegate;
@property (nonatomic, strong) PullRefreshTableView * tableView;

- (void)getKeyworldsArr:(NSArray *)array keyworlds:(NSString *)SearchKeyworlds;

@end
