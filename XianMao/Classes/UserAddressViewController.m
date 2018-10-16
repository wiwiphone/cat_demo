//
//  UserAddressViewController.m
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "UserAddressViewController.h"
#import "NSString+Validation.h"
#import "NSString+Addtions.h"
#import "AddressInfo.h"

#import "PullRefreshTableView.h"

#import "Command.h"

#import "NetworkAPI.h"
#import "Session.h"

#import "UserAddressTableViewCell.h"
#import "PlaceHolderTextView.h"
#import "KLSwitch.h"

#import "AreaViewController.h"


@interface UserAddressViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,SwipeTableCellDelegate,EditAddressViewControllerDelegate,UserAddressChangedReceiver>

@property(nonatomic,strong) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation UserAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.isForSelectAddress?@"选择收货地址":@"管理收货地址"];
    [super setupTopBarBackButton];
    if (self.isForSelectAddress) {
        [super setupTopBarRightButton];
        [super.topBarRightButton setTitle:@"管理" forState:UIControlStateNormal];
        [super.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        self.topBarRightButton.backgroundColor = [UIColor clearColor];
    } else {
        [super setupTopBarRightButton:[UIImage imageNamed:@"add.png"] imgPressed:nil];
    }
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.enableLoadingMore = NO;
    self.tableView.pullDelegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _dataSources = [[NSMutableArray alloc] init];
    
    if (!self.addressList) {
        [self showLoadingView];
        [self reloadData];
    } else {
        [self $$handleFetchAddressListDidFinishNotification:nil addressList:_addressList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_request cancel];
}

- (void)reloadData
{
    WEAKSELF;
    //[weakSelf showProcessingHUD:nil forView:self.view];
    _request = [[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId completion:^(NSArray *addressDictList) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *addressList = [[NSMutableArray alloc] init];
        if (addressDictList && [addressDictList count] > 0) {
            for (NSDictionary *dict in addressDictList) {
                [addressList addObject:[AddressInfo createWithDict:dict]];
            }
        }
        MBGlobalSendFetchAddressListDidFinishNotification(addressList);
        weakSelf.tableView.pullTableIsRefreshing = NO;
        //[weakSelf hideHUD];
        
    } failure:^(XMError *error) {
        
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                [weakSelf reloadData];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
    }];
}

- (void)editAddressSaved:(EditAddressViewController*)viewController addressInfo:(AddressInfo*)addressInfo {
    
    
}

-(NSArray*)createRightButtons
{
    int number = 2;
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@" 删除 ", @" 修改 "};
    UIColor * colors[2] = {[UIColor redColor], [UIColor lightGrayColor]};
    for (int i = 0; i < number; ++i)
    {
        SwipeCellButton * button = [SwipeCellButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(SwipeTableViewCell * sender){
//            NSLog(@"Convenience callback received (right).");
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

-(NSArray*)swipeTableCell:(SwipeTableViewCell*) cell swipeButtonsForDirection:(SwipeDirection)direction
         swipeCellSettings:(SwipeSettings*) swipeSettings expansionSettings:(SwipeExpansionSettings*) expansionSettings {
    swipeSettings.transition = SwipeTransitionBorder;
    
    if (direction == SwipeDirectionLeftToRight) {
        return nil;
    }
    else {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = YES;
        return [self createRightButtons];
    }
}

-(BOOL)swipeTableCell:(SwipeTableViewCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(SwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == SwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if (direction == SwipeDirectionRightToLeft && index == 0) {
        //delete button
        
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        NSDictionary *dict = [_dataSources objectAtIndex:path.row];
        AddressInfo *addressInfo = [dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        
        if ([addressInfo isDefault]) {
             [self showHUD:@"不能删除默认收货地址" hideAfterDelay:0.8f forView:self.view];
        } else {
            NSInteger addressId = addressInfo.addressId;
            WEAKSELF;
            [weakSelf showProcessingHUD:nil forView:weakSelf.view];
            _request = [[NetworkAPI sharedInstance] delUserAddress:[Session sharedInstance].currentUserId addressId:addressInfo.addressId completion:^{
                [weakSelf hideHUD];
                MBGlobalSendRemoveAddressDidFinishNotification(addressId);
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
        }
    } else if (direction == SwipeDirectionRightToLeft && index == 1) {
        
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        
        AddressInfo *addressInfo = (AddressInfo*)[[_dataSources objectAtIndex:[path row]] objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
        viewController.title = @"编辑收货地址";
        viewController.addressInfo = addressInfo;
        viewController.totalAddressNum = [_dataSources count];
        viewController.delegate = self;
        NSDictionary *data = @{@"type":@1};
        if (self.isForSelectAddress) {
            [ClientReportObject clientReportObjectWithViewCode:ManagePutGoodsAddrViewCode regionCode:AddPutGoodsAddrViewCode referPageCode:AddPutGoodsAddrViewCode andData:data];
        } else {
            [ClientReportObject clientReportObjectWithViewCode:ManageOutGoodsAddrViewCode regionCode:AddOutGoodsAddrViewCode referPageCode:AddOutGoodsAddrViewCode andData:data];
        }
        
        [super pushViewController:viewController animated:YES];
    }
    return YES;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    if (self.isForSelectAddress) {
        UserAddressViewController *viewController = [[UserAddressViewController alloc] init];
        viewController.isForSelectAddress = NO;
        
        NSMutableArray *addressList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[self.dataSources count];i++) {
            NSMutableDictionary *dict = (NSMutableDictionary*)[self.dataSources objectAtIndex:i];
            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                AddressInfo *addressInfoTemp = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                [addressList addObject:addressInfoTemp];
            }
        }
        viewController.addressList =addressList;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
        viewController.title = @"新增收货地址";
        viewController.delegate = self;
        viewController.totalAddressNum = [self.dataSources count];
        NSDictionary *data = @{@"type":@0};
        if (self.isForSelectAddress) {
            [ClientReportObject clientReportObjectWithViewCode:ManagePutGoodsAddrViewCode regionCode:AddPutGoodsAddrViewCode referPageCode:AddPutGoodsAddrViewCode andData:data];
        } else {
            [ClientReportObject clientReportObjectWithViewCode:ManageOutGoodsAddrViewCode regionCode:AddOutGoodsAddrViewCode referPageCode:AddOutGoodsAddrViewCode andData:data];
        }
        [super pushViewController:viewController animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    _tableView.pullTableIsRefreshing = YES;
    [self reloadData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
    }
    [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([tableViewCell isKindOfClass:[UserAddressTableViewCell class]]) {
        ((UserAddressTableViewCell*)tableViewCell).swipeCellDelegate = self.isForSelectAddress?nil:self;
        ((UserAddressTableViewCell*)tableViewCell).isForSelectAddress = self.isForSelectAddress;
    }
    
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isForSelectAddress) {
        AddressInfo *addressInfo = (AddressInfo*)[[_dataSources objectAtIndex:[indexPath row]] objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        if (_handleAddressSelected) {
            _handleAddressSelected(self,addressInfo);
        }
        [self dismiss];
    } else {
        AddressInfo *addressInfo = (AddressInfo*)[[_dataSources objectAtIndex:[indexPath row]] objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
        viewController.title = @"编辑收货地址";
        viewController.addressInfo = addressInfo;
        viewController.totalAddressNum = [_dataSources count];
        viewController.delegate = self;
        [super pushViewController:viewController animated:YES];
    }
}

- (void)$$handleFetchAddressListDidFinishNotification:(id<MBNotification>)notifi addressList:(NSArray*)addressList
{
    [self handleFetchAddressListDidFinishNotification:notifi addressList:addressList];
}

- (void)handleFetchAddressListDidFinishNotification:(id<MBNotification>)notifi addressList:(NSArray*)addressList
{
    WEAKSELF;
    NSMutableArray *dataSources = [[NSMutableArray alloc] init];
    for (AddressInfo *addressInfo in addressList) {
        if ([addressInfo isKindOfClass:[AddressInfo class]]) {
            NSMutableDictionary *dict = [UserAddressTableViewCell buildCellDict:addressInfo];
            [dict setObject:[NSNumber numberWithBool:addressInfo.addressId==weakSelf.seletedAddressId] forKey:[UserAddressTableViewCell cellDictKeyForSelected]];
            [dataSources addObject:dict];
        }
    }
    weakSelf.dataSources = dataSources;
    [weakSelf.tableView reloadData];
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加收货地址"];
    }
}

- (void)$$handleUserDefaultAddressChangedNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    [self handleUserDefaultAddressChangedNotification:notifi addressInfo:addressInfo];
}
- (void)handleUserDefaultAddressChangedNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
//    if (!self.isForSelectAddress) {
        if (addressInfo.isDefault) {
            NSMutableArray *dataSources = [[NSMutableArray alloc] initWithArray:self.dataSources];
            
            NSInteger removedIndex = -1;
            for (NSInteger i=0;i<[dataSources count];i++) {
                NSMutableDictionary *dict = (NSMutableDictionary*)[dataSources objectAtIndex:i];
                if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                    AddressInfo *addressInfoTemp = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                    if (addressInfoTemp.addressId == addressInfo.addressId) {
                        removedIndex = i;
                    } else {
                        addressInfoTemp.isDefault = NO;
                    }
                }
            }
            if (removedIndex>=0 && removedIndex<[dataSources count]) {
                [dataSources removeObjectAtIndex:removedIndex];
            }
            
            [dataSources insertObject:[UserAddressTableViewCell buildCellDict:addressInfo] atIndex:0];
            self.dataSources = dataSources;
            [self.tableView reloadData];
        }
//    }
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加收货地址"];
    }
}

- (void)$$handleAddAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    [self handleAddAddressDidFinishNotification:notifi addressInfo:addressInfo];
}

- (void)handleAddAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    if (addressInfo) {
        if ([self.dataSources count]>0) {
            [self.dataSources insertObject:[UserAddressTableViewCell buildCellDict:addressInfo] atIndex:1];
        } else {
            [self.dataSources insertObject:[UserAddressTableViewCell buildCellDict:addressInfo] atIndex:0];
        }
        [self.tableView reloadData];
    }
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加收货地址"];
    }
}

- (void)$$handleRemoveAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSNumber*)addressId
{
    [self handleRemoveAddressDidFinishNotification:notifi addressId:addressId];
}
- (void)handleRemoveAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSNumber*)addressId
{
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSDictionary *dict = (NSDictionary*)[self.dataSources objectAtIndex:i];
        if ([dict isKindOfClass:[NSDictionary class]]) {
             AddressInfo *addressInfo = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
            if (addressInfo.addressId == [addressId integerValue]) {
                [self.dataSources removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    if (self.isForSelectAddress) {
        if (self.seletedAddressId == [addressId integerValue]) {
            if ([self.dataSources count]>0) {
                NSMutableDictionary *dict = (NSMutableDictionary*)[self.dataSources objectAtIndex:0];
                if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                    AddressInfo *addressInfo = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                    if (_handleAddressSelected) {
                        _seletedAddressId = addressInfo.addressId;
                        [dict setObject:[NSNumber numberWithBool:YES] forKey:[UserAddressTableViewCell cellDictKeyForSelected]];
                        _handleAddressSelected(self,addressInfo);
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加收货地址"];
    }
}

- (void)$$handleModifyAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    [self handleModifyAddressDidFinishNotification:notifi addressInfo:addressInfo];
}
- (void)handleModifyAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSMutableDictionary *dict = (NSMutableDictionary*)[self.dataSources objectAtIndex:i];
        if ([dict isKindOfClass:[NSMutableDictionary class]]) {
            AddressInfo *addressInfoTemp = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
            if (addressInfoTemp.addressId == addressInfo.addressId) {
                [dict setObject:addressInfo forKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                [self.tableView reloadData];
                break;
            }
        }
    }
}

@end

//@property(nonatomic,assign) NSInteger addressId;
//@property(nonatomic,copy)   NSString *areaCode;
//@property(nonatomic,copy)   NSString *areaDetail;
//@property(nonatomic,copy)   NSString *receiver;
//@property(nonatomic,copy)   NSString *phoneNumber;
//@property(nonatomic,copy)   NSString *address;
//@property(nonatomic,copy)   NSString *zipcode;
//@property(nonatomic,assign) BOOL isDefault;

@interface EditAddressViewController () <UITextFieldDelegate,AreaViewControllerDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,weak) UITextField *receiverTextFiled;
@property(nonatomic,weak) UITextField *phoneNumberTextFiled;
@property(nonatomic,weak) UITextField *zipcodeTextFiled;
@property(nonatomic,weak) UITextField *areaDetailTextFiled;
@property(nonatomic,weak) PlaceHolderTextView *addressTextView;

@property(nonatomic,strong) KLSwitch *switchBtn;


@property(nonatomic,copy) NSString *districtID;
@property(nonatomic,copy) NSString *areaName;

@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation EditAddressViewController

- (id)init {
    self = [super init];
    if (self){
        _isForReturn = NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    if (_isForReturn) {
        [super setupTopBarTitle:self.title&&[self.title length]>0?self.title:@"编辑退货地址"];
    } else {
        [super setupTopBarTitle:self.title&&[self.title length]>0?self.title:@"编辑收货地址"];
    }
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [super.topBarRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [super.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
 
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.alwaysBounceVertical  =YES;
    [self.view addSubview:_scrollView];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:_scrollView];
    
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = 16.f;
    self.contentView.frame = frame;
    [_scrollView addSubview:self.contentView];
    
    if (_contentView.bounds.size.height+_contentView.frame.origin.y>_scrollView.bounds.size.height) {
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _contentView.bounds.size.height+_contentView.frame.origin.y);
    }
    
    [super bringTopBarToTop];
    
    
    WEAKSELF;
    _scrollView.keyboardWillChange = ^(CGRect beginKeyboardRect, CGRect endKeyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             
                             if (showKeyborad) {
                                 CGFloat keyboardHeight = [weakSelf.view convertRect:endKeyboardRect fromView:nil].size.height;
                                 CGFloat contentY = weakSelf.contentView.frame.origin.y;
                                 CGFloat contentHeight = weakSelf.contentView.bounds.size.height;
                                 CGFloat targetEndY = contentY-(weakSelf.scrollView.bounds.size.height-keyboardHeight-contentHeight)/2;
                                 
                                 CGFloat visibleHeight = weakSelf.view.bounds.size.height-keyboardHeight-weakSelf.topBarHeight;
                                 if (visibleHeight<contentHeight) {
                                     targetEndY = contentY-15;
                                 }
                                 
                                 [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, contentY+contentHeight)];
                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(-targetEndY, 0, 0, 0)];
                                 [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height+contentY+15+(contentHeight-visibleHeight))];
                                 
                             } else {
                                 [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, weakSelf.view.bounds.size.height-weakSelf.scrollView.frame.origin.y)];
                                 [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                                 [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height)];
                             }
                         }
                         completion:nil];
    };
    
    _scrollView.keyboardDidChange = ^(BOOL didShowed) {
        
    };
    
    [self setupForDismissKeyboard];
    
    
    if (_addressInfo) {
        _receiverTextFiled.text = _addressInfo.receiver;
        _phoneNumberTextFiled.text = _addressInfo.phoneNumber;
        _areaDetailTextFiled.text = _addressInfo.areaDetail;
        _zipcodeTextFiled.text = _addressInfo.zipcode;
        _addressTextView.text = _addressInfo.address;
        
        self.districtID = _addressInfo.areaCode;
        self.areaName = _addressInfo.areaDetail;
    } else {
        _addressInfo = [[AddressInfo alloc] init];
        
        _receiverTextFiled.text = [Session sharedInstance].currentUser.userName;
        _phoneNumberTextFiled.text = [Session sharedInstance].currentUser.phoneNumber;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:NO];
    
//    WEAKSELF;
//    [weakSelf.scrollView setFrame:CGRectMake(0, weakSelf.scrollView.frame.origin.y, weakSelf.scrollView.bounds.size.width, weakSelf.view.bounds.size.height-weakSelf.scrollView.frame.origin.y)];
//    [weakSelf.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, 0)];
        
        CGFloat marginTop = 0.f;
        
        UIView *view = [self createEditAddressItemView:@"收件人" frame:CGRectMake(0, marginTop, _contentView.bounds.size.width, 45)];
        _receiverTextFiled = (UITextField*)[view viewWithTag:100];
        _receiverTextFiled.returnKeyType = UIReturnKeyNext;
        [_contentView addSubview:view];
        marginTop += view.bounds.size.height;
        
        view = [self createEditAddressItemView:@"电话号码" frame:CGRectMake(0, marginTop, _contentView.bounds.size.width, 45)];
        _phoneNumberTextFiled = (UITextField*)[view viewWithTag:100];
        [_contentView addSubview:view];
        marginTop += view.bounds.size.height;
        
        view = [self createEditAddressItemView:@"所在地区" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 45)];
        _areaDetailTextFiled = (UITextField*)[view viewWithTag:100];
        _areaDetailTextFiled.tag = 200;
        [_contentView addSubview:view];
        marginTop += view.bounds.size.height;
        
//        view = [self createEditAddressItemView:@"邮编" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 49)];
//        _zipcodeTextFiled = (UITextField*)[view viewWithTag:100];
//        [_contentView addSubview:view];
//        marginTop += view.bounds.size.height;
        
        view = [self createEditAddressDetailView:@"详细地址" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 45)];
        _addressTextView = (PlaceHolderTextView*)[view viewWithTag:100];
        [_contentView addSubview:view];
        marginTop += view.bounds.size.height;
        
        UIView * segView2 = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 12)];
        segView2.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [_contentView addSubview:segView2];
        marginTop += segView2.bounds.size.height;
        
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, _contentView.bounds.size.width, 45)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.bounds.size.width-15-15-60, 45)];
        if(_isForReturn) {
            lbl.text = @"设为默认退货地址";
        } else {
            lbl.text = @"设为默认收货地址";
        }
        lbl.textColor = [UIColor colorWithHexString:@"181818"];
        lbl.font = [UIFont systemFontOfSize:15.f];
        lbl.backgroundColor = [UIColor whiteColor];
        [view addSubview:lbl];
        
        
        KLSwitch *switchBtn = [[KLSwitch alloc] initWithFrame:CGRectMake(view.bounds.size.width-60-15, (45-30)/2, 60, 30)];
        switchBtn.tag = 300;
        [switchBtn setOnTintColor:[DataSources colorf9384c]];
        [switchBtn setDidChangeHandler:^(BOOL isOn) {
        }];
        if (self.totalAddressNum<=1) {
            switchBtn.enabled = NO;
            [switchBtn setOn:YES];
        }
        if (self.addressInfo.isDefault) {
            [switchBtn setOn:YES];
            
        }
        [view addSubview:switchBtn];
        [_contentView addSubview:view];
        marginTop += view.bounds.size.height;
        
        CALayer *bottomLine = [CALayer layer];
        bottomLine.frame = CGRectMake(0, marginTop, _contentView.bounds.size.width, 1);
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [_contentView.layer addSublayer:bottomLine];
        marginTop += 1;
        
        marginTop += 40;
        
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake((_contentView.bounds.size.width-170)/2, marginTop, 170, 45)];
        [delBtn addTarget:self action:@selector(delAddress:) forControlEvents:UIControlEventTouchUpInside];
        delBtn.layer.masksToBounds = YES;
        delBtn.layer.cornerRadius = 5;
        delBtn.layer.borderWidth = 1.f;
        delBtn.layer.borderColor = [UIColor colorWithHexString:@"C7AF7A"].CGColor;
        delBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [delBtn setTitleColor:[UIColor colorWithHexString:@"C7AF7A"] forState:UIControlStateNormal];
        [delBtn setTitle:@"删除地址" forState:UIControlStateNormal];
        [_contentView addSubview:delBtn];
        delBtn.hidden = YES;
        
        marginTop += delBtn.bounds.size.height;
        marginTop += 40.f;
        
        _contentView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.height, marginTop);
    }
    return _contentView;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *receiver = [_receiverTextFiled.text trim];
    NSString *phoneNumber = [_phoneNumberTextFiled.text trim];
    NSString *zipcode = [_zipcodeTextFiled.text trim];
    NSString *areaDetail = [_areaDetailTextFiled.text trim];
    NSString *address = [NSString disable_emoji:[_addressTextView.text trim]];
    
    BOOL isValidInput = YES;
    
    if ([receiver length] == 0) {
        _receiverTextFiled.text = @"";
        _receiverTextFiled.placeholder = @"请输入联系人";
        [_receiverTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        isValidInput = NO;
    }
    if ([phoneNumber length] == 0 || ![phoneNumber isValidMobilePhoneNumber]) {
        _phoneNumberTextFiled.text = @"";
        _phoneNumberTextFiled.placeholder = @"请输电话号码";
        [_phoneNumberTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        isValidInput = NO;
    }
    if ([areaDetail length] == 0) {
        _areaDetailTextFiled.text = @"";
        _areaDetailTextFiled.placeholder = @"请选择地址";
        [_areaDetailTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        isValidInput = NO;
    }
    if ([zipcode length]>0 && ![zipcode isValidPostalCode]) {
        _zipcodeTextFiled.text = @"";
        _zipcodeTextFiled.placeholder = @"请输入正确邮编";
        [_zipcodeTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        isValidInput = NO;
    }
    if ([address length] == 0) {
        _addressTextView.text = @"";
        _addressTextView.placeHolder = @"请输入详细地址";
        _addressTextView.placeHolderTextColor = [UIColor redColor];
        isValidInput = NO;
    }
    if (!isValidInput) {
        return;
    }
    
    KLSwitch *switchBtn = (KLSwitch*)[self.contentView viewWithTag:300];
    _addressInfo.isDefault = switchBtn.isOn;
    
    _addressInfo.address = address;
    _addressInfo.areaCode = self.districtID;
    _addressInfo.areaDetail = areaDetail;
    _addressInfo.receiver = receiver;
    _addressInfo.phoneNumber = phoneNumber;
    _addressInfo.zipcode = zipcode;
    
    [super showProcessingHUD:nil];
    WEAKSELF;
    if (_addressInfo.addressId > 0) {
        _request = [[NetworkAPI sharedInstance] modifyUserAddress:[Session sharedInstance].currentUserId type:_isForReturn?1:0 addressInfo:_addressInfo completion:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(editAddressSaved:addressInfo:)]) {
                [weakSelf.delegate editAddressSaved:weakSelf addressInfo:weakSelf.addressInfo];
            }
            MBGlobalSendModifyAddressDidFinishNotification(_addressInfo);
            if (_addressInfo.isDefault) {
                MBGlobalSendUserDefaultAddressChangedNotification(_addressInfo);
            }
            [weakSelf hideHUD];
            [weakSelf dismiss];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
        }];
    } else {
        _request = [[NetworkAPI sharedInstance] addUserAddress:[Session sharedInstance].currentUserId type:_isForReturn?1:0 addressInfo:_addressInfo completion:^(NSInteger totalNum, AddressInfo *addedAddressInfo) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(editAddressSaved:addressInfo:)]) {
                [weakSelf.delegate editAddressSaved:weakSelf addressInfo:addedAddressInfo];
            }
            MBGlobalSendAddAddressDidFinishNotification(addedAddressInfo);
            if (addedAddressInfo.isDefault) {
                MBGlobalSendUserDefaultAddressChangedNotification(addedAddressInfo);
            }
            [weakSelf hideHUD];
            [weakSelf dismiss];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
            
        }];
    }
}

- (void)delAddress:(UIButton*)sender
{
    if (_addressInfo && _addressInfo.addressId > 0) {
        if ([_addressInfo isDefault]) {
            if (_isForReturn) {
                [self showHUD:@"不能删除默认退货地址" hideAfterDelay:0.8f forView:self.view];
            } else {
                [self showHUD:@"不能删除默认收货地址" hideAfterDelay:0.8f forView:self.view];
            }
        } else {
            NSInteger addressId = _addressInfo.addressId;
            WEAKSELF;
            [weakSelf showProcessingHUD:nil forView:weakSelf.view];
            _request = [[NetworkAPI sharedInstance] delUserAddress:[Session sharedInstance].currentUserId type:_isForReturn?1:0 addressId:_addressInfo.addressId completion:^{
                [weakSelf hideHUD];
                MBGlobalSendRemoveAddressDidFinishNotification(addressId);
                [self dismiss];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
        }
    } else {
        [self dismiss];
    }
}

- (UIView*)createEditAddressItemView:(NSString*)text frame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.bounds.size.width-40, view.bounds.size.height)];
    nameLbl.text = text;
    nameLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    nameLbl.font = [UIFont systemFontOfSize:15.f];
    nameLbl.userInteractionEnabled = YES;
    [view addSubview:nameLbl];
    
    UITextField *textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(100, 0, view.bounds.size.width-100-15, view.bounds.size.height)];
    textFiled.font = [UIFont systemFontOfSize:15.f];
    textFiled.text = @"";
    textFiled.placeholder = [NSString stringWithFormat:@"请输入%@",text];
    textFiled.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    textFiled.delegate = self;
    textFiled.tag = 100;
    [view addSubview:textFiled];
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(13, view.bounds.size.height-0.5, view.bounds.size.width-26, 0.5);
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
    [view.layer addSublayer:bottomLine];
    return view;
}

- (UIView*)createEditAddressDetailView:(NSString*)text frame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _scrollView.bounds.size.width-40, 44)];
    nameLbl.text = text;
    nameLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    nameLbl.font = [UIFont systemFontOfSize:15.f];
    nameLbl.userInteractionEnabled = YES;
    [view addSubview:nameLbl];
    
    PlaceHolderTextView *textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(95, 5, view.bounds.size.width-100-25, view.bounds.size.height-5)];
    textView.font = [UIFont systemFontOfSize:15.f];
    textView.text = @"";
    textView.placeHolder = [NSString stringWithFormat:@"请输入%@",text];
    textView.placeHolderTextColor = [UIColor colorWithHexString:@"b2b2b2"];
    textView.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    textView.tag = 100;
    [view addSubview:textView];
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(13, view.bounds.size.height-0.5, view.bounds.size.width-26, 0.5);
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
    [view.layer addSublayer:bottomLine];
    
    return view;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 200) {
        AreaViewController *viewController = [[AreaViewController alloc] init];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        return NO;
    }
    return YES;
}

- (void)areaDidSelected:(AreaViewController*)viewController districtID:(NSString*)districtID areaName:(NSString*)areaName {
    self.districtID = districtID;
    self.areaName = areaName;
    _areaDetailTextFiled.text = areaName;
}

@end



@implementation UserAddressViewControllerReturn

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.isForSelectAddress?@"选择退货地址":@"管理退货地址"];
    [super setupTopBarBackButton];
}

- (void)reloadData
{
    WEAKSELF;
    //[weakSelf showProcessingHUD:nil forView:self.view];
    weakSelf.request = [[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId type:1 completion:^(NSArray *addressDictList) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *addressList = [[NSMutableArray alloc] init];
        if (addressDictList && [addressDictList count] > 0) {
            for (NSDictionary *dict in addressDictList) {
                [addressList addObject:[AddressInfo createWithDict:dict]];
            }
        }
        MBGlobalSendFetchAddressListDidFinishNotification(addressList);
        weakSelf.tableView.pullTableIsRefreshing = NO;
        //[weakSelf hideHUD];
        
    } failure:^(XMError *error) {
        
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                [weakSelf reloadData];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
    }];
}

-(BOOL)swipeTableCell:(SwipeTableViewCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(SwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == SwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if (direction == SwipeDirectionRightToLeft && index == 0) {
        //delete button
        
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        NSDictionary *dict = [self.dataSources objectAtIndex:path.row];
        AddressInfo *addressInfo = [dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        
        if ([addressInfo isDefault]) {
            [self showHUD:@"不能删除默认退货地址" hideAfterDelay:0.8f forView:self.view];
        } else {
            NSInteger addressId = addressInfo.addressId;
            WEAKSELF;
            [weakSelf showProcessingHUD:nil forView:weakSelf.view];
            weakSelf.request = [[NetworkAPI sharedInstance] delUserAddress:[Session sharedInstance].currentUserId type:1 addressId:addressInfo.addressId completion:^{
                [weakSelf hideHUD];
                MBGlobalSendRemoveAddressDidFinishNotification(addressId);
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
        }
    } else if (direction == SwipeDirectionRightToLeft && index == 1) {
        
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        
        AddressInfo *addressInfo = (AddressInfo*)[[self.dataSources objectAtIndex:[path row]] objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
        viewController.isForReturn = YES;
        viewController.title = @"编辑退货地址";
        viewController.addressInfo = addressInfo;
        viewController.totalAddressNum = [self.dataSources count];
        viewController.delegate = self;
        [super pushViewController:viewController animated:YES];
    }
    return YES;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    if (self.isForSelectAddress) {
        UserAddressViewControllerReturn *viewController = [[UserAddressViewControllerReturn alloc] init];
        viewController.isForSelectAddress = NO;
        
        NSMutableArray *addressList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[self.dataSources count];i++) {
            NSMutableDictionary *dict = (NSMutableDictionary*)[self.dataSources objectAtIndex:i];
            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                AddressInfo *addressInfoTemp = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                [addressList addObject:addressInfoTemp];
            }
        }
        viewController.addressList =addressList;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
        viewController.isForReturn = YES;
        viewController.title = @"新增退货地址";
        viewController.delegate = self;
        viewController.totalAddressNum = [self.dataSources count];
        [super pushViewController:viewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isForSelectAddress) {
        AddressInfo *addressInfo = (AddressInfo*)[[self.dataSources objectAtIndex:[indexPath row]] objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        if (self.handleAddressSelected) {
            self.handleAddressSelected(self,addressInfo);
        }
        [self dismiss];
    } else {
        AddressInfo *addressInfo = (AddressInfo*)[[self.dataSources objectAtIndex:[indexPath row]] objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
        EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
        viewController.isForReturn = YES;
        viewController.title = @"编辑退货地址";
        viewController.addressInfo = addressInfo;
        viewController.totalAddressNum = [self.dataSources count];
        viewController.delegate = self;
        [super pushViewController:viewController animated:YES];
    }
}

- (void)handleFetchAddressListDidFinishNotification:(id<MBNotification>)notifi addressList:(NSArray*)addressList
{
    WEAKSELF;
    NSMutableArray *dataSources = [[NSMutableArray alloc] init];
    for (AddressInfo *addressInfo in addressList) {
        if ([addressInfo isKindOfClass:[AddressInfo class]]) {
            NSMutableDictionary *dict = [UserAddressTableViewCell buildCellDict:addressInfo];
            [dict setObject:[NSNumber numberWithBool:addressInfo.addressId==weakSelf.seletedAddressId] forKey:[UserAddressTableViewCell cellDictKeyForSelected]];
            [dataSources addObject:dict];
        }
    }
    weakSelf.dataSources = dataSources;
    [weakSelf.tableView reloadData];
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加退货地址"];
    }
}

- (void)handleUserDefaultAddressChangedNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    //    if (!self.isForSelectAddress) {
    if (addressInfo.isDefault) {
        NSMutableArray *dataSources = [[NSMutableArray alloc] initWithArray:self.dataSources];
        
        NSInteger removedIndex = -1;
        for (NSInteger i=0;i<[dataSources count];i++) {
            NSMutableDictionary *dict = (NSMutableDictionary*)[dataSources objectAtIndex:i];
            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                AddressInfo *addressInfoTemp = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                if (addressInfoTemp.addressId == addressInfo.addressId) {
                    removedIndex = i;
                } else {
                    addressInfoTemp.isDefault = NO;
                }
            }
        }
        if (removedIndex>=0 && removedIndex<[dataSources count]) {
            [dataSources removeObjectAtIndex:removedIndex];
        }
        
        [dataSources insertObject:[UserAddressTableViewCell buildCellDict:addressInfo] atIndex:0];
        self.dataSources = dataSources;
        [self.tableView reloadData];
    }
    //    }
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加退货地址"];
    }
}

- (void)handleAddAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    if (addressInfo) {
        if ([self.dataSources count]>0) {
            [self.dataSources insertObject:[UserAddressTableViewCell buildCellDict:addressInfo] atIndex:1];
        } else {
            [self.dataSources insertObject:[UserAddressTableViewCell buildCellDict:addressInfo] atIndex:0];
        }
        [self.tableView reloadData];
    }
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加退货地址"];
    }
}

- (void)handleRemoveAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSNumber*)addressId
{
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSDictionary *dict = (NSDictionary*)[self.dataSources objectAtIndex:i];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            AddressInfo *addressInfo = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
            if (addressInfo.addressId == [addressId integerValue]) {
                [self.dataSources removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    if (self.isForSelectAddress) {
        if (self.seletedAddressId == [addressId integerValue]) {
            if ([self.dataSources count]>0) {
                NSMutableDictionary *dict = (NSMutableDictionary*)[self.dataSources objectAtIndex:0];
                if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                    AddressInfo *addressInfo = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                    if (self.handleAddressSelected) {
                        self.seletedAddressId = addressInfo.addressId;
                        [dict setObject:[NSNumber numberWithBool:YES] forKey:[UserAddressTableViewCell cellDictKeyForSelected]];
                        self.handleAddressSelected(self,addressInfo);
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
    
    if ([self.dataSources count]>0) {
        [self hideLoadingView];
    } else {
        [self loadEndWithNoContent:@"请添加退货地址"];
    }
}

- (void)handleModifyAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSMutableDictionary *dict = (NSMutableDictionary*)[self.dataSources objectAtIndex:i];
        if ([dict isKindOfClass:[NSMutableDictionary class]]) {
            AddressInfo *addressInfoTemp = (AddressInfo*)[dict objectForKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
            if (addressInfoTemp.addressId == addressInfo.addressId) {
                [dict setObject:addressInfo forKey:[UserAddressTableViewCell cellDictKeyForAddressInfo]];
                [self.tableView reloadData];
                break;
            }
        }
    }
}


@end



