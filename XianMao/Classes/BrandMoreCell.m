//
//  BrandMoreCell.m
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BrandMoreCell.h"
#import "Masonry.h"
#import "PublishGoodsViewController.h"
#import "CategoryService.h"
#import "BrandInfo.h"
#import "SearchViewController.h"
#import "ExploreViewController.h"

@interface BrandMoreCell () <PublishSelectViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *brandArr;

@end

@implementation BrandMoreCell

-(NSMutableArray *)brandArr{
    if (!_brandArr) {
        _brandArr = [[NSMutableArray alloc] init];
    }
    return _brandArr;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BrandMoreCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 50.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BrandMoreCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [BrandService getBrandList:0 completion:^(NSArray *fechtedBrandList) {
            
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
                    [self.brandArr addObject:[PublishSelectableItem buildSelectableItem:name summary:nil isSelected:0 attatchedItem:brandInfo]];
                }
            }
        } failure:^(XMError *error) {
            nil;
        }];
        
        UIButton *moreBtn = [[UIButton alloc] init];
        [moreBtn setTitle:@"查看更多品牌" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"8e8e93"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        moreBtn.layer.borderColor = [UIColor colorWithHexString:@"8e8e93"].CGColor;
        moreBtn.layer.borderWidth = 0.5;
        moreBtn.layer.masksToBounds = YES;
        moreBtn.layer.cornerRadius = 2;
        [self.contentView addSubview:moreBtn];
        
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@117);
            make.height.equalTo(@25);
        }];
        
        [moreBtn addTarget:self action:@selector(pushChooseBrandVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)pushChooseBrandVC{
//    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
//    viewController.title = @"选择品牌";
//    viewController.delegate = self;
//    viewController.isGroupedWithName = YES;
//    viewController.isSupportSearch = YES;
//    viewController.cate_id = 0;
//    viewController.selectableItemArray = self.brandArr;
//    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    ExploreBrandViewController *explore = [[ExploreBrandViewController alloc] init];
    explore.isShowTitleBar = YES;
    [[CoordinatingController sharedInstance] pushViewController:explore animated:YES];
}

-(void)publishDidSelect:(PublishSelectViewController *)viewController selectableItem:(PublishSelectableItem *)selectableItem{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    BrandInfo *brandInfo = (BrandInfo *)selectableItem.attachedItem;
    searchVC.searchKeywords = brandInfo.brandName;
    [viewController pushViewController:searchVC animated:YES];
}

@end
