//
//  FilterItemView.m
//  XianMao
//
//  Created by 阿杜 on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FilterItemView.h"
#import "FilterItemModel.h"
#import "FilterModel.h"
#import "FilterSmallItemModel.h"
#import "Command.h"
#import "FilterItemSubView.h"
#import "FilterButton.h"
#import "SearchSiftGradeViewController.h"


@interface FilterItemView()

@property (nonatomic, strong) UILabel * itemName;
@property (nonatomic, strong) FilterItemModel * filterItem;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) NSMutableArray * itemArray;
@property (nonatomic, strong) NSMutableArray * tempArray; //记录点击展开的item;
@property (nonatomic, assign) NSInteger viewTag;
@property (nonatomic, assign) NSInteger multisSelected; //判断多选单选
@property (nonatomic, assign) NSInteger marginTop;
@property (nonatomic, assign) FilterButton * selectTapButton;
@property (nonatomic, strong) TapDetectingImageView * icon;


@end

@implementation FilterItemView


-(NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

-(NSMutableArray *)tempArray
{
    if (!_tempArray) {
        _tempArray = [[NSMutableArray alloc] init];
    }
    return _tempArray;
}

-(FilterItemSubView *)itemSubView
{
    if (!_itemSubView) {
        _itemSubView = [[FilterItemSubView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth-70, 200)];
        _itemSubView.userInteractionEnabled = YES;
    }
    return _itemSubView;
}

-(UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"pulldown"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"pullup"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

-(TapDetectingImageView *)icon
{
    if (!_icon) {
        _icon = [[TapDetectingImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"Grade"];
    }
    return _icon;
}

-(UILabel *)itemName
{
    if (!_itemName) {
        _itemName = [[UILabel alloc] init];
        _itemName.textColor = [UIColor colorWithHexString:@"333333"];
        _itemName.font = [UIFont systemFontOfSize:14];
        [_itemName sizeToFit];
    }
    return _itemName;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.itemName];
        [self addSubview:self.line];
        [self addSubview:self.moreBtn];
        self.line.hidden = self.isHiddenLine;
        [self addSubview:self.itemSubView];
        [self addSubview:self.icon];
        self.icon.hidden = YES;
        self.itemSubView.alpha = 0;
        
        self.icon.handleSingleTapDetected = ^(TapDetectingImageView * icon,UIGestureRecognizer * recognizer){
            SearchSiftGradeViewController * grade = [[SearchSiftGradeViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:grade animated:YES];
        };
    }
    return self;
}

-(void)setIsHiddenLine:(BOOL)isHiddenLine
{
    self.line.hidden = isHiddenLine;
}



- (CGFloat)getFilterItemArray:(FilterItemModel *)filterItem viewTag:(NSInteger)tag filterArray:(NSArray *)filterArray
{
    self.filterItem = filterItem;
    self.viewTag = tag;
    self.itemName.text = self.filterItem.name;
    NSDictionary * dict = self.filterItem.fixed_sfi;
    
    if ([filterItem.query_key isEqualToString:@"grade"]) {
        self.icon.hidden = NO;
    }else{
        self.icon.hidden = YES;
    }
    
    FilterModel * filterModel = [FilterModel createWithDict:dict];
    NSArray * itemArray2 = filterModel.items;
    NSInteger row = [self itemViewHight:itemArray2];
    self.marginTop = 40*row+45+20;
    
    _moreBtn.selected = kDictIsEmpty(dict);
    
    if (!kDictIsEmpty(dict)) {
        
        FilterModel * filterModel = [FilterModel createWithDict:dict];
        self.multisSelected = filterModel.multi_selected;
        NSArray * itemArray = filterModel.items;
        //添加标签
        for (NSDictionary * dict in itemArray) {
            FilterSmallItemModel * smallItems = [FilterSmallItemModel createWithDict:dict];
            [self.itemArray addObject:smallItems];
        }
        
        NSInteger height = [self.itemSubView getFilterItemArray:self.filterItem.items type:self.filterItem.type qk:self.filterItem.query_key multiSelected:filterModel.multi_selected filterArray:filterArray];
        self.isShowSubItem = NO;
        self.itemSubView.frame = CGRectMake(0, self.marginTop, kScreenWidth-70, height+20);
        [self addItmes:filterModel.query_key multisSelected:filterModel.multi_selected filterArray:filterArray];
    }else if(filterItem.is_spread){
        NSArray * itemArray = filterItem.items;
        //添加标签
        for (NSDictionary * dict in itemArray) {
            FilterSmallItemModel * smallItems = [FilterSmallItemModel createWithDict:dict];
            [self.itemArray addObject:smallItems];
        }
        NSInteger row = [self itemViewHight:self.itemArray];
        self.isShowSubItem = YES;
        self.itemSubView.frame = CGRectMake(0, self.marginTop, kScreenWidth-70, 50*row);
        if ([filterItem.query_key isEqualToString:@"shopPrice"]) {//自定义价格筛选
            self.itemSubView.frame = CGRectMake(0, self.marginTop, kScreenWidth-70, 50*row+100);
        }
        [self.itemSubView getFilterItemArray:self.itemArray qk:filterItem.query_key multiSelected:filterItem.multi_selected filterArray:filterArray];
    }
    
    
    CGFloat itemSubViewHeight = self.itemSubView.frame.size.height;
    return itemSubViewHeight;
    
}




-(NSInteger)itemViewHight:(NSArray *)array
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


-(void)buttonClick:(UIButton *)button
{
    
    button.selected = !button.selected;
    self.isShowSubItem = !self.isShowSubItem;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreButtonClick:viewTag:)]) {
        [self.delegate moreButtonClick:500 viewTag:self.tag];
    }
    
}

-(void)setIsShowSubItem:(BOOL)isShowSubItem
{
    _isShowSubItem = isShowSubItem;
    self.itemSubView.hidden = !isShowSubItem;
    [UIView animateWithDuration:0.25f animations:^{
        if (isShowSubItem) {
            self.itemSubView.alpha = 1;
        } else {
            self.itemSubView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addItmes:(NSString *)qk multisSelected:(NSInteger)multisSelected filterArray:(NSArray *)filterArray
{
  
    int i = 0;
    for (FilterSmallItemModel * smallItems in self.itemArray) {
        
        FilterButton * button = [[FilterButton alloc] initWithFrame:CGRectMake(13 + ((self.width-20)/3)*(i%3), 40*(i/3)+45, (self.width-36)/3, 0)];
        button.qk = qk;
        button.qv = smallItems.query_value;
        button.multi_selected = multisSelected;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:smallItems.title forState:UIControlStateNormal];
        [button sizeToFit];
        button.frame = CGRectMake(13 + ((self.width-20)/3)*(i%3), (button.height+15)*(i/3)+45, (self.width-36)/3, button.height+10);
        button.titleLabel.numberOfLines = 2;
        button.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        button.tag = 10+i;
        [self addSubview:button];
        [button addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (filterArray.count > 0) {
            for (NSDictionary * dict in filterArray) {
                if ([button.qk isEqualToString:dict[@"qk"]] && [button.qv isEqualToString:dict[@"qv"]]) {
                    button.selected = YES;
                    [button setBackgroundColor:[UIColor colorWithHexString:@"666666"]];
                }
            }
        }
        
        
        i++;
    }
}


-(void)filterButtonClick:(FilterButton *)sender
{
    if (self.multisSelected) { // 多选
        sender.selected = !sender.selected;
        
        
        if (sender.selected) {
            sender.backgroundColor = [UIColor colorWithHexString:@"666666"];
        }else{
            sender.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        }
        
        
    }else{
        
        NSInteger tag = sender.tag;
        for (int i = 0; i < self.subviews.count; i++) {
            FilterButton *btn = [self viewWithTag:i+10];
            if (btn.tag == tag && btn.isSelected == 1) {
                btn.selected = NO;
                btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                break ;
            }
            if (btn.tag == tag) {
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithHexString:@"666666"];
            } else {
                btn.selected = NO;
                btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            }
        }
        
    }
    NSDictionary * dict = @{@"qv":sender.qv,@"qk":sender.qk};
    NSDictionary * buttonStatus = @{@"multisSelected":[NSNumber numberWithBool:sender.multi_selected],@"buttonIsSeclected":[NSNumber numberWithBool:sender.selected]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"filterSearch" object:buttonStatus userInfo:dict];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(14);
        make.left.equalTo(self.mas_left).offset(13);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.itemName.mas_centerY);
        make.left.equalTo(self.mas_right).offset(-34);
        make.height.equalTo(@40);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.itemName.mas_centerY);
        make.left.equalTo(self.itemName.mas_right).offset(10);
    }];
    
}

@end
