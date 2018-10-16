//
//  SearchSiftView.m
//  XianMao
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchSiftView.h"
#import "FilterItemView.h"
#import "FilterModel.h"
#import "FilterItemModel.h"
#import "Command.h"

@interface SearchSiftView()<FilterItemViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) NSInteger marginTop;
@property (nonatomic, strong) FilterItemView * itemView;
@property (nonatomic, strong) CommandButton * resetBtn;
@property (nonatomic, strong) CommandButton * finishBtn;
@property (nonatomic, strong) NSArray * itemsArray;
@property (nonatomic, copy) NSString * keyworlds; //记录关键词,避免itemView重复添加
@property (nonatomic, strong) NSMutableArray * heightArray;
@property (nonatomic, strong) NSMutableArray * itemSubViewHeightArray;
@property (nonatomic, strong) NSMutableArray * FilterArray;

@end

@implementation SearchSiftView


-(NSMutableArray *)itemSubViewHeightArray
{
    if (!_itemSubViewHeightArray) {
        _itemSubViewHeightArray = [[NSMutableArray alloc] init];
    }
    return _itemSubViewHeightArray;
}

-(CommandButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [[CommandButton alloc] init];
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_resetBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    }
    return _resetBtn;
}

-(CommandButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[CommandButton alloc] init];
        _finishBtn.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _finishBtn;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
    }
    return _scrollView;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.resetBtn];
        [self addSubview:self.finishBtn];
        
        WEAKSELF;
        _resetBtn.handleClickBlock = ^(CommandButton * sender){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetSearchFilter" object:nil];
        };
        _finishBtn.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.handleFinishButtonClick) {
                weakSelf.handleFinishButtonClick();
            }
        };
    }
    return self;
}

-(void)getFilterModel:(FilterModel *)filterModel keyworlds:(NSString *)keyworlds array:(NSMutableArray *)FilterArray
{
    NSArray * itemsArray = filterModel.items;
    self.FilterArray = FilterArray;
    self.itemsArray = itemsArray;
    self.keyworlds = keyworlds;
    [self createItemView:FilterArray];
    
}

-(void)createItemView:(NSArray *)filterArray
{
    
    self.heightArray = [[NSMutableArray alloc] init];
    self.marginTop = 0;
    for (UIView * view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.itemsArray.count; i++) {
        
        [heightArray addObject:[NSNumber numberWithInteger:self.marginTop]];
        
        FilterItemModel * filterItem = [FilterItemModel createWithDict:[self.itemsArray objectAtIndex:i]];
        NSInteger row = [self itemViewHight:filterItem];
        FilterItemView * itemView = [[FilterItemView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.width, 40 * row+45 + 20)];
        self.marginTop += 40 * row+45 + 20;
        itemView.tag = 100 + i;
        itemView.delegate = self;
        CGFloat itemSubViewHeight = [itemView getFilterItemArray:filterItem viewTag:itemView.tag filterArray:filterArray];
        if (i==0) {
            itemView.isHiddenLine = YES;
        }
        //记录每个itewView高度
        [self.heightArray addObject:[NSNumber numberWithInteger:40 * row+45 + 20]];
        //记录每个itemSubView高度,,防止itemSubview超出父视图button无法点击
        [self.itemSubViewHeightArray addObject:[NSNumber numberWithFloat:itemSubViewHeight]];
        [self.scrollView addSubview:itemView];
    }

    self.scrollView.contentSize = CGSizeMake(self.width, self.marginTop);
    
    [self customUI];
}

-(void)customUI
{
    UIView * container = [UIView new];
    
    
//    for (UIView * view in container.subviews) {
//        if ([view isKindOfClass:[FilterItemView class]]) {
//            [view removeFromSuperview];
//        }
//    }
    
    [self.scrollView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        
    }];
    
    __block FilterItemView * lastview = nil;
    for (int i = 0; i < self.itemsArray.count+1; ++i) {
        FilterItemView * subView = [self viewWithTag:100+i];
        [container addSubview:subView];
        
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(container);
            make.height.mas_equalTo(@([self.heightArray[i] integerValue]+5000));//+5000是为了防止子视图超出父视图button无法点击
            
            if (lastview.isShowSubItem) {
                if (lastview) {//lastview表示每一个cell上面的cell
                    make.top.mas_equalTo(lastview.itemSubView.mas_bottom);
                } else {
                    make.top.mas_equalTo(self.scrollView);
                }
                
            }else{
                
                if (lastview) {
                    make.top.mas_equalTo(lastview.mas_bottom).offset(-5000);
                } else {
                    make.top.mas_equalTo(self.scrollView);
                }
            }
            
            lastview = subView;
        }];
    }
    
    //起到设置scrollView.contentSize的作用
    if (lastview.isShowSubItem) {
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastview.itemSubView.mas_bottom);
        }];
    }else{
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastview.mas_bottom).offset(-5000);
        }];
    }
}

-(void)moreButtonClick:(NSInteger)height viewTag:(NSInteger)tag
{
    
    //在滚动视图添加一个一样大小的view
    UIView * container = [UIView new];
    
    
    for (UIView * view in container.subviews) {
        if ([view isKindOfClass:[FilterItemView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self.scrollView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        
    }];
    
    __block FilterItemView * lastview = nil;
    for (int i = 0; i < self.itemsArray.count+1; ++i) {
        FilterItemView * subView = [self viewWithTag:100+i];
        [container addSubview:subView];
        
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(container);
            make.height.mas_equalTo(@([self.heightArray[i] integerValue]+5000));//+5000是为了防止子视图超出父视图button无法点击
            
            if (lastview.isShowSubItem) {
                if (lastview) {//lastview表示每一个cell上面的cell
                    make.top.mas_equalTo(lastview.itemSubView.mas_bottom);
                } else {
                    make.top.mas_equalTo(self.scrollView);
                }
                
            }else{
                
                if (lastview) {
                    make.top.mas_equalTo(lastview.mas_bottom).offset(-5000);
                } else {
                    make.top.mas_equalTo(self.scrollView);
                }
            }
            
            lastview = subView;
        }];
    }
    
    //起到设置scrollView.contentSize的作用
    if (lastview.isShowSubItem) {
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastview.itemSubView.mas_bottom);
        }];
    }else{
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastview.mas_bottom).offset(-5000);
        }];
    }
    
}


-(NSInteger)itemViewHight:(FilterItemModel *)filterItem
{
    
    NSInteger row;
    NSDictionary * dict = filterItem.fixed_sfi;
    FilterModel * filterModel = [FilterModel createWithDict:dict];
    NSArray * itemArray2 = filterModel.items;
    NSInteger count = itemArray2.count;
    if (count > 3*(count/3)) {
        row = count/3+1;
    }else{
        row = count/3;
    }

    return row;
}

//-(NSInteger)itemViewHight:(FilterItemModel *)filterItem
//{
//    
//    NSInteger row;
//    NSDictionary * dict = filterItem.fixed_sfi;
//    if (!kDictIsEmpty(dict)) {
//        FilterModel * filterModel = [FilterModel createWithDict:dict];
//        NSArray * itemArray2 = filterModel.items;
//        NSInteger count = itemArray2.count;
//        if (count > 3*(count/3)) {
//            row = count/3+1;
//        }else{
//            row = count/3;
//        }
//    }else if (filterItem.is_spread){
//        NSArray * itemArray2 = filterItem.items;
//        NSInteger count = itemArray2.count;
//        if (count > 3*(count/3)) {
//            row = count/3+1;
//        }else{
//            row = count/3;
//        }
//    }
//    return row;
//}

-(NSInteger)itemViewHight2:(FilterItemModel *)filterItem
{
    
    NSInteger row;
    NSDictionary * dict = filterItem.fixed_sfi;
    if (!kDictIsEmpty(dict)) {
        FilterModel * filterModel = [FilterModel createWithDict:dict];
        NSArray * itemArray2 = filterModel.items;
        NSInteger count = itemArray2.count;
        if (count > 3*(count/3)) {
            row = count/3+1;
        }else{
            row = count/3;
        }
        
    }else if (filterItem.is_spread){
        row = 0;
    }
    return row;
}





-(NSInteger)itemViewHightWith:(NSArray *)array
{
    NSInteger row;
    NSInteger count = array.count;
    if (count > 3*(count/3)) {
        row = count/3+1;
    }else{
        row = count/3;
    }
    return row;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 20, self.width, self.height-20-40);
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_bottom).offset(-40);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resetBtn.mas_right);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.resetBtn.mas_top);
        make.bottom.equalTo(self.resetBtn.mas_bottom);
    }];
}
@end
