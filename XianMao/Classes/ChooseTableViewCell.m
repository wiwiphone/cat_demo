//
//  ChooseTableViewCell.m
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ChooseTableViewCell.h"
#import "GoodsEditableInfo.h"
#import "ChooseCollectionView.h"
#import "Masonry.h"

#import <UIKit/UIKit.h>

@interface ChooseTableViewCell ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) ChooseCollectionView *collectionView;

@end

@implementation ChooseTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ChooseTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict {
    CGFloat rowHeight = 0;
    
    AttrEditableInfo *attrInfo = dict[@"attrInfo"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:attrInfo.values];
    rowHeight = (arr.count / 2 + arr.count % 2) * 50;
    
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(AttrEditableInfo *)attrInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ChooseTableViewCell class]];
    if (attrInfo) {
        [dict setObject:attrInfo forKey:@"attrInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth / 2 - 24, 27);
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 15;
        ChooseCollectionView *collectionView = [[ChooseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    
    AttrEditableInfo *attrInfo = dict[@"attrInfo"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:attrInfo.values];
    
    [self.collectionView upDataArr:arr editInfo:attrInfo];
    self.dataArr = arr;
    
    [self setNeedsDisplay];
}

@end
