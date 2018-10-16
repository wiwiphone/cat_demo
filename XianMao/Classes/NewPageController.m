//
//  NewPageController.m
//  NewPage
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewPageController.h"
#import "NewPageCollectionViewCell.h"
#import "AppDirs.h"
@interface NewPageController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *pageBackArr;
@property (nonatomic, assign) NSInteger len;
@property (nonatomic, weak) UIImageView *textImageView;
@property (nonatomic, strong) UIButton *logInButton;

@property (nonatomic, strong) UIPageControl *pageControl;
@end

static NSString *ID = @"MYCell";
@implementation NewPageController

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    }
    return _pageControl;
}

-(NSMutableArray *)pageBackArr{
    if (!_pageBackArr) {
        _pageBackArr = [[NSMutableArray alloc] init];
    }
    return _pageBackArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearNoticeCount];
    
    self.len = 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[NewPageCollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    
    
//    UIImage* textImage = [UIImage imageNamed:@"t1"];
//    UIImageView* textImageView = [[UIImageView alloc] initWithImage:textImage];
//    textImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 240 / 2, kScreenHeight / 2 + 50, 255, 58);
//    textImageView.alpha = 0;
//    [UIView animateWithDuration:0.25 animations:^{
//        textImageView.alpha = 1;
//        textImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 240 / 2, kScreenHeight / 2 - 100, 255, 58);
//    }];
    
    UIButton *logInButton = [[UIButton alloc] init];
//    logInButton.backgroundColor = [UIColor redColor];
    [logInButton setImage:[UIImage imageNamed:@"LogIn"] forState:UIControlStateNormal];
    self.logInButton = logInButton;
    
    [collectionView addSubview:logInButton];
//    [collectionView addSubview:textImageView];
//    self.textImageView = textImageView;
    
    [self.view addSubview:collectionView];
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.len;
    self.pageControl.currentPage = 0;
    self.pageControl.tintColor = [UIColor clearColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.logInButton addTarget:self action:@selector(pushMainController) forControlEvents:UIControlEventTouchUpInside];
}

//新版本第一次启动清空本地notice缓存
- (void)clearNoticeCount {
    NSString *cacheFile = [AppDirs noticeListCacheFile];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:0] forKey:@"noticeCount"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"notice"];
    [archiver finishEncoding];
    [data writeToFile:cacheFile atomically:YES];
}

-(void)pushMainController{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchRootController" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPageImage" object:nil];
    [self dismiss:NO];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageControl setCurrentPage:offset.x / bounds.size.width];
    
//    int page = offsetX / [UIScreen mainScreen].bounds.size.width;
//
//    NSString* textImageName = [NSString stringWithFormat:@"t%d", page + 1];
//    UIImage *image = [UIImage imageNamed:textImageName];
//    self.textImageView.image = image;
//    self.textImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 240 / 2 + offsetX, kScreenHeight / 2 + 50, 255, 58);
//    self.textImageView.alpha = 0;
//    
//    NSLog(@"%f", offsetX);
    if (offsetX <= kScreenWidth*3 && offsetX >= kScreenWidth*2) {
//        self.textImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 60 / 2 + offsetX, kScreenHeight / 2 - 140, 60, 250);
//        self.textImageView.alpha = 0;
        if (kScreenWidth == 320) {
            self.logInButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 114 / 2 + offsetX, [UIScreen mainScreen].bounds.size.height - 90, 114, 41);
        } else {
            self.logInButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 114 / 2 + offsetX, [UIScreen mainScreen].bounds.size.height - 100, 114, 41);
        }
        
        self.logInButton.alpha = 0;
        
        self.logInButton.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.logInButton.alpha = 1;
            self.logInButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            nil;
        }];
    }
//
//    [UIView animateWithDuration:0.25
//                     animations:^{
//                         
//                         if (offsetX <= 1242 && offsetX >= 960) {
//                             self.textImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 60 / 2 + offsetX, kScreenHeight / 2 - 135, 60, 250);
//                             self.textImageView.alpha = 1;
//                         } else {
//                             self.textImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 240 / 2 + offsetX, kScreenHeight / 2 - 100, 255, 58);
//                             self.textImageView.alpha = 1;
//                         }
//                         
////                         self.logInButton.frame = CGRectMake(1230, 0, 150, 50);
//                         
//                     }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.len;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
//    if ((indexPath.row + 1) / 2 == 1) {
//        cell.contentView.backgroundColor = [UIColor redColor];
//    } else {
//        cell.contentView.backgroundColor = [UIColor greenColor];
//    }
    NSString* imageName = [NSString stringWithFormat:@"newpage%ld", indexPath.row + 1];
    
    cell.imageName = [UIImage imageNamed:imageName];
    
    return cell;
}

@end
