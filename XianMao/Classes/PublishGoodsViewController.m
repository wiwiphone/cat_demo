//
//  PublishGoodsViewController.m
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "PublishGoodsViewController.h"

#import "UIActionSheet+Blocks.h"
#import "UIImage+Resize.h"
#import "AppDirs.h"
#import "AssetPickerController.h"

#import "NSString+Addtions.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import "Command.h"
#import "NetworkAPI.h"
#import "Error.h"

#import "Cate.h"
#import "GoodsEditableInfo.h"
#import "GoodsInfo.h"
#import "BrandInfo.h"

#import "HPGrowingTextView.h"

#import "IQKeyboardManager.h"
#import "Session.h"
#import "CoordinatingController.h"

#import "UIInsetCtrls.h"
#import "PlaceHolderTextView.h"

#import "PictureItemsEditView.h"

#import "WCAlertView.h"
#import "CategoryService.h"

#import "SepTableViewCell.h"
#import "pinyin.h"
#import "SRMonthPicker.h"

#import "NSDate+Additions.h"
#import "NSDate+Category.h"

#import "TakePhotoViewController.h"
#import "TagsViewController.h"

#import "NSString+Addtions.h"
#import "WCAlertView.h"

#import "DigitalKeyboardView.h"
#import "Masonry.h"
#import "TTTAttributedLabel.h"
#import "WebViewController.h"

#import "PublishSelectHeaderView.h"
//#import "MineSegNewView.h"
#import "pulishSourceModel.h"
#import "CertificationModel.h"

@interface PublishGoodsViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, PublishGoodsContentViewDelegate>

@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,strong) PublishGoodsContentView *scrollView;

@property (nonatomic, strong) UIButton *rigthButton;



@end

@implementation PublishGoodsViewController

-(UIButton *)rigthButton{
    if (!_rigthButton) {
        _rigthButton = [[UIButton alloc] init];
        [_rigthButton setTitleColor:[UIColor colorWithHexString:@"9e9e9f"] forState:UIControlStateNormal];
        [_rigthButton setTitle:@"卖家必读" forState:UIControlStateNormal];
        _rigthButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_rigthButton sizeToFit];
    }
    return _rigthButton;
}

- (id)init {
    self = [super init];
    if (self) {
        _isEditGoods = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Message" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:_isEditGoods?@"编辑商品":@"售卖"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"back_Log_MF"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"back_Log_MF"] imgPressed:nil];
    }
//    [self.topBar addSubview:self.rigthButton];
//    [self.rigthButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.topBar.mas_right).offset(-15);
//        make.centerY.equalTo(self.topBar.mas_centerY).offset(10);
//    }];
//    [super setupTopBarRightButton];
//    super.topBarRightButton.backgroundColor = [UIColor clearColor];
//    [super.topBarRightButton setTitle:@"卖家必读" forState:UIControlStateNormal];
//    [super.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"9e9e9f"] forState:UIControlStateNormal];
//    super.topBarRightButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
//    tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.alwaysBounceVertical = YES;
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:tableView];
//    self.tableView = tableView;

    
    _scrollView = [[PublishGoodsContentView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.viewController = self;
    [self.view addSubview:_scrollView];
    _scrollView.publishGoodsDelegate = self;

//    _goodsId = @"03142555967850300190";
    if ([_goodsId length]>0) {
        WEAKSELF;
        [weakSelf showLoadingView];
        _request = [[NetworkAPI sharedInstance] getEditableInfo:_goodsId type:0 completion:^(NSDictionary *editableInfoDict) {
            [weakSelf hideLoadingView];
            
            NSLog(@"GoodsEditableInfo:%@", editableInfoDict);
            
            weakSelf.scrollView.editableInfo = [GoodsEditableInfo createWithDict:editableInfoDict];
        } failure:^(XMError *error) {
            [weakSelf hideLoadingView];
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        GoodsEditableInfo *editableInfo = [[GoodsEditableInfo alloc] init];
//        editableInfo.isSupportReturn = YES;//[Session sharedInstance].currentUser.isSupportReturn;
        self.scrollView.editableInfo = editableInfo;
    }
    
    [AppDirs cleanupDir:[AppDirs publishGoodsCacheFilePath]];
    
    [self setupForDismissKeyboard];
    
    [self bringTopBarToTop];
}

-(void)pushWebViewController:(UIViewController *)controller{
    [self pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _handlePublishGoodsFinished = nil;
}

- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (_scrollView.editableInfo.isModified) {
        WEAKSELF;
        [WCAlertView showAlertWithTitle:@""
                                message:@"退出后当前编辑的商品信息将会丢失，是否退出？"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         if (buttonIndex == 0) {
                             
                         } else {
                             [weakSelf dismiss];
                         }
                     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    } else {
        [self dismiss];
    }
}

//- (void)handleTopBarRightButtonClicked:(UIButton *)sender
//{
//    [self.view endEditing:YES];
//    
//    WEAKSELF;
//    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
//    if (isLoggedIn) {
//        [MobClick event:@"click_goods_publish"];
//        [weakSelf.scrollView publish];
//    }
//}

- (void)layoutSubViews {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 100;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//    [super touchesBegan:touches withEvent:event];
//}

@end

#import "NSMutableArray+WeakReferences.h"



@implementation AttrInfoEditButton
@end

@interface AttrInfoHelpButton : CommandButton
@property(nonatomic,copy) NSString *helpString;
@end

@implementation AttrInfoHelpButton
@end

@interface PublishSRMonthPicker : SRMonthPicker
@property(nonatomic,strong) AttrInfoEditButton *attrInfoEditButton;
@end

@implementation PublishSRMonthPicker
@end


@interface PublishGoodsContentView () <HPGrowingTextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,PictureItemsEditViewDelegate,PublishSelectViewControllerDelegate,PublishTextEditViewControllerDelegate,SRMonthPickerDelegate,UITextFieldDelegate,PublishSelectFitPeopleViewControllerDelegate,UIPickerViewDelegate, TTTAttributedLabelDelegate, ColourSubViewDelegate, SourceSubViewDelegate>

@property(nonatomic,strong) PictureItemsEditViewForPublishGoods *picturesEditView;
@property(nonatomic,strong) CALayer *picturesEditViewTop;
@property(nonatomic,strong) CALayer *picturesEditViewBottom;
@property(nonatomic,assign) CGFloat picturesEditViewHeight;
@property(nonatomic,strong) UIInsetTextField *goodsNameTextField;
@property(nonatomic,strong) CALayer *goodsNameBottomLine;
@property(nonatomic,strong) UIInsetLabel *goodsNameExplainLbl;
@property(nonatomic,strong) CommandButton *editPriceBtn;
@property(nonatomic,strong) UIInsetTextField *shopPriceField;
@property(nonatomic,strong) UIInsetTextField *marketPriceField;
@property(nonatomic,strong) UIInsetLabel *earnMoneyLbl;
@property(nonatomic,strong) UILabel *earnMoneyLblSubtitle;
@property(nonatomic,strong) UIInsetLabel *earnMoneyHelperLbl;
@property(nonatomic,strong) CommandButton *cateSelectorBtn;
@property(nonatomic,strong) CommandButton *brandSelectorBtn;
@property(nonatomic,strong) CommandButton *tagsSelectorBtn;
@property(nonatomic,strong) CommandButton *gradeBtn;
@property(nonatomic,strong) CommandButton *fitPeopleBtn;
//@property(nonatomic,strong) CommandButton *goodsReturnLbl;
@property(nonatomic,strong) CommandButton *expectedDeliveryTypeBtn;
@property(nonatomic,strong) UILabel *numLbl;
@property(nonatomic,strong) HPGrowingTextView *summaryTextView;

@property(nonatomic,strong) CommandButton *moreBtn;

@property(nonatomic,strong) Cate *selectedCate;
@property(nonatomic,strong) NSArray *cateList;
@property(nonatomic,strong) BrandInfo *selectedBrandInfo;
@property(nonatomic,strong) NSArray *brandList;
@property(nonatomic,strong) NSMutableArray *attrBtnArray;

@property(nonatomic,strong) NSMutableDictionary *sampleListDict;
@property(nonatomic,strong) NSArray *tagGroupList;

@property(nonatomic,strong) NSMutableDictionary *cateAttrInfoDict;


@property(nonatomic,copy) NSString *goods_name_sample;
@property(nonatomic,assign) NSInteger poundage_cent;
@property(nonatomic,copy) NSString *poundage_explain;
@property(nonatomic,copy) NSString *poundage_cent_String;

@property (nonatomic, weak) UIView *agreeView;
@property (nonatomic, weak) UIButton *agreeBtn;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) UIImageView *pictImageView;
@property (nonatomic, weak) UIView *backView;


@property (nonatomic, strong) PriceView *priceView;
@property (nonatomic, strong) ColourView *colourView;
@property (nonatomic, strong) SourceView *SourceView;
@property (nonatomic, strong) SegView *segOne;
@property (nonatomic, strong) SegView *segTwo;
@property (nonatomic, strong) SegView *segThree;
@property (nonatomic, strong) UIView *bgLine;
@property (nonatomic, strong) UIView *bgLine1;
@property (nonatomic, strong) UIView *bgLine2;

@property (nonatomic, strong) NSArray *colourArr;
@property (nonatomic, strong) NSDictionary *sourceDic; //处理过的
@property (nonatomic, strong) NSDictionary *dataDic;    //未处理的
@property (nonatomic, strong) pulishSourceModel *publishModelOne;
@property (nonatomic, strong) pulishSourceModel *publishModelTwo;

@property (nonatomic, strong) NSString *sourceOneStr;
@property (nonatomic, strong) NSString *sourceTwoStr;

@property (nonatomic, strong) NSString *colourStr;

@property (nonatomic, assign) NSInteger colourTag;
@property (nonatomic, assign) NSInteger sourceOneTag;
@property (nonatomic, assign) NSInteger sourceTwoTag;

@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation PublishGoodsContentView {
    HTTPRequest *_request;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        self.delegate = self;
        
        _editableInfo = [[GoodsEditableInfo alloc] init];
        _editableInfo.brandId = 0;
        _editableInfo.categoryId = 0;
        _editableInfo.fitPeople = -1;
//        _editableInfo.isSupportReturn = YES;
        
        _cateAttrInfoDict = [[NSMutableDictionary alloc] init];
        _sampleListDict = [[NSMutableDictionary alloc] init];
        _isSelected = YES;
        _poundage_cent = 0;
        
        
        WEAKSELF;
        NSString *urlStr = @"/category/goods_resource_list";
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:urlStr path:@"" parameters:nil completionBlock:^(NSDictionary *data) {
            NSLog(@"data======%@", data);
            self.dataDic = data;
            
            NSArray *array = [data objectForKey:@"purchaseAreaList"];
//            NSArray *array = [data objectForKey:@"goodsResourceList"];
            if (array.count > 0) {
                weakSelf.publishModelOne = [[pulishSourceModel alloc] initWithJSONDictionary:array[0]];
                weakSelf.publishModelTwo = [[pulishSourceModel alloc] initWithJSONDictionary:array[1]];
                self.sourceDic = [NSDictionary dictionaryWithObjectsAndKeys:self.publishModelOne, @"first", self.publishModelTwo, @"second", nil];
            }
            [weakSelf reloadData];
            
        } failure:^(XMError *error) {
            
        } queue:nil]];
        
        //编辑页面来源的数据处理
        if (_editableInfo.goodsResourceList.count > 0) {
            
        }
        
    }
    return self;
}

- (CommandButton*)createSelectableButton:(NSString*)title withSwitchBtn:(BOOL)withSwitchBtn {
    
    CGFloat height = kScreenWidth*40.f/320.f;
    
//    UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
    UIImage *rightArrow = [UIImage imageNamed:@"publish_right"];
    CommandButton *selectorBtn = [[AttrInfoEditButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    [selectorBtn setTitle:title forState:UIControlStateNormal];
    [selectorBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
    selectorBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    selectorBtn.backgroundColor = [UIColor whiteColor];
    selectorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectorBtn setImage:rightArrow forState:UIControlStateNormal];
    [selectorBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth-15-rightArrow.size.width, 0, 0)];
    [selectorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15-rightArrow.size.width, 0, 15)];
    
    [selectorBtn.titleLabel sizeToFit];
    CGSize size = selectorBtn.titleLabel.size;
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//    textLbl.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    textLbl.textColor = [UIColor colorWithHexString:@"8e8e93"];
//    textLbl.font = [UIFont systemFontOfSize:13.f];
    textLbl.font = [UIFont systemFontOfSize:15.f];
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.textAlignment = NSTextAlignmentRight;
    CGFloat marginRight = 15+rightArrow.size.width+10;
    CGFloat marginLeft = 15+size.width+15;
    textLbl.frame = CGRectMake(marginLeft, 0, selectorBtn.width-marginRight-marginLeft, selectorBtn.height);
    textLbl.tag = 100;
    textLbl.numberOfLines = 1;
    [selectorBtn addSubview:textLbl];
    
    if (withSwitchBtn) {
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchBtn.on = 1;
        switchBtn.onTintColor = [UIColor colorWithHexString:@"c2a79d"];
//        switchBtn.tag = 8001;
        switchBtn.backgroundColor = [UIColor clearColor];
        switchBtn.frame = CGRectMake(kScreenWidth-15-switchBtn.width, selectorBtn.top+(selectorBtn.height-switchBtn.height)/2, switchBtn.width,switchBtn.height);
        [switchBtn addTarget:self action:@selector(didSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectorBtn addSubview:switchBtn];
        [selectorBtn setImage:nil forState:UIControlStateNormal];
        [selectorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
//        [selectorBtn setNeedsDisplay];
    }
    return selectorBtn;
}

- (CommandButton*)createSelectableButton:(NSString*)title
{
    return [self createSelectableButton:title withSwitchBtn:NO];
}

- (CommandButton*)createAttrEditableButton:(AttrEditableInfo*)attrEditableInfo
{
    CommandButton *btn = [self createSelectableButton:attrEditableInfo.attrName withSwitchBtn:NO];
    UILabel *textLbl = (UILabel*)[btn viewWithTag:100];
    textLbl.text = attrEditableInfo.attrValue;
    if (attrEditableInfo.isMust && [attrEditableInfo.attrValue length]==0) {
        textLbl.text = @"必填";
    }
    
    if ([btn isKindOfClass:[AttrInfoEditButton class]]) {
        ((AttrInfoEditButton*)btn).attrEditableInfo = attrEditableInfo;
    }
    if ([attrEditableInfo.explain length]>0) {
        UILabel *helpLbl = [self createHelpLabel:attrEditableInfo.explain];
        helpLbl.frame = CGRectMake(15, btn.height+6, helpLbl.width, helpLbl.height);
        helpLbl.tag = 6000;
        helpLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        [btn addSubview:helpLbl];
        
//        [helpBtn setTitle:attrEditableInfo.explain forState:UIControlStateApplication];
//        helpBtn.tag = 101;
//        helpBtn.frame = CGRectMake(textLbl.left-15, 0, 30, btn.height);
//        CGFloat width = helpBtn.right-textLbl.left;
//        textLbl.left = textLbl.left+width;
//        textLbl.width = textLbl.width-width;
//        [btn addSubview:helpBtn];
//        helpBtn.handleClickBlock = ^(CommandButton *sender) {
//            CGFloat width = kScreenWidth*240/320;
//            CGFloat height = width;
//            TapDetectingView *view = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
////            view.layer.masksToBounds = YES;
////            view.layer.cornerRadius = kScreenWidth*90.f/320.f;
//            view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
//            view.frame = CGRectMake((kScreenWidth-view.width)/2, (kScreenHeight-view.height)/2, view.width, view.height);
//            [[[UIApplication sharedApplication] keyWindow] addSubview:view];
//            view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                [view removeFromSuperview];
//                view = nil;
//            };
//        };
    }
    return btn;
}

- (CGFloat)editableButtonRealHeight:(CommandButton*)btn
{
    CGFloat height = btn.height;
    UIView *helpLbl = [btn viewWithTag:6000];
    if (helpLbl) {
        height += 6;
        height += helpLbl.height;
        height += 8;
    }
    return height;
}

- (UIInsetTextField*)createTextFiled:(NSString*)placeholder textLbl:(NSString*)textLbl
{
    CGFloat height = kScreenWidth*40.f/320.f;
    UIInsetTextField *textField = [[UIInsetTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) rectInsetDX:15 rectInsetDY:0];
    textField.placeholder = placeholder;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.delegate = self;
    if ([textLbl length]>0) {
        UILabel *textFieldLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        textFieldLbl.text = textLbl;
        textFieldLbl.textColor = [UIColor colorWithHexString:@"181818"];
        textFieldLbl.font = [UIFont systemFontOfSize:12.f];
        [textFieldLbl sizeToFit];
        CGFloat marginRight = 18+textFieldLbl.width;
        textFieldLbl.frame = CGRectMake(textField.width-marginRight,0, textFieldLbl.width, textField.height);
        [textField addSubview:textFieldLbl];
    }
    return textField;
}

- (UIInsetLabel*)createHelpLabel:(NSString*)helpString
{
    UIInsetLabel *lbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 0)];
    lbl.font = [UIFont systemFontOfSize:12.f];
    lbl.text = helpString;
    lbl.font = [UIFont systemFontOfSize:11.f];
    lbl.numberOfLines = 0;
    [lbl sizeToFit];
    lbl.frame = CGRectMake(15, 0, kScreenWidth-30, lbl.height);
    return lbl;
}

- (AttrInfoHelpButton*)createHelpButton
{
    AttrInfoHelpButton *btn = [[AttrInfoHelpButton alloc] initWithFrame:CGRectMake(0, 0, 30, kScreenWidth*40.f/320.f)];
    [btn setImage:[UIImage imageNamed:@"sale_icon_question"] forState:UIControlStateNormal];
    return btn;
}


- (CommandButton*)createPriceButton  {
    
    NSString *title = @"售价";
    CGFloat height = kScreenWidth*40.f/320.f;
    
    UIImage *rightArrow = [UIImage imageNamed:@"right_arrow_gray"];
    CommandButton *selectorBtn = [[AttrInfoEditButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    [selectorBtn setTitle:title forState:UIControlStateNormal];
    [selectorBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
    selectorBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    selectorBtn.backgroundColor = [UIColor whiteColor];
    selectorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectorBtn setImage:rightArrow forState:UIControlStateNormal];
    [selectorBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth-15-rightArrow.size.width, 0, 0)];
    [selectorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15-rightArrow.size.width, 0, 15)];
    
    [selectorBtn.titleLabel sizeToFit];
    CGSize size = selectorBtn.titleLabel.size;
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectNull];
    textLbl.textColor = [UIColor colorWithHexString:@"333333"];
    textLbl.font = [UIFont systemFontOfSize:13.f];
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.textAlignment = NSTextAlignmentRight;
    CGFloat marginRight = 15+rightArrow.size.width+10;
    CGFloat marginLeft = 15+size.width+15;
    textLbl.frame = CGRectMake(marginLeft, 0, selectorBtn.width-marginRight-marginLeft, selectorBtn.height);
    textLbl.tag = 100;
    textLbl.numberOfLines = 1;
    [selectorBtn addSubview:textLbl];
    
    return selectorBtn;
}

- (void)didSwitchBtnClick:(UISwitch*)switchBtn
{
//    _editableInfo.isSupportReturn = switchBtn.isOn;
}

- (void)setViewController:(BaseViewController *)viewController {
    if (_viewController != viewController) {
        _viewController = viewController;
        _picturesEditView.viewController = viewController;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _shopPriceField) {
        if ([_shopPriceField.text trim].length>0 && [[_shopPriceField.text trim] floatValue]>=0.01) {
            double shopPrice = [[_shopPriceField.text trim] doubleValue];
            
            long long shopPriceCent = shopPrice*100;
            _shopPriceField.text = [NSString stringWithFormat:@"%.2f",(double)shopPriceCent/100.f];
            double fTmpCent = (shopPriceCent*_poundage_cent/10000.f);
            if (fTmpCent>2000*100) {
                fTmpCent = 2000*100;
            }
            NSInteger tmpCent = ceil(fTmpCent);
            _earnMoneyLblSubtitle.text = [NSString stringWithFormat:@"%.2f 元",(double)(shopPriceCent-tmpCent)/100.f];
        } else {
            _earnMoneyLblSubtitle.text = nil;
        }
        
        _poundage_cent_String = _earnMoneyLblSubtitle.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _goodsNameTextField) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 35 && range.length!=1){
            textField.text = [toBeString substringToIndex:35];
            return NO;
        }
        return YES;
    }
    if (textField == _shopPriceField || textField == _marketPriceField) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 10 && range.length!=1){
            textField.text = [toBeString substringToIndex:10];
            return NO;
        }
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 128 && range.length!=1){
        textField.text = [toBeString substringToIndex:128];
        return NO;
    }
    return YES;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *newtxt = [NSMutableString stringWithString:growingTextView.text];
    [newtxt replaceCharactersInRange:range withString:text];
    return [newtxt length]<=200;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    _numLbl.text = [NSString stringWithFormat:@"%ld/200",(long)[growingTextView.text length]];
}

- (void)reload_goods_publish_info:(NSInteger)cateId {
    
//    /category/goods_publish_info[GET] {cate_id(i)} 根据叶子类目获取发布相关信息 {goods_name_sample(s), poundage_cent(i), poundage_explain(s) }
    
    WEAKSELF;
    [weakSelf.viewController showProcessingHUD:nil];
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],@"cate_id":[NSNumber numberWithInteger:cateId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"goods_publish_info" parameters:parameters completionBlock:^(NSDictionary *data) {
        weakSelf.goods_name_sample = [data stringValueForKey:@"goods_name_sample"];
        weakSelf.poundage_explain = [data stringValueForKey:@"poundage_explain"];
        weakSelf.poundage_cent = [data integerValueForKey:@"poundage_cent"];

        [weakSelf saveEditInfo];
//        [weakSelf reloadData];
        [weakSelf.viewController hideHUD];
    } failure:^(XMError *error) {
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.viewController showHUD:[error errorMsg] hideAfterDelay:1.2f];
        });
    } queue:nil]];
}

- (void)reloadData
{
//    self.backgroundColor = [UIColor redColor];
    WEAKSELF;
    
    
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    CGFloat marginTop = 0.f;
    
//    CGFloat hegiht44 = kScreenWidth*44.f/320.f;
    CGFloat hegiht = kScreenWidth*40.f/320.f;
    
    _cateSelectorBtn = [self createSelectableButton:@"分类"];
    _cateSelectorBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    [self addSubview:_cateSelectorBtn];
    marginTop += _cateSelectorBtn.height;
    marginTop += 10.f;
    
    _bgLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 1)];
    _bgLine1.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
    [self addSubview:_bgLine1];
    marginTop += 1;
    
    _brandSelectorBtn = [self createSelectableButton:@"品牌"];
    _brandSelectorBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    [self addSubview:_brandSelectorBtn];
    
    marginTop += _brandSelectorBtn.height;
    marginTop += 10;
    
    _segOne = [[SegView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 12)];
    [self addSubview:_segOne];
    marginTop += 12;
    
    
    _picturesEditViewTop = [CALayer layer];
    _picturesEditViewTop.backgroundColor =[UIColor whiteColor].CGColor;
    _picturesEditViewTop.frame = CGRectMake(0, marginTop, kScreenHeight, 10);
    [self.layer addSublayer:_picturesEditViewTop];
    marginTop += 10;
    
//    _picturesEditView = [[PictureItemsEditViewForPublishGoods alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, [PictureItemsEditView itemViewHeight])];
    _picturesEditView = [[PictureItemsEditViewForPublishGoods alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, [PictureItemsEditView itemViewHeight]) isShowMainPicTip:YES isHaveFengM:YES];
    _picturesEditView.contentView = self;
    _picturesEditView.backgroundColor = [UIColor whiteColor];
    _picturesEditView.viewController = self.viewController;
    _picturesEditView.delegate = self;
    [self addSubview:_picturesEditView];
    _picturesEditViewHeight = _picturesEditView.height;
    
    marginTop += _picturesEditView.height;
    
    _picturesEditViewBottom = [CALayer layer];
    _picturesEditViewBottom.backgroundColor =[UIColor whiteColor].CGColor;
    _picturesEditViewBottom.frame = CGRectMake(0, marginTop, kScreenHeight, 10);
    [self.layer addSublayer:_picturesEditViewBottom];
    marginTop += 10;
    
    
    _segThree = [[SegView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 12)];
    [self addSubview:_segThree];
    marginTop += 12;
    marginTop += 0.5f;
    
    _priceView = [[PriceView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 89)];
    [self addSubview:_priceView];
    UITapGestureRecognizer *priceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTapAction:)];
    if (self.editableInfo.marketPrice > 0) {
        _priceView.buyPriceFD.text = [NSString stringWithFormat:@"%.2lf", self.editableInfo.marketPrice];
        _priceView.sellPriceFD.text = [NSString stringWithFormat:@"%.2lf", self.editableInfo.shopPrice];
    }
    [_priceView addGestureRecognizer:priceTap];
    
    marginTop += 89;
    
    self.colourArr = [NSArray arrayWithObjects:@"全新", @"98成新", @"95成新", @"9成新", @"85成新", @"8成新", nil];
    _colourView = [[ColourView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 45) andSelectArr:self.colourArr];
    [self addSubview:_colourView];
    [_colourView.showBtn addTarget:self action:@selector(showColourSubView:) forControlEvents:UIControlEventTouchUpInside];
    _colourView.selectSubView.delegate = self;
    if (self.editableInfo.grade > 0) {
        switch (self.editableInfo.grade) {
            case 1:
                self.colourStr = @"全新";
                break;
            case 2:
                self.colourStr = @"95成新";
                break;
            case 3:
                self.colourStr = @"9成新";
                break;
            case 4:
                self.colourStr = @"8成新";
                break;
            case 5:
                self.colourStr = @"98成新";
                break;
            case 6:
                self.colourStr = @"85成新";
                break;
            default:
                self.colourStr = nil;
                break;
        }

    }
    if (self.colourStr) {
        _colourView.btnLeftLB.text = self.colourStr;
    }
    for (NSInteger i = 0; i < 6; i++) {
        if([self.colourStr isEqualToString:self.colourArr[i]]) {
            UIButton *btn = [_colourView.selectSubView viewWithTag:10000 + i];
            [btn setSelected:YES];
        }
    }
    UITapGestureRecognizer *colourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showColourSubView:)];
    [_colourView addGestureRecognizer:colourTap];
    
    marginTop += 45;
    marginTop += 0.5f;
    
    
//    _summaryTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth - 30, 115)];
    _summaryTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth - 30, 88)];
    _summaryTextView.placeholder = @"商品描述可以被搜索，不妨多写点~";//请描述一下你的商品吧~
    _summaryTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    //    _summaryTextView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    _summaryTextView.returnKeyType = UIReturnKeyDefault; //just as an example
    _summaryTextView.font = [UIFont systemFontOfSize:14.0f];
    _summaryTextView.delegate = self;
    _summaryTextView.backgroundColor = [UIColor whiteColor];
    _summaryTextView.isScrollable = NO;
    _summaryTextView.enablesReturnKeyAutomatically = NO;
    _summaryTextView.animateHeightChange = NO;
    _summaryTextView.autoRefreshHeight = NO;
//    _summaryTextView.frame = CGRectMake(0, marginTop, kScreenWidth, 115);
    _summaryTextView.frame = CGRectMake(0, marginTop, kScreenWidth, 88);
    
    [self addSubview:_summaryTextView];
    
    marginTop += _summaryTextView.height;
    
    _bgLine = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 1)];
    _bgLine.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
    [self addSubview:_bgLine];
    marginTop += 1;
    
    _SourceView = [[SourceView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 45) andDic:self.sourceDic];
    [_SourceView.showBtn addTarget:self action:@selector(showSourceSubView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_SourceView];
    
//    NSString *key1;
    NSString *value1;
//    NSString *key2;
    NSString *value2;
    
    if ([self.editableInfo.goodsResourceList[0] allKeys].count > 0) {
//        key1 = [self.editableInfo.goodsResourceList[0] allKeys][0];
        value1 = [self.editableInfo.goodsResourceList[0] objectForKey:@"attr_value"];
        self.sourceOneStr = value1;
        
        //传过来的tag是真正的tag减去10000和20000之后的
        for (NSInteger i = 0; i < self.publishModelOne.list.count; i++) {
            if ([value1 isEqualToString:self.publishModelOne.list[i]]) {
                NSInteger tag = i + 10000;
                UIButton *btn = [_SourceView.selectSubView viewWithTag:tag];
                [btn setSelected:YES];
            }
        }
        
        for (int i = 0; i < self.publishModelTwo.list.count; i++) {
            if ([value1 isEqualToString:self.publishModelTwo.list[i]]) {
                
                NSInteger tag = i + 20000;
                UIButton *btn = [_SourceView.selectSubView viewWithTag:tag];
                [btn setSelected:YES];
            }
        }
        
    }
    
    
    if ([self.editableInfo.goodsResourceList[1] allKeys].count > 0) {
//        key2 = [self.editableInfo.goodsResourceList[1] allKeys][0];
        value2 = [self.editableInfo.goodsResourceList[1] objectForKey:@"attr_value"];
        self.sourceTwoStr = value2;
        for (NSInteger i = 0; i < self.publishModelTwo.list.count; i++) {
            if ([value2 isEqualToString:self.publishModelTwo.list[i]]) {
                NSInteger tag = i + 20000;
                UIButton *btn = [_SourceView.selectSubView viewWithTag:tag];
                [btn setSelected:YES];
            }
        }
        
        for (int i = 0; i < self.publishModelOne.list.count; i++) {
            if ([value2 isEqualToString:self.publishModelOne.list[i]]) {
                NSInteger tag = i + 10000;
                UIButton *btn = [_SourceView.selectSubView viewWithTag:tag];
                [btn setSelected:YES];
            }
        }
    }
    
    if (((![value1 isEqualToString:@""]) && value1) || ((![value2 isEqualToString:@""]) && value2)) {
        if (self.sourceOneStr.length > 0 && self.sourceTwoStr.length > 0) {
            _SourceView.btnLeftLB.text = [NSString stringWithFormat:@"%@ %@", self.sourceOneStr, self.sourceTwoStr];
        } else if (self.sourceOneStr.length > 0) {
            _SourceView.btnLeftLB.text = [NSString stringWithFormat:@"%@", self.sourceOneStr];
        } else {
            _SourceView.btnLeftLB.text = [NSString stringWithFormat:@"%@", self.sourceTwoStr];
        }
    }
//    if (![value1 isEqualToString:@""] && value1) {
////        if ([key1 isEqualToString:[NSString stringWithFormat:@"%ld", self.publishModelOne.attr_id]]) {
//            for (NSInteger i = 0; i < self.publishModelOne.list.count; i ++) {
//                if ([value1 isEqualToString:self.publishModelOne.list[i]]) {
//                    NSInteger tag = i + 10000;
//                    UIButton *btn = [_SourceView.selectSubView viewWithTag:tag];
//                    [btn setSelected:YES];
//                }
//            }
////        }
//    }
//    if (value2 && ![value2 isEqualToString:@""]) {
//        for (NSInteger i = 0; i < self.publishModelTwo.list.count; i ++) {
//            if ([value2 isEqualToString:self.publishModelTwo.list[i]]) {
//                NSInteger tag = i + 20000;
//                UIButton *btn = [_SourceView.selectSubView viewWithTag:tag];
//                [btn setSelected:YES];
//            }
//        }
//    }
    
    
    _SourceView.selectSubView.delegate = self;
    
    UITapGestureRecognizer *sourceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSourceSubView:)];
    [_SourceView addGestureRecognizer:sourceTap];
    
    marginTop += 45;
    
    
    _expectedDeliveryTypeBtn = [self createSelectableButton:@"付款后多久发货"];
    _expectedDeliveryTypeBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    [self addSubview:_expectedDeliveryTypeBtn];
    
    marginTop += _expectedDeliveryTypeBtn.height;
    marginTop += 5;
    
    _bgLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 1)];
    [self addSubview:_bgLine2];
    _bgLine2.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
    
    
    _moreBtn = [self createSelectableButton:@"更多详情"];
    _moreBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    ((UILabel*)[_moreBtn viewWithTag:100]).text = @"选填";
    [self addSubview:_moreBtn];
    
    _segTwo = [[SegView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 12)];
    marginTop += 12;
    marginTop += 0.5f;
    
//    _goodsNameTextField = [self createTextFiled:@"商品名称(最多35字)" textLbl:nil];
//    _goodsNameTextField.font = [UIFont systemFontOfSize:15.f];
//    _goodsNameTextField.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht44);
//    _goodsNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _goodsNameTextField.keyboardType = UIKeyboardTypeDefault;
//    [self addSubview:_goodsNameTextField];
//    _goodsNameTextField.tag = 1000;
//    _goodsNameTextField.delegate = self;
//    _goodsNameTextField.maxLength = 35;
//    
//    marginTop += _goodsNameTextField.height;
    
//    [_goodsNameBottomLine removeFromSuperlayer];
//    _goodsNameBottomLine = [CALayer layer];
//    _goodsNameBottomLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
//    _goodsNameBottomLine.frame = CGRectMake(15, _goodsNameTextField.bottom-0.5, kScreenWidth-15, 0.5);
//    [self.layer addSublayer:_goodsNameBottomLine];
//    
//    if (self.goods_name_sample&&[self.goods_name_sample length]>0) {
//        marginTop += 6;
//        _goodsNameExplainLbl = [self createHelpLabel:self.goods_name_sample];
//        _goodsNameExplainLbl.textColor = [UIColor colorWithHexString:@"aaaaaa"];
//        _goodsNameExplainLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, 0);
//        [_goodsNameExplainLbl sizeToFit];
//        _goodsNameExplainLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, _goodsNameExplainLbl.height);
//        [self addSubview:_goodsNameExplainLbl];
//        marginTop += 8;
//    } else {
////        marginTop += 15;
//    }
    
//    _numLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, self.width-30, 0)];
//    _numLbl.text = @"0/200";
//    _numLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
//    _numLbl.textAlignment = NSTextAlignmentRight;
//    _numLbl.font = [UIFont systemFontOfSize:12.f];
//    [_numLbl sizeToFit];
//    _numLbl.frame = CGRectMake(15, marginTop, self.width-30, _numLbl.height);
//    [self addSubview:_numLbl];
//    
//    marginTop += _numLbl.height;
//    marginTop += 5;
    
    
    
    
    
   
    
//    _editPriceBtn = [self createPriceButton];
//    _editPriceBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    [self addSubview:_editPriceBtn];
//    marginTop += _editPriceBtn.height;
    
    if (_poundage_cent>100) {
        _earnMoneyLbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, hegiht) andInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        _earnMoneyLbl.font = [UIFont systemFontOfSize:14.0f];
        _earnMoneyLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _earnMoneyLbl.text = @"售出后你将得到";
        _earnMoneyLbl.textAlignment = NSTextAlignmentLeft;
        _earnMoneyLbl.backgroundColor = [UIColor whiteColor];
        _earnMoneyLbl.tag = 1003;
        [self addSubview:_earnMoneyLbl];
        marginTop += _earnMoneyLbl.height;
        
        _earnMoneyLblSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(15, _earnMoneyLbl.top, kScreenWidth-30, _earnMoneyLbl.height)];
        _earnMoneyLblSubtitle.textAlignment = NSTextAlignmentRight;
        _earnMoneyLblSubtitle.textColor = [UIColor colorWithHexString:@"181818"];
        _earnMoneyLblSubtitle.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_earnMoneyLblSubtitle];
    }
    if ([self.poundage_explain length]>0) {
        marginTop += 6;
        //350 -> 3.5
        //355 -> 3.55
        //700 -> 7
        //        NSString *str = [NSString stringWithFormat:@"%ld",(long)(_poundage_cent/100)];
        //        double dRatioX = (double)_poundage_cent/10.f;
        //        NSInteger nRatioX = (NSInteger)(_poundage_cent/10);
        //        if (dRatioX-nRatioX>0) {
        //            str = [NSString stringWithFormat:@"%.2f",dRatioX];
        //        } else {
        //            double dRatio = (double)_poundage_cent/100.f;
        //            NSInteger nRatio = (NSInteger)(_poundage_cent/100);
        //            if (dRatio-nRatio>0) {
        //                str = [NSString stringWithFormat:@"%.1f",dRatio];
        //            }
        //        }
        //
        //        NSMutableString *strTmp = [[NSMutableString alloc] initWithString:str];
        //        [strTmp appendString:@"%"];
        //
        //        NSString *helpString = [NSString stringWithFormat:@"爱丁猫收取最终成交价的 %@ 作为交易服务费, 单个商品服务费不超过2000元",strTmp];
        _earnMoneyHelperLbl = [self createHelpLabel:self.poundage_explain];
        _earnMoneyHelperLbl.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        _earnMoneyHelperLbl.frame = CGRectMake(17, marginTop, kScreenWidth-34, 0);
        _earnMoneyHelperLbl.numberOfLines = 0;
        [_earnMoneyHelperLbl sizeToFit];
        _earnMoneyHelperLbl.frame = CGRectMake(17, marginTop, kScreenWidth-34, _goodsNameExplainLbl.height);
        [self addSubview:_earnMoneyHelperLbl];
        marginTop += 8;
    }
    else {
        marginTop += 10;
    }
    
//    _gradeBtn = [self createSelectableButton:@"成色"];
//    _gradeBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
////    _gradeBtn.backgroundColor = [UIColor redColor];
//    [self addSubview:_gradeBtn];

    
    
    
    
    
    
    UIView *agreeView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, hegiht)];
    agreeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:agreeView];
    self.agreeView = agreeView;
    UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 80, agreeView.height / 2 - 5, 10, 10)];
    [agreeBtn setImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
    agreeBtn.selected = YES;
    [agreeView addSubview:agreeBtn];
    [agreeBtn addTarget:self action:@selector(clickAgreeBtn) forControlEvents:UIControlEventTouchUpInside];
    self.agreeBtn = agreeBtn;
//
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] init];
    label.font = [UIFont systemFontOfSize:11.f];
    label.textColor = [UIColor colorWithHexString:@"282828"];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.userInteractionEnabled = YES;
    label.linkAttributes = nil;
    label.highlightedTextColor = [UIColor colorWithHexString:@"ac7e33"];
    [label setText:@"已阅读并同意《爱丁猫商品售卖协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(mutableAttributedString.length-11,11);
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"ac7e33"] CGColor] range:stringRange];
        return mutableAttributedString;
    }];
    label.delegate = self;
    [label addLinkToURL:[NSURL URLWithString:@"http://activity.aidingmao.com/share/page/63"] withRange:NSMakeRange([label.text length]-11,11)];
    [label sizeToFit];
    [agreeView addSubview:label];
    label.frame = CGRectMake(agreeBtn.right + 5, agreeView.height / 2 - 5, label.width, label.height);
    marginTop += agreeView.height;
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, _pictImageView.height)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    self.backView = backView;
    UIImageView *pictImageView = [[UIImageView alloc] init];
//    pictImageView.image = [UIImage imageNamed:@"Picture-MF"];
//    pictImageView.backgroundColor = [UIColor whiteColor];
    [pictImageView sizeToFit];
    [self addSubview:pictImageView];
    self.pictImageView = pictImageView;
    marginTop += pictImageView.height;
    
//    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 50)];
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight -  50, kScreenWidth, 50)];
    backView1.backgroundColor = [UIColor whiteColor];
    //add code
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    
    [((UIViewController *)target).view addSubview:backView1];
    self.backView1 = backView1;
//    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 40)];
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    sendBtn.backgroundColor = [UIColor colorWithHexString:@"252525"];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendBtn = sendBtn;
    [backView1 addSubview:sendBtn];
//    [((UIViewController *)target).view insertSubview:sendBtn aboveSubview:self];
    [sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
//
//    _marketPriceField = [self createTextFiled:@"请填写购入价" textLbl:@"元"];
//    _marketPriceField.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    [self addSubview:_marketPriceField];
//    _marketPriceField.tag = 1002;
//    _marketPriceField.delegate = self;
//    _marketPriceField.maxLength = 20;
//    
//    marginTop += _marketPriceField.height;
//    marginTop += 1;
//    
//    _shopPriceField = [self createTextFiled:@"请填写售价(必填)" textLbl:@"元"];
//    _shopPriceField.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    [self addSubview:_shopPriceField];
//    _shopPriceField.tag = 1001;
//    _shopPriceField.delegate = self;
//    _shopPriceField.maxLength = 20;
//    
//    marginTop += _shopPriceField.height;
//    

//    

//    
//    _tagsSelectorBtn = [self createSelectableButton:@"选择标签"];
//    _tagsSelectorBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    [self addSubview:_tagsSelectorBtn];
//    
//    marginTop += _tagsSelectorBtn.height;
//    marginTop += 15;
//    

//    
//    marginTop += _gradeBtn.height;
//    marginTop += 15;
//    
//    _fitPeopleBtn = [self createSelectableButton:@"请选适用人群"];
//    _fitPeopleBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    [self addSubview:_fitPeopleBtn];
//    
//    marginTop += _fitPeopleBtn.height;
//    marginTop += 15;
//    
//    NSMutableArray *attrBtnArray = [NSMutableArray noRetainingArray];
//    for (AttrEditableInfo *attrEditableInfo in self.editableInfo.attrInfoList) {
//        if (attrEditableInfo.type == kTYPE_TEXT_INPUT
//            || attrEditableInfo.type == kTYPE_YES_OR_NO
//            || attrEditableInfo.type == kTYPE_SELECT
//            || attrEditableInfo.type == kTYPE_DATE) {
//            CommandButton *btn = [self createAttrEditableButton:attrEditableInfo];
//            btn.tag = 2000+attrEditableInfo.type;
//            btn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//            [self addSubview:btn];
//            marginTop += [self editableButtonRealHeight:btn];
//            marginTop += 1;
//            [attrBtnArray addObject:btn];
//            
////            
////            UILabel *lbl = (UILabel*)[btn viewWithTag:100];
////            lbl.text = attrEditableInfo.isMust?@"必填":@"";
//            
//            WEAKSELF;
//            btn.handleClickBlock = ^(CommandButton *sender) {
//                if ([sender isKindOfClass:[AttrInfoEditButton class]]) {
//                    AttrInfoEditButton *editButton = (AttrInfoEditButton*)sender;
//                    [weakSelf publishSelectAttrEditInfo:editButton];
//                }
//            };
//        }
//    }
//    
//    if ([attrBtnArray count]>0) {
//        marginTop += 15.f;
//    }
//    _attrBtnArray = attrBtnArray;
//    
////    _goodsReturnLbl = [self createSelectableButton:@"支持7天无条件退货" withSwitchBtn:YES];
////    _goodsReturnLbl.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
////    [self addSubview:_goodsReturnLbl];
////    
////    marginTop += _goodsReturnLbl.height;
////    marginTop += 15;
//    
//
    _expectedDeliveryTypeBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf showExpectedDeliveryPickerView];
    };
    
    [_picturesEditView removeFromSuperview];
    [self addSubview:_picturesEditView];
    
    [self fillEditData];
    
    [self setNeedsLayout];
    
    void(^fillEditPriceBtnBlock)() = ^(NSInteger shopPriceCent, NSInteger marketPriceCent){
        UILabel *lbl = (UILabel*)[weakSelf.editPriceBtn viewWithTag:100];
        lbl.font = [UIFont boldSystemFontOfSize:13.f];
        if (shopPriceCent >0) {
            NSString *shopPriceString = @"";
            shopPriceString = [NSString stringWithFormat:@"￥%@",[[NSNumber numberWithDouble:(double)shopPriceCent/100.f] stringValue]];
            
            NSString *marketPriceString = @"";
            if (marketPriceCent>0) {
                marketPriceString = [NSString stringWithFormat:@"原价￥%@",[[NSNumber numberWithDouble:(double)marketPriceCent/100.f] stringValue]];
            }
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %@",shopPriceString,marketPriceString]];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(attrString.length-marketPriceString.length, marketPriceString.length)];
            lbl.text = nil;
            lbl.attributedText = attrString;
        } else {
            lbl.text = nil;
            lbl.attributedText = nil;
        }
    };
    
    fillEditPriceBtnBlock(_editableInfo.shopPriceCent,_editableInfo.marketPriceCent);
    
    
    void(^fillEarnMoneyLblSubtitleBlock)() = ^(NSInteger shopPriceCent){
        if (shopPriceCent>0) {
            double fTmpCent = (shopPriceCent*weakSelf.poundage_cent/10000.f);
            if (fTmpCent>2000*100) {
                fTmpCent = 2000*100;
            }
            NSInteger tmpCent = ceil(fTmpCent);
            weakSelf.earnMoneyLblSubtitle.text = [NSString stringWithFormat:@"%.2f 元",(double)(shopPriceCent-tmpCent)/100.f];
        } else {
            weakSelf.earnMoneyLblSubtitle.text = nil;
        }
        weakSelf.poundage_cent_String = weakSelf.earnMoneyLblSubtitle.text;
    };
    
    fillEarnMoneyLblSubtitleBlock(_editableInfo.shopPriceCent);
    
    _editPriceBtn.handleClickBlock = ^(CommandButton *sender) {
        
        if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
            DigitalPriceInputView *intputView = [[DigitalPriceInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            intputView.shopPriceCent = weakSelf.editableInfo.shopPriceCent;
            intputView.marketPriceCent = weakSelf.editableInfo.marketPriceCent;
            
            [DigitalKeyboardView showInViewMF:weakSelf.superview inputContainerView:intputView textFieldArray:[NSArray arrayWithObjects:intputView.priceTextField,intputView.marketPriceTextField, nil] completion:^(DigitalInputContainerView *inputContainerView) {
                NSInteger shopPriceCent = ((DigitalPriceInputView*)inputContainerView).shopPriceCent;
                NSInteger marketPriceCent = ((DigitalPriceInputView*)inputContainerView).marketPriceCent;
                
                weakSelf.editableInfo.shopPriceCent = shopPriceCent;
                weakSelf.editableInfo.marketPriceCent = marketPriceCent;
                fillEditPriceBtnBlock(shopPriceCent,marketPriceCent);
                fillEarnMoneyLblSubtitleBlock(shopPriceCent);
            }];
            
//            [DigitalKeyboardView showInViewFromPublish:weakSelf.superview inputContainerView:intputView textFieldArray:[NSArray arrayWithObjects:intputView.priceTextField,intputView.marketPriceTextField, nil] completion:^(DigitalInputContainerView *inputContainerView) {
//                NSInteger shopPriceCent = ((DigitalPriceInputView*)inputContainerView).shopPriceCent;
//                NSInteger marketPriceCent = ((DigitalPriceInputView*)inputContainerView).marketPriceCent;
//                
//                weakSelf.editableInfo.shopPriceCent = shopPriceCent;
//                weakSelf.editableInfo.marketPriceCent = marketPriceCent;
//                fillEditPriceBtnBlock(shopPriceCent,marketPriceCent);
//                fillEarnMoneyLblSubtitleBlock(shopPriceCent);
//            }];
            [weakSelf.editPriceBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        } else {
            [weakSelf.cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择商品类目"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             [weakSelf pulishSelectCate:weakSelf.cateList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
        }
    };
    
    //PublishGoodsMoreDetailView
    
    _moreBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
            [PublishGoodsMoreDetailView showInView:weakSelf];
        } else {
            [weakSelf.cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择商品类目"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             [weakSelf pulishSelectCate:weakSelf.cateList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    };

    _cateSelectorBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf pulishSelectCate:weakSelf.cateList];
    };
    _brandSelectorBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf publishSelectBrand:weakSelf.brandList];
    };
//    _tagsSelectorBtn.handleClickBlock = ^(CommandButton *sender) {
//        [weakSelf publishSelectTags:weakSelf.tagGroupList];
//    };
//
    _gradeBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf publishSelectGrade];
    };
//    _fitPeopleBtn.handleClickBlock = ^(CommandButton *sender) {
//        [weakSelf publishSelectFitPeople];
//    };
    _picturesEditView.handleAddPicActionBlock = ^(NSInteger userData) {
        if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
            NSInteger cateId = weakSelf.selectedCate?weakSelf.selectedCate.cateId:weakSelf.editableInfo.categoryId;
            TakePhotoViewController *viewController = [[TakePhotoViewController alloc] init];
            viewController.title = weakSelf.selectedCate?weakSelf.selectedCate.name:@"";
            viewController.userData = userData;
            viewController.cateId = cateId;
            viewController.sampleList = [weakSelf.sampleListDict objectForKey:[NSNumber numberWithInteger:cateId]];;
            viewController.handleImagePicked = ^(NSInteger userData, UIImage *image, NSString *filePath) {
                [weakSelf.picturesEditView handleImagePicked:userData image:image filePath:filePath];
            };
            viewController.handleSampleListFetchedBlock = ^(NSInteger caiteId, NSArray *sampleList) {
                [weakSelf.sampleListDict setObject:[NSNumber numberWithInteger:cateId] forKey:sampleList];
            };
            [weakSelf.viewController pushViewController:viewController animated:YES];
        } else {
            [weakSelf.cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择商品类目"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             [weakSelf pulishSelectCate:weakSelf.cateList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
       
    };
}


- (void)showColourSubView:(UIButton *)btn {
    self.colourView.isShow = !self.colourView.isShow;
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutSubviews];
        if (self.colourView.isShow) {
            self.colourView.showBtn.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.colourView.showBtn.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showSourceSubView:(UIButton *)btn {
    self.SourceView.isShow = !self.SourceView.isShow;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutSubviews];
        if (self.SourceView.isShow) {
            self.SourceView.showBtn.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.SourceView.showBtn.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ColourSubViewDelegate
- (void)didSelectColourBtnWithTag:(NSInteger)tag {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"全新", @"2", @"95成新", @"3", @"9成新", @"4", @"8成新", @"5", @"98成新", @"6", @"85成新", nil];
    NSLog(@"点击了第%ld个", tag);
    if (tag >= 0) {
        self.colourView.btnLeftLB.text = self.colourArr[tag];
        self.editableInfo.grade = [[dic objectForKey:self.colourArr[tag]] integerValue];
        self.colourStr = self.colourArr[tag];
    } else {
        self.colourView.btnLeftLB.text = @"请选择";
        //未选择时
        self.editableInfo.grade = 0;
    }
    //执行数据对接
    [self showColourSubView:nil];
}

- (void)didSelectSourceViewWithBtn1Tag:(NSInteger)tag1 andBtn2Tag:(NSInteger)tag2 {
    NSLog(@"选中的firstTag:%ld, secondTag:%ld", tag1, tag2);
    if (!self.editableInfo.goodsResourceList) {
        self.editableInfo.goodsResourceList = [NSMutableArray arrayWithCapacity:0];
    }
    [self.editableInfo.goodsResourceList removeAllObjects];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithCapacity:0];
    
    CertificationModel *cerModel1 = [[CertificationModel alloc] init];
    CertificationModel *cerModel2 = [[CertificationModel alloc] init];
    //执行数据对接
    if (tag1 >= 0 && tag2 < 0) {
        
        self.SourceView.btnLeftLB.text = self.publishModelOne.list[tag1];
        
        cerModel1.attr_value = self.publishModelOne.list[tag1];
        cerModel1.attr_id = [NSString stringWithFormat:@"%ld", self.publishModelOne.attr_id];
        
//        [dict setValue:self.publishModelOne.list[tag1] forKey:@"attr_value"];
//        [dict setValue:[NSString stringWithFormat:@"%ld", self.publishModelOne.attr_id] forKey:@"attr_id"];
        
    }
    if (tag2 >= 0 && tag1 < 0) {
        self.SourceView.btnLeftLB.text = self.publishModelTwo.list[tag2];
        
        cerModel2.attr_id = [NSString stringWithFormat:@"%ld", self.publishModelTwo.attr_id];
        cerModel2.attr_value = self.publishModelTwo.list[tag2];
        
//        [dict setValue:self.publishModelTwo.list[tag2] forKey:@"attr_value"];
//        [dict setValue:[NSString stringWithFormat:@"%ld", self.publishModelTwo.attr_id] forKey:@"attr_id"];
//        [dict1 setValue:@"" forKey:[NSString stringWithFormat:@"%ld", self.publishModelOne.attr_id]];
    }
    
    if (tag1 >= 0 && tag2 >= 0) {
        self.SourceView.btnLeftLB.text = [NSString stringWithFormat:@"%@ %@", self.publishModelOne.list[tag1], self.publishModelTwo.list[tag2]];
//        [self showSourceSubView:nil];
        
        cerModel1.attr_id = [NSString stringWithFormat:@"%ld", self.publishModelOne.attr_id];
        cerModel1.attr_value = self.publishModelOne.list[tag1];
        cerModel2.attr_id = [NSString stringWithFormat:@"%ld", self.publishModelTwo.attr_id];
        cerModel2.attr_value = self.publishModelTwo.list[tag2];
        
//        [dict setValue:self.publishModelTwo.list[tag2] forKey:@"attr_value"];
//        [dict setValue:[NSString stringWithFormat:@"%ld", self.publishModelTwo.attr_id] forKey:@"attr_id"];
//        [dict1 setValue:self.publishModelOne.list[tag1] forKey:@"attr_value"];
//        [dict1 setValue:[NSString stringWithFormat:@"%ld", self.publishModelOne.attr_id] forKey:@"attr_id"];
    }
    if (tag1 < 0 && tag2 < 0) {
        self.SourceView.btnLeftLB.text = @"请选择";
    }
    
//    [self.editableInfo.goodsResourceList addObject:dict1];
//    [self.editableInfo.goodsResourceList addObject:dict];
    [self.editableInfo.goodsResourceList addObject:[cerModel1 toJSONDictionary]];
    [self.editableInfo.goodsResourceList addObject:[cerModel2 toJSONDictionary]];
    NSLog(@"arr:%@", self.editableInfo.goodsResourceList);
    
    
}

- (void)priceTapAction:(UITapGestureRecognizer *)tap {
    WEAKSELF;
    if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
        DigitalPriceInputView *intputView = [[DigitalPriceInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        //交换
        intputView.shopPriceCent = weakSelf.editableInfo.marketPriceCent;
        intputView.marketPriceCent = weakSelf.editableInfo.shopPriceCent;
        
        [DigitalKeyboardView showInViewFromPublish:weakSelf.superview inputContainerView:intputView
                         textFieldArray:[NSArray arrayWithObjects:intputView.priceTextField,intputView.marketPriceTextField, nil] completion:^(DigitalInputContainerView *inputContainerView) {
                             //因为修改了售价和买入价的位置, 这里做了互换
                             NSInteger marketPriceCent = ((DigitalPriceInputView*)inputContainerView).shopPriceCent;
                             NSInteger shopPriceCent = ((DigitalPriceInputView*)inputContainerView).marketPriceCent;
                             
                             weakSelf.editableInfo.shopPriceCent = shopPriceCent;
                             weakSelf.editableInfo.marketPriceCent = marketPriceCent;
                             self.priceView.buyPriceFD.text = [NSString stringWithFormat:@"%.2lf", marketPriceCent / 100.];
                             self.priceView.sellPriceFD.text = [NSString stringWithFormat:@"%.2lf", shopPriceCent / 100.];
//                            fillEditPriceBtnBlock(shopPriceCent,marketPriceCent);
//                             fillEarnMoneyLblSubtitleBlock(shopPriceCent);
                         }];
        [weakSelf.editPriceBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
    } else {
        [weakSelf.cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [WCAlertView showAlertWithTitle:@""
                                message:@"请先选择商品类目"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         [weakSelf pulishSelectCate:weakSelf.cateList];
                     } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
    }

}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    //    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
    
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.title = @"服务协议";
    viewController.url = [url absoluteString];
    if ([self.publishGoodsDelegate respondsToSelector:@selector(pushWebViewController:)]) {
        [self.publishGoodsDelegate pushWebViewController:viewController];
    }
//    [self pushViewController:viewController animated:YES];
}

-(void)clickSendBtn{
    
    WEAKSELF;
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
    if (isLoggedIn) {
        
        if (_isSelected == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先阅读爱丁猫平台售卖协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [MobClick event:@"click_goods_publish"];
        [weakSelf publish];
    }
    
}

-(void)clickAgreeBtn{
    if (_isSelected) {
        _agreeBtn.selected = NO;
        _isSelected = NO;
    } else {
        _agreeBtn.selected = YES;
        _isSelected = YES;
    }
}

- (void)hidenExpectedDeliveryPickerView {
    WEAKSELF;
    CommandButton *sender = (CommandButton*)[weakSelf.superview viewWithTag:2115];
    UIPickerView *pickerView = (UIPickerView*)[weakSelf.superview viewWithTag:6868];
    UIView *bgView = [weakSelf.superview viewWithTag:2215];
    
    NSInteger row = [pickerView  selectedRowInComponent:0];
    
    [weakSelf pickerView:pickerView didSelectRow:row inComponent:0];
    
    [UIView animateWithDuration:0.25f animations:^{
        sender.frame = CGRectMake(weakSelf.superview.width-40-5, weakSelf.superview.height+5, 40, 40);
        pickerView.frame = CGRectMake(0, weakSelf.superview.height, weakSelf.superview.width, pickerView.height);
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.];
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
        [pickerView removeFromSuperview];
        [bgView removeFromSuperview];
    }];
}

- (void)showExpectedDeliveryPickerView {
    WEAKSELF;
    
    [[self.superview viewWithTag:2215] removeFromSuperview];
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:self.superview.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.];
    bgView.tag = 2215;
    [self.superview addSubview:bgView];
    bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [weakSelf hidenExpectedDeliveryPickerView];
    };
    
    [UIView animateWithDuration:0.25f animations:^{
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    }];

    UIPickerView *pickerView = (UIPickerView*)[weakSelf.superview viewWithTag:6868];
    [pickerView removeFromSuperview];
    pickerView = nil;
    if (!pickerView) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 160)];
        pickerView.tag = 6868;
        [weakSelf.superview addSubview:pickerView];
    }
    [weakSelf.superview bringSubviewToFront:pickerView];
    
    
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = weakSelf;
    pickerView.showsSelectionIndicator = YES;
    
    if (_editableInfo.expected_delivery_type>=1&&_editableInfo.expected_delivery_type<=5) {
        [pickerView selectRow:_editableInfo.expected_delivery_type-1 inComponent:0 animated:NO];
    } else {
        [pickerView selectRow:0 inComponent:0 animated:NO];
    }
    
    CommandButton *closeBtn = (CommandButton*)[self.superview viewWithTag:2115];
    [closeBtn removeFromSuperview];
    closeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(self.superview.width-40-5, self.superview.height+5, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"checked_big"] forState:UIControlStateNormal];
    closeBtn.tag = 2115;
    [weakSelf.superview addSubview:closeBtn];
    
    [UIView animateWithDuration:0.25f animations:^{
        pickerView.frame = CGRectMake(0, weakSelf.superview.height-pickerView.height, weakSelf.superview.width, pickerView.height);
        closeBtn.frame = CGRectMake(self.superview.width-40-5, self.superview.height-160+5, 40, 40);
    } completion:^(BOOL finished) {
    }];
    
    closeBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf hidenExpectedDeliveryPickerView];
    };
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [GoodsInfo expected_delivery_desc:row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _editableInfo.expected_delivery_type = row+1;
    UILabel *lbl = (UILabel*)[_expectedDeliveryTypeBtn viewWithTag:100];
    if (row>=0) {
        lbl.text = [GoodsInfo expected_delivery_desc:row+1];
        [_expectedDeliveryTypeBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
    } else {
        lbl.text = nil;
        [_expectedDeliveryTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)fillEditData
{
    NSMutableArray *picItemsArray = [[NSMutableArray alloc] init];
    if (_editableInfo.mainPicItem && [_editableInfo.mainPicItem.picUrl length]>0) {
        [picItemsArray addObject:_editableInfo.mainPicItem];
    }
    
    for (NSInteger i=0;i<[_editableInfo.gallary count];i++) {
        PictureItem *item = [_editableInfo.gallary objectAtIndex:i];
        if ([item isKindOfClass:[PictureItem class]]) {
            [picItemsArray addObject:item];
        }
    }
    _picturesEditView.picItemsArray = picItemsArray;
    _goodsNameTextField.text = _editableInfo.goodsName;
    if (_editableInfo.shopPrice>0) {
        _shopPriceField.text = [NSString stringWithFormat:@"%.2f",_editableInfo.shopPrice];
        _earnMoneyLblSubtitle.text = _poundage_cent_String;
    } else {
        _earnMoneyLblSubtitle.text = nil;
    }
    
    if (_editableInfo.marketPrice>0) {
        _marketPriceField.text = [NSString stringWithFormat:@"%.2f",_editableInfo.marketPrice];
    }
    
    
    UILabel *lblCate = (UILabel*)[_cateSelectorBtn viewWithTag:100];
    lblCate.text = [_editableInfo.categoryName length]>0?_editableInfo.categoryName:@"请选择商品类别";
    
    UILabel *lblBrand = (UILabel*)[_brandSelectorBtn viewWithTag:100];
    lblBrand.text = [_editableInfo.brandName length]>0?_editableInfo.brandName:@"";
    
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (TagVo *tagVo in _editableInfo.tagList) {
        if ([str length]>0) {
            [str appendString:@" "];
        }
        [str appendString:tagVo.tagName];
    }
    UILabel *tagsLbl = (UILabel*)[_tagsSelectorBtn viewWithTag:100];
    tagsLbl.text = str;
    
    UILabel *lblGrade = (UILabel*)[_gradeBtn viewWithTag:100];
    GradeInfo *gradeInfo = [GradeInfo gradeInfoByGrade:_editableInfo.grade];
    lblGrade.text = gradeInfo?[NSString stringWithFormat:@"%@(%@)",gradeInfo.gradeName,gradeInfo.gradeDesc]:@"必填";
    
    UILabel *lblFitPeople = (UILabel*)[_fitPeopleBtn viewWithTag:100];
    lblFitPeople.text = [GoodsEditableInfo fitPeopleString:_editableInfo.fitPeople];
    
//    UISwitch *switchBtn = (UISwitch*)[self viewWithTag:8001];
//    switchBtn.on = _editableInfo.isSupportReturn;
    
    if (!(_editableInfo.expected_delivery_type>=1&&_editableInfo.expected_delivery_type<=5)) {
        _editableInfo.expected_delivery_type = 1;
    }
    UILabel *lbl = (UILabel*)[_expectedDeliveryTypeBtn viewWithTag:100];
    if (_editableInfo.expected_delivery_type>0) {
        lbl.text = [GoodsInfo expected_delivery_desc:_editableInfo.expected_delivery_type];
    } else {
        lbl.text = nil;
    }
    
    _summaryTextView.text = _editableInfo.summary?_editableInfo.summary:@"";
    
    [self textFieldDidEndEditing:_shopPriceField];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    return NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginTop = 0.f;
    
    CGFloat hegiht44 = kScreenWidth*44.f/320.f;
    CGFloat hegiht = kScreenWidth*40.f/320.f;
    
    _cateSelectorBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    marginTop += _cateSelectorBtn.height;
    
//    marginTop += 0.5f;
    
    _bgLine1.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    marginTop += 1;
    
    _brandSelectorBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    marginTop += _brandSelectorBtn.height;
    
    marginTop += 0.5f;
    
    _segOne.frame = CGRectMake(0, marginTop, kScreenWidth, 12);
    marginTop += 12;
    marginTop += 0.5f;
    
    
    _picturesEditViewTop.frame = CGRectMake(0, marginTop, kScreenWidth, 10);
    marginTop += 10;
    
    _picturesEditView.frame = CGRectMake(0, marginTop, kScreenWidth, _picturesEditView.height);
    marginTop += _picturesEditView.height;
    
    _picturesEditViewBottom.frame = CGRectMake(0, marginTop, kScreenWidth, 10);
    marginTop += 10.f;
    
    
    _segThree.frame = CGRectMake(0, marginTop, kScreenWidth, 12);
    marginTop += 12;
    marginTop += 0.5f;
    
    _priceView.frame = CGRectMake(0, marginTop, kScreenWidth, 89);
    marginTop += 89;
    
    if (_colourView.isShow) {
        _colourView.frame = CGRectMake(0, marginTop, kScreenWidth, 171);
        marginTop += 171;
    } else {
        _colourView.frame = CGRectMake(0, marginTop, kScreenWidth, 45);
        marginTop += 45;
    }
    marginTop += 0.5f;
    
//    _summaryTextView.frame = CGRectMake(0, marginTop, kScreenWidth, 64);
    _summaryTextView.frame = CGRectMake(0, marginTop, kScreenWidth, 88);
    marginTop += _summaryTextView.height;
    
    _bgLine.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    marginTop += 1;
    
    if (self.SourceView.isShow) {
        //根据数组判定/....
        CGFloat height;
        if (self.dataDic) {
            CGFloat firstHeight = (self.publishModelOne.list.count % 4) == 0 ? (self.publishModelOne.list.count / 4) * 40 : ((self.publishModelOne.list.count / 4) + 1) * 40;
            CGFloat secondHeight = (self.publishModelTwo.list.count % 4) == 0 ? (self.publishModelTwo.list.count / 4) * 40 : ((self.publishModelTwo.list.count / 4) + 1) * 40;
            
            height = 82 + firstHeight + 35 + secondHeight + 7;
        } else {
            height = 45;
        }
        _SourceView.frame = CGRectMake(0, marginTop, kScreenWidth, height);
        marginTop += height;
    } else {
        _SourceView.frame = CGRectMake(0, marginTop, kScreenWidth, 45);
        marginTop += 45;
    }
    
    _expectedDeliveryTypeBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    marginTop += _expectedDeliveryTypeBtn.height;
//    marginTop += 0.5;
    
    _bgLine2.frame = CGRectMake(0, marginTop, kScreenWidth, 1);
    marginTop += 1;
    
    _moreBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    marginTop += _moreBtn.height;
    
    
//    _segTwo.frame = CGRectMake(0, marginTop, kScreenWidth, 12);
//    marginTop += 12;
    marginTop += 0.5f;
    
//    _goodsNameTextField.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht44);
//    marginTop += _goodsNameTextField.height;
//    
//    _goodsNameBottomLine.frame = CGRectMake(15, _goodsNameTextField.bottom-0.5, kScreenWidth-15, 0.5);
    
//    if (self.goods_name_sample&&[self.goods_name_sample length]>0) {
//        marginTop += 6;
//        _goodsNameExplainLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, _goodsNameExplainLbl.height);
//        marginTop += _goodsNameExplainLbl.height;
//        marginTop += 8;
//    } else {
////        marginTop += 15;
//    }
//    
//    _numLbl.frame = CGRectMake(15, marginTop, self.width-30, _numLbl.height);
//    marginTop += _numLbl.height;
//    marginTop += 5;
    
    
//    marginTop += 0.5f;
    
    
    
    
    
//    marginTop += 10;
    
    
    
//    _gradeBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    marginTop += _gradeBtn.height;
//    marginTop += 0.5f;
//    
//    
//    
//    _editPriceBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    marginTop += _editPriceBtn.height;
    
    if (_poundage_cent>100) {
        marginTop += 0.5;
        _earnMoneyLbl.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
        marginTop += _earnMoneyLbl.height;
        _earnMoneyLblSubtitle.frame = CGRectMake(17, _earnMoneyLbl.top, kScreenWidth-34, _earnMoneyLbl.height);
    }
    if ([self.poundage_explain length]>0) {
        marginTop += 6;
        _earnMoneyHelperLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, _earnMoneyHelperLbl.height);
        _earnMoneyHelperLbl.numberOfLines = 0;
        [_earnMoneyHelperLbl sizeToFit];
        _earnMoneyHelperLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, _earnMoneyHelperLbl.height);
        marginTop += _earnMoneyHelperLbl.height;
        marginTop += 8;
    }
    else {
        marginTop += 0.5;
    }
    
    
    
    
    
    _agreeView.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
    marginTop += _agreeView.height;
    
    _backView.frame = CGRectMake(0, marginTop, kScreenWidth, _pictImageView.height);
    _pictImageView.frame = CGRectMake(kScreenWidth / 2 - _pictImageView.width / 2, marginTop, _pictImageView.width, _pictImageView.height);
    marginTop += _pictImageView.height;
    
//    _backView1.frame = CGRectMake(0, marginTop, kScreenWidth, 75);
    _backView1.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    marginTop += _backView1.height;
//
    
//    _marketPriceField.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    marginTop += _marketPriceField.height;
//    marginTop += 1;
//    
//    _shopPriceField.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    marginTop += _shopPriceField.height;
//    


//    
//    _tagsSelectorBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    marginTop += _tagsSelectorBtn.height;
//    marginTop += 15;
//
//    
//    _fitPeopleBtn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//    marginTop += _fitPeopleBtn.height;
//    
//    for (CommandButton *btn in _attrBtnArray) {
//        btn.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
//        [self addSubview:btn];
//        marginTop += 1;
//        marginTop += [self editableButtonRealHeight:btn];
//    }
//    
//    if ([_attrBtnArray count]>0) {
//        if ([self editableButtonRealHeight:_attrBtnArray[[_attrBtnArray count]-1]]>kScreenWidth*40.f/320.f) {
//            
//        } else {
//            
//        }
//    }
//    
//    marginTop += 15;
//    
//
////    _goodsReturnLbl.frame = CGRectMake(0, marginTop, kScreenWidth, hegiht);
////    marginTop += _goodsReturnLbl.height;
////    marginTop += 15;
//    
////    UIView *switchBtn = [self viewWithTag:8001];
////    switchBtn.frame = CGRectMake(kScreenWidth-15-switchBtn.width, _goodsReturnLbl.top+(_goodsReturnLbl.height-switchBtn.height)/2, switchBtn.width,switchBtn.height);;

    
    
    self.contentSize = CGSizeMake(kScreenWidth, marginTop);
}

- (void)setEditableInfo:(GoodsEditableInfo *)editableInfo {
    if (_editableInfo != editableInfo) {
        
        _editableInfo = editableInfo;
        if (editableInfo.categoryId>0) {
            [self.cateAttrInfoDict setObject:_editableInfo.attrInfoList forKey:[NSNumber numberWithInteger:editableInfo.categoryId]];
//            [self.cateAttrInfoDict setObject:_editableInfo.categoryId forKey:editableInfo.categoryId];
        }
        [self reloadData];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)pulishSelectCate:(NSArray*)cateList
{
    WEAKSELF;
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    //        viewController.delegate = weakSelf;
    //        viewController.selectedCateId = weakSelf.editableInfo.categoryId;
    //        viewController.selectedCateName = weakSelf.editableInfo.categoryName;
    viewController.title = @"选择类别";
    viewController.delegate = weakSelf;
    viewController.selectableItemArray = nil;
    if ([cateList count]>0) {
        NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateList.count];
        for (Cate *cate in cateList) {
            if ([cate isKindOfClass:[Cate class]]) {
                if ([cate.children count]>0) {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
                    NSLog(@"%@", selectableItemArray);
                } else {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:cate==weakSelf.selectedCate attatchedItem:cate]];
                    
                    weakViewController.isSupportSearch = YES;
                }
            }
        }
        weakViewController.selectableItemArray = selectableItemArray;
    } else {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            [weakViewController showProcessingHUD:nil];
            [CategoryService getCateList:^(NSDictionary *data) {
                [weakViewController hideHUD];
                NSArray *cateListDicts = [data arrayValueForKey:@"list"];
                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
                NSMutableArray *cateList = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
                for (NSDictionary *dict in cateListDicts) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        Cate *cate = [Cate createWithDict:dict];
                        //一级
                        [cateList addObject:cate];
                        if ([cate.children count]>0) {
                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
                        } else {
                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:NO attatchedItem:cate]];
                            weakViewController.isSupportSearch = YES;
                        }
                    }
                }
                weakSelf.cateList = cateList;
                weakViewController.selectableItemArray = selectableItemArray;
                [weakViewController reloadData];
            } failure:^(XMError *error) {
                [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    [weakSelf.viewController.navigationController pushViewController:viewController animated:YES];
}

- (void)publishSelectBrand:(NSArray*)brandList
{
    WEAKSELF;
    if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
        
    } else {
        [weakSelf.cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
        //                                                             message:@"请先选择商品类目 "
        //                                                            delegate:nil
        //                                                   cancelButtonTitle:nil
        //                                                   otherButtonTitles:@"确定", nil];
        //        [alertView show];
        
        [WCAlertView showAlertWithTitle:@""
                                message:@"请先选择商品类目"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         [weakSelf pulishSelectCate:weakSelf.cateList];
                     } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        return;
    }
    

    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    viewController.title = @"选择品牌";
    viewController.delegate = weakSelf;
    viewController.isGroupedWithName = YES;
    viewController.isSupportSearch = YES;
    
    //add code
    viewController.isShowHeader = YES;
    
    if ([brandList count]>0) {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:brandList.count];
            for (BrandInfo *brandInfo in brandList) {
                NSString *name = @"";
                if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
                    name = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
                } else if ([brandInfo.brandEnName length]>0) {
                    name = brandInfo.brandEnName;
                } else if (brandInfo.brandName) {
                    name = brandInfo.brandName;
                }
                if ([name length]>0) {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:name summary:nil isSelected:weakSelf.selectedBrandInfo==brandInfo attatchedItem:brandInfo]];
                }
            }
            weakViewController.selectableItemArray = selectableItemArray;
            [weakViewController reloadData];
        };
    } else {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            [weakViewController showProcessingHUD:nil];
            //_selectedCate?0:
            [BrandService getBrandList:_selectedCate.cateId completion:^(NSArray *fechtedBrandList) {
                [weakViewController hideHUD];
                NSLog(@"%ld, %ld", _selectedCate.cateId, _selectedCate.parentId);
                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:fechtedBrandList.count];
                for (BrandInfo *brandInfo in fechtedBrandList) {
                    NSString *name = @"";
                    if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
                        name = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
                    } else if ([brandInfo.brandEnName length]>0) {
                        name = brandInfo.brandEnName;
                    } else if (brandInfo.brandName) {
                        name = brandInfo.brandName;
                    }
                    if ([name length]>0) {
                        [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:name summary:nil isSelected:weakSelf.selectedBrandInfo==brandInfo attatchedItem:brandInfo]];
                    }
                }
                weakSelf.brandList = fechtedBrandList;
                weakViewController.selectableItemArray = selectableItemArray;
                [weakViewController reloadData];
            } failure:^(XMError *error) {
                [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    [weakSelf.viewController.navigationController pushViewController:viewController animated:YES];
}

- (void)publishSelectTags:(NSArray*)tagGroupList
{
    WEAKSELF;
    if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
        
    } else {
        [weakSelf.cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
        //                                                             message:@"请先选择商品类目 "
        //                                                            delegate:nil
        //                                                   cancelButtonTitle:nil
        //                                                   otherButtonTitles:@"确定", nil];
        //        [alertView show];
        
        [WCAlertView showAlertWithTitle:@""
                                message:@"请先选择商品类目"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         [weakSelf pulishSelectCate:weakSelf.cateList];
                     } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        return;
    }
    
    for (TagGroupVo *tagGroupVo in tagGroupList) {
        for (TagVo *tagVo in tagGroupVo.tagList) {
            tagVo.isSelected = NO;
        }
    }
    
    for (TagGroupVo *tagGroupVo in tagGroupList) {
        for (TagVo *tagVo in tagGroupVo.tagList) {
            if ([self.editableInfo.tagList count]>0 ) {
                for (TagVo *tmpTagVo in self.editableInfo.tagList) {
                    if (tmpTagVo.tagId == tagVo.tagId) {
                        tagVo.isSelected = YES;
                    }
                }
            }
        }
    }

    TagsViewController *viewController = [[TagsViewController alloc] init];
    viewController.category_id = self.selectedCate?0:self.selectedCate.cateId;
    viewController.tagGroupList = tagGroupList;
    viewController.handleTagsListFetchedBlock = ^(NSArray *tagGroupList) {
        weakSelf.tagGroupList = tagGroupList;
        
        for (TagGroupVo *tagGroupVo in tagGroupList) {
            for (TagVo *tagVo in tagGroupVo.tagList) {
                for (TagVo *tmpTagVo in weakSelf.editableInfo.tagList) {
                    if (tmpTagVo.tagId == tagVo.tagId) {
                        tagVo.isSelected = YES;
                        break;
                    }
                }
            }
        }
    };
    viewController.handleTagsDidSelectBlock = ^() {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (TagGroupVo *tagGroupVo in self.tagGroupList) {
            for (TagVo *tagVo in tagGroupVo.tagList) {
                if (tagVo.isSelected) {
                    [array addObject:tagVo];
                }
            }
        }
        [weakSelf saveEditInfo];
        weakSelf.editableInfo.tagList = array;
        [weakSelf reloadData];
    };
    [self.viewController pushViewController:viewController animated:YES];
}

- (void)publishSelectGrade
{
    WEAKSELF;
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    viewController.title = @"选择成色";
    viewController.delegate = weakSelf;
    
    NSMutableArray *selectableItemArray = [[NSMutableArray alloc] init];
    
    for (GradeInfo *gradeInfo in [GradeInfo allGradeInfoArray]) {
        [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:[NSString stringWithFormat:@"%@ (%@)",gradeInfo.gradeName,gradeInfo.gradeDesc] summary:gradeInfo.gradeSummary isSelected:weakSelf.editableInfo.grade==gradeInfo.grade attatchedItem:gradeInfo]];
    }
    weakViewController.selectableItemArray = selectableItemArray;
    [weakSelf.viewController.navigationController pushViewController:viewController animated:YES];
}

- (void)publishSelectFitPeople
{
//    WEAKSELF;
//    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
//    typeof(viewController) __weak weakViewController = viewController;
//    viewController.title = @"选择适用人群";
//    viewController.delegate = weakSelf;
//    
//    NSMutableArray *selectableItemArray = [[NSMutableArray alloc] init];
//    
//    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:@"所有人" summary:nil isSelected:weakSelf.editableInfo.fitPeople==0 attatchedItem:[NSNumber numberWithInteger:0]]];
//    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:@"男士" summary:nil isSelected:weakSelf.editableInfo.fitPeople==1 attatchedItem:[NSNumber numberWithInteger:1]]];
//    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:@"女士" summary:nil isSelected:weakSelf.editableInfo.fitPeople==2 attatchedItem:[NSNumber numberWithInteger:2]]];
//    
//    weakViewController.selectableItemArray = selectableItemArray;
//    weakViewController.view.tag = 1001;
//    [weakSelf.viewController.navigationController pushViewController:viewController animated:YES];
    
    PublishSelectFitPeopleViewController *viewController = [[PublishSelectFitPeopleViewController alloc] init];
    viewController.fitPeople = self.editableInfo.fitPeople;
    viewController.delegate = self;
    [self.viewController.navigationController pushViewController:viewController animated:YES];
}

- (void)publishSelectAttrEditInfo:(AttrInfoEditButton*)attrEditButton
{
    if (attrEditButton.attrEditableInfo.type == kTYPE_YES_OR_NO
        || attrEditButton.attrEditableInfo.type == kTYPE_SELECT) {
        WEAKSELF;
        AttrEditableInfo *attrEditInfo = attrEditButton.attrEditableInfo;
        PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
        typeof(viewController) __weak weakViewController = viewController;
        viewController.title = [attrEditInfo.attrName length]>0?[NSString stringWithFormat:@"选择%@",attrEditInfo.attrName]:@"";
        viewController.delegate = weakSelf;
        
        NSMutableArray *selectableItemArray = [[NSMutableArray alloc] init];
        
        for (NSString *value in attrEditInfo.values) {
            if ([value isKindOfClass:[NSString class]]) {
                [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:value summary:nil isSelected:[attrEditInfo.attrValue isEqualToString:value] attatchedItem:attrEditButton]];
            }
        }
        weakViewController.selectableItemArray = selectableItemArray;
        [weakSelf.viewController.navigationController pushViewController:viewController animated:YES];
    }
    else if (attrEditButton.attrEditableInfo.type == kTYPE_TEXT_INPUT) {
        WEAKSELF;
        AttrEditableInfo *attrEditInfo = attrEditButton.attrEditableInfo;
        PublishTextEditViewController *viewController = [[PublishTextEditViewController alloc] init];
        typeof(viewController) __weak weakViewController = viewController;
        viewController.title = [attrEditInfo.attrName length]>0?[NSString stringWithFormat:@"选择%@",attrEditInfo.attrName]:@"";
        viewController.delegate = weakSelf;
        viewController.title = attrEditInfo.attrName;
        weakViewController.selectableItem = [PublishSelectableItem buildSelectableItem:attrEditInfo.attrValue summary:attrEditInfo.placeholder isSelected:NO attatchedItem:attrEditButton];
        [weakSelf.viewController.navigationController pushViewController:viewController animated:YES];
    }
    else if (attrEditButton.attrEditableInfo.type == kTYPE_DATE) {
            [self pickDate:attrEditButton];
    }
}

- (void)pickDate:(AttrInfoEditButton*)attrEditButton
{
    WEAKSELF;
    void(^hideSRMonthPickerBlock)() = ^(){

        CommandButton *sender = (CommandButton*)[weakSelf.superview viewWithTag:2115];
        UIView *bgView = [weakSelf.superview viewWithTag:2215];
        
        [UIView animateWithDuration:0.25f animations:^{
            ((UIView*)(sender.userData)).frame = CGRectMake(0, weakSelf.superview.height, weakSelf.superview.width, 160);
            sender.frame = CGRectMake(weakSelf.superview.width-40-5, weakSelf.superview.height+5, 40, 40);
            bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.];
        } completion:^(BOOL finished) {
            [((UIView*)(sender.userData)) removeFromSuperview];
            [sender removeFromSuperview];
            [bgView removeFromSuperview];
        }];
        
        PublishSRMonthPicker *monthPicker = (PublishSRMonthPicker*)[weakSelf.superview viewWithTag:2015];
        if ([monthPicker isKindOfClass:[PublishSRMonthPicker class]]) {
            AttrInfoEditButton *attrEditButton = ((PublishSRMonthPicker*)monthPicker).attrInfoEditButton;
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM";
            NSString *yearMonth = [formatter stringFromDate:monthPicker.date];
            NSDate *now = [NSDate date];
            if (monthPicker.date.month > now.month && [monthPicker.date year]>=now.year) {
                yearMonth = [formatter stringFromDate:now];
            }
            
            UILabel *lbl = (UILabel*)[attrEditButton viewWithTag:100];
            lbl.text = yearMonth;
            [attrEditButton setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
            attrEditButton.attrEditableInfo.attrValue = yearMonth;
        }
    };
    
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:self.superview.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.];
    bgView.tag = 2215;
    [self.superview addSubview:bgView];
    bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        hideSRMonthPickerBlock();
    };
    
    [UIView animateWithDuration:0.25f animations:^{
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    }];
    
    PublishSRMonthPicker *monthPicker = [[PublishSRMonthPicker alloc] initWithFrame:CGRectMake(0, self.superview.height, self.superview.width, 160)];
    monthPicker.maximumYear = [NSNumber numberWithInteger:[[NSDate date] year]];
    monthPicker.minimumYear = @1950;
    monthPicker.wrapMonths = YES;
    monthPicker.yearFirst = YES;
    monthPicker.backgroundColor = [UIColor whiteColor];
    monthPicker.tag = 2015;
    [self.superview addSubview:monthPicker];
    
    monthPicker.monthPickerDelegate = self;
    // Some options to play around with
    
    monthPicker.attrInfoEditButton = attrEditButton;
    
    if ([attrEditButton.attrEditableInfo.attrValue length]>0) {
        NSDate *date = [NSDate dateFromString:attrEditButton.attrEditableInfo.attrValue withFormat:@"yyyy-MM"];
        if (date) {
            monthPicker.date = date;
        }
    }
    
    CommandButton *closeBtn = (CommandButton*)[self.superview viewWithTag:2115];
    [closeBtn removeFromSuperview];
    closeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(self.superview.width-40-5, self.superview.height+5, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"checked_big"] forState:UIControlStateNormal];
    closeBtn.userData = monthPicker;
    closeBtn.tag = 2115;
    [self.superview addSubview:closeBtn];
    
    [UIView animateWithDuration:0.25f animations:^{
        monthPicker.frame = CGRectMake(0, self.superview.height-160, self.superview.width, 160);
        closeBtn.frame = CGRectMake(self.superview.width-40-5, self.superview.height-160+5, 40, 40);
    }];
    
    closeBtn.handleClickBlock = ^(CommandButton *sender) {
        hideSRMonthPickerBlock();
    };

}

- (void)monthPickerWillChangeDate:(SRMonthPicker *)monthPicker
{
    // Show the date is changing (with a 1 second wait mimicked)
}

- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM";
        NSString *yearMonth = [formatter stringFromDate:monthPicker.date];
        NSDate *now = [NSDate date];
        if (monthPicker.date.month > now.month && [monthPicker.date year]>=now.year) {
            yearMonth = [formatter stringFromDate:now];
        }
        
        if ([monthPicker isKindOfClass:[PublishSRMonthPicker class]]) {
            AttrInfoEditButton *attrEditButton = ((PublishSRMonthPicker*)monthPicker).attrInfoEditButton;
            
            UILabel *lbl = (UILabel*)[attrEditButton viewWithTag:100];
            lbl.text = yearMonth;
            [attrEditButton setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
            attrEditButton.attrEditableInfo.attrValue = yearMonth;
        }
    });
    
//    // All this GCD stuff is here so that the label change on -[self monthPickerWillChangeDate] will be visible
//    dispatch_queue_t delayQueue = dispatch_queue_create("com.aidingmao.SRMonthPickerExample.DelayQueue", 0);
//    dispatch_async(delayQueue, ^{
//        // Wait 1 second
//        sleep(1);
//        
//    });
//    
}

- (void)publishDidSelect:(PublishSelectFitPeopleViewController*)viewController fitPeople:(NSInteger)fitPeople title:(NSString*)title {
    self.editableInfo.fitPeople = fitPeople;
    UILabel *lbl = (UILabel*)[_fitPeopleBtn viewWithTag:100];
    lbl.text = title;
    self.editableInfo.fitPeople = self.editableInfo.fitPeople;
    [_fitPeopleBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
}

- (void)publishDidSelect:(PublishSelectViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem
{
    void(^popToPulishController)() = ^{
        NSArray *viewControllers= viewController.navigationController.viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[PublishGoodsViewController class]]) {
                [viewController.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    };

    if ([selectableItem.attachedItem isKindOfClass:[Cate class]]) {
        if ([((Cate*)selectableItem.attachedItem).children count]==0) {
            _selectedCate = (Cate*)selectableItem.attachedItem;
            UILabel *lbl = (UILabel*)[_cateSelectorBtn viewWithTag:100];
            lbl.text = _selectedCate.name;
            if (self.editableInfo.categoryId!=_selectedCate.cateId) {
                self.tagGroupList = [NSArray array];
                self.brandList = [NSArray array];
                self.goods_name_sample = nil;
                self.poundage_explain = nil;
                self.poundage_cent = 0;
            }
            if ([self.goods_name_sample length]==0 || [self.poundage_explain length]==0 || self.poundage_cent==0) {
                [self reload_goods_publish_info:_selectedCate.cateId];
            }
            self.editableInfo.categoryId = _selectedCate.cateId;
            self.editableInfo.categoryName = _selectedCate.name;
            [_cateSelectorBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
            
            
            WEAKSELF;
            void(^reloadWithAttrInfoList)(NSArray *attrInfoList) = ^(NSArray *attrInfoList){
                if ([attrInfoList count]>0) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:attrInfoList.count];
                    for (AttrEditableInfo *editInfo in attrInfoList) {
                        BOOL isExist = NO;
                        for (AttrEditableInfo *tmp in weakSelf.editableInfo.attrInfoList) {
                            if (tmp.attrId == editInfo.attrId) {
                                isExist = YES;
                                [array addObject:tmp];
                                break;
                            }
                        }
                        if (!isExist) {
                            [array addObject:editInfo];
                        }
                    }
                    weakSelf.editableInfo.attrInfoList = array;
                    [weakSelf.cateAttrInfoDict setObject:array forKey:[NSNumber numberWithInteger:weakSelf.selectedCate.cateId]];
                    [weakSelf saveEditInfo];
                    [weakSelf reloadData];
                } else {
                    weakSelf.editableInfo.attrInfoList = nil;
                    [weakSelf saveEditInfo];
                    [weakSelf reloadData];
                }
            };
            NSArray *attrInfoList = [weakSelf.cateAttrInfoDict objectForKey:[NSNumber numberWithInteger:weakSelf.selectedCate.cateId]];
            if (attrInfoList) {
                reloadWithAttrInfoList(attrInfoList);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.viewController showProcessingHUD:nil];
                    [CategoryService getAttrInfoList:_selectedCate.cateId completion:^(NSArray *attrInfoList) {
                        [weakSelf.viewController hideHUD];
                        reloadWithAttrInfoList(attrInfoList);
                    } failure:^(XMError *error) {
                        [weakSelf.viewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                });
            }
            popToPulishController();
        } else {
            [self pulishSelectCate:((Cate*)selectableItem.attachedItem).children];
        }
    }
    else if ([selectableItem.attachedItem isKindOfClass:[BrandInfo class]]) {
        BrandInfo *brandInfo = (BrandInfo*)selectableItem.attachedItem;
        _selectedBrandInfo = brandInfo;
        UILabel *lbl = (UILabel*)[_brandSelectorBtn viewWithTag:100];
        if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
            lbl.text = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
        } else if ([brandInfo.brandEnName length]>0) {
            lbl.text = brandInfo.brandEnName;
        } else if (brandInfo.brandName) {
            lbl.text = brandInfo.brandName;
        }
        
        self.editableInfo.brandId = brandInfo.brandId;
        self.editableInfo.brandName = brandInfo.brandName;
        self.editableInfo.brandEnName = brandInfo.brandEnName;
        [_brandSelectorBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        popToPulishController();
    }
    else if ([selectableItem.attachedItem isKindOfClass:[GradeInfo class]]) {
        GradeInfo *gradeInfo = (GradeInfo*)selectableItem.attachedItem;
        UILabel *lbl = (UILabel*)[_gradeBtn viewWithTag:100];
        lbl.text = [NSString stringWithFormat:@"%@ (%@)",gradeInfo.gradeName,gradeInfo.gradeDesc];
        self.editableInfo.grade = gradeInfo.grade;
        [_gradeBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        popToPulishController();
    }
    else if ([selectableItem.attachedItem isKindOfClass:[NSNumber class]]) {
        if (viewController.view.tag==1000) {
            self.editableInfo.grade = [((NSNumber*)selectableItem.attachedItem) integerValue];
            UILabel *lbl = (UILabel*)[_gradeBtn viewWithTag:100];
            lbl.text = selectableItem.title;
            self.editableInfo.grade = self.editableInfo.grade;
            [_gradeBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        }
        else if (viewController.view.tag==1001) {
            self.editableInfo.fitPeople = [((NSNumber*)selectableItem.attachedItem) integerValue];
            UILabel *lbl = (UILabel*)[_fitPeopleBtn viewWithTag:100];
            lbl.text = selectableItem.title;
            self.editableInfo.fitPeople = self.editableInfo.fitPeople;
            [_fitPeopleBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        }
        popToPulishController();
    }
    else if ([selectableItem.attachedItem isKindOfClass:[AttrInfoEditButton class]]) {
        AttrInfoEditButton *attrInfoEditButton = (AttrInfoEditButton*)selectableItem.attachedItem;
        AttrEditableInfo *attrEditableInfo = attrInfoEditButton.attrEditableInfo;
        attrEditableInfo.attrValue = selectableItem.title;
        UILabel *lbl = (UILabel*)[attrInfoEditButton viewWithTag:100];
        lbl.text = selectableItem.title;
        [attrInfoEditButton setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        popToPulishController();
    }
}

- (void)publishDidEdit:(PublishTextEditViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem
{
    void(^popToPulishController)() = ^{
        NSArray *viewControllers= viewController.navigationController.viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[PublishGoodsViewController class]]) {
                [viewController.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    };
    if ([selectableItem.attachedItem isKindOfClass:[AttrInfoEditButton class]]) {
        AttrInfoEditButton *attrInfoEditButton = (AttrInfoEditButton*)selectableItem.attachedItem;
        AttrEditableInfo *attrEditableInfo = attrInfoEditButton.attrEditableInfo;
        attrEditableInfo.attrValue = selectableItem.title;
        UILabel *lbl = (UILabel*)[attrInfoEditButton viewWithTag:100];
        lbl.text = selectableItem.title;
        [attrInfoEditButton setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        popToPulishController();
    }
}

- (void)picturesEditViewHeightChanged:(PictureItemsEditView*)view height:(CGFloat)height
{
    [self setNeedsLayout];
}

- (BOOL)saveEditInfo
{
    BOOL isValid = YES;
    if ([_goodsNameTextField.text trim].length==0) {
        [_goodsNameTextField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        //修改解决必填项空缺问题
        isValid = NO;
    } else {
        _editableInfo.goodsName = [_goodsNameTextField.text trim];
    }
    //add code
    isValid = YES;
    
    if (_editableInfo.shopPriceCent==0) {
        [self.editPriceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        isValid = NO;
    }
    
//    if ([_shopPriceField.text trim].length>0 && [[_shopPriceField.text trim] floatValue]>=0.01) {
//        _editableInfo.shopPrice = [[_shopPriceField.text trim] floatValue];
//        _earnMoneyLblSubtitle.text = _poundage_cent_String;
//        
//    } else {
//        _earnMoneyLblSubtitle.text = nil;
//        _shopPriceField.text = @"";
//        [_shopPriceField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//        isValid = NO;
//    }
//    
//    if ([_marketPriceField.text trim].length >0) {
//        _editableInfo.marketPrice = [[_marketPriceField.text trim] floatValue];
//    } else {
//        _editableInfo.marketPrice = 0.f;
//    }
    
    if (_editableInfo.categoryId==0) {
        [_cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        isValid = NO;
    }
    if (_editableInfo.brandId == 0) {
        [_brandSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        isValid = NO;
    }
    if (_editableInfo.grade == -1) {
        [_gradeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        isValid = NO;
    }
    if ([_summaryTextView.text trim].length==0) {
        _summaryTextView.placeholderColor = [UIColor redColor];
        isValid = NO;
    }
//    if (_editableInfo.fitPeople==-1) {
//        [_fitPeopleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        isValid = NO;
//    }
    
    if (_editableInfo.expected_delivery_type<=0) {
        [_expectedDeliveryTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        isValid = NO;
        isValid = YES;
    }
    
    _editableInfo.summary = [_summaryTextView.text trim];
    

    NSArray *picItemsArray = [_picturesEditView picItemsArray];
    if ([picItemsArray count]==0) {
        isValid = NO;
        _editableInfo.mainPicItem = nil;
        _editableInfo.gallary = nil;
    } else {
        _editableInfo.mainPicItem = [picItemsArray objectAtIndex:0];
        if ([picItemsArray count]>1) {
            NSMutableArray *gallery = [[NSMutableArray alloc] initWithCapacity:picItemsArray.count-1];
            for (NSInteger i=1;i<picItemsArray.count;i++) {
                [gallery addObject:[picItemsArray objectAtIndex:i]];
            }
            _editableInfo.gallary = gallery;
        } else {
            _editableInfo.gallary = nil;
        }
    }
    
//    for (AttrInfoEditButton *btn in _attrBtnArray) {
//        if (btn.attrEditableInfo.isMust && [btn.attrEditableInfo.attrValue length]==0) {
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            isValid = NO;
//        }
//    }
    return isValid;
}

- (void)publish
{
    BOOL isValid = [self saveEditInfo];
    if (!isValid) {
        NSArray *picItemArray = [_picturesEditView picItemsArray];
        if (picItemArray.count == 0) {
            [self.viewController showHUD:@"请至少提供一个主图" hideAfterDelay:0.8f];
        } else {
            [self.viewController showHUD:@"请检查有必填项未填写" hideAfterDelay:0.8f];
        }
        return;
    }
    
    NSArray *picItemArray = [_picturesEditView picItemsArray];
    // add code
    
    
    NSMutableArray *uploadFiles = [[NSMutableArray alloc] init];
    for (NSInteger i=0;i<[picItemArray count];i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (item.picId == kPictureItemLocalPicId) {
            [uploadFiles addObject:item.picUrl];
        }
    }
    WEAKSELF;
    [weakSelf.viewController showProcessingHUD:nil];
    if ([uploadFiles count]>0) {
        [[NetworkAPI sharedInstance] updaloadPics:uploadFiles completion:^(NSArray *picUrlArray) {
            [weakSelf publishGoods:picUrlArray];
        } failure:^(XMError *error) {
            [weakSelf.viewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [weakSelf publishGoods:nil];
    }
}

- (void)publishGoods:(NSArray*)picUrlArray {
    
    NSArray *picItemArray = [_picturesEditView picItemsArray];
    NSInteger index = 0;
    for (PictureItem *item in picItemArray) {
        if (item.picId == kPictureItemLocalPicId) {
            if (index < [picUrlArray count]) {
                item.picUrl = [picUrlArray objectAtIndex:index];
            }
            index+=1;
        }
    }
    NSMutableArray *gallery = [[NSMutableArray alloc] init];
    for (NSInteger i=0;i<[picItemArray count];i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (item.picId == kPictureItemLocalPicId) {
            item.picId = 0;
        }
        if (i==0) {
            _editableInfo.mainPicItem = item;
        } else {
            [gallery addObject:item];
        }
    }
    _editableInfo.gallary = gallery;
    
//    NSMutableArray *cretArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [picItemArray count]; i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (item.isCer) {
            [_editableInfo.voucherPictures addObject:item];
        }
    }
    BOOL flag = NO;
    for (NSInteger i = 0; i < _editableInfo.voucherPictures.count; i++) {
        PictureItem *itemTemp = [[PictureItem alloc] initWithDict:_editableInfo.voucherPictures[i]];
        for (NSInteger j = 0; j < picItemArray.count; j++) {
            PictureItem *item = [picItemArray objectAtIndex:j];
            if ([item.picUrl isEqualToString:itemTemp.picUrl]) {
                flag = YES;
                break;
            } else {
                
            }
        }
        if (!flag) {
            [_editableInfo.voucherPictures removeObjectAtIndex:i];
            i--;
            flag = NO;
        }
        
    }
//    _editableInfo.voucherPictures = cretArr;
    
    WEAKSELF;
    self.sendBtn.userInteractionEnabled = NO;
    _request = [[NetworkAPI sharedInstance] publishGoods:_editableInfo publish_type:0 completion:^(GoodsPublishResultInfo *resultInfo) {
        self.sendBtn.userInteractionEnabled = YES;
        [weakSelf.viewController dismiss];
        if (((PublishGoodsViewController*)(weakSelf.viewController)).handlePublishGoodsFinished) {
            ((PublishGoodsViewController*)(weakSelf.viewController)).handlePublishGoodsFinished(weakSelf.editableInfo);
        }
    } failure:^(XMError *error) {
        self.sendBtn.userInteractionEnabled = YES;
        [weakSelf.viewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

@end

@interface PublishTextEditViewController ()<HPGrowingTextViewDelegate>

@end
@implementation PublishTextEditViewController {
    HPGrowingTextView *_textView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@""];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [super.topBarRightButton setTitle:@"保存" forState:UIControlStateNormal];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [super.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    [self.view addSubview:scrollView];
    
    CGFloat marginTop = 0;
    marginTop += 15;
    
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 115)];
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _textView.returnKeyType = UIReturnKeyDefault; //just as an example
    _textView.font = [UIFont systemFontOfSize:15.f];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.isScrollable = NO;
    _textView.enablesReturnKeyAutomatically = NO;
    _textView.animateHeightChange = NO;
    _textView.autoRefreshHeight = NO;
    _textView.frame = CGRectMake(15, marginTop, kScreenWidth-30, 115);
    [scrollView addSubview:_textView];
    
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    _textView.layer.masksToBounds = YES;
    _textView.placeholder = _selectableItem.summary;
    _textView.text = _selectableItem.title;
    _textView.delegate = self;
    
    [self bringTopBarToTop];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textView becomeFirstResponder];
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    [self dismiss];
    
    if (_delegate && [_delegate respondsToSelector:@selector(publishDidEdit:selectableItem:)]) {
        self.selectableItem.title = [NSString disable_emoji:_textView.text];
        [_delegate publishDidEdit:self selectableItem:self.selectableItem];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //emoji无效
    if([NSString isContainsEmoji:text]) {
        return NO;
    }
    NSMutableString *newtxt = [NSMutableString stringWithString:growingTextView.text];
    [newtxt replaceCharactersInRange:range withString:text];
    return [newtxt length]<=200;
}


@end


@implementation PublishSelectFitPeopleViewController

- (void)dealloc
{
    
}

- (id)init {
    self = [super init];
    if (self) {
        _fitPeople = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@"适用人群"];
    [super setupTopBarBackButton];
    
    CGFloat marginTop = topBarHeight;
    marginTop += 10.f;
    
    CommandButton *allPeople = [self createButton:@"所有人"];
    allPeople.frame = CGRectMake(0, marginTop, self.view.width, allPeople.height);
    allPeople.tag = 0;
    [allPeople viewWithTag:100].hidden =!(self.fitPeople==0);
    [self.view addSubview:allPeople];
    
    marginTop += allPeople.height;
    marginTop += 10.f;
    
    CommandButton *maleBtn = [self createButton:@"男士"];
    maleBtn.frame = CGRectMake(0, marginTop, self.view.width, maleBtn.height);
    maleBtn.tag = 1;
    [maleBtn viewWithTag:100].hidden =!(self.fitPeople==1);
    [self.view addSubview:maleBtn];
    
    marginTop += maleBtn.height;
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(0, marginTop, self.view.width, 0.5f);
    [self.view.layer addSublayer:line];
    marginTop += 0.5f;
    
    CommandButton *femaleBtn = [self createButton:@"女士"];
    femaleBtn.frame = CGRectMake(0, marginTop, self.view.width, femaleBtn.height);
    femaleBtn.tag = 2;
    [femaleBtn viewWithTag:100].hidden =!(self.fitPeople==2);
    [self.view addSubview:femaleBtn];
    
    WEAKSELF;
    void (^handleClick)(CommandButton*sender) = ^(CommandButton *sender) {
        [allPeople viewWithTag:100].hidden = YES;
        [maleBtn viewWithTag:100].hidden = YES;
        [femaleBtn viewWithTag:100].hidden = YES;
        
        [sender viewWithTag:100].hidden = NO;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(publishDidSelect:fitPeople:title:)]) {
            [weakSelf.delegate publishDidSelect:weakSelf fitPeople:sender.tag title:[sender titleForState:UIControlStateNormal]];
        }
        
        [weakSelf dismiss];
    };
    
    allPeople.handleClickBlock = ^(CommandButton *sender) {
        handleClick(sender);
    };
    maleBtn.handleClickBlock = ^(CommandButton *sender) {
        handleClick(sender);
    };
    femaleBtn.handleClickBlock = ^(CommandButton *sender) {
        handleClick(sender);
    };
}

- (CommandButton*)createButton:(NSString*)title {
    CommandButton *allPeople = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    [allPeople setTitle:title forState:UIControlStateNormal];
    allPeople.backgroundColor = [UIColor whiteColor];
    allPeople.titleLabel.font = [UIFont systemFontOfSize:16];
    [allPeople setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    allPeople.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    allPeople.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    UIImageView *checkedBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_big"]];
    [allPeople addSubview:checkedBg];
    checkedBg.frame = CGRectMake(allPeople.width-15-checkedBg.width, (allPeople.height-checkedBg.height)/2, checkedBg.width, checkedBg.height);
    checkedBg.tag = 100;
    checkedBg.hidden = YES;
    return allPeople;
}
@end

#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface PublishSelectViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, PublishSelectHeaderViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableDictionary *sections;
@property(nonatomic,weak) UIView *headerView;
@property(nonatomic,weak) UISearchBar *searchBar;

@property(nonatomic, strong) NSArray *headerViewDataArr;
@end

@implementation PublishSelectViewController {
    UISearchDisplayController *_searchDisplayController;
    NSMutableArray *_searchResults;
}

- (void)dealloc
{
    _callbackBlockAfterWiewDidLoad = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        _isGroupedWithName = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@""];
    [super setupTopBarBackButton];
    
    _dataSources = [[NSMutableArray alloc] init];
    _sections = [[NSMutableDictionary alloc] init];
    
    
    if (_isSupportSearch) {
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f,topBarHeight, self.view.frame.size.width, 44.0f)];
        [self.view addSubview:searchBar];
        _searchBar = searchBar;
        _searchBar.delegate =self;
        _searchBar.placeholder = @"搜索列表";
        _searchBar.tintColor = [UIColor lightGrayColor];
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        
        _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
        _searchDisplayController.active = NO;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        _searchResults = [[NSMutableArray alloc] init];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight+(_searchBar?_searchBar.height:0), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-(topBarHeight+(_searchBar?_searchBar.height:0)))];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alwaysBounceVertical = YES;
    //    tableView.showsVerticalScrollIndicator = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    if (self.isShowHeader) {
        
        NSString *URLStr = @"/brand/get_specified";
        NSDictionary *paramss = @{@"cate_id":@(self.cate_id)};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:URLStr path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
            NSLog(@"data:%@", data);
            if (((NSArray *)[data objectForKey:@"get_specified"]).count > 0) {
                PublishSelectHeaderView *headerView = [[PublishSelectHeaderView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 50 * ((NSArray *)[data objectForKey:@"get_specified"]).count)];
                headerView.delegate = self;
                _tableView.tableHeaderView = headerView;
                
                self.headerViewDataArr = [NSArray arrayWithArray:[data objectForKey:@"get_specified"]];
                [headerView updateWithArr:self.headerViewDataArr];
                
                [self.tableView reloadData];
            }
        } failure:^(XMError *error) {
            NSLog(@"load error");
        } queue:nil]];

    }
    
    
    
    [self bringTopBarToTop];
    
    [self reloadData];
    
    if (_callbackBlockAfterWiewDidLoad) {
        WEAKSELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf) {
                if (weakSelf.callbackBlockAfterWiewDidLoad) {
                    weakSelf.callbackBlockAfterWiewDidLoad();
                }
            }
        });
    }
}

// add code delegate founc
- (void)headerViewTapAction:(NSInteger)tag {
    NSDictionary *dic = self.headerViewDataArr[tag];
    
    NSInteger brandId = [dic[@"brand_id"] integerValue];
    NSString *brandName = dic[@"brand_name"];
    
    if ([self.delegate respondsToSelector:@selector(publishDidSelectHeaderView:andBrandName:)]) {
        [self.delegate publishDidSelectHeaderView:brandId andBrandName:brandName];
    }
    
    [self dismiss];
    
//    PublishSelectableItem *item = [dic objectForKey:[PublishSelectableTableViewCell cellKeyForSelectableItem]];
//    PublishSelectableItem *item = [[PublishSelectableItem alloc] init];
//    item.title = [dic objectForKey:@"brand_name"];
    
//    if (_delegate && [_delegate respondsToSelector:@selector(publishDidSelect:selectableItem:)]) {
//        [_delegate publishDidSelect:self selectableItem:item];
//    }
}


- (void)reloadData
{
    if (_isGroupedWithName) {
        NSMutableDictionary *sections = [[NSMutableDictionary alloc] init];
        for (PublishSelectableItem *item in self.selectableItemArray) {
            NSString *firstLetter = [item getFirstName];
            BOOL found = NO;
            for (NSString *str in [sections allKeys]) {
                if ([str isEqualToString:[firstLetter uppercaseString]]) {
                    found = YES;
                }
            }
            if (!found) {
                [sections setValue:[[NSMutableArray alloc] init] forKey:[firstLetter uppercaseString]];
            }
        }
        
        for (PublishSelectableItem *item in self.selectableItemArray){
            [[sections objectForKey:[[item getFirstName] uppercaseString]] addObject:[PublishSelectableTableViewCell buildCellDict:item]];
        }
        // Sort each section array
        for (NSString* key in [sections allKeys]) {
            [[sections objectForKey:key] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"brandName" ascending:YES]]];
        }
        _sections = sections;
        [_tableView reloadData];
    } else {
        
        NSMutableArray *dataSources = [[NSMutableArray alloc] init];
        for (PublishSelectableItem *item in _selectableItemArray) {
            [dataSources addObject:[PublishSelectableTableViewCell buildCellDict:item]];
        }
        _dataSources = dataSources;
        [_tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return _isGroupedWithName?[_sections count]:1;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        if (_isGroupedWithName)
        {
            return [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        } else {
            return nil;
        }
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        if (_isGroupedWithName) {
            NSString* title = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section];
            return title;
        } else {
            return nil;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return _searchResults.count;
    } else {
        return _isGroupedWithName?[[self.sections valueForKey:
                                    [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section]] count]:[self.dataSources count];;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchDisplayController.searchResultsTableView) {
        NSDictionary *dict = [_searchResults objectAtIndex:[indexPath row]];
        
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
        
//        NSLog(@"reuseIdentifier:%@", reuseIdentifier);
        
        BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (tableViewCell == nil) {
            tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        [tableViewCell updateCellWithDict:dict];
        return tableViewCell;
    } else {
        NSDictionary *dict = nil;
        if (_isGroupedWithName) {
            NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        } else {
            dict = [self.dataSources objectAtIndex:[indexPath row]];
        }
        
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
        
        NSLog(@"reuseIdentifier:%@", reuseIdentifier);
        
        BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (tableViewCell == nil) {
            tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            [tableViewCell setBackgroundColor:[UIColor colorWithHexString:@"F7F7F7"]];
            [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [tableViewCell updateCellWithDict:dict];
        
        return tableViewCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchDisplayController.searchResultsTableView) {
        NSDictionary *dict = [_searchResults objectAtIndex:[indexPath row]];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        return [ClsTableViewCell rowHeightForPortrait:dict];
    } else {
        if (_isGroupedWithName) {
            NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            NSDictionary *dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
            return [ClsTableViewCell rowHeightForPortrait:dict];
        }
        else {
            NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
            Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
            return [ClsTableViewCell rowHeightForPortrait:dict];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchDisplayController.searchResultsTableView)  {
        NSDictionary *dict = [_searchResults objectAtIndex:[indexPath row]];
        PublishSelectableItem *item = [dict objectForKey:[PublishItemSearchResultTableViewCell cellKeyForSelectableItem]];
        if (_delegate && [_delegate respondsToSelector:@selector(publishDidSelect:selectableItem:)]) {
            [_delegate publishDidSelect:self selectableItem:item];
        }
    } else {
        NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NSDictionary *dict = nil;
        if (_isGroupedWithName) {
            dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        } else {
            dict = [self.dataSources objectAtIndex:[indexPath row]];
        }
        PublishSelectableItem *item = [dict objectForKey:[PublishSelectableTableViewCell cellKeyForSelectableItem]];
        if (_delegate && [_delegate respondsToSelector:@selector(publishDidSelect:selectableItem:)]) {
            [_delegate publishDidSelect:self selectableItem:item];
        }
    }
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    
    if (_searchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:_searchBar.text]) {
        for (int i=0; i<_selectableItemArray.count; i++) {
            PublishSelectableItem *item = _selectableItemArray[i];
            if ([ChineseInclude isIncludeChineseInString:item.title]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:item.title];
                NSRange titleResult=[tempPinYinStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[PublishItemSearchResultTableViewCell buildCellDict:item]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:item.title];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:[PublishItemSearchResultTableViewCell buildCellDict:item]];
                }
            }
            else {
                NSRange titleResult=[item.title rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[PublishItemSearchResultTableViewCell buildCellDict:item]];
                }
            }
        }
    }
    else if (_searchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:_searchBar.text]) {
        for (PublishSelectableItem *item in _selectableItemArray) {
            NSRange titleResult=[item.title rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:[PublishItemSearchResultTableViewCell buildCellDict:item]];
            }
        }
    }
    _searchResults = searchResults;
}

@end


@interface PublishSelectableItem ()
@property(nonatomic,copy) NSString *firstName;
@end
@implementation PublishSelectableItem

+ (PublishSelectableItem*)buildSelectableItem:(NSString*)title
                                      summary:(NSString*)summary
                                   isSelected:(BOOL)isSelected attatchedItem:(NSObject*)attatchedItem {
    PublishSelectableItem *item = [[PublishSelectableItem alloc] init];

    item.title = title;
    item.summary = summary;
    item.isSelected = isSelected;
    item.hasChildren = NO;
    item.attachedItem = attatchedItem;
    return item;
}

+ (PublishSelectableItem*)buildSelectableItem:(NSString*)title
                                      summary:(NSString*)summary
                                  hasChildren:(BOOL)hasChildren attatchedItem:(NSObject*)attatchedItem {
    PublishSelectableItem *item = [[PublishSelectableItem alloc] init];
    item.title = title;
    item.summary = summary;
    item.hasChildren = hasChildren;
    item.isSelected = NO;
    item.attachedItem = attatchedItem;
    return item;
}

- (NSString *)getFirstName
{
    if (!_firstName) {
        NSString *firstChar = [_title substringToIndex:1];
        if ([firstChar canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            _firstName = [firstChar substringToIndex:1];
        } else {
            char firstletter = ' ';
            if ([firstChar isEqualToString:@"重"] || [firstChar isEqualToString:@"长"]) {
                firstletter = 'C';
            } else {
                firstletter = pinyinFirstLetter([firstChar characterAtIndex:0]);
            }
            _firstName = [NSString stringWithFormat:@"%c",firstletter];
        }
    }
    return _firstName;
}

@end

@implementation PublishItemSearchResultTableViewCell {
    UILabel *_nameLbl;
    CALayer *_bottomLine;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishItemSearchResultTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return 44;
}

+ (NSMutableDictionary*)buildCellDict:(PublishSelectableItem*)item {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishItemSearchResultTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellKeyForSelectableItem]];
    return dict;
}

+ (NSString*)cellKeyForSelectableItem {
    return @"selectableItem";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLbl = [[UIInsetLabel alloc] initWithFrame:CGRectNull andInsets:UIEdgeInsetsMake(0, 15, 0, 15+17)];
        _nameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _nameLbl.font = [UIFont systemFontOfSize:14.f];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLbl];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _nameLbl.frame = CGRectMake(0, 0, kScreenWidth, self.contentView.height);
    
    _bottomLine.frame = CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5);
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    
    PublishSelectableItem *selectableItem = [dict objectForKey:[[self class] cellKeyForSelectableItem]];
    if ([selectableItem isKindOfClass:[selectableItem class]]) {
        _selectableItem = selectableItem;
        _nameLbl.text = selectableItem.title;
        [self setNeedsLayout];
    }
}

@end

@implementation PublishSelectableTableViewCell {
    UILabel *_nameLbl;
    UILabel *_summaryLbl;
    UIImageView *_flagView;
    UIImageView *_rightArrowView;
    CALayer *_middleLine;
    CALayer *_bottomLine;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishSelectableTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = [self cellHeight];
    PublishSelectableItem *selectableItem = [dict objectForKey:[self cellKeyForSelectableItem]];
    if ([selectableItem isKindOfClass:[selectableItem class]]) {
        NSString *summary = selectableItem.summary;
        if ([summary length]>0) {
            height += 5;
            CGSize size = [summary sizeWithFont:[UIFont systemFontOfSize:11.f]
                              constrainedToSize:CGSizeMake(kScreenWidth-15.f-15,MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            height += size.height;
            height += 15;
        }
        
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(PublishSelectableItem*)item {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishSelectableTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellKeyForSelectableItem]];
    return dict;
}

+ (NSString*)cellKeyForSelectableItem {
    return @"selectableItem";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLbl = [[UIInsetLabel alloc] initWithFrame:CGRectNull andInsets:UIEdgeInsetsMake(0, 15, 0, 15+17)];
        _nameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _nameLbl.font = [UIFont systemFontOfSize:14.f];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLbl];
        
        _summaryLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _summaryLbl.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        _summaryLbl.font = [UIFont systemFontOfSize:11.f];
        _summaryLbl.textAlignment = NSTextAlignmentLeft;
        _summaryLbl.numberOfLines = 0;
        [self.contentView addSubview:_summaryLbl];
        
        
        _flagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_big"]];
        _flagView.hidden = YES;
        [self.contentView addSubview:_flagView];
        
        _rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow_gray"]];
        _rightArrowView.hidden = YES;
        [self.contentView addSubview:_rightArrowView];
        
        _middleLine = [CALayer layer];
        _middleLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_middleLine];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
    }
    return self;
}

+ (CGFloat)cellHeight
{
    return kScreenWidth*44.f/320.f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = [[self class] cellHeight];
    
    _nameLbl.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    _flagView.frame = CGRectMake(self.contentView.width-15-_flagView.width, (height-_flagView.height)/2, _flagView.width, _flagView.height);
    _rightArrowView.frame = CGRectMake(self.contentView.width-15-_rightArrowView.width, (height-_rightArrowView.height)/2, _rightArrowView.width, _rightArrowView.height);
    
    _middleLine.frame = CGRectMake(0, height-0.5, self.contentView.width, 0.5);
    
    _summaryLbl.frame = CGRectMake(15, 0, kScreenWidth-15.f-15, 0);
    [_summaryLbl sizeToFit];
    _summaryLbl.frame = CGRectMake(15, height+8, kScreenWidth-30, _summaryLbl.height);
    
    _bottomLine.frame = CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _nameLbl.frame = CGRectNull;
    _summaryLbl.hidden = YES;
    _flagView.hidden = YES;
    _rightArrowView.hidden = YES;
    _bottomLine.frame = CGRectNull;
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    
    PublishSelectableItem *selectableItem = [dict objectForKey:[[self class] cellKeyForSelectableItem]];
    if ([selectableItem isKindOfClass:[selectableItem class]]) {
        _selectableItem = selectableItem;
        _summaryLbl.text = selectableItem.summary;
        _nameLbl.text = selectableItem.title;
        if ([_summaryLbl.text length]>0) {
            _summaryLbl.hidden = NO;
            _middleLine.hidden = NO;
        } else {
            _summaryLbl.hidden = YES;
            _middleLine.hidden = YES;
        }
        _rightArrowView.hidden = !selectableItem.hasChildren;
        _flagView.hidden = !selectableItem.isSelected;
        [self setNeedsLayout];
    }
}

@end


@implementation PictureItemsEditViewForPublishGoods

- (void)addPics:(UIButton*)sender
{

    [super addPics:sender];
//取消之前选照片之前要先选商品类目要求
//    if (weakSelf.contentView.selectedCate || weakSelf.contentView.editableInfo.categoryId>0) {
//        [super addPics:sender];
//    } else {
//        
//        [WCAlertView showAlertWithTitle:@""
//                                message:@"请先选择商品类目"
//                     customizationBlock:^(WCAlertView *alertView) {
//                         alertView.style = WCAlertViewStyleWhite;
//                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                         [weakSelf.contentView pulishSelectCate:weakSelf.contentView.cateList];
//                     } cancelButtonTitle:@"确定" otherButtonTitles:nil];
//
//    }
}

- (void)handlePikeImageFromAlum:(NSInteger)tag
{
    [super handlePikeImageFromAlum:tag];
}

- (void)handlePikeImageFromCamera:(NSInteger)tag
{
    if (_handleAddPicActionBlock) {
        _handleAddPicActionBlock(tag);
    }
}
@end



@interface PublishGoodsMoreDetailView ()

@property(nonatomic,assign) PublishGoodsContentView *contentView;
@property(nonatomic,assign) GoodsEditableInfo *editableInfo;
@property(nonatomic,assign) BaseViewController *viewController;

@property(nonatomic,assign) CommandButton *tagsSelectorBtn;
@property(nonatomic,assign) CommandButton *fitPeopleBtn;

@property(nonatomic,weak) UIScrollView *scrollview;

@end

@implementation PublishGoodsMoreDetailView

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame contentView:(PublishGoodsContentView*)contentView {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.contentView = contentView;
        self.editableInfo = contentView.editableInfo;
        self.viewController = contentView.viewController;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        titleLbl.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.text = @"更多详细";
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor whiteColor];
        [self addSubview:titleLbl];
        
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 0)];
        [self addSubview:scrollview];
        _scrollview = scrollview;
        
        WEAKSELF;
        
        CGFloat height = 44;
        
        CGFloat marginTop = 0;
        
        contentView.tagsSelectorBtn = [self.contentView createSelectableButton:@"选择标签"];
        contentView.tagsSelectorBtn.frame = CGRectMake(0, marginTop, kScreenWidth, height);
        [_scrollview addSubview:contentView.tagsSelectorBtn];
        _tagsSelectorBtn = contentView.tagsSelectorBtn;
        
        marginTop += _tagsSelectorBtn.height;
        marginTop += 10;
        
        contentView.fitPeopleBtn = [self.contentView createSelectableButton:@"请选适用人群"];
        contentView.fitPeopleBtn.frame = CGRectMake(0, marginTop, kScreenWidth, height);
        [_scrollview addSubview:contentView.fitPeopleBtn];
        _fitPeopleBtn = contentView.fitPeopleBtn;
        
        marginTop += _fitPeopleBtn.height;
        marginTop += 10;
        
        NSMutableArray *attrBtnArray = [NSMutableArray noRetainingArray];
        for (AttrEditableInfo *attrEditableInfo in self.editableInfo.attrInfoList) {
            if (attrEditableInfo.type == kTYPE_TEXT_INPUT
                || attrEditableInfo.type == kTYPE_YES_OR_NO
                || attrEditableInfo.type == kTYPE_SELECT
                || attrEditableInfo.type == kTYPE_DATE) {
                CommandButton *btn = [self.contentView createAttrEditableButton:attrEditableInfo];
                btn.tag = 2000+attrEditableInfo.type;
                btn.frame = CGRectMake(0, marginTop, kScreenWidth, height);
                [_scrollview addSubview:btn];
                marginTop += [self.contentView editableButtonRealHeight:btn];
                marginTop += 1;
                [attrBtnArray addObject:btn];
                
                //
                //            UILabel *lbl = (UILabel*)[btn viewWithTag:100];
                //            lbl.text = attrEditableInfo.isMust?@"必填":@"";
                
                btn.handleClickBlock = ^(CommandButton *sender) {
                    if ([sender isKindOfClass:[AttrInfoEditButton class]]) {
                        AttrInfoEditButton *editButton = (AttrInfoEditButton*)sender;
                        [weakSelf.contentView publishSelectAttrEditInfo:editButton];
                    }
                };
            }
        }
        
        if ([attrBtnArray count]>0) {
            marginTop += 10.f;
        }
        
        _tagsSelectorBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf.contentView publishSelectTags:weakSelf.contentView.tagGroupList];
        };
        
        _fitPeopleBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf.contentView publishSelectFitPeople];
        };
        
        if (marginTop+40<2*kScreenHeight/5) {
            self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 2*kScreenHeight/5);
            _scrollview.frame = CGRectMake(0, 40, kScreenWidth, 2*kScreenHeight/5-40);
        } else {
            self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 2*kScreenHeight/3);
            _scrollview.frame = CGRectMake(0, 40, kScreenWidth, 2*kScreenHeight/3-40);
        }
        
        _scrollview.contentSize = CGSizeMake(kScreenWidth, marginTop);
        
        NSMutableString *str = [[NSMutableString alloc] init];
        for (TagVo *tagVo in _editableInfo.tagList) {
            if ([str length]>0) {
                [str appendString:@" "];
            }
            [str appendString:tagVo.tagName];
        }
        UILabel *tagsLbl = (UILabel*)[_tagsSelectorBtn viewWithTag:100];
        tagsLbl.text = str;
        
        UILabel *lblFitPeople = (UILabel*)[_fitPeopleBtn viewWithTag:100];
        lblFitPeople.text = [GoodsEditableInfo fitPeopleString:_editableInfo.fitPeople];
    }
    return self;
}

- (void)dismiss {
    UIView *view = self.superview;
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

+ (void)showInView:(PublishGoodsContentView*)contentView {
    UIView *view = [contentView superview];
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [view addSubview:bgView];
    
    
    PublishGoodsMoreDetailView *moreDetailView = [[PublishGoodsMoreDetailView alloc] initWithFrame:CGRectZero contentView:contentView];
    moreDetailView.tag = 100;
    [bgView addSubview:moreDetailView];
    moreDetailView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, moreDetailView.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        moreDetailView.frame = CGRectMake(0, kScreenHeight-moreDetailView.height, kScreenWidth, moreDetailView.height);
    } completion:^(BOOL finished) {
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        PublishGoodsMoreDetailView *detailView = (PublishGoodsMoreDetailView*)[view viewWithTag:100];
        [detailView dismiss];
    };
}

@end

@interface PriceView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *buyLB;
@property (nonatomic, strong) UILabel *sellLB;
@property (nonatomic, strong) UIView *bgLineView;

@end

@implementation PriceView

- (UITextField *)buyPriceFD {
    if (!_buyPriceFD) {
        _buyPriceFD = [[UITextField alloc] initWithFrame:CGRectZero];
        _buyPriceFD.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _buyPriceFD.font = [UIFont systemFontOfSize:15.f];
        _buyPriceFD.textColor = [UIColor colorWithHexString:@"8e8e93"];
        _buyPriceFD.textAlignment = NSTextAlignmentCenter;
        _buyPriceFD.keyboardType = UIKeyboardTypeDecimalPad;
        
        _buyPriceFD.delegate = self;
        _buyPriceFD.userInteractionEnabled = NO;
    }
    return _buyPriceFD;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (UITextField *)sellPriceFD {
    if (!_sellPriceFD) {
        _sellPriceFD = [[UITextField alloc] initWithFrame:CGRectZero];
        _sellPriceFD.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _sellPriceFD.font = [UIFont systemFontOfSize:15.f];
        _sellPriceFD.textColor = [UIColor colorWithHexString:@"8e8e93"];
        _sellPriceFD.textAlignment = NSTextAlignmentCenter;
        _sellPriceFD.keyboardType = UIKeyboardTypeDecimalPad;
        _sellPriceFD.userInteractionEnabled = NO;
    }
    return _sellPriceFD;
}

- (UILabel *)buyLB {
    if (!_buyLB) {
        _buyLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _buyLB.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        _buyLB.text = @"买入价";
        _buyLB.font = [UIFont systemFontOfSize:15.f];
        [_buyLB sizeToFit];
    }
    return _buyLB;
}

- (UILabel *)sellLB {
    if (!_sellLB) {
        _sellLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _sellLB.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        _sellLB.text = @"出售价";
        _sellLB.font = [UIFont systemFontOfSize:15.f];
        [_sellLB sizeToFit];
    }
    return _sellLB;
}

- (UIView *)bgLineView {
    if (!_bgLineView) {
        _bgLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgLineView.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        
    }
    return _bgLineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buyPriceFD];
        [self addSubview:self.sellPriceFD];
        [self addSubview:self.buyLB];
        [self addSubview:self.sellLB];
        [self addSubview:self.bgLineView];
        [self setupPriceViewUI];
    }
    return self;
}

- (void)setupPriceViewUI {
    [self.buyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(18);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@15);
    }];
    [self.sellLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth / 2. + 45.f / 2));
        make.top.equalTo(self.mas_top).offset(18);
        make.height.equalTo(@15);
    }];
    [self.buyPriceFD mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(40);
        make.top.equalTo(self.buyLB.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@((kScreenWidth - 45 - 30) / 2.));
        make.height.equalTo(@33);
    }];
    [self.sellPriceFD mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(40);
        make.top.equalTo(self.buyLB.mas_bottom).offset(8);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(self.buyPriceFD);
        make.height.equalTo(self.buyPriceFD);
    }];
    [self.bgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
}

@end

//成色
@interface ColourView ()

@property (nonatomic, strong) UILabel *titleLB;



@property (nonatomic, strong) UIView *bgLineView;

@end

@implementation ColourView

- (instancetype)initWithFrame:(CGRect)frame andSelectArr:(NSArray *)arr {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _titleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLB.font = [UIFont systemFontOfSize:15.f];
        _titleLB.text = @"成色";
        _titleLB.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        [_titleLB sizeToFit];
        
        _btnLeftLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _btnLeftLB.textColor = [UIColor colorWithHexString:@"8e8e93"];
        _btnLeftLB.font = [UIFont systemFontOfSize:15.f];
        _btnLeftLB.text = @"请选择";
        [_btnLeftLB sizeToFit];
        
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setImage:[UIImage imageNamed:@"colourShow"] forState:UIControlStateNormal];
        [_showBtn sizeToFit];
        
        _selectSubView = [[ColourSubView alloc] initWithFrame:CGRectZero andArr:arr];
//        [_selectSubView updateWithArr:[arr copy]];
        _selectSubView.hidden = YES;
        _selectSubView.alpha = 0.f;
        
        _bgLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgLineView.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        
        [self addSubview:_titleLB];
        [self addSubview:_btnLeftLB];
        [self addSubview:_showBtn];
        [self addSubview:_selectSubView];
        [self addSubview:_bgLineView];
        
        [self setupColourUI];
    }
    return self;
}

- (void)setupColourUI {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    [self.btnLeftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showBtn.mas_left).offset(-8);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB);
        make.right.equalTo(self.mas_right).offset(-15);
        
    }];
//    if (_isShow) {
        [self.selectSubView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(45);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(171 - 45));
        }];
//    }
    
    [self.bgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    self.selectSubView.hidden = !isShow;
    [UIView animateWithDuration:0.25f animations:^{
        if (isShow) {
            self.selectSubView.alpha = 1.f;
        } else {
            self.selectSubView.alpha = 0.f;
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end
//成色选择
@interface ColourSubView ()

@property (nonatomic, strong) UILabel *subTitleLB;
@property (nonatomic, assign) NSInteger selectBtnTag;

@property (nonatomic, strong) NSArray *array;

@end
@implementation ColourSubView

- (instancetype)initWithFrame:(CGRect)frame andArr:(NSArray *)arr {
    if (self = [super initWithFrame:frame]) {
        
        self.array = arr;
        
        _subTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(17, 54 - 45, 0, 0)];
        _subTitleLB.text = @"商品成色";
        _subTitleLB.textColor = [UIColor colorWithHexString:@"8e8e93"];
        _subTitleLB.font = [UIFont systemFontOfSize:15.f];
        [_subTitleLB sizeToFit];
        
        self.selectBtnTag = -1;
        
        [self addSubview:_subTitleLB];
        CGFloat margin = 84 - 45 -45; //因为margin第一次会加45
        
        for (NSInteger i = 0; i < arr.count; i++) {
            if (i % 4 == 0) {
                margin += 45;
            }
            CGFloat index = 0;
            index = 18 + (i % 4) * (((kScreenWidth - 45 - 36) / 4.f) + 15);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(index, margin, (kScreenWidth - (36+45))/4, 25)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            btn.layer.cornerRadius = 4;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithHexString:@"b3b3b3"].CGColor;
            
            btn.tag = 10000 + i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.clipsToBounds = YES;
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"150c0f"]] forState:UIControlStateSelected];
            
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)btnAction:(UIButton *)btn {
    
    for (NSInteger i = 0; i < self.array.count; i++) {
        UIButton *btn = [self viewWithTag:i + 10000];
        if (btn.isSelected) {
            self.selectBtnTag = btn.tag;
        }
    }
    
    [btn setSelected:!btn.isSelected];
    
    if (self.selectBtnTag == btn.tag) {
        self.selectBtnTag = -1;
    } else {
        if (self.selectBtnTag != -1) {
            UIButton *btn1 = (UIButton *)[self viewWithTag:self.selectBtnTag];
            [btn1 setSelected:NO];
        }
    }
    
    for (NSInteger i = 0; i < self.array.count; i++) {
        UIButton *btn = [self viewWithTag:i + 10000];
        if (btn.isSelected) {
            self.selectBtnTag = btn.tag;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectColourBtnWithTag:)]) {
        [self.delegate didSelectColourBtnWithTag:self.selectBtnTag - 10000];
    } else {
        NSLog(@"代理方法未响应");
    }
}

@end


//渠道来源
@interface SourceSubView ()
@property (nonatomic, strong) UILabel *subTitleOneLB;
@property (nonatomic, strong) UILabel *subTitleTwoLB;

@property (nonatomic, assign) NSInteger selectBtnTag;
@property (nonatomic, assign) NSInteger selectFirstBtnTag;
@property (nonatomic, assign) NSInteger selectSecondBtnTag;

@property (nonatomic, strong) pulishSourceModel *model1;
@property (nonatomic, strong) pulishSourceModel *model2;

@end

@implementation SourceSubView

- (instancetype)initWithFrame:(CGRect)frame andSourceDic:(NSDictionary *)dic {
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor orangeColor];
        self.model1 = [dic objectForKey:@"first"];
        self.model2 = [dic objectForKey:@"second"];
        
        self.alpha = 0;
        
        _subTitleOneLB = [[UILabel alloc] initWithFrame:CGRectMake(17, 9, 0, 0)];
        _subTitleOneLB.text = @"购入地";
        _subTitleOneLB.textColor = [UIColor colorWithHexString:@"8e8e93"];
        _subTitleOneLB.font = [UIFont systemFontOfSize:15.f];
        [_subTitleOneLB sizeToFit];
        
        NSInteger n = (self.model1.list.count % 4) == 0 ? self.model1.list.count / 4 : self.model1.list.count / 4 + 1;
        CGFloat height = height = 82 - 45 + n * 40 + 5;
        _subTitleTwoLB = [[UILabel alloc] initWithFrame:CGRectMake(17, height, 0, 0)];
        _subTitleTwoLB.text = @"渠道";
        _subTitleTwoLB.textColor = [UIColor colorWithHexString:@"8e8e93"];
        _subTitleTwoLB.font = [UIFont systemFontOfSize:15.f];
        [_subTitleTwoLB sizeToFit];
        
        [self addSubview:_subTitleOneLB];
        [self addSubview:_subTitleTwoLB];
        
        CGFloat margin = 82 - 45 - 40; //因为margin第一次会加45
        for (NSInteger i = 0; i < ((pulishSourceModel *)([dic objectForKey:@"first"])).list.count; i++) {
            if (i % 4 == 0) {
                margin += 40;
            }
            CGFloat index = 0;
            index = 18 + (i % 4) * (((kScreenWidth - 45 - 36) / 4.f) + 15);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(index, margin, (kScreenWidth - (36+45))/4, 25)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            btn.layer.cornerRadius = 4;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithHexString:@"b3b3b3"].CGColor;
            
            btn.tag = 10000 + i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:self.model1.list[i] forState:UIControlStateNormal];
            [btn setClipsToBounds:YES];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"150c0f"]] forState:UIControlStateSelected];
            
            [self addSubview:btn];
        }
        
        margin = 35 + margin;
        for (NSInteger i = 0; i < ((pulishSourceModel *)([dic objectForKey:@"second"])).list.count; i++) {
            if (i % 4 == 0) {
                margin += 40;
            }
            CGFloat index = 0;
            index = 18 + (i % 4) * (((kScreenWidth - 45 - 36) / 4.f) + 15);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(index, margin, (kScreenWidth - (36+45))/4, 25)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            btn.layer.cornerRadius = 4;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithHexString:@"b3b3b3"].CGColor;
            
            btn.tag = 20000 + i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:self.model2.list[i] forState:UIControlStateNormal];
            [btn setClipsToBounds:YES];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"150c0f"]] forState:UIControlStateSelected];
            
            [self addSubview:btn];
        }
        self.selectFirstBtnTag = -1;
        self.selectSecondBtnTag = -1;
        
    }
    return self;
}

- (void)btnAction:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    NSLog(@"btntag:%ld", btn.tag);
    if (btn.tag < 20000) {
        if (self.selectFirstBtnTag == btn.tag) {
            self.selectFirstBtnTag = -1;
        } else {
            if (self.selectFirstBtnTag != -1) {
                UIButton *btn1 = (UIButton *)[self viewWithTag:self.selectFirstBtnTag];
                [btn1 setSelected:NO];
            }
        }
    } else {
        if (self.selectSecondBtnTag == btn.tag) {
            self.selectSecondBtnTag = -1;
        } else {
            if (self.selectSecondBtnTag != -1) {
                UIButton *btn1 = (UIButton *)[self viewWithTag:self.selectSecondBtnTag];
                [btn1 setSelected:NO];
            }
        }
        
    }
    
    for (NSInteger i = 0; i < self.model1.list.count; i++) {
        UIButton *btn = [self viewWithTag:i + 10000];
        if (btn.isSelected) {
            self.selectFirstBtnTag = i + 10000;
        }
    }
    
    for (NSInteger i = 0; i < self.model2.list.count; i++) {
        UIButton *btn = [self viewWithTag:i + 20000];
        if (btn.isSelected) {
            self.selectSecondBtnTag = i + 20000;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSourceViewWithBtn1Tag:andBtn2Tag:)]) {
        [self.delegate didSelectSourceViewWithBtn1Tag:self.selectFirstBtnTag - 10000 andBtn2Tag:self.selectSecondBtnTag - 20000];
    }
}


@end

@interface SourceView ()
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIView *bgLineView;
@property (nonatomic, strong) NSDictionary *sourceDic;
@end

@implementation SourceView

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLB.font = [UIFont systemFontOfSize:15.f];
        _titleLB.textColor = [UIColor colorWithHexString:@"4c4c4c"];
        _titleLB.text = @"渠道来源";
    }
    return _titleLB;
}

- (UILabel *)btnLeftLB {
    if (!_btnLeftLB) {
        _btnLeftLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _btnLeftLB.font = [UIFont systemFontOfSize:15.f];
        _btnLeftLB.textColor = [UIColor colorWithHexString:@"8e8e93"];
        _btnLeftLB.text = @"请选择";
        
    }
    return _btnLeftLB;
}

- (UIButton *)showBtn {
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setImage:[UIImage imageNamed:@"colourShow"] forState:UIControlStateNormal];
        [_showBtn sizeToFit];
    }
    return _showBtn;
}

- (UIView *)bgLineView {
    if (!_bgLineView) {
        _bgLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgLineView.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
    }
    return _bgLineView;
}

- (instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic {
    if (self = [super initWithFrame:frame]) {
        self.sourceDic = dic;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLB];
        [self addSubview:self.btnLeftLB];
        [self addSubview:self.showBtn];
        [self addSubview:self.bgLineView];
        
        
        self.selectSubView = [[SourceSubView alloc] initWithFrame:CGRectZero andSourceDic:dic];
        
        [self addSubview:self.selectSubView];
        self.selectSubView.hidden = YES;
        
        [self setupSourceUI];
    }
    return self;
}

- (void)setupSourceUI {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    [self.btnLeftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showBtn.mas_left).offset(-8);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB);
        make.right.equalTo(self.mas_right).offset(-15);
        
    }];
    [self.selectSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(45);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        
        CGFloat firstHeight = ((NSInteger)(((pulishSourceModel *)([self.sourceDic objectForKey:@"first"])).list.count % 4)) == 0 ? ((NSInteger)(((pulishSourceModel *)([self.sourceDic objectForKey:@"first"])).list.count / 4)) * 40 : ((NSInteger)(((pulishSourceModel *)([self.sourceDic objectForKey:@"first"])).list.count / 4) + 1) * 40;
        CGFloat secondHeight = ((NSInteger)(((pulishSourceModel *)([self.sourceDic objectForKey:@"second"])).list.count % 4)) == 0 ? ((NSInteger)(((pulishSourceModel *)([self.sourceDic objectForKey:@"second"])).list.count / 4)) * 40 : ((NSInteger)(((pulishSourceModel *)([self.sourceDic objectForKey:@"second"])).list.count / 4) + 1) * 40;
        
        CGFloat height = 82 - 45 + firstHeight + 35 + secondHeight + 7;
        
        make.height.equalTo(@(height));
    }];
    
    [self.bgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    self.selectSubView.hidden = !isShow;
    [UIView animateWithDuration:0.25f animations:^{
        if (isShow) {
            self.selectSubView.alpha = 1.0f;
        } else {
            self.selectSubView.alpha = 0.f;
        }
    } completion:^(BOOL finished) {
        
    }];
}
@end

@implementation SegView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return self;
}

@end

