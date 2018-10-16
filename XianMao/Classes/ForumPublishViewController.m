//
//  ForumPublishViewController.m
//  XianMao
//
//  Created by simon cai on 21/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumPublishViewController.h"
#import "ForumInputToolBar.h"

#import "ForumService.h"
#import "NSString+Addtions.h"

#import "Error.h"

#import "Session.h"
#import "SearchViewController.h"

#import "PictureItemsEditView.h"

#import "CoordinatingController.h"

#import "UIImage+Resize.h"
#import "ActionSheet.h"
#import "AssetPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "NetworkAPI.h"
#import "FRDLivelyButton.h"
#import "Masonry.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ForumTopicVO.h"
#define BASECOLOR [UIColor colorWithHexString:@"c2a79d"]


@implementation TopicSelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 7;
        self.layer.borderColor = BASECOLOR.CGColor;
        self.layer.borderWidth = 0.5;
        self.isSelect = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:BASECOLOR forState:UIControlStateNormal];
        UIImage *closeImg = [UIImage imageNamed:@"filter_btn_chosen_close.png"];
        UIImageView *closeIcon = [[UIImageView alloc] initWithImage:closeImg];
        closeIcon.frame = CGRectMake(0, 0, closeImg.size.width, closeImg.size.height);
        [self addSubview:closeIcon];
        closeIcon.hidden = YES;
        self.closeIcon = closeIcon;
    }
    return self;
}

@end

@interface ForumPublishViewController () <ForumInputToolBarDelegate,DXChatBarMoreViewDelegate,SearchViewControllerDelegate,UIScrollViewDelegate,PictureItemsEditViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property(nonatomic,weak) XHMessageTextView *inputTextView;
@property(nonatomic,weak) TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic,weak) ForumInputToolBar *toolBar;
@property(nonatomic,weak) PictureItemsEditView *editView;
@property (nonatomic, strong) NSArray *tagArrays;
@property (nonatomic, weak) UIView *container;
@property (nonatomic, weak) UILabel *headerLable;
@property (nonatomic, weak) FRDLivelyButton *chooseTypeArrowbutton;
@property (nonatomic, weak) UIImageView *menu_select;
@property (nonatomic, weak) UITextField *tagField;
@property (nonatomic, strong) NSArray *topicButtons;
@property (nonatomic, strong) UIView *buttonsView;
@property (nonatomic, strong) UIView *container_s;
@end

@implementation ForumPublishViewController
{
    BOOL isShowMenu;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    isShowMenu = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    //        [super setupTopBarTitle:self.title?self.title:@"发布求购"];
    [self setupTopBarView];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitle:@"发布" forState:UIControlStateNormal];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-30-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width+30, hegight);
    self.topBarRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight-[ForumInputToolBar defaultHeight])];
    
    [self.view addSubview:scrollView];
    scrollView.clipsToBounds=NO;
    self.view.backgroundColor      = [UIColor whiteColor];
    scrollView.contentSize         = CGSizeMake(scrollView.width,scrollView.height+0.5);
    
    scrollView.delegate = self;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    scrollView.delegate = self;
    _scrollView = scrollView;
    
    XHMessageTextView *inputTextView = [[XHMessageTextView alloc] initWithFrame:CGRectMake(15, 15, scrollView.width-30, 100)];
    [scrollView addSubview:inputTextView];
    
    CGFloat marginTop = inputTextView.bottom;
    marginTop += 10;
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    line.frame = CGRectMake(15, marginTop, kScreenWidth, 0.5f);
    [scrollView.layer addSublayer:line];
    
    marginTop += 15;
    
    PictureItemsEditView *editView = [[PictureItemsEditView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, [PictureItemsEditView heightForOrientationPortrait:0 maxItemsCount:9]) isShowMainPicTip:NO];
    editView.backgroundColor = [UIColor clearColor];
    editView.maxItemsCount = 9;
    editView.delegate = self;
    editView.viewController = self;
    [scrollView addSubview:editView];
    _editView = editView;
    
    marginTop += 15;
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, marginTop);
    if (kScreenHeight < 568) {
        scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 100);
    }
    _scrollView.alwaysBounceVertical = YES;
    
    _inputTextView = inputTextView;
    _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //    self.inputTextView.contentMode = UIViewContentModeCenter;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeyDefault;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.placeHolder = @"写点什么吧";
    for (ForumCatHouseTopData *vo in _topic_array) {
        if (vo.topic_id == _topic_id) {
            _inputTextView.placeHolder = vo.enter_tip;
        }
    }
   
    
    _inputTextView.backgroundColor = [UIColor clearColor];
    //    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    //    _inputTextView.layer.borderWidth = 0.65f;
    //    _inputTextView.layer.cornerRadius = 0.f;
    
    ForumInputToolBar *toolBar = [[ForumInputToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [ForumInputToolBar defaultHeight], self.view.frame.size.width, [ForumInputToolBar defaultHeight]) withInputTextView:inputTextView isNeedMoreView:NO];
    _toolBar = toolBar;
    toolBar.doSendWhenEditDone = NO;
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _toolBar.delegate = self;
    if ([_toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        DXChatBarMoreView *moreView = (DXChatBarMoreView*)(_toolBar.moreView);
        moreView.delegate = self;
    }
    [self.view addSubview:toolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.toolBar.moreView setDelegate:self];
    }
    
    inputTextView.backgroundColor = [UIColor whiteColor];
    
    [self initContainer];
    [self bringTopBarToTop];
    
    [self setupForDismissKeyboard];
    
    [self loadData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [self.scrollView addGestureRecognizer:tap];
    //    WEAKSELF;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [weakSelf.inputTextView becomeFirstResponder];
    //    });
    [self initMenuView];
    
    
}

- (void)handleTopBarBackButtonClicked:(UIButton*)sender {
    
    NSString *title = @"取消发布";
    NSString *message = @"取消发布，你刚刚写的内容会丢失噢，真的要取消么";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"继续写" otherButtonTitles:@"下次重写", nil];
    [alert show];
    
}

//- (void)willPresentAlertView:(UIAlertView *)alertView {
//    // 遍历 UIAlertView 所包含的所有控件
//    for (UIView *tempView in alertView.subviews) {
//        if ([tempView isKindOfClass:[UILabel class]]) {
//            // 当该控件为一个 UILabel 时
//            UILabel *tempLabel = (UILabel *) tempView;
//            if ([tempLabel.text isEqualToString:alertView.message]) {
//                // 调整对齐方式
////                tempLabel.textAlignment = UITextAlignmentLeft;
//                // 调整字体大小
//                [tempLabel setFont: [UIFont boldSystemFontOfSize:14]];
//            }
//        }
//    }
//}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1) {
        [self.view endEditing:YES];
        [self dismiss];
    }
}

- (void)loadData
{
    [ForumService getTopicButtons:_topic_id completion:^(NSDictionary *dic) {
        self.topicButtons = [NSArray arrayWithArray:dic[@"forum_tags"]];
        [self addTopicButtons];
    } failure:^(XMError *error) {
        
    }];
}

- (void)addTopicButtons
{
    if (!self.buttonsView) {
        self.buttonsView = [UIView new];
    } else {
        [self.buttonsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int i = 0; i < _topicButtons.count; i++) {
        TopicSelectButton *button;
        if (i < 4) {
            button = [[TopicSelectButton alloc] initWithFrame:CGRectMake(105 + i * 70, 0, 70, 20)];
        } else {
            button = [[TopicSelectButton alloc] initWithFrame:CGRectMake(20 + i % 6 * 70,30 * (i / 6), 70, 20)];
        }
        
        [_buttonsView addSubview:button];
        button.serNum = i;
        NSString *str = _topicButtons[i];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
        button.width = rect.size.width + 20;
        [button setTitle:_topicButtons[i] forState:UIControlStateNormal];//保护 todo
        [button addTarget:self action:@selector(topicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    _buttonsView.frame = CGRectMake(0, 100, kScreenWidth, (_topicButtons.count - 4) / 6 *30 + 30+10);
    [_container addSubview:_buttonsView];
    self.container.height = _buttonsView.height + 100;
}

- (void)topicButtonAction:(TopicSelectButton *)sender
{
    
    NSString *filedText;
    if (_tagField.text != nil) {
        filedText = [NSString stringWithString:_tagField.text];
    } else {
        filedText = @"";
    }
    
    if (sender.isSelect) {
        sender.layer.borderColor = BASECOLOR.CGColor;
        sender.closeIcon.hidden = YES;
        [sender setTitleColor:BASECOLOR forState:UIControlStateNormal];
        NSArray *textArray  = [filedText componentsSeparatedByString:@" "];
        NSString *textString = textArray[0];
        NSString *topicStr;
        if ([textString isEqualToString:_topicButtons[sender.serNum]]) {
            topicStr = [NSString stringWithFormat:@"%@ ", textString];
        } else {
            topicStr = [NSString stringWithFormat:@" %@", _topicButtons[sender.serNum]];
        }
        NSArray *array = [filedText componentsSeparatedByString:topicStr];
        filedText = @"";
        for (NSString *str in array) {
            if ([str isNotEmptyCtg] && [filedText isNotEmptyCtg]) {
                filedText = [NSString stringWithFormat:@"%@ %@", filedText, str];
            } else if([str isNotEmptyCtg] && ![filedText isNotEmptyCtg]){
                filedText = str;
            }
        }
        if (textArray.count == 1) {
            filedText = @"";
        }
    } else {
        if (![filedText isNotEmptyCtg]) {
            filedText = _topicButtons[sender.serNum];
        } else {
            
            filedText = [NSString stringWithFormat:@"%@ %@", filedText, _topicButtons[sender.serNum]];
        }
        sender.layer.borderColor = [UIColor blackColor].CGColor;
        sender.closeIcon.hidden = NO;
    }
    sender.isSelect = !sender.isSelect;
    _tagField.text = filedText;
    
}
- (void)touchScrollView
{
    if (isShowMenu) {
        [self showSearchTypeMenu];
    }
    [_inputTextView resignFirstResponder];
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
}

#pragma mark Container初始化
- (void)initContainer
{
    
    UIView *container = [UIView new];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_editView.mas_bottom).with.offset(80);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(kScreenWidth);
    }];
    _container = container;
    
    self.container_s = [[UIView alloc] init];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 1.5, 12, 12)];
    [_container_s addSubview:icon];
    icon.image = [UIImage imageNamed:@"sale_icon_question"];
    NSString *str = [NSString stringWithFormat:@"     %@", _prompt?_prompt:@"自定义发布的喵帖不会有标签，不会进入分类模块，只有进入你的主页或者关注你的人才能看得到"];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    UILabel *promtLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, rect.size.height)];
    promtLabel.textColor = [UIColor colorWithRed:152 / 255.0 green:152 / 255.0 blue:152 / 255.0 alpha:1];
    promtLabel.font = [UIFont systemFontOfSize:12];
    promtLabel.text = str;
    promtLabel.numberOfLines = 0;
    [self.container_s addSubview:promtLabel];
    self.container_s.frame = CGRectMake(0, 0, kScreenWidth, rect.size.height +5);
    [self.container addSubview:self.container_s];
    if (_topic_id ==6) {
        self.container_s.hidden = NO;
    } else {
        self.container_s.hidden = YES;
    }
    UILabel *inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 25)];
    inputLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    inputLabel.text = @"输入标签";
    inputLabel.font = [UIFont systemFontOfSize:15];
    [container addSubview:inputLabel];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 25)];
    hotLabel.font = [UIFont systemFontOfSize:15];
    hotLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    hotLabel.text = @"热门标签";
    [container addSubview:hotLabel];
    
    UIView *parentView = [[UIView alloc] init];
    parentView.frame = CGRectMake(105, 50, kScreenWidth - 110 - 20, 25);
    [container addSubview:parentView];
    parentView.layer.borderColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor;
    parentView.layer.borderWidth = 0.5;
    parentView.layer.cornerRadius = 8;
    parentView.layer.masksToBounds = YES;
    UITextField *field = [UITextField new];
    field.placeholder = @"输入标签可让更多人搜到，多个标签用空格间隔";
    field.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(115);
        make.height.mas_equalTo(20);
        make.top.equalTo(_editView.mas_bottom).with.offset(130 + 2.5);
        make.width.mas_equalTo(kScreenWidth - 109 - 20);
    }];
    _tagField = field;
    field.userInteractionEnabled = YES;
    
    
    
    field.delegate = self;
    
    
    
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView scrollToActiveTextField];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark menu初始化

- (void)initMenuView
{
    UIImageView *menu_select = [UIImageView new];
    menu_select.userInteractionEnabled = YES;
    UIImage *bgImage = [UIImage imageNamed:@"forum_popup_menu_bg"];
    menu_select.layer.cornerRadius = 3;
    menu_select.layer.masksToBounds = YES;
    [menu_select setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
    _menu_select = menu_select;
    [self.view addSubview:_menu_select];
    //    for (int i = 0; i < _topic_array.count; i++) {
    //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 30, 80, 30)];
    //        [_menu_select addSubview:label];
    //        NSDictionary *dic = _topic_array[i];
    //        label.text = dic[@""];
    //    }
    for (int i = 0; i < _topic_array.count; i++) {
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 35 + 10, 140, 35)];
        ForumCatHouseTopData *vo = _topic_array[i];
        [label setTitle:vo.title forState:UIControlStateNormal];
        [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        label.tag = 10000+i;
        [_menu_select addSubview:label];
        [label addTarget:self action:@selector(changeTopicWithDic:) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(0, 10 +35 * (i+1) - 2.5, 140, 0.5);
        line.backgroundColor = [UIColor blackColor].CGColor;
        [_menu_select.layer addSublayer:line];
        
    }
    menu_select.hidden = YES;
    //    menu_select.width = 140;
    //    menu_select.height = 35 * 4 + 10;
    //    menu_select.top = isShowMenu?super.topBarHeight-10:-menu_select.height;
    menu_select.frame = CGRectMake((self.view.width-134)/2, super.topBarHeight-10, 140, 35 * _topic_array.count + 10);
    //    menu_select.centerX = self.view.centerX;
    [self.view bringSubviewToFront:menu_select];
    
}

#pragma mark -
#pragma mark - 设置topbarview

-(void)showSearchTypeMenu
{
    
    //    float y = isShowMenu?-(35 * 4 + 10):super.topBarHeight-10;
    [UIView animateWithDuration:0.3 animations:^{
        
        
        if (isShowMenu) {
            _menu_select.alpha = 0;
        } else {
            _menu_select.alpha = 1;
        }
        isShowMenu=!isShowMenu;
        [self setChooseImage:isShowMenu];
    }
                     completion:^(BOOL finished) {
                         if (isShowMenu) {
                             if (_topic_array.count > 0) {
                                 _menu_select.hidden = NO;
                             }
                         } else {
                             _menu_select.hidden = YES;
                         }
                     }
     ];
}

- (void)changeTopicWithDic:(UIButton *)sender
{
    ForumCatHouseTopData *dic = _topic_array[sender.tag - 10000];
    NSInteger topic = dic.topic_id;
    _inputTextView.placeHolder = dic.enter_tip;
    if (_topic_id != topic) {
        [self loadData];
    }
    
    _topic_id = topic;
    if (topic == 6) {
        self.container_s.hidden = NO;
    } else {
        self.container_s.hidden = YES;
    }
    _headerLable.text = dic.title;
    if (isShowMenu) {
        [self showSearchTypeMenu];
    }
}

- (void)setChooseImage:(BOOL)isOpen {
    if (isOpen) {
        [_chooseTypeArrowbutton setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
    }else {
        [_chooseTypeArrowbutton setStyle:kFRDLivelyButtonStyleCaretDown animated:YES];
    }
}


- (void)setupTopBarView
{
    
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchTypeMenu)];
    UILabel *headerLabel = [UILabel new];
    headerLabel.userInteractionEnabled = YES;
    [headerLabel addGestureRecognizer:tag];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.frame = CGRectMake(0, 0, 50, 16);
    _headerLable = headerLabel;
    
    for (ForumCatHouseTopData *vo in _topic_array) {
        if (vo.topic_id == _topic_id) {
            _headerLable.text = vo.title;
        }
    }
    _headerLable.centerX = self.view.centerX - 10;
    headerLabel.centerY = self.topBar.height / 2.0 +10;
    [headerLabel sizeToFit];
    FRDLivelyButton *chooseTypeArrowbutton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    chooseTypeArrowbutton.centerY = headerLabel.centerY;
    chooseTypeArrowbutton.left = _headerLable.right + 2;
    [chooseTypeArrowbutton addTarget:self action:@selector(showSearchTypeMenu) forControlEvents:UIControlEventTouchUpInside];
    
    chooseTypeArrowbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [chooseTypeArrowbutton setStyle:kFRDLivelyButtonStyleCaretDown animated:NO];
    [chooseTypeArrowbutton setOptions:@{kFRDLivelyButtonLineWidth: @(2.0f),kFRDLivelyButtonColor:BASECOLOR}];
    _chooseTypeArrowbutton = chooseTypeArrowbutton;
    [self.topBar addSubview:_headerLable];
    [self.topBar addSubview:_chooseTypeArrowbutton];
    
    //    self.navigationItem.titleView = barView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [_inputTextView resignFirstResponder];
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
}

- (void)picturesEditViewHeightChanged:(PictureItemsEditView*)view height:(CGFloat)height
{
    CGFloat marginTop = _inputTextView.bottom + 300;
    marginTop += 10;
    
    marginTop += 10;
    
    marginTop += view.height;
    
    marginTop += 15;
    
    if (_scrollView.height>marginTop) {
        _scrollView.contentSize = CGSizeMake(kScreenWidth, _scrollView.height);
    } else {
        _scrollView.contentSize = CGSizeMake(kScreenWidth, marginTop);
    }
    _scrollView.alwaysBounceVertical = YES;
}
- (void)picturesEditViewPictureItemDeleted:(PictureItemsEditView*)view item:(PictureItem*)item
{
    [self picturesEditViewHeightChanged:view height:0];
}
- (void)picturesEditViewPictureItemAdded:(PictureItemsEditView*)view
{
    [self picturesEditViewHeightChanged:view height:0];
}
- (void)picturesEditViewPictureItemOrdersChanged:(PictureItemsEditView*)view
{
    [self picturesEditViewHeightChanged:view height:0];
}

- (void)dealloc
{
    _toolBar.delegate = nil;
    _toolBar = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    WEAKSELF;
    //    [weakSelf.inputTextView becomeFirstResponder];
    
}


- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    NSString *filedText = _tagField.text;
    NSArray *array = [filedText componentsSeparatedByString:@" "];
    int count = 0;
    for (NSString *str in array) {
        if ([str isNotEmptyCtg]) {
            count++;
        }
    }
    if (count > 4) {
        [self showHUD:@"标签数目最多存在3个哦" hideAfterDelay:1];
        return;
    }
    
    [self publishContent:self.toolBar.inputTextView.text];
}


#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    
    //    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    if (isShowMenu) {
        [self showSearchTypeMenu];
    }
    //    [UIView animateWithDuration:0.3 animations:^{
    //        CGRect rect = self.tableView.frame;
    //        rect.origin.y = self.topBarHeight;
    //        rect.size.height = self.view.frame.size.height - toHeight - self.topBarHeight;
    //        self.tableView.frame = rect;
    //    }];
    //    [self scrollViewToBottom:YES];
}

- (void)didSendFaceWithText:(NSString *)text
{
    //    _extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName,
    //                                                                  @"fromHeaderImg" : [Session sharedInstance].currentUser.avatarUrl,
    //                                                                  @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
    //                                                                  @"toNickname" : _sellerName,
    //                                                                  @"toHeaderImg": _sellerHeaderImg,
    //                                                                  @"toUserId" : [NSNumber numberWithInteger:_sellerId]}];
    //    if (text && text.length > 0) {
    //        [self sendTextMessage:text];
    //    }
    
    [self publishContent:self.toolBar.inputTextView.text];
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    //    // 隐藏键盘
    //    [self keyBoardHidden];
    //
    //    //    // 弹出照片选择
    //    //    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    //    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    //    //    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    //
    //    //从手机相册选择
    //    WEAKSELF;
    //    AssetPickerController * imagePicker =  [[AssetPickerController alloc] init];
    //    imagePicker.minimumNumberOfSelection = 1;
    //    imagePicker.delegate = weakSelf;
    //    imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
    //    imagePicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    //        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
    //            return NO;
    //        } else {
    //            return YES;
    //        }
    //    }];
    //    [weakSelf presentViewController:imagePicker animated:YES completion:^{
    //    }];
}

- (void)moreViewGoodsAction:(DXChatBarMoreView *)moreView
{
    //    [self.view endEditing:YES];
    //    [self.toolBar endEditing:YES];
    
    if ([Session sharedInstance].currentUser.type==1) {
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.delegate = self;
        viewController.isForSelected = YES;
        [self pushViewController:viewController animated:YES];
    } else {
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.delegate = self;
        viewController.isForSelected = YES;
        viewController.sellerId = [Session sharedInstance].currentUserId;
        [self pushViewController:viewController animated:YES];
    }
}

- (void)searchViewGoodsSelected:(SearchViewController*)viewController recommendGoods:(RecommendGoodsInfo*)recommendGoodsInfo
{
    
    [viewController dismiss];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    
}

- (void)publishContent:(NSString*)content
{
    WEAKSELF;
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:nil];
    if (isLoggedIn) {
        
        NSArray *gallary = _editView.picItemsArray;
        NSMutableArray *uploadFiles = [[NSMutableArray alloc] init];
        for (PictureItem *item in gallary) {
            if ([item isKindOfClass:[PictureItem class]]) {
                if (item.picId == kPictureItemLocalPicId) {
                    [uploadFiles addObject:item.picUrl];
                }
            }
        }
        
        [self.view endEditing:YES];
        [self.toolBar endEditing:YES];
        
        NSString *text = [content trim];
        
        if ([uploadFiles count]>0 || [text length]>0) {
            
            [weakSelf showProcessingHUD:nil];
            
            if ([uploadFiles count]>0) {
                [[NetworkAPI sharedInstance] updaloadPics:uploadFiles completion:^(NSArray *picUrlArray) {
                    NSInteger index = 0;
                    for (PictureItem *tempItem in gallary) {
                        if (tempItem.picId == kPictureItemLocalPicId) {
                            tempItem.picId = 0;
                            if (index<[picUrlArray count]) {
                                tempItem.picUrl = [picUrlArray objectAtIndex:index];
                            }
                            index+=1;
                        }
                    }
                    [weakSelf publishContentImpl:text gallary:gallary];
                    //                [weakSelf upddateGallery:gallary];
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            } else {
                [weakSelf publishContentImpl:text gallary:nil];
            }
        }
    }
}

- (void)publishContentImpl:(NSString*)content gallary:(NSArray*)gallary {
    WEAKSELF;
    NSMutableArray *array = nil;
    if ([gallary count]>0) {
        array = [[NSMutableArray alloc] init];
        for (PictureItem *item in gallary) {
            ForumAttachItemPicsVO *picsVO = [[ForumAttachItemPicsVO alloc] init];
            picsVO.pic_url = item.picUrl;
            picsVO.pic_desc = item.picDescription;
            picsVO.width = item.width;
            picsVO.height = item.height;
            
            
            ForumAttachmentVO *attachmentVO = [[ForumAttachmentVO alloc] init];
            attachmentVO.type = ForumAttachTypePics;
            attachmentVO.item = picsVO;
            [array addObject:attachmentVO];
        }
    }
    NSString *filedText = _tagField.text;
    NSArray *tagsarray = [filedText componentsSeparatedByString:@" "];
    [ForumService publish_post:self.topic_id content:content?content:@"" attachments:array tags:tagsarray completion:^(ForumPostVO *postVO) {
        [weakSelf hideHUD];
        [weakSelf dismiss];
        if (weakSelf.handlePublishedBlock) {
            weakSelf.handlePublishedBlock(postVO);
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}


//- (void)editProfileGalleryChanged:(EditProfileViewController*)viewController gallery:(NSArray*)gallary
//{
//    WEAKSELF;
//    NSMutableArray *uploadFiles = [[NSMutableArray alloc] init];
//    for (PictureItem *item in gallary) {
//        if ([item isKindOfClass:[PictureItem class]]) {
//            if (item.picId == kPictureItemLocalPicId) {
//                [uploadFiles addObject:item.picUrl];
//            }
//        }
//    }
//
//    if ([uploadFiles count]>0) {
//        [weakSelf showProcessingHUD:nil];
//        [[NetworkAPI sharedInstance] updaloadPics:uploadFiles completion:^(NSArray *picUrlArray) {
//            NSInteger index = 0;
//            for (PictureItem *tempItem in gallary) {
//                if (tempItem.picId == kPictureItemLocalPicId) {
//                    tempItem.picId = 0;
//                    if (index<[picUrlArray count]) {
//                        tempItem.picUrl = [picUrlArray objectAtIndex:index];
//                    }
//                    index+=1;
//                }
//            }
//            [weakSelf upddateGallery:gallary];
//        } failure:^(XMError *error) {
//            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//        }];
//    } else {
//        [self upddateGallery:gallary];
//    }
//}
//
//- (void)upddateGallery:(NSArray*)gallary
//{
////    WEAKSELF;
////    [[NetworkAPI sharedInstance] setGallery:gallary completion:^{
////        [weakSelf hideHUD];
////    } failure:^(XMError *error) {
////        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
////    }];
//}

@end



