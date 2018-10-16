//
//  ChooseCollectionViewCell.m
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ChooseCollectionViewCell.h"
#import "Masonry.h"

@interface ChooseCollectionViewCell ()

@property (nonatomic, weak) UIButton *chooseBtn;
@property (nonatomic, strong) AttrEditableInfo *attrInfo;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ChooseCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.index = 0;
        
        UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        chooseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [chooseBtn setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [chooseBtn.layer setBorderColor:[UIColor colorWithHexString:@"b4b4b5"].CGColor];
        [chooseBtn.layer setBorderWidth:1];
        [chooseBtn.layer setMasksToBounds:YES];
        [self.contentView addSubview:chooseBtn];
        self.chooseBtn = chooseBtn;
        [chooseBtn addTarget:self action:@selector(clickChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickChooseBtn:(UIButton *)senders{
    
    
    
//    for (id sender in self.subviews) {
//        if ([sender isKindOfClass:[UIView class]]) {
//            UIView *contentView = (UIView *)sender;
//            for (id sender in contentView.subviews) {
//                NSLog(@"%@", sender);
//                if ([sender isKindOfClass:[UIButton class]]) {
//                    UIButton *chooseBtn = (UIButton *)sender;
//                    chooseBtn.selected = NO;
//                    if (chooseBtn == senders){
//                        chooseBtn.selected = YES;
//                    }
//                }
//            }
//        }
//    }
    
    
    
//    sender.selected = YES;
//    NSString *str = sender.titleLabel.text;
////    for (NSString *str in self.attrInfo.values) {
////        if (![str isEqualToString:sender.titleLabel.text]) {
////            if ([sender.titleLabel.text isEqualToString:str]) {
////                sender.selected = NO;
////            }
////        }
//    for (int i = 0; i < self.attrInfo.values.count; i++) {
//        if ([sender.titleLabel.text isEqualToString:str]) {
//            sender.selected = YES;
//        }
//    }
    if (self.attrInfo.is_multi_choice == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseBtn" object:senders];
    } else {
//        if (self.index == 0) {
//            senders.selected = YES;
//            self.index = 1;
//        } else if (self.index == 1) {
//            senders.selected = NO;
//            self.index = 0;
//        }
        if (senders.selected == NO) {
            senders.selected = YES;
        } else {
            senders.selected = NO;
        }
        
    }
    
    if (senders.selected == YES) {
        NSDictionary *dict = @{@"button" : senders, @"attr" : self.attrInfo};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getDataChoose" object:dict];
    }
    
    if (self.attrInfo.is_multi_choice == 1) {
        if (senders.selected == NO) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remDataChoose" object: senders];
        }
    }
    
//    }
}

//-(void)setAttrInfo:(AttrEditableInfo *)attrInfo{
//    _attrInfo = attrInfo;
//}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getData:(AttrEditableInfo *)attrInfo{
    self.attrInfo = attrInfo;
    if ([attrInfo.attrName isEqualToString:@"配件"]) {
        NSString *nstring = attrInfo.attrValue;
        NSArray *array = [nstring componentsSeparatedByString:@","];
        for (int i = 0; i < [array count]; i++) {
            NSLog(@"string:%@", [array objectAtIndex:i]);
            if ([self.chooseBtn.titleLabel.text isEqualToString:[array objectAtIndex:i]]) {
                self.chooseBtn.selected = YES;
            }
        }
    } else {
        if ([self.chooseBtn.titleLabel.text isEqualToString:attrInfo.attrValue]) {
            self.chooseBtn.selected = YES;
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self.chooseBtn setTitle:title forState:UIControlStateNormal];
    NSLog(@"%@", title);
}


@end
