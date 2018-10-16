//
//  SearchTopNewView.m
//  XianMao
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchTopNewView.h"
#import "SearchFilterInfo.h"
#import "SearchViewController.h"
#import "NetworkManager.h"

@interface SearchTopNewView ()

@property (nonatomic, assign) NSInteger itemNum;

@end

@implementation SearchTopNewView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
//
//        WEAKSELF;
//        for (NSInteger i=0;i<4;i++) {
//            SearchFilterTopItemView *itemView = [[SearchFilterTopItemView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
//            [self addSubview:itemView];
//            X += width;
//            X += 8.f;
//            [itemView addTarget:self action:@selector(topItemClicked:) forControlEvents:UIControlEventTouchUpInside];
//            itemView.hidden = YES;
//            
//            typeof(SearchFilterTopItemView*) __weak weakTopItemView = itemView;
//            itemView.chosingView.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
////                if (weakTopItemView
////                    && weakSelf.handleTopItemCancelTapDetected) {
////                    weakSelf.handleTopItemCancelTapDetected(weakTopItemView);
////                }
//            };
//        }
        
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"paixu_item_list" parameters:nil completionBlock:^(NSDictionary *data) {
            
            CGFloat X = 8.f;
            CGFloat height = 30.f;
            CGFloat Y = (51-height)/2;
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
//                    [itemView setImage:[UIImage imageNamed:@"Search_Sift"] forState:UIControlStateNormal];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSearchView" object:dict];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadSearchView" object:nil];
}

//-(void)topItemClicked:(SearchFilterTopItemView *)sender{
//    
//    if (sender.selected == YES) {
//        sender.selected = NO;
//        if (self.handleTopItemCancelTapDetected) {
//            self.handleTopItemCancelTapDetected(sender);
//        }
//    } else {
//        sender.selected = YES;
//        if (self.handleTopItemTapDetected) {
//            self.handleTopItemTapDetected(sender);
//        }
//    }
//}
//
- (void)updateByFilterInfos:(NSArray*)filterInfos
{
//    for (UIView *view in [self subviews]) {
//        view.hidden = YES;
//    }
//    for (NSInteger i=0;i<[filterInfos count];i++) {
//        SearchFilterInfo * filterInfo = [filterInfos objectAtIndex:i];
//        if (i<[self.subviews count]) {
//            SearchFilterTopItemView *itemView = (SearchFilterTopItemView*)[self.subviews objectAtIndex:i];
//            itemView.hidden = NO;
//            itemView.tag = i+10;
//            itemView.filterInfo = filterInfo;
//            [itemView setTitle:filterInfo.name forState:UIControlStateNormal];
//        }
//    }
//    
//    [self updateTopItemsSelectedState];
}

- (void)updateTopItemsSelectedState
{
    for (SearchFilterTopItemView *itemView in [self subviews]) {
        [itemView setChosingState:NO];
        [itemView setSelected:NO];
        
        if (![itemView isHidden]) {
            SearchFilterInfo * filterInfo = itemView.filterInfo;
            if (filterInfo.type == 0) {
                for (SearchFilterItem *item in filterInfo.items) {
                    if (item.isYesSelected) {
                        [itemView setTitle:item.title forState:UIControlStateNormal];
                        [itemView setChosingState:NO];
                        [itemView setSelected:YES]; //removed
                        break;
                    }
                }
            }
            else if (filterInfo.type == 1) {
                [itemView setChosingState:NO];
                BOOL selected = NO;
                for (SearchFilterInfo *filterInfoSub in filterInfo.items)  {
                    if (filterInfoSub.type == 0) {
                        for (SearchFilterItem *item in filterInfoSub.items) {
                            if (item.isYesSelected && [item isKindOfClass:[SearchFilterItem class]]) {
                                selected = YES; //removed
                                [itemView setTitle:item.title forState:UIControlStateNormal];
                                [itemView setSelected:selected];
                                break;
                            }
                        }
                    } else if (filterInfoSub.type == 1) {
                        for (SearchFilterInfo *filterInfoSubT in filterInfo.items)  {
                            if (filterInfoSubT.type == 0) {
                                for (SearchFilterItem *item in filterInfoSubT.items) {
                                    if (item.isYesSelected && [item isKindOfClass:[SearchFilterItem class]]) {
                                        selected = YES; //removed
                                        [itemView setTitle:item.title forState:UIControlStateNormal];
                                        [itemView setSelected:selected];
                                        break;
                                    }
                                }
                            } else if (filterInfoSub.type == 1) {
                                for (SearchFilterInfo *filterInfoSubT in filterInfo.items)  {
                                    if (filterInfoSubT.type == 0) {
                                        for (SearchFilterItem *item in filterInfoSubT.items) {
                                            if (item.isYesSelected && [item isKindOfClass:[SearchFilterItem class]]) {
                                                selected = YES; //removed
                                                [itemView setTitle:item.title forState:UIControlStateNormal];
                                                [itemView setSelected:selected];
                                                break;
                                            }
                                        }
                                    } else if (filterInfoSub.type == 1) {
                                        
                                    }
                                    if (selected) break;
                                }
                            }
                            if (selected) break;
                        }
                    }
                    if (selected) break;
                }
            }
        }
    }
}

- (NSArray*)filterInfos {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (SearchFilterTopItemView *itemView in [self subviews]) {
        if ([itemView isKindOfClass:[SearchFilterTopItemView class]]) {
            if (![itemView isHidden] && itemView.filterInfo) {
                [array addObject:itemView.filterInfo];
            }
        }
    }
    return array;
}


@end
