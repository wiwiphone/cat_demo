//
//  AboutViewController.m
//  XianMao
//
//  Created by simon on 1/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableViewCell.h"
#import "SepTableViewCell.h"
#import "NSDictionary+Additions.h"
#import "Command.h"
#import "WebViewController.h"
#import "URLScheme.h"
#import "Version.h"
#import "DataSources.h"
#import "UIActionSheet+Blocks.h"
#import "CoordinatingController.h"


#define ICON_WIDTH 104.f
#define VERSION_LABEL_MARGIN_TOP 22.f

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) AboutHeaderView *headerView;
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSArray *dataSources;

@end

@implementation AboutViewController
- (void)dealloc
{
    self.tableView = nil;
    self.headerView = nil;
    self.dataSources = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  self.view.clipsToBounds = YES;
    
    WEAKSELF;
    self.dataSources = [NSArray arrayWithObjects:
                        
                        [[AboutTableViewCell buildCellDict:@"服务协议"] fillAction:^{
                            WebViewController *serviceWeb = [[WebViewController alloc] init];
                            serviceWeb.url = kURLAgreement;
                            serviceWeb.title = @"服务协议";
                            [weakSelf pushViewController:serviceWeb animated:YES];
                        }],
                        [[AboutTableViewCell buildCellDict:@"版权信息"] fillAction:^{
                            WebViewController *serviceWeb = [[WebViewController alloc] init];
                            serviceWeb.url = kURLCopyright;
                            serviceWeb.title = @"版权信息";
                            [weakSelf pushViewController:serviceWeb animated:YES];
                        }]
                        ,nil];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"关于爱丁猫"];
    [super setupTopBarBackButton];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight - topBarHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    AboutHeaderView *headerView = [[AboutHeaderView alloc] initWithFrame:CGRectZero];
    headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, [AboutHeaderView heightForOrientationPortrait]);
    AboutFooterView *footerView = [[AboutFooterView alloc] initWithFrame:CGRectZero];
    footerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-topBarHeight , kScreenWidth, topBarHeight);
    self.tableView.tableHeaderView = headerView;
    
    [self.view addSubview:footerView];
    
    [super bringTopBarToTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    [dict doAction];
}


@end

@interface AboutHeaderView ()

@property(nonatomic,retain) UIImageView *iconView;
@property(nonatomic,retain) UILabel *versionLbl;

@property(nonatomic,retain) CALayer *bottomBorder;


@end

@implementation AboutHeaderView

+ (CGFloat)heightForOrientationPortrait {
    return 215.f;
}

- (void)dealloc
{
    self.iconView = nil;
    self.versionLbl = nil;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectNull];
        self.iconView.image = [UIImage imageNamed:@"AppIcon_120"];
        self.iconView.userInteractionEnabled = NO;
        self.iconView.clipsToBounds = YES;
        self.iconView.layer.borderWidth = 2.0f;
        self.iconView.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        self.iconView.layer.masksToBounds=YES;
        self.iconView.layer.cornerRadius=18;    //最重要的是这个地方要设成imgview高的一半
        [self addSubview:self.iconView];
        
        self.versionLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.versionLbl.textColor = [UIColor colorWithHexString:@"86858a"];
        self.versionLbl.font = [UIFont systemFontOfSize:17.f];
        self.versionLbl.text = [NSString stringWithFormat:@"爱丁猫 %@",APP_VERSION];
        self.versionLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.versionLbl];
        
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.borderColor = [UIColor colorWithHexString:@"4A2F31"].CGColor;
        self.bottomBorder.borderWidth = 1.f;
        [self.layer addSublayer:self.bottomBorder];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.iconView.frame = CGRectMake((self.frame.size.width - ICON_WIDTH) / 2, (self.frame.size.height-ICON_WIDTH)/2 - 20,
                                       ICON_WIDTH, ICON_WIDTH);
    
    
    float marginTop = self.iconView.frame.origin.y + ICON_WIDTH + 20;
    [self.versionLbl sizeToFit];
    self.versionLbl.frame = CGRectMake((kScreenWidth - ICON_WIDTH) / 2, marginTop, ICON_WIDTH,30);
    
   // self.bottomBorder.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
}


@end

@interface AboutFooterView ()

@property(nonatomic,retain) UIImageView *iconView;
@property(nonatomic,retain) UILabel *versionLbl;

@property(nonatomic,retain) CALayer *bottomBorder;


@end

@implementation AboutFooterView

+ (CGFloat)heightForOrientationPortrait {
    return 65.f;
}

- (void)dealloc
{
    self.iconView = nil;
    self.versionLbl = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.iconView = [[UIImageView alloc] initWithFrame:CGRectNull];
//        self.iconView.image = [UIImage imageNamed:@"AppIcon_120"];
//        self.iconView.userInteractionEnabled = NO;
//        self.iconView.clipsToBounds = YES;
//        self.iconView.layer.borderWidth = 2.0f;
//        self.iconView.layer.borderColor = [UIColor colorWithHexString:@"E2BB66"].CGColor;
//        self.iconView.layer.masksToBounds=YES;
//        self.iconView.layer.cornerRadius=18;    //最重要的是这个地方要设成imgview高的一半
//        [self addSubview:self.iconView];
        
        self.versionLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.versionLbl.textColor = [UIColor colorWithHexString:@"86858a"];
        self.versionLbl.font = [UIFont systemFontOfSize:13.f];
        self.versionLbl.text = [NSString stringWithFormat:@"©2015 aidingmao.com 杭州爱丁猫科技有限公司"];
        self.versionLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.versionLbl];
        
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.borderColor = [UIColor colorWithHexString:@"4A2F31"].CGColor;
        self.bottomBorder.borderWidth = 1.f;
        [self.layer addSublayer:self.bottomBorder];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.versionLbl sizeToFit];
    self.versionLbl.frame = CGRectMake(0, 0, kScreenWidth,65);
    
    // self.bottomBorder.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
}

@end

#import "HPGrowingTextView.h"
#import "NSString+Addtions.h"
#import "Session.h"
#import "NetworkManager.h"
#import "Error.h"
#import "TZImagePickerController.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "UIActionSheet+Blocks.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "WCAlertView.h"
#import "UIImage+Resize.h"
#import "AppDirs.h"
#import "NetworkAPI.h"
#import "JSONKit.h"

#define kADMFeedbackImageSize 800

@interface FeedbackViewController ()<HPGrowingTextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) HPGrowingTextView * suggestTF;
@property (nonatomic,strong) UILabel * numLbl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic, strong) UILabel * officialContectsLbl;

@end

@implementation FeedbackViewController
{
    CGFloat _itemWH;
    CGFloat _margin;
    NSMutableArray * _selectedPhotos;
    NSMutableArray * _selectedAssets;
    NSMutableArray * _uploadFiles;
}


-(HPGrowingTextView *)suggestTF
{
    if (!_suggestTF) {
        _suggestTF = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(14, 64+14, kScreenWidth-28, 200)];
        _suggestTF.placeholder = @"主银, 您有何吩咐?";
        _suggestTF.returnKeyType = UIReturnKeyDefault;
        _suggestTF.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _suggestTF.isScrollable = NO;
        _suggestTF.enablesReturnKeyAutomatically = NO;
        _suggestTF.animateHeightChange = NO;
        _suggestTF.autoRefreshHeight = NO;
        _suggestTF.delegate = self;
    }
    return _suggestTF;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(60, 60);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(self.suggestTF.frame)+15, self.view.width-14*2, 60) collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.contentSize = CGSizeMake(0, 0);
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        
    }
    return _collectionView;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.officialContectsLbl.frame)+20, kScreenWidth-80, 40)];
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _submitBtn.layer.borderWidth = 1;
        _submitBtn.layer.borderColor = [UIColor colorWithHexString:@"e2e2e2"].CGColor;
        [_submitBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _submitBtn.enabled = NO;
    }
    return _submitBtn;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

-(UILabel *)numLbl
{
    if (!_numLbl) {
        _numLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.suggestTF.frame)-120, CGRectGetMaxY(self.suggestTF.frame)-15, 110, 13)];
        _numLbl.text = @"0/200";
        _numLbl.textColor = [UIColor colorWithHexString:@"c0c0c0"];
        _numLbl.textAlignment = NSTextAlignmentRight;
        _numLbl.font = [UIFont systemFontOfSize:12.f];
    }
    return _numLbl;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"意见反馈"];
    [super setupTopBarBackButton];
    [self.view addSubview:self.suggestTF];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.numLbl];
    [self createOfficialContects];
    [self.view addSubview:self.submitBtn];
    
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AddPic"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    //反馈意见的图片,仅限3张,
    if (indexPath.row == 3) {
        cell.hidden = YES;
    }else{
        cell.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    cell.promptLbl.hidden = YES;
    cell.titleLbl.hidden = YES;
    cell.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.imageView.clipsToBounds  = YES;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_uploadFiles removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pushImagePickerController];
    }else {
        // preview photos or video / 预览照片或者视频
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            [_collectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}


- (void)pushImagePickerController {
    
    TZImagePickerController * imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    // 目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets;
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerController
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _uploadFiles = [[NSMutableArray alloc] init];
        for (UIImage * originalImage in _selectedPhotos) {
            CGSize originalSize = originalImage.size;
            UIImage *image = originalImage;
            if (originalSize.width == kADMFeedbackImageSize && originalSize.height== kADMFeedbackImageSize) {
                //... originalImage
            } else {
                if (originalSize.width == originalSize.height) {
                    if (originalSize.width>kADMFeedbackImageSize) {
                        CGSize size = CGSizeMake(kADMFeedbackImageSize, kADMFeedbackImageSize);
                        UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    } else {
                        //... originalImage
                    }
                } else {
                    if (originalSize.width < kADMFeedbackImageSize && originalSize.height<kADMFeedbackImageSize) {
                        //... originalImage
                    } else {
                        
                        CGSize size = CGSizeMake(kADMFeedbackImageSize, kADMFeedbackImageSize);
                        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    }
                }
            }
            
            NSString *filePath = [AppDirs savefeedBackPicture:image fileName:nil];
            
            [_uploadFiles addObject:filePath];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
        
    });
    
}

-(void)createOfficialContects
{
    UILabel *officialContectsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.collectionView.frame)+10, kScreenWidth-30, 15)];
    officialContectsLbl.font = [UIFont systemFontOfSize:12.f];
    officialContectsLbl.textColor = [UIColor colorWithHexString:@"A7A7A7"];
    officialContectsLbl.textAlignment = NSTextAlignmentCenter;
    officialContectsLbl.text = @"官方微信: aidingmao007 官方QQ群: 246276941";
    _officialContectsLbl = officialContectsLbl;
    [self.view addSubview:self.officialContectsLbl];
}

- (void)submitBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    WEAKSELF;
    if ([_uploadFiles count]>0) {
        [[NetworkAPI sharedInstance] updaloadPics:_uploadFiles completion:^(NSArray *picUrlArray) {
            NSString * UrlString =[picUrlArray componentsJoinedByString:@","];
            [weakSelf submitFeedBack:UrlString];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [weakSelf submitFeedBack:nil];
    }
}

- (void)submitFeedBack:(NSString *)pictureUrl{
    WEAKSELF;
    //去除的特殊符号
    NSString *content = [_suggestTF.text trim];
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId],
                                 @"content":content?content:@"",
                                 @"image":pictureUrl?pictureUrl:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"platform" path:@"feedback" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        [WCAlertView showAlertWithTitle:@"提交成功,感谢反馈" message:@"我们会仔细阅读您的反馈，并作为后续改进的参考。" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            [AppDirs cleanupFeedBackDir];
            if (buttonIndex == 0) {
                [weakSelf dismiss];
            }
        } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
    } queue:nil]];
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    _numLbl.text = [NSString stringWithFormat:@"%ld/200",(long)[growingTextView.text length]];
    
    if ([growingTextView.text length]>0) {
        _submitBtn.selected = YES;
        _submitBtn.enabled = YES;
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
    }else{
        _submitBtn.selected = NO;
        _submitBtn.enabled = NO;
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([growingTextView.text length]<=200) {
        return YES;
    }
    return NO;
}


@end










