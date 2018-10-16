//
//  GoodsPictrueCell.m
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GoodsPictrueCell.h"
#import "IdleCollectionView.h"
#import "SendSaleVo.h"
#import "PictureItem.h"

@interface GoodsPictrueCell()

@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic, strong) UILabel * goodsName;
@property (nonatomic, strong) IdleCollectionView * collectionView;

@end

@implementation GoodsPictrueCell


- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"bg_top"];
        _containerView.userInteractionEnabled = YES;
    }
    return _containerView;
}

- (IdleCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[IdleCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UILabel *)goodsName{
    if (!_goodsName) {
        _goodsName = [[UILabel alloc] init];
        _goodsName.font = [UIFont systemFontOfSize:15];
        _goodsName.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_goodsName sizeToFit];
    }
    return _goodsName;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsPictrueCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {

    CGFloat rowHeight = 122;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsPictrueCell class]];
    if (sendVo) {
        [dict setObject:sendVo forKey:@"sendVo"];
    }
    return dict;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.goodsName];
        [self.containerView addSubview:self.collectionView];
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    SendSaleVo * sendVo = [dict objectForKey:@"sendVo"];
    
    self.goodsName.text = sendVo.title;
    NSMutableArray * picData = [[NSMutableArray array] init];
    if (sendVo.attachment && sendVo.attachment.count > 0) {
        for (PictureItem * pic in sendVo.attachment) {
            [picData addObject:pic];
        }
        
        [self.collectionView getPicData:picData];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(15);
        make.right.equalTo(self.containerView.mas_right).offset(-18);
        make.left.equalTo(self.containerView.mas_left).offset(18);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsName.mas_bottom).offset(15);
        make.left.equalTo(self.containerView.mas_left).offset(18);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.right.equalTo(self.containerView.mas_right).offset(-8);
    }];
}

@end
