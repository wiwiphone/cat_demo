//
//  FindADMAdviseView.m
//  XianMao
//
//  Created by 阿杜 on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FindADMAdviseView.h"
#import "XMWebImageView.h"
#import "NetworkAPI.h"
#import "AdviserPage.h"
#import "URLScheme.h"
#import "Command.h"
#import "PictureItemsEditViewForConsignment.h"
#import "MineSeekViewController.h"
#import "GlobalSeekBannerVo.h"
#import "SeekToPurchasePublishController.h"
#import "UIImage+Resize.h"
#import "WCAlertView.h"
#import "HPGrowingTextView.h"


#define kADMImageSize 800
@interface FindADMAdviseView() <UITextViewDelegate, PictureItemsEditViewForConsignmentDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *lineViewLeft;
@property (nonatomic, strong) UIView *lineViewRight;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) CommandButton *mineSeek;
@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) UILabel *plaTextViewLbl;
@property (nonatomic, strong) CommandButton *sureBtn;
@property (nonatomic, strong) UILabel *resultLbl;
@property (nonatomic, strong) GlobalSeekBannerVo *globalSeekBannerVo;
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, strong) PictureItemsEditViewForConsignment *picView;
@property (nonatomic, strong) NSArray *pictrueItemArr;
@property (nonatomic, strong) NSMutableArray *uploadFiles;
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) NSArray *pictreus;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) HTTPRequest *request;

@end

@implementation FindADMAdviseView

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

-(NSMutableArray *)picArr{
    if (!_picArr) {
        _picArr = [[NSMutableArray alloc] init];
    }
    return _picArr;
}

-(UILabel *)resultLbl{
    if (!_resultLbl) {
        _resultLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _resultLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _resultLbl.textAlignment = NSTextAlignmentCenter;
        _resultLbl.font = [UIFont systemFontOfSize:15.f];
        _resultLbl.numberOfLines = 0;
        [_resultLbl sizeToFit];
    }
    return _resultLbl;
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
        _picView.defautViewHeight = 145;
        _picView.backgroundColor = [UIColor redColor];
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
        [_mineSeek setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _mineSeek.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_mineSeek sizeToFit];
    }
    return _mineSeek;
}


-(UIView *)lineViewRight{
    if (!_lineViewRight) {
        _lineViewRight = [[UIView alloc] initWithFrame:CGRectZero];
        _lineViewRight.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    }
    return _lineViewRight;
}

-(UIView *)lineViewLeft{
    if (!_lineViewLeft) {
        _lineViewLeft = [[UIView alloc] initWithFrame:CGRectZero];
        _lineViewLeft.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    }
    return _lineViewLeft;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    }
    return _scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self networkRequest];
       
        self.mineSeek.handleClickBlock = ^(CommandButton *sender){
            MineSeekViewController *viewController = [[MineSeekViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        [self.sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)networkRequest {
    WEAKSELF;
    _request = [[NetworkAPI sharedInstance] getGlobalSeekDetail:^(NSDictionary *data) {
        GlobalSeekBannerVo * globalSeekBannerVo = [GlobalSeekBannerVo createWithDict:data];
        if (globalSeekBannerVo && [globalSeekBannerVo isKindOfClass:[GlobalSeekBannerVo class]]) {
            _globalSeekBannerVo = globalSeekBannerVo;
        }
        [weakSelf addSubview:weakSelf.scrollView];
        [weakSelf.scrollView addSubview:weakSelf.resultLbl];
        [weakSelf.scrollView addSubview:weakSelf.textView];
        [weakSelf.scrollView addSubview:weakSelf.picView];
        [weakSelf.scrollView addSubview:weakSelf.sureBtn];
        [weakSelf.scrollView addSubview:weakSelf.mineSeek];
        [weakSelf.scrollView addSubview:weakSelf.line];
        [weakSelf setData];
        [weakSelf setUpUI:0];
    } failure:^(XMError *error) {
        [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
    }];
}

- (void)setData{
    _textView.placeholder = _globalSeekBannerVo.desc;
}

-(void)clickSureBtn{
    WEAKSELF;
    if ([self isFinish]) {
        [[CoordinatingController sharedInstance] showProcessingHUD:@""];
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
                    [[CoordinatingController sharedInstance] hideHUD];
                    
                    [WCAlertView showAlertWithTitle:@"提交成功" message:@"不论是否找到，爱丁猫顾问都会在7天之内给您留言答复~" customizationBlock:^(WCAlertView *alertView) {
                        
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        if (weakSelf.successBack) {
                            weakSelf.successBack();
                        }
                    } cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    
                } failure:^(XMError *error) {
                    [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:1.2f];
                } queue:nil]];
                
            } failure:^(XMError *error) {
                [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        } else {
            NSMutableArray *picArr = [[NSMutableArray alloc] init];
            NSDictionary *params = @{@"content":self.textView.text, @"attachment":picArr};
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"user_need" path:@"publish" parameters:params completionBlock:^(NSDictionary *data) {
                [[CoordinatingController sharedInstance] hideHUD];
                
                [WCAlertView showAlertWithTitle:@"提交成功" message:@"不论是否找到，爱丁猫顾问都会在7天之内给您留言答复~" customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    if (weakSelf.successBack) {
                        weakSelf.successBack();
                    }
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

-(void)setSearchKey:(NSString *)searchKey{
    _searchKey = searchKey;
    self.resultLbl.text = [NSString stringWithFormat:@"抱歉,没有找到与 “%@” 相关的商品", searchKey];
}

-(void)setUpUI:(CGFloat)height{
    self.margin = 0;
    self.margin += 20;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.resultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(20);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
    }];
    self.margin += self.resultLbl.height;
    
    self.margin += 200;
    if (height == 0) {
        height = 140;
    }
    self.picView.frame = CGRectMake(5, self.margin, kScreenWidth-10, height);
    self.margin += self.picView.height;
    
    self.margin += 28;
    self.line.frame = CGRectMake(15, self.margin, kScreenWidth, 0.5);
    self.margin += 15.5;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15.5);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@90);
    }];
    self.margin += 90;
    self.margin += 12;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(12);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@45);
    }];
    self.margin += 45;
    
    [self.mineSeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];

    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.margin+40);
}

- (void)imagePickerDidFinishPickingPhotos:(CGFloat)height picTrueItem:(NSArray *)pictreus{
    
    WEAKSELF;
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
