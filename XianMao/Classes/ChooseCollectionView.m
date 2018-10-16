//
//  ChooseCollectionView.m
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ChooseCollectionView.h"
#import "ChooseCollectionViewCell.h"
#import "Masonry.h"

@interface ChooseCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) AttrEditableInfo *attrInfo;
@property (nonatomic, assign) NSInteger attr_id;

@end

static NSString *ID = @"ChooseCollectionCell";
@implementation ChooseCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[ChooseCollectionViewCell class] forCellWithReuseIdentifier:ID];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseBtn:) name:@"chooseBtn" object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)chooseBtn:(NSNotification *)notify{
    
    UIButton *btn = notify.object;
    
    for (id sender in self.subviews) {
        if ([sender isKindOfClass:[ChooseCollectionViewCell class]]) {
            ChooseCollectionViewCell *cell = (ChooseCollectionViewCell *)sender;
            for (id sender in cell.subviews) {
                if ([sender isKindOfClass:[UIView class]]) {
                    UIView *contentView = (UIView *)sender;
                    for (id sender in contentView.subviews) {
//                        NSLog(@"%@", sender);
//                        NSLog(@"%@", self.attrInfo);
                        if ([sender isKindOfClass:[UIButton class]]) {
                            UIButton *chooseBtn = (UIButton *)sender;
                            if (self.attrInfo.is_multi_choice == 0) {
                                chooseBtn.selected = NO;
                            }
                            if (chooseBtn == btn) {
                                chooseBtn.selected = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *title = self.dataArr[indexPath.row];
    
    cell.title = title;
//    cell.attrInfo = self.attrInfo;
    [cell getData:self.attrInfo];
    return cell;
}



-(void)upDataArr:(NSMutableArray *)dataArr editInfo:(AttrEditableInfo *)attrInfo{
    NSLog(@"%@", dataArr);
    self.dataArr = dataArr;
    self.attrInfo = attrInfo;
    self.attr_id = attrInfo.attrId;
}

@end
