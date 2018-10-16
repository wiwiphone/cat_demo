//
//  DidPriceViewController.h
//  XianMao
//
//  Created by 阿杜 on 16/3/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

//#import "BaseViewController.h"
#import "BaseTableViewController.h"
#import "XMWebImageView.h"
@interface DidPriceViewController : BaseTableViewController

//@property (nonatomic, strong) PullRefreshTableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewTwo;
@property (nonatomic, strong) UITableView *tableViewThree;
@property (nonatomic, strong) UITableView *tableViewFour;
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSMutableArray *dataSourceArrOne;
@property (nonatomic, strong) NSMutableArray *dataSourceArrTwo;
@property (nonatomic, strong) NSMutableArray *dataSourceArrThree;
@property (nonatomic, strong) NSMutableArray *dataSourceArrFour;

@property (nonatomic, strong) NSString *dataURL;

@property (assign, nonatomic) NSInteger followPageOne;
@property (assign, nonatomic) NSInteger followPageTwo;
@property (assign, nonatomic) NSInteger followPageThree;
@property (assign, nonatomic) NSInteger followPageFour;

@property (nonatomic, strong) UIImageView *noContentImageViewOne;
@property (nonatomic, strong) UIImageView *noContentImageViewTwo;
@property (nonatomic, strong) UIImageView *nocontentImageViewThree;
@property (nonatomic, strong) UIImageView *noContentImageViewFour;

@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@property (nonatomic, strong) UILabel *labelThree;
@property (nonatomic, strong) UILabel *labelFour;

@end

@class didPriceCellModel;
@interface didPriceCell : UITableViewCell

@property (nonatomic, strong) XMWebImageView *myImageView;
@property (nonatomic, strong) UILabel *myTitleLB;
@property (nonatomic, strong) UILabel *myNewLB;
@property (nonatomic, strong) UILabel *sourceLB;
@property (nonatomic, strong) UILabel *countLB;
@property (nonatomic, strong) UILabel *fontPriceLB;
@property (nonatomic, strong) UILabel *priceLB;
@property (nonatomic, strong) UILabel *statusLB;
@property (nonatomic, strong) UIView *HXView;

- (void)updataWithDic:(NSDictionary *)dic;
- (void)updataWithModel:(didPriceCellModel *)model;

@end

@interface didPriceCellModel : NSObject

@property (nonatomic, strong) NSString *brandEnName;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *goodsSn;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSDictionary *mainPic;
@property (nonatomic, strong) NSString *myBidPrice;
@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *totalBidNum;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@end
