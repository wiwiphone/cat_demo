//
//  LaunchPageView.m
//  XianMao
//
//  Created by simon cai on 21/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "LaunchPageView.h"

#import "AppDelegate.h"
#import "BaseService.h"
#import "AppDirs.h"
#import "BaseService.h"
#import "RecommendTableViewCell.h"

#import "WeakTimerTarget.h"
#import "URLScheme.h"

#import "LaunchBottomView.h"

#import "NSDate+Category.h"
@interface LaunchPageView ()
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) UIImageView *defaultLaunchView;
@property(nonatomic,strong) XMWebImageView *imageView;
@property(nonatomic,strong) RedirectInfo *redirectInfo;
@property (nonatomic, strong) LaunchBottomView *bottomView;

@property (nonatomic, strong) UIButton *timeView;
@property (nonatomic, strong) UILabel *timeTitle;
@property (nonatomic, strong) UILabel *timeSubLbl;
@property (nonatomic, strong) WeakTimerTarget *weakTimerTarget;

@end

NSInteger timetime = 4;
@implementation LaunchPageView

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

-(UILabel *)timeSubLbl{
    if (!_timeSubLbl) {
        _timeSubLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeSubLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _timeSubLbl.font = [UIFont systemFontOfSize:12.f];
        _timeSubLbl.text = @"4 s";
        [_timeSubLbl sizeToFit];
    }
    return _timeSubLbl;
}


-(UILabel *)timeTitle{
    if (!_timeTitle) {
        _timeTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeTitle.textColor = [UIColor colorWithHexString:@"434342"];
        _timeTitle.font = [UIFont systemFontOfSize:12.f];
        _timeTitle.text = @"跳过";
        [_timeTitle sizeToFit];
    }
    return _timeTitle;
}

-(UIButton *)timeView{
    if (!_timeView) {
        _timeView = [[UIButton alloc] initWithFrame:CGRectZero];
        _timeView.backgroundColor = [UIColor whiteColor];
        _timeView.layer.masksToBounds = YES;
        _timeView.layer.cornerRadius = 46/2;
    }
    return _timeView;
}

-(LaunchBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[LaunchBottomView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

+ (UIImage *)launchImage {
    // search 'UILaunchImages' in documentation
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 7 or later
        NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary *dict in imagesDict) {
            if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeFromString(dict[@"UILaunchImageSize"]))) {
                return [UIImage imageNamed:dict[@"UILaunchImageName"]];
            }
        }
    }
    // Load resources for iOS 6.1 or earlier
    NSString *launchImageName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImageFile"];
    // iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
            return [UIImage imageNamed:[launchImageName stringByAppendingString:@"-Portrait"]];
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
            return [UIImage imageNamed:[launchImageName stringByAppendingString:@"-Landscape"]];
        // TODO: Portrait (Exclude Status Bar) / Landscape (Exclude Status Bar)
    }
    // iPhone5
    if (iPhone5) {
        return [UIImage imageNamed:[launchImageName stringByAppendingString:@"-568h"]];
    }
    return [UIImage imageNamed:launchImageName];
}

+ (void)showLaunchView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone)
    {
        LaunchPageView *view = [[LaunchPageView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [view show];
    }
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"000000"];
        self.userInteractionEnabled = YES;
        
        _defaultLaunchView = [[UIImageView alloc] initWithFrame:self.bounds];
        _defaultLaunchView.backgroundColor = [UIColor whiteColor];
        _defaultLaunchView.contentMode = UIViewContentModeScaleAspectFill;
        _defaultLaunchView.image =  [[self class] launchImage];
        [self addSubview:_defaultLaunchView];
        
        _imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        WEAKSELF;
//        [self addSubview:self.bottomView];
//        self.bottomView.frame = CGRectMake(0, kScreenHeight-142, kScreenWidth, 142);//*(kScreenWidth/375)
        
        [self addSubview:self.timeView];
        [self.timeView addSubview:self.timeTitle];
        [self.timeView addSubview:self.timeSubLbl];
        [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(24);
            make.right.equalTo(self.mas_right).offset(-22);
            make.width.equalTo(@46);
            make.height.equalTo(@46);
        }];
        
        
        
        [self.timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeView.mas_top).offset(8);
            make.centerX.equalTo(self.timeView.mas_centerX);
        }];
        
        [self.timeSubLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.timeView.mas_bottom).offset(-8);
            make.centerX.equalTo(self.timeView.mas_centerX);
        }];
        
        [self.timeView addTarget:self action:@selector(clickJumpTimer) forControlEvents:UIControlEventTouchUpInside];
        
        _imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            
            if (weakSelf.redirectInfo
                && [weakSelf.redirectInfo.redirectUri length]>0) {
                [URLScheme locateWithRedirectUri:weakSelf.redirectInfo.redirectUri andIsShare:YES];
            }
            
            [weakSelf dismiss:^(BOOL finished) {
            }];
        };
    }
    return self;
}

- (void)show
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self removeFromSuperview];
    self.contentMode = UIViewContentModeScaleAspectFill;
    [appDelegate.window addSubview:self];
    [appDelegate.window bringSubviewToFront:self];
    
    [PlatformService launchPage:^(NSArray *redirectList) {
            for (LaunchPageInfo *info in redirectList) {
                if ([info isKindOfClass:[LaunchPageInfo class]]
                    && [info.redirectInfo.imageUrl length]>0) {
                    NSString *url = [XMWebImageView imageUrlToQNImageUrl:info.redirectInfo.imageUrl isWebP:NO size:CGSizeMake(kScreenWidth*2, kScreenHeight*2)];
                    
                    if (![[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:url]]) {
                        if ([NetworkManager sharedInstance].isReachableViaWiFi) {
                            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                                            options:SDWebImageLowPriority
                                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                               NSLog(@"%@",[imageURL absoluteString]);
                                                                           }];
                        }
                    }
                }
            }
    } failure:^(XMError *error) {
    }];
    
    WEAKSELF;
    
    NSArray *array = [PlatformService loadRedirectListFromFile];
    if ([array count]>0) {
        LaunchPageInfo *info = [array objectAtIndex:0];
        
        self.redirectInfo = info.redirectInfo;
            
            self.timeSubLbl.hidden = NO;
            self.timeTitle.hidden = NO;
            self.timeView.hidden = NO;
        
        NSString *url = [XMWebImageView imageUrlToQNImageUrl:info.redirectInfo.imageUrl isWebP:NO size:CGSizeMake(kScreenWidth*2, kScreenHeight*2)];
        
        UIImage * memoryImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:url];
        if (!memoryImage) {
            memoryImage = [[SDWebImageManager.sharedManager imageCache] imageFromDiskCacheForKey:url];
        }
        if (memoryImage) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.defaultLaunchView.alpha = 0.;
            } completion:^(BOOL finished) {
                weakSelf.imageView.image = nil;
                CATransition *animation = [CATransition animation];
                animation.delegate       = nil;
                animation.duration       = 0.5;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                animation.type           = kCATransitionFade;
                weakSelf.imageView.image   = memoryImage;
                [[weakSelf.imageView layer] addAnimation:animation forKey:@"animation"];
            }];
        } else {
            [_imageView setImageWithURL:info.redirectInfo.imageUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, kScreenHeight*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
        }
        
        
        
        [_timer invalidate];
        WeakTimerTarget *weakTimerTarget = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:6.f target:weakTimerTarget selector:@selector(timerDidFire:) userInfo:nil repeats:NO];
        weakSelf.weakTimerTarget = weakTimerTarget;
    } else {
        self.timeSubLbl.hidden = YES;
        self.timeTitle.hidden = YES;
        self.timeView.hidden = YES;
        [_timer invalidate];
        WeakTimerTarget *weakTimerTarget = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:weakTimerTarget selector:@selector(timerDidFire:) userInfo:nil repeats:NO];
        weakSelf.weakTimerTarget = weakTimerTarget;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeJian) userInfo:nil repeats:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    _imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

-(void)clickJumpTimer{
    [self.weakTimerTarget timerDidFire:_timer];
    [self onTimer:_timer];
}


-(void)timeJian{
    if (timetime >= 0) {
        self.timeSubLbl.text = [NSString stringWithFormat:@"%ld s", timetime--];
    } else {
        self.timeSubLbl.text = [NSString stringWithFormat:@"0 s"];
    }
    
    if (timetime < 0) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void)onTimer:(NSTimer*)theTimer
{
    [_timer invalidate];
    _timer = nil;
    [self dismiss:nil];
}

- (void)dismiss:(void (^)(BOOL finished))completion
{
    WEAKSELF;
    CGRect endFrame = CGRectMake(-self.width, 0, self.width, self.height);
    endFrame = CGRectMake(-[UIScreen mainScreen].bounds.size.width * 0.5, -[UIScreen mainScreen].bounds.size.height * 0.5, [UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height * 2);
    [UIView animateWithDuration:0.5 animations:^{
        //        self.frame = endFrame;
        weakSelf.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPageImage" object:nil];
        if (completion) {
            completion(finished);
        }
    }];
}

@end



