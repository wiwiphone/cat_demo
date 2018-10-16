//
//  ADMShoppingSiftView.m
//  XianMao
//
//  Created by apple on 16/9/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ADMShoppingSiftView.h"
#import "Command.h"
#import "SearchFilterInfo.h"
#import "NetworkManager.h"
#import "SearchViewController.h"

@interface ADMShoppingSiftView ()

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *btnsView;
@property (nonatomic, assign) NSInteger itemNum;

@end

@implementation ADMShoppingSiftView

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _bottomLineView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
//        UIView *btnsView = [[UIView alloc] initWithFrame:CGRectZero];
//        btnsView.backgroundColor = [UIColor clearColor];
//        [self addSubview:btnsView];
//        _btnsView = btnsView;
//        
//        for (NSInteger i=0;i<4;i++) {
//            UserHomeFilterButton *btn = [[UserHomeFilterButton alloc] initWithFrame:CGRectMake(0+(kScreenWidth/4*i), 0, kScreenWidth/4, 44)];
//            btn.backgroundColor = [UIColor clearColor];
//            btn.hidden = YES;
////            btn.layer.borderColor = [UIColor colorWithHexString:@"E8E8E8"].CGColor;
////            btn.layer.borderWidth = 0.5f;
////            btn.layer.masksToBounds = YES;
//            [_btnsView addSubview:btn];
//        }
//
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"paixu_item_list" parameters:nil completionBlock:^(NSDictionary *data) {
            
            CGFloat X = 8.f;
            CGFloat height = 30.f;
            CGFloat Y = (44-height)/2;
            CGFloat width = (kScreenWidth-5*8)/4;
            
            NSArray *listArr = [data arrayValueForKey:@"result"];
            for (int i = 0; i < listArr.count+1; i++) {
                SearchFilterInfo *filterInfo = nil;
                if (i<3) {
                    filterInfo = [[SearchFilterInfo alloc] initWithDict:listArr[i]];
                    NSLog(@"%@", filterInfo);
                } else {
                    filterInfo = [[SearchFilterInfo alloc] init];
                    filterInfo.name = @"筛选";
                }
                
                SearchFilterTopItemView *itemView = [[SearchFilterTopItemView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
                [itemView setTitle:filterInfo.name forState:UIControlStateNormal];
                itemView.titleLabel.font = [UIFont systemFontOfSize:14.f];
                [itemView setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
                [itemView setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
                itemView.filterInfo = filterInfo;
                
                if (i == 3) {
                    [itemView setImage:[UIImage imageNamed:@"Search_Sift"] forState:UIControlStateNormal];
                } else {
                    if (filterInfo.items.count > 1) {
                        [itemView setImage:[UIImage imageNamed:@"Search_PriceChoose"] forState:UIControlStateNormal];
                    } else {
                        [itemView setImage:nil forState:UIControlStateNormal];
                    }
                }
                
                CGFloat imageW = itemView.imageView.width;
                CGFloat labelW = itemView.titleLabel.width;
                
                itemView.imageEdgeInsets = UIEdgeInsetsMake(0, labelW, 0, -labelW);
                itemView.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW);
                
                itemView.tag = i+1;
                [self addSubview:itemView];
                X += width;
                X += 8.f;
                
                [itemView addTarget:self action:@selector(handleItemViewClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:self.bottomLineView];
            
        } failure:^(XMError *error) {
            
        } queue:nil]];
        
    }
    return self;
}

-(void)handleItemViewClick:(SearchFilterTopItemView *)sender{
    
    if (sender.filterInfo.queryKey == nil) {
        //        if (sender.selected) {
        //            sender.selected = NO;
        //        } else {
        //            sender.selected = YES;
        //        }
        
        if (self.showSiftView) {
            self.showSiftView();
        }
        
        return;
    } else {
        for (SearchFilterTopItemView *itemView in self.subviews) {
            if ([itemView isKindOfClass:[SearchFilterTopItemView class]]) {
                
                if (itemView.tag == sender.tag) {
                    if (sender.filterInfo.items.count > 1) {
                        if (self.itemNum == 0) {
                            self.itemNum = 1;
                            [sender setImage:[UIImage imageNamed:@"Search_PriceChoose_Down"] forState:UIControlStateSelected];
                            sender.selected = YES;
                        } else {
                            self.itemNum = 0;
                            [sender setImage:[UIImage imageNamed:@"Search_PriceChoose_Up"] forState:UIControlStateSelected];
                            sender.selected = YES;
                        }
                    } else {
                        self.itemNum = 0;
                        if (sender.selected) {
                            
                        } else {
                            if (sender.selected) {
                                sender.selected = NO;
                            } else {
                                sender.selected = YES;
                            }
                        }
                    }
                    
                } else {
                    if (itemView.filterInfo.queryKey == nil) {
                        
                    } else {
                        itemView.selected = NO;
                    }
                }
            }
        }
    }
    
    NSDictionary *dict = @{@"filterInfo":sender.filterInfo, @"itemNum":@(self.itemNum)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSearchViews" object:dict];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadSearchViews" object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    _btnsView.frame = self.bounds;
//    
//    NSInteger count = 0;
//    for (UIView *view in _btnsView.subviews) {
//        if (![view isHidden]) {
//            count+=1;
//        }
//    }
//    if (count > 0) {
//        CGFloat width = (self.width+0.5*2)/count+(count-0.5);
//        CGFloat X = -0.5f;
//        CGFloat Y = 0.f;
//        for (UIView *view in _btnsView.subviews) {
//            if (view.isHidden) {
//                break;
//            }
//            view.frame = CGRectMake(X, Y, width, self.height);
//            X += view.width;
//            X -= 0.5;
//        }
//    }
//    
//    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//        make.height.equalTo(@1);
//    }];
    
}

-(void)getFilterInfoArray:(NSMutableArray *)filterInfoArray{
    
//    for (int i = 0; i < filterInfoArray.count; i++) {
//        SearchFilterInfo *filterInfo = filterInfoArray[i];
//        
//        CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(0+(kScreenWidth/filterInfoArray.count)*i, 0, kScreenWidth/filterInfoArray.count, 44)];
//        [btn setTitle:filterInfo.name forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//        [btn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
//        [self addSubview:btn];
//        
//        btn.handleClickBlock = ^(CommandButton *sender){
//            if (sender.selected == NO) {
//                sender.selected = YES;
//                
//            } else {
//                sender.selected = NO;
//            }
//        };
//    }
    
//    for (UserHomeFilterButton *btn in self.subviews) {
//        if ([btn isKindOfClass:[UserHomeFilterButton class]]) {
//            [btn removeFromSuperview];
//        }
//    }
//    
//    WEAKSELF;
//    if ([filterInfoArray isKindOfClass:[NSArray class]]) {
//        for (NSInteger i=0;i<[filterInfoArray count];i++) {
//            SearchFilterInfo *filterInfo = [filterInfoArray objectAtIndex:i];
//            if ([filterInfo.items count]>=2 && i+1<[_btnsView.subviews count]) {
//                SearchFilterItem *filterItem = nil;
//                for (SearchFilterItem *filterItemTmp in filterInfo.items) {
//                    if (filterItemTmp.isSelected) {
//                        filterItem = filterItemTmp;
//                        break;
//                    }
//                }
//                
////                UserHomeFilterButton *btn = (UserHomeFilterButton*)[_btnsView.subviews objectAtIndex:i+1];
//                UserHomeFilterButton *btn = [[UserHomeFilterButton alloc] initWithFrame:CGRectMake(0+(filterInfoArray.count*i), 0, kScreenWidth/filterInfoArray.count, 44)];
//                [btn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
//                btn.titleLabel.font = [UIFont systemFontOfSize:12.5f];
//                btn.hidden = NO;
//                btn.filterInfo = filterInfo;
//                if (filterItem) {
//                    [btn setTitle:filterItem.title forState:UIControlStateNormal];
//                    btn.selected = YES;
//                } else {
//                    [btn setTitle:filterInfo.name forState:UIControlStateNormal];
//                }
//                [self addSubview:btn];
//                btn.handleClickBlock = ^(CommandButton *sender) {
//                    if (sender.selected == NO) {
//                        sender.selected = YES;
//                    } else {
//                        sender.selected = NO;
//                    }
//                    if (filterItem) {
//                        sender.selected = YES;
//                    }
//                    if (weakSelf.handleFilterButtonActionBlock) {
//                        BOOL hanldLed = NO;
//                        SearchFilterInfo *filterInfoTmp = ((UserHomeFilterButton*)sender).filterInfo;
//                        for (NSInteger j=0;j<filterInfoTmp.items.count;j++) {
//                            SearchFilterItem *itemTmp1 = (SearchFilterItem*)[filterInfoTmp.items objectAtIndex:j];
//                            if (itemTmp1.isSelected) {
//                                itemTmp1.isSelected = NO;
//                                if (j+1<filterInfoTmp.items.count) {
//                                    SearchFilterItem *itemTmp2 = (SearchFilterItem*)[filterInfoTmp.items objectAtIndex:j+1];
//                                    itemTmp2.isSelected = YES;
//                                    hanldLed = YES;
//                                    [sender setTitle:itemTmp2.title forState:UIControlStateNormal];
//                                    break;
//                                }
//                            }
//                        }
//                        if (!hanldLed && [filterInfoTmp.items count]>0) {
//                            SearchFilterItem *itemTmp3 = (SearchFilterItem*)[filterInfoTmp.items objectAtIndex:0];
//                            itemTmp3.isSelected = YES;
//                            [sender setTitle:itemTmp3.title forState:UIControlStateNormal];
//                        }
//                        weakSelf.handleFilterButtonActionBlock(filterInfoTmp);
//                    }
//                };
//            }
//        }
//    }
    
}

@end


@implementation UserHomeFilterButton



@end
