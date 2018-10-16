//
//  QuanListPopupView.m
//  XianMao
//
//  Created by simon on 2/14/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "QuanListPopupView.h"
#import "BonusInfo.h"
#import "BonusTableViewCell.h"
#import "Command.h"
#import "DeviceUtil.h"

#import "CoordinatingController.h"

@interface QuanListPopupView () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,copy) QuanListPopupViewConfirmClickedBlock confirmClickedBlock;
@property(nonatomic,copy) QuanListPopupViewCancelClickedBlock cancelClickedBlock;

@end

@implementation QuanListPopupView {
    UITableView *_tableView;
}

- (id)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.bgView];
        
        
    }
    return self;
}

- (void)tappedBgView:(UIGestureRecognizer*)gesture
{
    
}

- (UIView*)bgView {
    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 112, self.width-40, self.height-224)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 3.f;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBgView:)];
        tapGesture.delegate = self;
        [_bgView addGestureRecognizer:tapGesture];
        
        if ([DeviceUtil isIphone4]||[DeviceUtil isIphone3]) {
            _bgView.frame = CGRectMake(20, 60, self.width-40, self.height-120);
        }
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _bgView.width-10, 82)];
        titleLbl.font = [UIFont systemFontOfSize:13.f];
        titleLbl.text = @"可以使用优惠券抵扣现金";
        titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.tag = 100;
        [_bgView addSubview:titleLbl];
        
        CGFloat topBarHeight = 82.f;
        
        WEAKSELF;
        CommandButton *cancelBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, _bgView.height-62.f, _bgView.width/2, 62.f)];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"不使用" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:cancelBtn];
        cancelBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf tappedCancel:nil];
        };
        
        CommandButton *confirmBtn = [[CommandButton alloc] initWithFrame:CGRectMake(_bgView.width/2, _bgView.height-62.f, _bgView.width/2, 62.f)];
        [confirmBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"使用" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        confirmBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
        [_bgView addSubview:confirmBtn];
        confirmBtn.handleClickBlock = ^(CommandButton *sender) {
            BonusInfo *bonusInfo = nil;
            for (NSMutableDictionary *dict in weakSelf.dataSources) {
                if ([dict boolValueForKey:[BonusTableViewCell cellKeyForBonusSeleted]]) {
                    bonusInfo = (BonusInfo*)[dict objectForKey:[BonusTableViewCell cellKeyForBonusInfo]];
                    break;
                }
            }
            if (bonusInfo) {
                weakSelf.confirmClickedBlock(bonusInfo);
                [weakSelf tappedConfirmThenHidePopView:nil];
//                [weakSelf tappedCancel:nil];
            } else {
                [[CoordinatingController sharedInstance] showHUD:@"请选择要使用的优惠券" hideAfterDelay:0.8 forView:[UIApplication sharedApplication].keyWindow];
            }
        };
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, _bgView.width, _bgView.height-topBarHeight-62.f)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [_bgView addSubview:_tableView];
    }
    return _bgView;
}

- (void)updateTitleBarLbl:(BonusInfo*)bonusInfo
{
    UILabel *titleLbl = (UILabel*)[self.bgView viewWithTag:100];
    titleLbl.numberOfLines = 0;
    
    NSString *amountString = [NSString stringWithFormat:@"%.2f",bonusInfo.amount];
    NSString *yuanString = @"元";
    NSString *fullString =  [NSString stringWithFormat:@"可以使用优惠券抵扣现金\n已抵扣：%@%@",amountString,yuanString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullString attributes:@{NSFontAttributeName:titleLbl.font}];;

    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHexString:@"985F65"]
                       range:NSMakeRange(fullString.length-yuanString.length-amountString.length, amountString.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:2.f];
    [attrString addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [fullString length])];
    
    titleLbl.text = nil;
    titleLbl.attributedText = attrString;

    
}

#pragma mark - Tap Gesture
- (void)tappedCancel:(UIGestureRecognizer*)gesture
{
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
            
            if (weakSelf.cancelClickedBlock) {
                weakSelf.cancelClickedBlock();
            }
        }
    }];
}

- (void)tappedConfirmThenHidePopView:(UIGestureRecognizer*)gesture
{
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
        }
    }];

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources?[_dataSources count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [tableViewCell updateCellWithDict:dict index:[indexPath row]];
    
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
    for (NSMutableDictionary *dict in _dataSources) {
        [dict setObject:[NSNumber numberWithBool:NO] forKey:[BonusTableViewCell cellKeyForBonusSeleted]];
    }
    
    NSMutableDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:[BonusTableViewCell cellKeyForBonusSeleted]];
    
    [self updateTitleBarLbl:[dict objectForKey:[BonusTableViewCell cellKeyForBonusInfo]]];
    
    [_tableView reloadData];
}

#define TBSCREEN_SIZE   [[UIScreen mainScreen] bounds].size
#define TBBUTTON_CORNER_RADIUS  4.0
#define TBBUTTON_BORDER_WIDTH   0.5

- (void)showInView:(UIView *)view
        bonusItems:(NSArray*)bonusItems
confirmClickedBlock:(QuanListPopupViewConfirmClickedBlock)confirmClickedBlock
cancelClickedBlock:(QuanListPopupViewCancelClickedBlock)cancelClickedBlock {
    
    [self removeFromSuperview];
    if (view == nil) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    } else {
        [view addSubview:self];
    }
    
    _confirmClickedBlock = confirmClickedBlock;
    _cancelClickedBlock = cancelClickedBlock;
    
    [_dataSources removeAllObjects];
    _dataSources = [[NSMutableArray alloc] init];
    if (bonusItems) {
        for (BonusInfo *info in bonusItems) {
            if ([info isKindOfClass:[BonusInfo class]]) {
                [_dataSources addObject:[BonusTableViewCell buildCellDict:info BonusSeleted:NO isHaveUnableLbl:NO]];
            }
        }
    }
    
    [_tableView reloadData];
    
    WEAKSELF;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf setAlpha:1.0];
    }];
}

@end


//
//@interface PayQuanViewController () <UITableViewDataSource,UITableViewDelegate>
//
//@property(nonatomic,strong) UITableView *tableView;
//@property(nonatomic,strong) NSMutableArray *dataSources;
//
//@end
//
//@implementation PayQuanViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"优惠券"];
//    [super setupTopBarBackButton];
//    
//    _dataSources = [[NSMutableArray alloc] init];
//    if (_quanItemList) {
//        for (BonusInfo *info in _quanItemList) {
//            if ([info isKindOfClass:[BonusInfo class]]) {
//                [_dataSources addObject:[BonusTableViewCell buildCellDict:info]];
//            }
//        }
//    }
//    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
//    [self.view addSubview:self.tableView];
//    
//    [super bringTopBarToTop];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [_dataSources count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
//    
//    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
//    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
//    
//    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (tableViewCell == nil) {
//        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
//        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//    
//    [tableViewCell updateCellWithDict:dict index:[indexPath row]];
//    
//    return tableViewCell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
//    
//    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
//    return [ClsTableViewCell rowHeightForPortrait:dict];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
//    
//    BonusInfo *bonusInfo = [dict objectForKey:[BonusTableViewCell cellKeyForBonusInfo]];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSelectQuan:bonusInfo:)]) {
//        [self.delegate handleSelectQuan:self bonusInfo:bonusInfo];
//    }
//}
//
//
//@end

