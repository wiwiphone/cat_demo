//
//  ConsignViewController.h
//  XianMao
//
//  Created by simon on 12/2/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface ConsignViewController : BaseViewController

@end


@interface ConsignSubmitPicsViewController : BaseViewController
@property (nonatomic, assign) CGFloat marginTop;
@property(nonatomic,strong) UIScrollView *scrollView;
@end

@interface ConsignSubmitedViewController : BaseViewController

@end


@interface ConsignOrderListViewController : BaseViewController

@end

@class ConsignOrder;
@interface ConsignOrderDetailViewController : BaseViewController

@property(nonatomic,strong) ConsignOrder *consignOrder;

@end




//@interface ConsignServiceViewController : BaseViewController
//
//@end
//
//@interface ConsignCateViewController : BaseViewController
//
//@end
//
//@interface ConsignWayViewController : BaseViewController
//
//@property(nonatomic,strong) NSArray *cateIds;
//
//@end
//
//@interface ConsignSubmitAddressViewController : BaseViewController
//
//@property(nonatomic,strong) NSArray *cateIds;
//
//@end




//@interface ConsignSubmitViewController : BaseViewController
//
//@end
//
//
//@interface SaleMailAddressViewController : BaseViewController
//
//@end

