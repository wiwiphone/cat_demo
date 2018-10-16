//
//  FilterItemSubView.m
//  XianMao
//
//  Created by 阿杜 on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FilterItemSubView.h"
#import "Command.h"
#import "FilterSmallItemModel.h"
#import "FilterItemViewTwo.h"
#import "FilterItemModel.h"
#import "FilterButton.h"
#import "NSString+Addtions.h"

@interface FilterItemSubView()

@property (nonatomic, strong) NSMutableArray * tempArray;
@property (nonatomic, assign) NSInteger marginTop;
@property (nonatomic, strong) NSMutableArray * title;
@property (nonatomic, assign) NSInteger multiSelected;
@property (nonatomic, strong) FilterButton * selectTapButton;
@property (nonatomic, strong) UITextField * maxPriceTf;
@property (nonatomic, strong) UITextField * minPriceTf;
@property (nonatomic, strong) NSString * maxPrice;
@property (nonatomic, strong) NSString * minPrice;
@property (nonatomic, strong) UIView * line;

@end

@interface FilterItemSubView()<UITextFieldDelegate>

@end

@implementation FilterItemSubView

-(NSMutableArray *)title
{
    if (!_title) {
        _title = [[NSMutableArray alloc] init];
    }
    return _title;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)getFilterItemArray:(NSArray *)smallItemArray qk:(NSString *)qk multiSelected:(NSInteger)multiSelected filterArray:(NSArray *)filterArray
{
    int i = 0;
    self.multiSelected = multiSelected;
    CGFloat shopPriceChooseView = 0;
    for (FilterSmallItemModel * smallItems in smallItemArray) {
        
        FilterButton * button = [[FilterButton alloc] initWithFrame:CGRectMake(13 + ((self.width-20)/3)*(i%3), 40*(i/3), (self.width-36)/3, 0)];
        button.qk = qk;
        button.qv = smallItems.query_value;
        button.multi_selected = multiSelected;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:smallItems.title forState:UIControlStateNormal];
        [button sizeToFit];
        button.frame = CGRectMake(13 + ((self.width-20)/3)*(i%3), (button.height+15)*(i/3), (self.width-36)/3, button.height+10);
        button.titleLabel.numberOfLines = 2;
        button.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        button.tag = 200 +i;
        [self addSubview:button];
        
        if (filterArray.count > 0) {
            for (NSDictionary * dict in filterArray) {
                if ([button.qk isEqualToString:dict[@"qk"]] && [button.qv isEqualToString:dict[@"qv"]]) {
                    button.selected = YES;
                    [button setBackgroundColor:[UIColor colorWithHexString:@"666666"]];
                }else{
                    if ([dict[@"qk"] isEqualToString:@"shopPrice"]) {//显示自定义价格区间范围
                        NSString *qv = dict[@"qv"];
                        NSArray * qvArr = [qv componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" TO[]"]];
                        NSMutableArray * array = [NSMutableArray arrayWithArray:qvArr];
                        for (int i = 0; i < array.count; i++) {
                            [array removeObject:@""];
                        }
                        self.minPrice = [array objectAtIndex:0];
                        self.maxPrice = [array objectAtIndex:1];
                    }
                }
            }
        }
 
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        shopPriceChooseView = 40*(i/3);
        i++;
    }
    
    
    if ([qk isEqualToString:@"shopPrice"]) {
        [self createShopPriceChooseView:shopPriceChooseView];
    }
    
}

- (void)createShopPriceChooseView:(CGFloat)height 
{
    
    [self.minPriceTf removeFromSuperview];
    [self.maxPriceTf removeFromSuperview];
    [self.line removeFromSuperview];
    
    self.minPriceTf = [[UITextField alloc] initWithFrame:CGRectMake(13, height+60, 120, 30)];
    self.minPriceTf.placeholder = @"最低价";
    self.minPriceTf.layer.borderWidth = 1;
    self.minPriceTf.font = [UIFont systemFontOfSize:14];
    self.minPriceTf.keyboardType = UIKeyboardTypeNumberPad;
    if (self.minPrice.length > 0 && self.minPrice.integerValue >= 0) {
        self.minPriceTf.text = self.minPrice;
    }
    self.minPriceTf.textAlignment = NSTextAlignmentCenter;
    self.minPriceTf.delegate = self;
    self.minPriceTf.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    
    
    self.maxPriceTf = [[UITextField alloc] initWithFrame:CGRectMake(self.width-13-120, height+60, 120, 30)];
    self.maxPriceTf.placeholder = @"最高价";
    self.maxPriceTf.textAlignment = NSTextAlignmentCenter;
    self.maxPriceTf.keyboardType = UIKeyboardTypeNumberPad;
    self.maxPriceTf.layer.borderWidth = 1;
    if (self.maxPrice.length > 0 && self.maxPrice.integerValue > 0) {
        self.maxPriceTf.text = self.maxPrice;
    }
    self.maxPriceTf.font = [UIFont systemFontOfSize:14];
    self.maxPriceTf.delegate = self;
    self.maxPriceTf.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    
    [self addSubview:self.line];
    [self addSubview:self.minPriceTf];
    [self addSubview:self.maxPriceTf];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minPriceTf.mas_right).offset(10);
        make.right.equalTo(self.maxPriceTf.mas_left).offset(-10);
        make.centerY.equalTo(self.maxPriceTf.mas_centerY);
        make.height.equalTo(@1);
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i = 0; i < self.subviews.count; i++) {
        UIView * view = [self viewWithTag:200+i];
        if ([view isKindOfClass:[FilterButton class]]) {
            FilterButton * button = (FilterButton *)view;
            button.selected = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        }
    }
   
    if (self.minPriceTf.text.length > 0) {
        self.minPrice = [self.minPriceTf.text trim];;
    }else{
        self.minPrice = @"0";
    }

    if (self.maxPriceTf.text.length > 0) {
        self.maxPrice = [self.maxPriceTf.text trim];
    }else{
        self.maxPrice = @"*";
    }
    
    NSString * qv;
    if (![self.minPrice isEqualToString:@"0"] && ![self.maxPrice isEqualToString:@"*"]) {
        if (self.minPrice.integerValue > self.maxPrice.integerValue) {
            qv = [NSString stringWithFormat:@"[%@ TO %@]",self.maxPrice,self.minPrice];
        }else{
            qv = [NSString stringWithFormat:@"[%@ TO %@]",self.minPrice,self.maxPrice];
        }
    }else{
        qv = [NSString stringWithFormat:@"[%@ TO %@]",self.minPrice,self.maxPrice];
    }

    
    NSDictionary * dict = @{@"qv":qv,@"qk":@"shopPrice"};
    NSDictionary * status = @{@"multisSelected":[NSNumber numberWithBool:self.multiSelected],};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"overridePriceFilterSearch" object:status userInfo:dict];
}

//type==1的点击方法
-(void)buttonClick:(FilterButton *)sender
{
    if (self.multiSelected) { // 多选
        sender.selected = !sender.selected;
        
        
        if (sender.selected) {
            sender.backgroundColor = [UIColor colorWithHexString:@"666666"];
        }else{
            sender.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        }
        
        
    }else{
        
        
        NSInteger tag = sender.tag;
        for (int i = 0; i < self.subviews.count; i++) {
            FilterButton *btn = [self viewWithTag:i+200];
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




//type==0的点击方法
-(void)buttonClick2:(FilterButton *)sender
{
    if (self.multiSelected) { // 多选
        sender.selected = !sender.selected;
    }else{
        
        NSInteger tag = sender.tag;
        for (int i = 0; i < self.subviews.count; i++) {
            FilterButton *btn = [self viewWithTag:i+8000];
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

- (NSInteger)getFilterItemArray:(NSArray *)smallItemArray type:(NSInteger)type qk:(NSString *)qk multiSelected:(NSInteger)multiSelected filterArray:(NSArray *)filterArray
{
    
    NSInteger  height = 0;
    
    if (type == 0) {
        self.multiSelected = multiSelected;
        NSMutableDictionary * dict = [self behaviorClassification:smallItemArray];
        NSArray *allkeys = [dict allKeys];
        
        NSMutableArray * key = [[NSMutableArray alloc] initWithArray:allkeys];
        for (int i = 0; i < key.count; i++) {
            for (int j = i+1; j < key.count; j++) {
                if (key[i] > key[j]) {
                    [key exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        
        
        int marginTop = 0;
        for (int i = 0; i < key.count; i++) {
            NSArray * modelArray = [dict objectForKey:key[i]];
            UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(13, marginTop, self.width-13, 34)];
            bgView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            UILabel * group = [[UILabel alloc] initWithFrame:CGRectMake(30, marginTop, self.width-30, 34)];
            group.text = [key objectAtIndex:i];
            [self addSubview:bgView];
            [self addSubview:group];
            marginTop += 34;
            for (int j = 0; j < modelArray.count; j++) {
                FilterSmallItemModel * smallItem = [modelArray objectAtIndex:j];
                FilterButton * button = [[FilterButton alloc] initWithFrame:CGRectMake(30, marginTop, self.width-30, 0)];
                button.qk = qk;
                button.qv = smallItem.query_value;
                button.multi_selected = multiSelected;
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.textAlignment = NSTextAlignmentLeft;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [button setTitle:smallItem.title forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@   √",smallItem.title] forState:UIControlStateSelected];
                [button setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateSelected];
                [button sizeToFit];
                button.frame = CGRectMake(30, marginTop, self.width-30, button.height+10);
                button.backgroundColor = [UIColor whiteColor];
                button.tag = 8000+i;
                marginTop += 40;
                [button addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
                if (filterArray.count > 0) {
                    for (NSDictionary * dict in filterArray) {
                        if ([button.qk isEqualToString:dict[@"qk"]] && [button.qv isEqualToString:dict[@"qv"]]) {
                            button.selected = YES;
                        }
                    }
                }
            }
        }
        
        height = marginTop;
    }else if (type == 1){
        
        self.marginTop = 0;
        for (UIView * view in self.subviews) {
            [view removeFromSuperview];
        }
        
        for (int i = 0; i < smallItemArray.count; i++) {
            
            FilterItemModel * filterItem = [FilterItemModel createWithDict:[smallItemArray objectAtIndex:i]];
            NSInteger row = [self itemViewHight:filterItem];
            FilterItemViewTwo * itemView = [[FilterItemViewTwo alloc] initWithFrame:CGRectMake(0, self.marginTop, self.width, 40 * row+45 + 20)];
            itemView.userInteractionEnabled = YES;
            self.marginTop += 40 * row+45 + 2; 
            [itemView getFilterItemArray:filterItem qk:filterItem.query_key multiSelected:multiSelected filterArray:filterArray];
            [self addSubview:itemView];
        }
        height = self.marginTop;
    }
    
    return height;
}



//对品牌归类排序
-(NSMutableDictionary *)behaviorClassification:(NSArray *)model
{
    NSMutableDictionary * dataSource = [[NSMutableDictionary alloc] init];
    NSArray *modelList = model;
    NSMutableArray *others = [NSMutableArray array];
    
    for (int i = 0; i < modelList.count; i++) {
        FilterSmallItemModel * smallItem = [FilterSmallItemModel createWithDict:[modelList objectAtIndex:i]];
        char ch = [smallItem.title characterAtIndex:0];
        if (ch < 'A' || ch > 'z' || (ch > 'Z' && ch < 'a')) {
            [others addObject:smallItem];
            continue;
        }
        if (ch >= 'a' && ch <= 'z') {
            ch -= 32;
        }
        NSString *key = [NSString stringWithFormat:@"%c",ch];
        NSMutableArray *models = [NSMutableArray arrayWithArray:dataSource[key]];
        [models addObject:smallItem];
        [dataSource setObject:models forKey:key];
    }
    
    return dataSource;
}


-(NSInteger)itemViewHight:(FilterItemModel *)filterItem
{
    
    NSInteger row;
    
    NSArray * itemArray2 = filterItem.items;
    NSInteger count = itemArray2.count;
    if (count > 3*(count/3)) {
        row = count/3+1;
    }else{
        row = count/3;
    }
    
    return row;
}

@end
