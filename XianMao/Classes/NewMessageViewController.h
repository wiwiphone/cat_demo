//
//  NewMessageViewController.h
//  XianMao
//
//  Created by 阿杜 on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface NewMessageViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end


@interface NewInformationCell : UITableViewCell

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *myTitleLB;
@property (nonatomic, strong) UILabel *mySubTitleLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *numLB;


- (void) updateWithDic:(NSDictionary *)dic;

@end