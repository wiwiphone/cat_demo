//
//  FilterItemViewTwo.m
//  XianMao
//
//  Created by 阿杜 on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FilterItemViewTwo.h"
#import "FilterSmallItemModel.h"
#import "Command.h"
#import "FilterButton.h"

@interface FilterItemViewTwo()

@property (nonatomic, strong) UILabel * itemName;
@property (nonatomic, assign) NSInteger multisSelected; //判断多选单选
@property (nonatomic, assign) FilterButton * selectTapButton;

@end

@implementation FilterItemViewTwo

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


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.itemName];
    }
    return self;
}

- (void)getFilterItemArray:(FilterItemModel *)filterItem qk:(NSString *)qk multiSelected:(NSInteger)multiSelected filterArray:(NSArray *)filterArray
{
    self.itemName.text = filterItem.name;
    self.multisSelected = multiSelected;
    NSArray * itemArray = filterItem.items;

    //添加标签
    int i = 0;
    for (NSDictionary * dict in itemArray) {
        FilterSmallItemModel * smallItems = [FilterSmallItemModel createWithDict:dict];
        FilterButton * button = [[FilterButton alloc] initWithFrame:CGRectMake(13 + ((self.width-20)/3)*(i%3), 40*(i/3)+45, (self.width-36)/3, 0)];
        button.qv = smallItems.query_value;
        button.qk = qk;
        button.multi_selected = multiSelected;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:smallItems.title forState:UIControlStateNormal];
        [button sizeToFit];
        button.frame = CGRectMake(13 + ((self.width-20)/3)*(i%3), (button.height+15)*(i/3)+45, (self.width-36)/3, button.height+10);
        button.titleLabel.numberOfLines = 2;
        button.tag = 10000+i;
        button.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self addSubview:button];
        if (filterArray.count > 0) {
            for (NSDictionary * dict in filterArray) {
                if ([button.qk isEqualToString:dict[@"qk"]] && [button.qv isEqualToString:dict[@"qv"]]) {
                    button.selected = YES;
                    [button setBackgroundColor:[UIColor colorWithHexString:@"666666"]];
                }
            }
        }
        [button addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        
        
    }else{  //单选
        NSInteger tag = sender.tag;
        for (int i = 0; i < self.subviews.count; i++) {
            FilterButton *btn = [self viewWithTag:i+10000];
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
    
    [self.itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(14);
        make.left.equalTo(self.mas_left).offset(13);
    }];
    
}

@end
