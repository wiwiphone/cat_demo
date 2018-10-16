//
//  UserAddressViewController.h
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@class AddressInfo;

@interface UserAddressViewController : BaseViewController

@property(nonatomic,strong) NSArray *addressList;

@property(nonatomic,assign) BOOL isForSelectAddress;
@property(nonatomic,assign) NSInteger seletedAddressId;

@property(nonatomic,copy) void(^handleAddressSelected)(UserAddressViewController *viewController, AddressInfo *addressInfo);

@end


@class EditAddressViewController;

@protocol EditAddressViewControllerDelegate <NSObject>
- (void)editAddressSaved:(EditAddressViewController*)viewController addressInfo:(AddressInfo*)addressInfo;
@end

@interface EditAddressViewController : BaseViewController
@property(nonatomic,assign) id<EditAddressViewControllerDelegate> delegate;
@property(nonatomic,strong) AddressInfo *addressInfo;
@property(nonatomic,assign) NSInteger totalAddressNum; //如果只有一个地址
@property(nonatomic,assign) BOOL isForReturn;
@end



@interface UserAddressViewControllerReturn : UserAddressViewController

@end



//address/list[GET]{type(0收货1退货)}
//address/add[POST]{type, address_info(结构)}
//address/modify[POST]{type, address_info(结构)}
//address/remove[POST]{address_id_list[id]}


