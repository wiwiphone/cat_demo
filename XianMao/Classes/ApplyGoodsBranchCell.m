//
//  ApplyGoodsBranchCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "Masonry.h"
#import "ApplyGoodsBranchCell.h"


@implementation ApplyGoodsBranchCell


-(XMWebImageView *)branchTopImageView
{
    if (!_branchTopImageView) {
        _branchTopImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _branchTopImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    
    return _branchTopImageView;
}

-(XMWebImageView *)branchDownImageView
{
    if (!_branchDownImageView) {
        _branchDownImageView =[[XMWebImageView alloc] initWithFrame:CGRectZero];
        _branchDownImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _branchDownImageView;
}


-(UILabel *)branchOneLbl
{
    if (!_branchOneLbl) {
        _branchOneLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _branchOneLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _branchOneLbl.font = [UIFont systemFontOfSize:12.0f];
    }
    return _branchOneLbl;
}

-(UILabel *)branchDescLbl
{
    if (!_branchDescLbl) {
        _branchDescLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _branchDescLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        _branchDescLbl.font = [UIFont systemFontOfSize:10.0f];
    }
    return _branchDescLbl;
}

-(UILabel *)chargeLbl
{
    if (!_chargeLbl) {
        _chargeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _chargeLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        _chargeLbl.font = [UIFont systemFontOfSize:10.0f];
        _chargeLbl.backgroundColor = [UIColor cyanColor];
    }
    return _chargeLbl;
}

-(UILabel *)branchTwoLbl
{
    if (!_branchTwoLbl) {
        _branchTwoLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _branchTwoLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _branchTwoLbl.font = [UIFont systemFontOfSize:12.0];
    }
    return _branchTwoLbl;
}

-(UILabel *)branchTwoDescLbl
{
    if (!_branchTwoDescLbl) {
        _branchTwoDescLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _branchTwoDescLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        _branchTwoDescLbl.font = [UIFont systemFontOfSize:10.0f];
    }
    return _branchTwoDescLbl;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.branchTopImageView];
        [self.contentView addSubview:self.branchOneLbl];
        [self.contentView addSubview:self.branchDescLbl];
//        [self.contentView addSubview:self.chargeLbl];
//        [self.contentView addSubview:self.branchTwoLbl];
//        [self.contentView addSubview:self.branchTwoDescLbl];
    }
    return self;
}

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ApplyGoodsBranchCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait
{
    CGFloat height = 75;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ApplyGoodsBranchCell class]];
    return dict;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.branchTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*50, kScreenWidth/375*50));
        
    }];
    
//    [self.branchDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.branchTopImageView.mas_bottom).offset(20);
//        make.left.equalTo(self.contentView.mas_left).offset(14);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*50, kScreenWidth/375*50));
//
//    }];
    
    
    CGFloat padding = kScreenWidth/375*50/3;
    [self.branchOneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.branchTopImageView.mas_top);
        make.left.equalTo(self.branchTopImageView.mas_right).offset(20);
        make.bottom.equalTo(self.branchTopImageView.mas_bottom).offset(-padding*2);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.branchDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.branchOneLbl.mas_bottom);
        make.left.equalTo(self.branchTopImageView.mas_right).offset(20);
        make.bottom.equalTo(self.branchTopImageView.mas_bottom).offset(-padding);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
//    [self.chargeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.branchDescLbl.mas_bottom);
//        make.left.equalTo(self.branchTopImageView.mas_right).offset(20);
//        make.bottom.equalTo(self.branchTopImageView.mas_bottom);
//        make.right.equalTo(self.contentView.mas_right).offset(-14);
//    }];
    
//    [self.branchTwoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.branchDownImageView.mas_top);
//        make.left.equalTo(self.branchDownImageView.mas_right).offset(20);
//        make.bottom.equalTo(self.branchDownImageView.mas_bottom).offset(-padding*2);
//        make.right.equalTo(self.contentView.mas_right);
//    }];
//    
//    [self.branchTwoDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.branchTwoLbl.mas_bottom);
//        make.left.equalTo(self.branchDownImageView.mas_right).offset(20);
//        make.bottom.equalTo(self.branchDownImageView.mas_bottom).offset(-padding);
//        make.right.equalTo(self.contentView.mas_right);
//    }];
    
    
}

+ (NSMutableDictionary*)buildCellDict:(GoodsFittingsListModel *)GoodsFittingsListModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ApplyGoodsBranchCell class]];
    if (GoodsFittingsListModel) {
        [dict setObject:GoodsFittingsListModel forKey:@"GoodsFittingsListModel"];
    }
    return dict;
}

+ (NSMutableDictionary*)buildCellDictWithList:(GoodsLossFittingsListModel *)GoodsLossFittingsListModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ApplyGoodsBranchCell class]];
    if (GoodsLossFittingsListModel) {
        [dict setObject:GoodsLossFittingsListModel forKey:@"GoodsLossFittingsListModel"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsFittingsListModel * model = dict[@"GoodsLossFittingsListModel"];
    if (model.pic) {
        [self.branchTopImageView setImageWithURL:model.pic placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    }
    if (model.name) {
        self.branchOneLbl.text = model.name;
    }
    if (model.info) {
        self.branchDescLbl.text = [NSString stringWithFormat:@"%@",model.info];
    }

}
@end
