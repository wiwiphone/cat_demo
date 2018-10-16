//
//  ForumPostCatHouseTopView.m
//  XianMao
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "ForumPostCatHouseTopView.h"
#import "ForumService.h"
#import "ForumPostCatHouseTopCell.h"

@interface ForumPostCatHouseTopVO : NSObject
@property(nonatomic,strong) ForumTopicVO *topicVO;
@property(nonatomic,assign) BOOL isSelected;

+ (ForumPostCatHouseTopVO*)create:(ForumTopicVO *)topicVO;

@end

@implementation ForumPostCatHouseTopVO

+ (ForumPostCatHouseTopVO*)create:(ForumTopicVO *)topicVO {
    ForumPostCatHouseTopVO *tmp = [[ForumPostCatHouseTopVO alloc] init];
    tmp.topicVO = topicVO;
    tmp.isSelected = NO;
    return tmp;
}

@end

@interface ForumPostCatHouseTopView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrGroup;
//@property (nonatomic, strong) ForumPostCatHouseTopCell *cell;
@property (nonatomic, weak) ForumPostCatHouseTopCell *cell;
@property (nonatomic, assign) CGFloat indexC;

@end

static NSString *ID = @"ForumPostCatHouseTopViewCell";
@implementation ForumPostCatHouseTopView

- (void)reloadData:(NSArray*)array {
    self.arrGroup = [NSMutableArray array];

    for (ForumTopicVO *topicVO in array) {
        [_arrGroup addObject:[ForumPostCatHouseTopVO create:topicVO]];
    }
    
    [self reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self selectAtIndex:0];
    });
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"F4F5F5"];
        [self registerClass:[ForumPostCatHouseTopCell class] forCellWithReuseIdentifier:ID];
        self.dataSource = self;
        self.delegate = self;
        self.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seletedItem:) name:@"seletedItem" object:nil];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)seletedItem:(NSNotification *)notify{
    NSIndexPath *indexPath = notify.object;
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld", self.arrGroup.count);
    return self.arrGroup.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ForumPostCatHouseTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
//    cell.layer.borderWidth=1;
    
    ForumPostCatHouseTopVO *topic = (ForumPostCatHouseTopVO*)self.arrGroup[indexPath.row];
    cell.topicGroup = topic.topicVO;
    
    if (topic.isSelected) {
        cell.label.textColor = [UIColor colorWithHexString:@"c2a79d"];
        cell.label.font = [UIFont systemFontOfSize:13];
    } else {
        cell.label.textColor = [UIColor colorWithHexString:@"868686"];
        cell.label.font = [UIFont systemFontOfSize:13];
    }
    
    self.cell = cell;
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self selectAtIndex:[indexPath row]];

    
    ForumPostCatHouseTopVO *topic = self.arrGroup[indexPath.row];

    if ([self.catHouseDelegate respondsToSelector:@selector(scrollCollectionViewCell:andIndexPath:)]) {
        [self.catHouseDelegate scrollCollectionViewCell:topic.topicVO andIndexPath:indexPath];
    }

    
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 10, 0, 10);
//}

- (void)selectAtIndex:(NSInteger)index {
    
    for (NSInteger i=0;i<self.arrGroup.count;i++ ) {
        ForumPostCatHouseTopVO *topic = (ForumPostCatHouseTopVO*)self.arrGroup[i];
        if (i==index) {
            topic.isSelected = YES;
            
        } else {
            topic.isSelected = NO;
        }
    }
    
    [self reloadData];

}

@end


/*
 
 */
