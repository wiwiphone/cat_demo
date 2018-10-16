//
//  ReportViewController.m
//  XianMao
//
//  Created by simon cai on 29/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ReportViewController.h"
#import "Command.h"

#import "HPGrowingTextView.h"
#import "NSString+Addtions.h"
#import "BaseService.h"
#import "Error.h"

@interface ReportViewController () <HPGrowingTextViewDelegate>
@property(nonatomic,weak) UILabel *numLbl;
@property(nonatomic,weak) HPGrowingTextView *summaryTextView;
@property(nonatomic,copy) NSString *reportType;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"举报"];
    [super setupTopBarBackButton];
    
    [super setupTopBarRightButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitle:@"提交" forState:UIControlStateNormal];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    [self.view addSubview:contentView];
    
    CGFloat marginTop = 0.f;
    UIInsetLabel *titleLbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(0, marginTop, contentView.width, 35) andInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    titleLbl.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    titleLbl.text = @"为什么要举报用户？";
    titleLbl.textColor = [UIColor colorWithHexString:@"686868"];
    titleLbl.font = [UIFont systemFontOfSize:12.f];
    [contentView addSubview:titleLbl];
    marginTop += titleLbl.height;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:bgView];
    
    CommandButton *reportType1 = [self buildReportTypeBtn:@"广告骚扰" isSelected:NO];
    reportType1.frame = CGRectMake(30, marginTop, kScreenWidth-30, 50);
    [contentView addSubview:reportType1];
    marginTop += reportType1.height;
    
    CALayer *line = [self buildLine];
    line.frame = CGRectMake(52, marginTop, kScreenWidth-52, 0.5f);
    [contentView.layer addSublayer:line];
    marginTop += line.bounds.size.height;
    
    CommandButton *reportType2 = [self buildReportTypeBtn:@"欺诈" isSelected:NO];
    reportType2.frame = CGRectMake(30, marginTop, kScreenWidth-30, 50);
    [contentView addSubview:reportType2];
    marginTop += reportType2.height;
    
    line = [self buildLine];
    line.frame = CGRectMake(52, marginTop, kScreenWidth-52, 0.5f);
    [contentView.layer addSublayer:line];
    marginTop += line.bounds.size.height;
    
    CommandButton *reportType3 = [self buildReportTypeBtn:@"色情" isSelected:NO];
    reportType3.frame = CGRectMake(30, marginTop, kScreenWidth-30, 50);
    [contentView addSubview:reportType3];
    marginTop += reportType3.height;
    
    bgView.frame = CGRectMake(0, bgView.top, bgView.width, marginTop-bgView.top);
    
    UIInsetLabel *otherLbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(0, marginTop, contentView.width, 35) andInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    otherLbl.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    otherLbl.text = @"其他原因";
    otherLbl.textColor = [UIColor colorWithHexString:@"686868"];
    otherLbl.font = [UIFont systemFontOfSize:12.f];
    [contentView addSubview:otherLbl];
    marginTop += otherLbl.height;
    
    HPGrowingTextView *summaryTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth,150)];
    _summaryTextView = summaryTextView;
    _summaryTextView.placeholder = @"举报内容";
    _summaryTextView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    _summaryTextView.returnKeyType = UIReturnKeyDefault; //just as an example
    _summaryTextView.font = [UIFont systemFontOfSize:14.0f];
    _summaryTextView.delegate = self;
    _summaryTextView.backgroundColor = [UIColor whiteColor];
    _summaryTextView.isScrollable = NO;
    _summaryTextView.enablesReturnKeyAutomatically = NO;
    _summaryTextView.animateHeightChange = NO;
    _summaryTextView.autoRefreshHeight = NO;
    _summaryTextView.frame = CGRectMake(0, marginTop, kScreenWidth, 115);
    _summaryTextView.backgroundColor = [UIColor whiteColor];
    
    [contentView addSubview:_summaryTextView];
    
    UILabel *numLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _summaryTextView.bottom-10, self.view.width, 0)];
    _numLbl = numLbl;
    _numLbl.text = @"0/200";
    _numLbl.textColor = [UIColor colorWithHexString:@"A7A7A7"];
    _numLbl.textAlignment = NSTextAlignmentRight;
    _numLbl.font = [UIFont systemFontOfSize:12.f];
    [_numLbl sizeToFit];
    _numLbl.frame = CGRectMake(15, _summaryTextView.bottom-10-_numLbl.height, self.view.width-30, _numLbl.height);
    [contentView addSubview:_numLbl];
    
    marginTop += _summaryTextView.height;
    
    marginTop += 10;
    
    UILabel *officialContectsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, self.view.width-30, 0)];
    officialContectsLbl.textAlignment = NSTextAlignmentCenter;
    officialContectsLbl.font = [UIFont systemFontOfSize:12.f];
    officialContectsLbl.textColor = [UIColor colorWithHexString:@"A7A7A7"];
    officialContectsLbl.text = @"官方微信: aidingmao 官方QQ群: 227940158";
    [officialContectsLbl sizeToFit];
    officialContectsLbl.frame = CGRectMake(15, marginTop, self.view.width-30, officialContectsLbl.height);
    [contentView addSubview:officialContectsLbl];
    
    marginTop += officialContectsLbl.height;
    
    contentView.contentSize = CGSizeMake(contentView.width, marginTop+20);
    
    WEAKSELF;
    
    void(^handleBtnClickedBlock)(CommandButton *sender) = ^(CommandButton *sender){
        reportType1.selected = NO;
        [reportType1 setImage:[UIImage imageNamed:@"shopping_cart_unchoose"] forState:UIControlStateNormal];
        reportType2.selected = NO;
        [reportType2 setImage:[UIImage imageNamed:@"shopping_cart_unchoose"] forState:UIControlStateNormal];
        reportType3.selected = NO;
        [reportType3 setImage:[UIImage imageNamed:@"shopping_cart_unchoose"] forState:UIControlStateNormal];
        
        sender.selected = !sender.isSelected;
        if (sender.isSelected) {
            [sender setImage:[UIImage imageNamed:@"shopping_cart_choosed"] forState:UIControlStateNormal];
        } else {
            [sender setImage:[UIImage imageNamed:@"shopping_cart_unchoose"] forState:UIControlStateNormal];
        }
        
        weakSelf.reportType = [sender titleForState:UIControlStateNormal];
    };
    
    reportType1.handleClickBlock = ^(CommandButton *sender) {
        handleBtnClickedBlock(sender);
    };
    reportType2.handleClickBlock = ^(CommandButton *sender) {
        handleBtnClickedBlock(sender);
    };
    reportType3.handleClickBlock = ^(CommandButton *sender) {
        handleBtnClickedBlock(sender);
    };
    
    [self bringTopBarToTop];
}

- (CALayer*)buildLine{
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"].CGColor;
    line.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    return line;
}

- (CommandButton*)buildReportTypeBtn:(NSString*)title isSelected:(BOOL)isSelected{
    CommandButton *reportType1 = [[CommandButton alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth-30, 50)];
    [reportType1 setTitle:title forState:UIControlStateNormal];
    [reportType1 setSelected:isSelected];
    [reportType1 setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
    reportType1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    reportType1.titleLabel.font = [UIFont systemFontOfSize:16.f];
    reportType1.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    if (isSelected) {
        [reportType1 setImage:[UIImage imageNamed:@"shopping_cart_choosed"] forState:UIControlStateNormal];
    } else {
        [reportType1 setImage:[UIImage imageNamed:@"shopping_cart_unchoose"] forState:UIControlStateNormal];
    }
    return reportType1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    NSString *content = _summaryTextView.text;
    NSString *reportType = _reportType;
    if ([content length]>0 || [reportType length]>0) {
        WEAKSELF;
        [super showProcessingHUD:nil];
        [PlatformService report:self.userId type:reportType content:content completion:^{
            [weakSelf showHUD:@"举报成功" hideAfterDelay:1.2f forView:[UIApplication sharedApplication].keyWindow];
            [weakSelf dismiss];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [super showHUD:@"请填写举报内容" hideAfterDelay:0.8f];
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    _numLbl.text = [NSString stringWithFormat:@"%ld/200",(long)[growingTextView.text length]];
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([growingTextView.text length]<=200) {
        return YES;
    }
    return NO;
}

@end


