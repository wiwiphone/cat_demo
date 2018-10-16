//
//  SeekToPurchasePublishController.m
//  XianMao
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SeekToPurchasePublishController.h"
#import "Command.h"
#import "PictureItemsEditViewForConsignment.h"
#import "MineSeekViewController.h"
#import "UIImage+Resize.h"
#import "WCAlertView.h"
#import "DataListLogic.h"
#import "RecommendVo.h"
#import "GlobalSeekBannerVo.h"
#import "HPGrowingTextView.h"

#define kADMImageSize 800
@interface SeekToPurchasePublishController () <UITextViewDelegate, PictureItemsEditViewForConsignmentDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *lineViewLeft;
@property (nonatomic, strong) UIView *lineViewRight;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) CommandButton *mineSeek;
@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) UILabel *plaTextViewLbl;
@property (nonatomic, strong) CommandButton *sureBtn;
@property (nonatomic, strong) GlobalSeekBannerVo * globalSeekBannerVo;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, strong) HTTPRequest * request;
@property (nonatomic, strong) PictureItemsEditViewForConsignment *picView;
@property (nonatomic, strong) NSArray *pictrueItemArr;
@property (nonatomic, strong) NSMutableArray *uploadFiles;
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) NSArray *pictreus;
@property (nonatomic, strong) XMWebImageView * seekBanner;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) RedirectInfo *redirectInfo;
@property (nonatomic, strong) VerticalCommandButton * addPicButton;
@property (nonatomic, strong) UIView * line;
@end

@implementation SeekToPurchasePublishController

-(NSArray *)pictreus{
    if (!_pictreus) {
        _pictreus = [[NSArray alloc] init];
    }
    return _pictreus;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectNull];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}

- (XMWebImageView *)seekBanner{
    if (!_seekBanner) {
        _seekBanner = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _seekBanner.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _seekBanner;
}

-(NSMutableArray *)picArr{
    if (!_picArr) {
        _picArr = [[NSMutableArray alloc] init];
    }
    return _picArr;
}

-(CommandButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_sureBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _sureBtn.backgroundColor = [DataSources colorf9384c];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 6;
    }
    return _sureBtn;
}

-(PictureItemsEditViewForConsignment *)picView{
    if (!_picView) {
        _picView = [[PictureItemsEditViewForConsignment alloc] initWithFrame:CGRectMake(5, 400, kScreenWidth-10, 140)];
        _picView.maxImagesCount = 9;
        _picView.isNeedPushViewCtrl = NO;
        _picView.delegate = self;
        _picView.defautViewHeight = 140;
        _picView.backgroundColor = [UIColor redColor];
        _picView.userInteractionEnabled = YES;
    }
    return _picView;
}

-(HPGrowingTextView *)textView{
    if (!_textView) {
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.autoRefreshHeight = NO;
        _textView.placeholder = @"描述下你想要的品牌、品类、成色、期望价，以及是否愿意付定金.";
        _textView.animateHeightChange = NO;
    }
    return _textView;
}

-(CommandButton *)mineSeek{
    if (!_mineSeek) {
        _mineSeek = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_mineSeek setTitle:@" 我的找货" forState:UIControlStateNormal];
        [_mineSeek setImage:[UIImage imageNamed:@"seek_mine_seek"] forState:UIControlStateNormal];
        [_mineSeek setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _mineSeek.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_mineSeek sizeToFit];
    }
    return _mineSeek;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)networkRequest {
    WEAKSELF;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getGlobalSeekDetail:^(NSDictionary *data) {
        GlobalSeekBannerVo * globalSeekBannerVo = [GlobalSeekBannerVo createWithDict:data];
        if (globalSeekBannerVo && [globalSeekBannerVo isKindOfClass:[GlobalSeekBannerVo class]]) {
            _globalSeekBannerVo = globalSeekBannerVo;
        }
        [weakSelf hideLoadingView];
        [weakSelf.view addSubview:weakSelf.scrollView];
        [weakSelf.scrollView addSubview:weakSelf.seekBanner];
        [weakSelf.scrollView addSubview:weakSelf.textView];
        [weakSelf.scrollView addSubview:weakSelf.picView];
        [weakSelf.scrollView addSubview:weakSelf.sureBtn];
        [weakSelf.scrollView addSubview:weakSelf.mineSeek];
        [weakSelf.scrollView addSubview:weakSelf.line];
        [weakSelf.picView addSubview:weakSelf.addPicButton];
        [weakSelf setData];
        [weakSelf setUpUI:0];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        [weakSelf loadEndWithError];
    }];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [super setupTopBar];
    [super setupTopBarTitle:@"全球找货"];
    [super setupTopBarBackButton];
    
    [self networkRequest];
    
    
    
    WEAKSELF;
    self.mineSeek.handleClickBlock = ^(CommandButton *sender){
        MineSeekViewController *viewController = [[MineSeekViewController alloc] init];
        [weakSelf pushViewController:viewController animated:YES];
    };
    
    [self.sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setData{
    
    
    CGFloat height = 0;
    CGFloat width = 0;
    if (_globalSeekBannerVo.banner.list && _globalSeekBannerVo.banner.list.count > 0) {
        RedirectInfo *redirectInfo = [RedirectInfo createWithDict:[_globalSeekBannerVo.banner.list objectAtIndex:0]];
        if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
            height = redirectInfo.height;
            width = redirectInfo.width;
            _redirectInfo = redirectInfo;
        }
        [_seekBanner setImageWithURL:redirectInfo.imageUrl XMWebImageScaleType:XMWebImageScaleNone];
    }
    
    _textView.placeholder = _globalSeekBannerVo.desc;
}

-(void)clickSureBtn{
    WEAKSELF;
    if ([self isFinish]) {
        [weakSelf showProcessingHUD:@""];
        if ([_uploadFiles count]>0) {
            [[NetworkAPI sharedInstance] updaloadPics:_uploadFiles completion:^(NSArray *picUrlArray) {
                NSMutableArray *picArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < picUrlArray.count; i++) {
                    UIImage *image = self.pictreus[i];
                    NSDictionary *dict = @{@"pic_url":picUrlArray[i], @"pic_desc":@"", @"width":@(image.size.width) ,@"height":@(image.size.height)};
                    [picArr addObject:dict];
                }
                //                        weakSelf.picArr = picArr;
                
                NSDictionary *params = @{@"content":self.textView.text, @"attachment":picArr};
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"user_need" path:@"publish" parameters:params completionBlock:^(NSDictionary *data) {
                    [weakSelf hideHUD];
                    
                    [WCAlertView showAlertWithTitle:@"提交成功" message:@"不论是否找到，爱丁猫顾问都会在7天之内给您留言答复~" customizationBlock:^(WCAlertView *alertView) {
                        
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        [weakSelf dismiss];
                    } cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
                } queue:nil]];
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        } else {
            NSMutableArray *picArr = [[NSMutableArray alloc] init];
            NSDictionary *params = @{@"content":self.textView.text, @"attachment":picArr};
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"user_need" path:@"publish" parameters:params completionBlock:^(NSDictionary *data) {
                [[CoordinatingController sharedInstance] hideHUD];
                
                [WCAlertView showAlertWithTitle:@"提交成功" message:@"不论是否找到，爱丁猫顾问都会在7天之内给您留言答复~" customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    [weakSelf dismiss];
                } cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                
            } failure:^(XMError *error) {
                [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:1.2f];
            } queue:nil]];
        }
    }
}

-(BOOL)isFinish{
    BOOL handle = YES;
    
    if (self.textView.text.length == 0) {
        [[CoordinatingController sharedInstance] showHUD:@"请填写描述信息" hideAfterDelay:1.2];
        handle = NO;
    }
    
    //    if (_uploadFiles.count == 0) {
    //        [[CoordinatingController sharedInstance] showHUD:@"请添加图片" hideAfterDelay:1.2];
    //        handle = NO;
    //    }
    
    return handle;
}

-(void)setUpUI:(CGFloat)height{
    self.margin = 0;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(65.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.seekBanner.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*_redirectInfo.height/_redirectInfo.width);
    self.margin += kScreenWidth*_redirectInfo.height/_redirectInfo.width;
    if (height == 0) {
        height = 140;
    }
    self.picView.frame = CGRectMake(5, self.margin, kScreenWidth-10, height);
    self.margin += self.picView.height;
    
    self.line.frame = CGRectMake(15, self.margin, kScreenWidth, 0.5);
    self.margin += 15.5;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15.5);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@90);
    }];
    self.margin += 90;
    self.margin += 12;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(12);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@45);
    }];
    self.margin += 45;
    
    [self.mineSeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12);
    }];

    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.margin+40);
}

- (void)imagePickerDidFinishPickingPhotos:(CGFloat)height picTrueItem:(NSArray *)pictreus{
    WEAKSELF;
    if (pictreus.count > 0) {
        self.addPicButton.hidden = YES;
    }else{
        self.addPicButton.hidden = NO;
    }
    self.pictreus = pictreus;
    [self setUpUI:height];
    _pictrueItemArr = [NSArray arrayWithArray:pictreus];
    [AppDirs clearupSeekDir];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _uploadFiles = [[NSMutableArray alloc] init];
        for (UIImage * originalImage in _pictrueItemArr) {
            CGSize originalSize = originalImage.size;
            UIImage *image = originalImage;
            if (originalSize.width == kADMImageSize && originalSize.height== kADMImageSize) {
                //... originalImage
            } else {
                if (originalSize.width == originalSize.height) {
                    if (originalSize.width>kADMImageSize) {
                        CGSize size = CGSizeMake(kADMImageSize, kADMImageSize);
                        UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    } else {
                        //... originalImage
                    }
                } else {
                    if (originalSize.width < kADMImageSize && originalSize.height<kADMImageSize) {
                        //... originalImage
                    } else {
                        
                        CGSize size = CGSizeMake(kADMImageSize, kADMImageSize);
                        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    }
                }
            }
            
            NSString *filePath = [AppDirs saveSeekPicture:image fileName:nil];
            
            [_uploadFiles addObject:filePath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        
    });
    
}


@end
