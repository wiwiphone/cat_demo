//
//  LoadingCell.m
//  XianMao
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LoadingCell.h"
#import "LoadingView.h"

@interface LoadingCell ()

@property (nonatomic, strong) UILabel *loadLbl;
@property (nonatomic, strong) LoadingView *loadView;

@end

@implementation LoadingCell

-(UILabel *)loadLbl{
    if (!_loadLbl) {
        _loadLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _loadLbl.font = [UIFont systemFontOfSize:15.f];
        _loadLbl.text = @"加载中...";
    }
    return _loadLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([LoadingCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 300;
    
    NSMutableArray *arr = dict[@"nickArrCount"];
    if (arr.count > 0) {
        height = 300*arr.count;
    }
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)nickArrCount
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[LoadingCell class]];
    if (nickArrCount.count > 0) {
        [dict setObject:nickArrCount forKey:@"nickArrCount"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    [self showLoadingView];
    [self.loadView addSubview:self.loadLbl];
    
    [self.loadLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(100);
    }];
    
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [self showLoadingView:self.contentView];
    self.loadView = view;
    view.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (LoadingView*)showLoadingView:(UIView*)forView {
    LoadingView *loadingView = [self createLoadingView:forView];
    [loadingView showLoadingView];
    return loadingView;
}

- (LoadingView*)createLoadingView:(UIView*)forView {
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:forView.bounds];
    [forView addSubview:loadingView];
    return loadingView;
}

+(NSString *)cellDictForkey
{
    return @"LoadingCell";
}

@end
