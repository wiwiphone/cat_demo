//
//  SaleViewController.m
//  XianMao
//
//  Created by simon cai on 11/10/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SaleViewController.h"
#import "WebViewController.h"


@interface SaleViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *bottomView;

@end

@implementation SaleViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"卖东西"];
    [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    CGRect frame = self.topView.frame;
    frame.origin.y = 0;
    self.topView.frame = frame;
    [self.view addSubview:self.topView];
    
    
    
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
//    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    scrollView.userInteractionEnabled = YES;
//    [self.view addSubview:scrollView];
//    
//    
//    CGFloat redLayerHeight = 205.f;
//    
//    CALayer *redLayer = [CALayer layer];
//    redLayer.backgroundColor = [UIColor colorWithHexString:@"ed3b43"].CGColor;
//    redLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, redLayerHeight);
//    [scrollView.layer addSublayer:redLayer];
//    
//    UIButton *saleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
//    [saleBtn setTitle:@"我要寄售" forState:UIControlStateNormal];
//    [saleBtn setTitleColor:[UIColor colorWithHexString:@"ed3b43"] forState:UIControlStateNormal];
//    saleBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
//    saleBtn.backgroundColor = [UIColor whiteColor];
//    saleBtn.frame = CGRectMake(20, redLayerHeight-24.f-60.f, scrollView.bounds.size.width-40, 60.f);
//    saleBtn.layer.masksToBounds=YES;
//    saleBtn.layer.cornerRadius=5;
//    [saleBtn addTarget:self action:@selector(consign:) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:saleBtn];
//    
//    CGFloat marginTop = 0.f;
//    marginTop += 33.f;
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLbl.font = [UIFont systemFontOfSize:12.f];
//    titleLbl.textColor = [UIColor colorWithHexString:@"ff9ca0"];
//    titleLbl.text = @"两步完成商品寄售，在家坐等收钱";
//    [titleLbl sizeToFit];
//    titleLbl.frame = CGRectMake(20, marginTop, scrollView.bounds.size.width, titleLbl.bounds.size.height);
//    [scrollView addSubview:titleLbl];
//    
//    marginTop += titleLbl.bounds.size.height;
//    marginTop += 10.f;
//    
//    UIButton *stepBtnLbl = [self createBtnLbl:[UIImage imageNamed:@"sale_step_1"]
//                                         title:@"选择商品类目"
//                                    titleColor:[UIColor whiteColor]
//                                          font:[UIFont systemFontOfSize:13.f]];
//    [stepBtnLbl sizeToFit];
//    stepBtnLbl.frame = CGRectMake(20, marginTop, scrollView.bounds.size.width, stepBtnLbl.bounds.size.height);
//    [scrollView addSubview:stepBtnLbl];
//    
//    marginTop += stepBtnLbl.bounds.size.height;
//    marginTop += 8.f;
//    
//    stepBtnLbl = [self createBtnLbl:[UIImage imageNamed:@"sale_step_2"]
//                              title:@"寄出商品"
//                         titleColor:[UIColor whiteColor]
//                               font:[UIFont systemFontOfSize:13.f]];
//    [stepBtnLbl sizeToFit];
//    stepBtnLbl.frame = CGRectMake(20, marginTop, scrollView.bounds.size.width, stepBtnLbl.bounds.size.height);
//    [scrollView addSubview:stepBtnLbl];
//    
//    
//    marginTop = redLayerHeight;
//    
//    marginTop += 40.f;
//    
//    NSArray *saleFaqs = [self saleFaqs];
//    for (int i=0;i<[saleFaqs count];i++) {
//        NSDictionary *dict = [saleFaqs objectAtIndex:i];
//        UIButton *faqBtnLbl = [self createBtnLbl:[dict objectForKey:@"icon"]
//                                           title:[dict objectForKey:@"title"]
//                                      titleColor:[UIColor colorWithHexString:@"333333"]
//                                            font:[UIFont systemFontOfSize:12.f]];
//        [faqBtnLbl sizeToFit];
//        faqBtnLbl.frame = CGRectMake(50, marginTop, scrollView.bounds.size.width, faqBtnLbl.bounds.size.height);
//        [scrollView addSubview:faqBtnLbl];
//        
//        marginTop += faqBtnLbl.bounds.size.height;
//        marginTop += 8.f;
//    }
//    
//    
//    
//    UIButton *faqBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-170)/2, marginTop, 170, 30)];
//    [faqBtn setTitle:@"查看更多寄卖FAQ" forState:UIControlStateNormal];
//    [faqBtn setTitleColor:[UIColor colorWithHexString:@"FF5858"] forState:UIControlStateNormal];
//    [faqBtn addTarget:self action:@selector(moreFaqs:) forControlEvents:UIControlEventTouchUpInside];
//    faqBtn.backgroundColor = [UIColor whiteColor];
//    faqBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
////    faqBtn.layer.borderWidth = 1.f;
////    faqBtn.layer.borderColor = [UIColor colorWithHexString:@"ff5858"].CGColor;
//    faqBtn.layer.masksToBounds=YES;
//    faqBtn.layer.cornerRadius=5;
//    [scrollView addSubview:faqBtn];
//    
//    
//    if (marginTop+32+faqBtn.bounds.size.height+32>scrollView.bounds.size.height) {
//        marginTop += 32;
//        faqBtn.frame = CGRectMake(faqBtn.frame.origin.x, marginTop, faqBtn.bounds.size.width, faqBtn.bounds.size.height);
//        marginTop += faqBtn.bounds.size.height;
//        marginTop += 32;
//        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, marginTop);
//    } else {
//        marginTop = scrollView.bounds.size.height-32-faqBtn.bounds.size.height;
//        faqBtn.frame = CGRectMake(faqBtn.frame.origin.x, marginTop, faqBtn.bounds.size.width, faqBtn.bounds.size.height);
//    }
}

- (void)dealloc
{
    
}

- (UIView*)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        
        CGFloat marginTop = 0.f;
        
        UIView *stepView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, _topView.bounds.size.width, 45.f)];
        stepView.backgroundColor = [UIColor colorWithHexString:@"392426"];
        [_topView addSubview:stepView];
        
        marginTop += stepView.bounds.size.height;
        
        
        _topView.frame = CGRectMake(0, marginTop, self.view.bounds.size.width, marginTop);
    }
    return _topView;
}

- (NSArray*)saleFaqs
{
    UIImage *iconYes = [UIImage imageNamed:@"sale_faq_icon_yes"];
    UIImage *iconNo = [UIImage imageNamed:@"sale_faq_icon_no"];
    NSMutableArray *faqs = [[NSMutableArray alloc] init];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"箱包、腕表、手饰、服装、配饰",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"商品无瑕疵，看起来几乎全新",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"干净没有异味的商品",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"过去5年之内的款式",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"脏的、损坏了的或者破旧的商品",@"title",iconNo,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"其他任何类目的商品",@"title",iconNo,@"icon",nil]];
    return faqs;
}

- (UIButton*)createBtnLbl:(UIImage*)icon title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font {
    UIButton *btnLbl = [[UIButton alloc] initWithFrame:CGRectZero];
    [btnLbl setImage:icon forState:UIControlStateDisabled];
    [btnLbl setTitle:title forState:UIControlStateDisabled];
    [btnLbl setTitleEdgeInsets: UIEdgeInsetsMake(0, 5, 0, 0)];
    btnLbl.titleLabel.font = font;
    [btnLbl setTitleColor:titleColor forState:UIControlStateNormal];
    btnLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnLbl.enabled = NO;
    return btnLbl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)consign:(UIButton*)sender {
    SaleCateViewController *viewController = [[SaleCateViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)moreFaqs:(UIButton*)sender {
    WebViewController *viewController = [[WebViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
//    [super pushViewController:viewController animated:YES];
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    [super dismiss];
}

@end


@interface SaleCateViewController ()
@property(nonatomic,retain) NSArray *cateItems;
@property(nonatomic,retain) UIButton *nextBtn;
@end

@implementation SaleCateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"卖东西"];
    [super setupTopBarBackButton];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    
    CGFloat marginTop = 0.f;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
    titleLbl.text = @"我要卖得是:";
    titleLbl.font = [UIFont systemFontOfSize:13.f];
    [titleLbl sizeToFit];
    titleLbl.frame = CGRectMake(19, marginTop, titleLbl.bounds.size.width, 45);
    [scrollView addSubview:titleLbl];
    
    self.cateItems = [self createCateItems];
    
    marginTop += titleLbl.bounds.size.height;
    marginTop -= 15.f;
    
    for (int i=0;i<[self.cateItems count];i++) {
        marginTop += 15.f;
        UIButton *cateBtn = [self.cateItems objectAtIndex:i];
        cateBtn.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, 50);
        [cateBtn addTarget:self action:@selector(cateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:cateBtn];
        marginTop += cateBtn.bounds.size.height;
    }
    
    
    _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-170)/2, marginTop, 170, 40)];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _nextBtn.layer.borderWidth = 1.f;
    _nextBtn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
    _nextBtn.layer.masksToBounds=YES;
    _nextBtn.layer.cornerRadius=5;
    [scrollView addSubview:_nextBtn];
    
    if (marginTop+32+_nextBtn.bounds.size.height+32>scrollView.bounds.size.height) {
        marginTop += 32;
        _nextBtn.frame = CGRectMake(_nextBtn.frame.origin.x, marginTop, _nextBtn.bounds.size.width, _nextBtn.bounds.size.height);
        marginTop += _nextBtn.bounds.size.height;
        marginTop += 32;
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, marginTop);
    } else {
        marginTop = scrollView.bounds.size.height-32-_nextBtn.bounds.size.height;
        _nextBtn.frame = CGRectMake(_nextBtn.frame.origin.x, marginTop, _nextBtn.bounds.size.width, _nextBtn.bounds.size.height);
    }
}

- (NSArray*)createCateItems
{
    UIImage *selectedIcon = [UIImage imageNamed:@"sale_cate_selected"];
    UIImage *unselectIcon = [UIImage imageNamed:@"sale_cate_unselect"];
    
    UIImage *selectedBtnBg = [UIImage imageWithColor:[UIColor colorWithHexString:@"7fd000"]];
    UIImage *unselectBtnBg = [UIImage imageWithColor:[UIColor whiteColor]];
    
    UIColor *selectedTextColor = [UIColor whiteColor];
    UIColor *unselectTextColor = [UIColor colorWithHexString:@"181818"];
    
    NSArray *cateTitles = [NSArray arrayWithObjects:@"服饰",@"箱包", @"美妆",@"配饰",@"鞋子",nil];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[cateTitles count];i++) {
        NSString *title = [cateTitles objectAtIndex:i];
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [cateBtn setBackgroundImage:[unselectBtnBg stretchableImageWithLeftCapWidth:unselectBtnBg.size.width/2 topCapHeight:unselectBtnBg.size.height/2] forState:UIControlStateNormal];
        [cateBtn setBackgroundImage:[selectedBtnBg stretchableImageWithLeftCapWidth:selectedBtnBg.size.width/2 topCapHeight:selectedBtnBg.size.height/2] forState:UIControlStateSelected];
        
        [cateBtn setTitleColor:unselectTextColor forState:UIControlStateNormal];
        [cateBtn setTitleColor:selectedTextColor forState:UIControlStateSelected];
        
        [cateBtn setImage:unselectIcon forState:UIControlStateNormal];
        [cateBtn setImage:selectedIcon forState:UIControlStateSelected];
        
        [cateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -unselectIcon.size.width, 0.0, 0.0)];
        [cateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.view.bounds.size.width-20-unselectIcon.size.width, 0, 0)];
        
        [cateBtn setTitle:title forState:UIControlStateNormal];
        
        [items addObject:cateBtn];
    }
    
    return items;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)cateBtnClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
    BOOL cateSelected = NO;
    
    for (int i=0;i<[self.cateItems count];i++) {
        UIButton *cateBtn = [self.cateItems objectAtIndex:i];
        if ([cateBtn isSelected]) {
            cateSelected = YES;
        }
    }
    
    _nextBtn.enabled = cateSelected;
    if ([_nextBtn isEnabled]) {
        [_nextBtn setTitleColor:[UIColor colorWithHexString:@"FF5858"] forState:UIControlStateNormal];
        _nextBtn.layer.borderColor = [UIColor colorWithHexString:@"FF5858"].CGColor;
    } else {
        [_nextBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
        _nextBtn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
    }
}

- (void)next:(UIButton*)sender
{
    SaleWayViewController *viewController = [[SaleWayViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end


@implementation SaleWayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"卖东西"];
    [super setupTopBarBackButton];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    UIFont *titleLblFont = [UIFont systemFontOfSize:13.f];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLbl.font = [UIFont systemFontOfSize:13.f];
    titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
    titleLbl.numberOfLines = 0;
    titleLbl.text = @"爱丁猫将寄给你一个专属的寄售袋和回程快递单，你只要将商品放入袋子，贴上快递单就可以将商品寄出。";
    CGSize titleLblSize = [titleLbl.text sizeWithFont:titleLblFont
                                     constrainedToSize:CGSizeMake(scrollView.bounds.size.width-69,MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];

    titleLbl.frame = CGRectMake((scrollView.bounds.size.width-titleLblSize.width)/2, 32, titleLblSize.width, titleLblSize.height);
    [scrollView addSubview:titleLbl];
    
    CGFloat btnWidth = 240.f;
    CGFloat btnHeight = 50.f;
    
    CGFloat marginTop = (scrollView.bounds.size.height-2*btnHeight-20)/2;
    
    UIImage *saleBtnBg = [UIImage imageNamed:@"sale_btn_bg"];
    UIButton *bagBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-btnWidth)/2, marginTop, btnWidth, btnHeight)];
    [bagBtn addTarget:self action:@selector(bagBtnCicked:) forControlEvents:UIControlEventTouchUpInside];
    [bagBtn setTitle:@"我要专属寄售袋" forState:UIControlStateNormal];
    [bagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bagBtn setBackgroundImage:[saleBtnBg stretchableImageWithLeftCapWidth:saleBtnBg.size.width/2 topCapHeight:saleBtnBg.size.height/2] forState:UIControlStateNormal];
    bagBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:bagBtn];
    
    marginTop += btnHeight;
    marginTop += 20.f;
    
    UIButton *adressBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-btnWidth)/2, marginTop, btnWidth, btnHeight)];
    adressBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    adressBtn.titleLabel.numberOfLines = 0;
    adressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [adressBtn setTitle:@"告诉我地址，\n我直接把商品寄给你们" forState:UIControlStateNormal];
    [adressBtn setTitleColor:[UIColor colorWithHexString:@"ff5858"] forState:UIControlStateNormal];
    [adressBtn addTarget:self action:@selector(adressBtnCicked:) forControlEvents:UIControlEventTouchUpInside];
    adressBtn.layer.borderWidth = 1.f;
    adressBtn.layer.borderColor = [UIColor colorWithHexString:@"ff5858"].CGColor;
    adressBtn.layer.masksToBounds=YES;
    adressBtn.layer.cornerRadius=5;
    [scrollView addSubview:adressBtn];
    
    scrollView.alwaysBounceVertical = YES;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)bagBtnCicked:(UIButton*)sender
{
    SaleSubmitAddressViewController *viewController = [[SaleSubmitAddressViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)adressBtnCicked:(UIButton*)sender
{
    SaleMailAddressViewController *viewController = [[SaleMailAddressViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];

}

@end

@interface SaleSubmitAddressViewController () <UITextFieldDelegate>
@property(nonatomic,retain) UIView *addressEditView;
@property(nonatomic,retain) UIView *addressSubmitedView;

@property(nonatomic,retain) UITextField *zipcodeFiled;
@property(nonatomic,retain) UITextField *cityFiled;
@property(nonatomic,retain) UITextField *addressFiled;
@end

@implementation SaleSubmitAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"卖东西"];
    [super setupTopBarBackButton];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    
    self.addressEditView = [self setupAddressEditView:topBarHeight];
    self.addressSubmitedView = [self setupAddressSubmitedView:topBarHeight];
    self.addressSubmitedView.hidden = YES;
    
    [self.view addSubview:self.addressEditView];
    [self.view addSubview:self.addressSubmitedView];
}

- (UIView*)setupAddressEditView:(CGFloat)topBarHeight
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    scrollView.userInteractionEnabled = YES;
    scrollView.alwaysBounceVertical = YES;
    
    
    CGFloat marginLeft = 30.f;
    CGFloat width = scrollView.bounds.size.width-60.f;
    CGFloat height = 44.f;
    
    CGFloat marginTop = 0.f;
    marginTop += 10.f;
    
    UIEdgeInsets lblInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    UILabel *nickNameLbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(marginLeft, marginTop, width, height) andInsets:lblInsets];
    nickNameLbl.font = [UIFont systemFontOfSize:13.f];
    nickNameLbl.textColor = [UIColor colorWithHexString:@"181818"];
    nickNameLbl.text = @"小美";
    [nickNameLbl.layer addSublayer:[self createBottomLineLayer:width height:height]];
    [scrollView addSubview:nickNameLbl];
    
    marginTop += height;
    
    UILabel *phoneLbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(marginLeft, marginTop, width, height) andInsets:lblInsets];
    phoneLbl.font = [UIFont systemFontOfSize:13.f];
    phoneLbl.textColor = [UIColor colorWithHexString:@"181818"];
    phoneLbl.text = @"13515819812";
    [phoneLbl.layer addSublayer:[self createBottomLineLayer:width height:height]];
    [scrollView addSubview:phoneLbl];
    
    marginTop += height;
    
    _zipcodeFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(marginLeft, marginTop, width, height) rectInsetDX:10 rectInsetDY:0];
    _zipcodeFiled.delegate = self;
    _zipcodeFiled.font = [UIFont systemFontOfSize:13.f];
    _zipcodeFiled.textColor = [UIColor colorWithHexString:@"181818"];
    _zipcodeFiled.placeholder = @"邮政编码";
    _zipcodeFiled.returnKeyType = UIReturnKeyNext;
    _zipcodeFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _zipcodeFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_zipcodeFiled.layer addSublayer:[self createBottomLineLayer:width height:height]];
    [scrollView addSubview:_zipcodeFiled];
    
    marginTop += height;
    
    _cityFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(marginLeft, marginTop, width, height) rectInsetDX:10 rectInsetDY:0];
    _cityFiled.delegate = self;
    _cityFiled.font = [UIFont systemFontOfSize:13.f];
    _cityFiled.textColor = [UIColor colorWithHexString:@"181818"];
    _cityFiled.placeholder = @"省、市、区";
    _cityFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _cityFiled.returnKeyType = UIReturnKeyNext;
    [_cityFiled.layer addSublayer:[self createBottomLineLayer:width height:height]];
    [scrollView addSubview:_cityFiled];
    
    marginTop += height;
    
    _addressFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(marginLeft, marginTop, width, height) rectInsetDX:10 rectInsetDY:0];
    _addressFiled.delegate = self;
    _addressFiled.font = [UIFont systemFontOfSize:13.f];
    _addressFiled.textColor = [UIColor colorWithHexString:@"181818"];
    _addressFiled.placeholder = @"详细地址";
    _addressFiled.returnKeyType = UIReturnKeyDone;
    _addressFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_addressFiled.layer addSublayer:[self createBottomLineLayer:width height:height]];
    [scrollView addSubview:_addressFiled];
    
    marginTop += height;
    marginTop += 42;
    
    UIButton *adressBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-170)/2, marginTop, 170, 40)];
    adressBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    adressBtn.titleLabel.numberOfLines = 0;
    adressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [adressBtn setTitle:@"提交" forState:UIControlStateNormal];
    [adressBtn setTitleColor:[UIColor colorWithHexString:@"ff5858"] forState:UIControlStateNormal];
    [adressBtn addTarget:self action:@selector(sumbitAddress:) forControlEvents:UIControlEventTouchUpInside];
    adressBtn.layer.borderWidth = 1.f;
    adressBtn.layer.borderColor = [UIColor colorWithHexString:@"ff5858"].CGColor;
    adressBtn.layer.masksToBounds=YES;
    adressBtn.layer.cornerRadius=5;
    [scrollView addSubview:adressBtn];
    
    marginTop += 42;
    
    if (scrollView.bounds.size.height<marginTop) {
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, marginTop);
    }

    return scrollView;
}

- (CALayer*)createBottomLineLayer:(CGFloat)width height:(CGFloat)height
{
    CALayer *bottomLineLayer = [CALayer layer];
    bottomLineLayer.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    bottomLineLayer.frame = CGRectMake(0, height-1, width, 1);
    return bottomLineLayer;
}

- (void)sumbitAddress:(UIButton*)sender
{
    self.addressEditView.hidden = YES;
    self.addressSubmitedView.hidden = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _zipcodeFiled) {
#define NUMBERS @"0123456789\n"
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest) {
            return NO;
        }
    }
    
    if (textField == _zipcodeFiled || textField == _cityFiled || textField == _addressFiled) {
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _zipcodeFiled) {
        [_cityFiled becomeFirstResponder];
    } else if (textField == _cityFiled) {
        [_addressFiled becomeFirstResponder];
    } else {
        UIView *firstResponder = [self.view findFirstResponder];
        [firstResponder resignFirstResponder];
    }
    return YES;
}

- (UIView*)setupAddressSubmitedView:(CGFloat)topBarHeight
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    scrollView.userInteractionEnabled = YES;
    scrollView.alwaysBounceVertical = YES;
    
    UIImageView *edinCatView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sale_edincat"]];
    CGRect frame = edinCatView.bounds;
    frame.origin.y = 75.f;
    frame.origin.x = (scrollView.bounds.size.width-edinCatView.bounds.size.width)/2;
    edinCatView.frame = frame;
    [scrollView addSubview:edinCatView];
    
    CGFloat marginTop = edinCatView.frame.origin.y+edinCatView.bounds.size.height;
    
    marginTop += 40.f;
    
    UIFont *successLblFont = [UIFont systemFontOfSize:17.f];
    UILabel *successLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    successLbl.font = successLblFont;
    successLbl.numberOfLines = 0;
    successLbl.textColor = [UIColor colorWithHexString:@"FF5858"];
    successLbl.textAlignment = NSTextAlignmentCenter;
    successLbl.text = @"提交成功！";
    CGSize successLblSize = [successLbl.text sizeWithFont:successLblFont
                                        constrainedToSize:CGSizeMake(scrollView.bounds.size.width,MAXFLOAT)
                                            lineBreakMode:NSLineBreakByWordWrapping];
    successLbl.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, successLblSize.height);
    [scrollView addSubview:successLbl];
    
    marginTop += successLblSize.height;
    marginTop += 8;
    
    UIFont *addressLblFont = [UIFont systemFontOfSize:12.f];
    UILabel *addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    addressTitleLbl.font = addressLblFont;
    addressTitleLbl.numberOfLines = 0;
    addressTitleLbl.textColor = [UIColor colorWithHexString:@"181818"];
    addressTitleLbl.textAlignment = NSTextAlignmentCenter;
    addressTitleLbl.text = @"你将会在1~2个工作日内收到我们的专属";
    CGSize addressTitleLbllSize = [addressTitleLbl.text sizeWithFont:addressLblFont
                                                   constrainedToSize:CGSizeMake(scrollView.bounds.size.width,MAXFLOAT)
                                                       lineBreakMode:NSLineBreakByWordWrapping];
    addressTitleLbl.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, addressTitleLbllSize.height);
    [scrollView addSubview:addressTitleLbl];
    
    
    marginTop += addressTitleLbllSize.height;
    marginTop += 5;
    
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    addressLbl.font = addressLblFont;
    addressLbl.numberOfLines = 0;
    addressLbl.textColor = [UIColor colorWithHexString:@"181818"];
    addressLbl.textAlignment = NSTextAlignmentCenter;
    addressLbl.text = @"寄售袋，我们非常期待你的商品！";
    CGSize addressLblSize = [addressLbl.text sizeWithFont:addressLblFont
                                        constrainedToSize:CGSizeMake(scrollView.bounds.size.width,MAXFLOAT)
                                            lineBreakMode:NSLineBreakByWordWrapping];
    addressLbl.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, addressLblSize.height);
    [scrollView addSubview:addressLbl];
    
    return scrollView;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


@end


@interface SaleMailAddressViewController ()
@end

@implementation SaleMailAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"卖东西"];
    [super setupTopBarBackButton];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    scrollView.userInteractionEnabled = YES;
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIImageView *edinCatView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sale_edincat"]];
    CGRect frame = edinCatView.bounds;
    frame.origin.y = 75.f;
    frame.origin.x = (scrollView.bounds.size.width-edinCatView.bounds.size.width)/2;
    edinCatView.frame = frame;
    [scrollView addSubview:edinCatView];
    
    CGFloat marginTop = edinCatView.frame.origin.y+edinCatView.bounds.size.height;
    
    marginTop += 40.f;
    
    UIFont *addressLblFont = [UIFont systemFontOfSize:12.f];
    UILabel *addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    addressTitleLbl.font = addressLblFont;
    addressTitleLbl.numberOfLines = 0;
    addressTitleLbl.textColor = [UIColor colorWithHexString:@"181818"];
    addressTitleLbl.textAlignment = NSTextAlignmentCenter;
    addressTitleLbl.text = @"我们的地址是:";
    CGSize addressTitleLbllSize = [addressTitleLbl.text sizeWithFont:addressLblFont
                                                   constrainedToSize:CGSizeMake(scrollView.bounds.size.width,MAXFLOAT)
                                                       lineBreakMode:NSLineBreakByWordWrapping];
    addressTitleLbl.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, addressTitleLbllSize.height);
    [scrollView addSubview:addressTitleLbl];
    
    marginTop += addressTitleLbllSize.height;
    marginTop += 5;
    
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    addressLbl.font = addressLblFont;
    addressLbl.numberOfLines = 0;
    addressLbl.textColor = [UIColor colorWithHexString:@"181818"];
    addressLbl.textAlignment = NSTextAlignmentCenter;
    addressLbl.text = @"浙江省杭州市西湖区公元里3幢405A";
    CGSize addressLblSize = [addressLbl.text sizeWithFont:addressLblFont
                                        constrainedToSize:CGSizeMake(scrollView.bounds.size.width,MAXFLOAT)
                                            lineBreakMode:NSLineBreakByWordWrapping];
    addressLbl.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, addressLblSize.height);
    [scrollView addSubview:addressLbl];
    
    marginTop += addressLblSize.height;
    
    marginTop += 30;
    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-170)/2, marginTop, 170, 40)];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    callBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [callBtn setTitle:@"呼叫快递" forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor colorWithHexString:@"ff5858"] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    callBtn.layer.borderWidth = 1.f;
    callBtn.layer.borderColor = [UIColor colorWithHexString:@"ff5858"].CGColor;
    callBtn.layer.masksToBounds=YES;
    callBtn.layer.cornerRadius=5;
    [scrollView addSubview:callBtn];
};

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)callBtnClicked:(UIButton*)sender
{
    
}

@end




