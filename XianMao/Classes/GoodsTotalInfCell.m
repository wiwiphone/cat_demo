//
//  GoodsTotalInfCell.m
//  XianMao
//
//  Created by apple on 16/11/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsTotalInfCell.h"
#import "Command.h"
#import "GoodsDetailInfo.h"

@interface GoodsTotalInfCell ()

@property (nonatomic, strong) CommandButton *picBtn;
@property (nonatomic, strong) CommandButton *parameterBtn;
@property (nonatomic, strong) CommandButton *guardBtn;

@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation GoodsTotalInfCell

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [DataSources colorf9384c];
    }
    return _bottomLineView;
}

-(CommandButton *)guardBtn{
    if (!_guardBtn) {
        _guardBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_guardBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_guardBtn setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
        _guardBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_guardBtn sizeToFit];
    }
    return _guardBtn;
}

-(CommandButton *)parameterBtn{
    if (!_parameterBtn) {
        _parameterBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_parameterBtn setTitle:@"商品参数" forState:UIControlStateNormal];
        [_parameterBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_parameterBtn setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
        _parameterBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_parameterBtn sizeToFit];
    }
    return _parameterBtn;
}

-(CommandButton *)picBtn{
    if (!_picBtn) {
        _picBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_picBtn setTitle:@"商品图片" forState:UIControlStateNormal];
        [_picBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_picBtn setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
        _picBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_picBtn sizeToFit];
    }
    return _picBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsTotalInfCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 54;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsTotalInfCell class]];
    if (detailInfo) {
        [dict setObject:detailInfo forKey:@"detailInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAKSELF;
        [self.contentView addSubview:self.picBtn];
        [self.contentView addSubview:self.parameterBtn];
        [self.contentView addSubview:self.guardBtn];
        [self.contentView addSubview:self.bottomLineView];
        
        self.picBtn.selected = YES;
        
        self.picBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf selectedBtnIndex:1];
        };
        
        self.parameterBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf selectedBtnIndex:2];
        };
        
        self.guardBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf selectedBtnIndex:3];
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseSelctCellIndex:) name:@"chooseSelctCellIndex" object:nil];
    }
    return self;
}

-(void)selectedBtnIndex:(NSInteger)index{
//    if (index == 1) {
//        self.picBtn.selected = YES;
//        self.parameterBtn.selected = NO;
//        self.guardBtn.selected = NO;
//    } else if (index == 2) {
//        self.picBtn.selected = NO;
//        self.parameterBtn.selected = YES;
//        self.guardBtn.selected = NO;
//    } else if (index == 3) {
//        self.picBtn.selected = NO;
//        self.parameterBtn.selected = NO;
//        self.guardBtn.selected = YES;
//    }
    if (self.scrollTableInfIndexP) {
        self.scrollTableInfIndexP(index);
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSelecteIndex" object:@(index)];
}

-(void)chooseSelctCellIndex:(NSNotification*)notify{
    NSInteger index = ((NSNumber *)notify.object).integerValue;
    if (index == 1) {
        self.picBtn.selected = YES;
        self.parameterBtn.selected = NO;
        self.guardBtn.selected = NO;
    } else if (index == 2) {
        self.picBtn.selected = NO;
        self.parameterBtn.selected = YES;
        self.guardBtn.selected = NO;
    } else if (index == 3) {
        self.picBtn.selected = NO;
        self.parameterBtn.selected = NO;
        self.guardBtn.selected = YES;
    }
//    [self bottomLineViewScrollWillScroll:index];
}

-(void)bottomLineViewScrollWillScroll:(NSInteger)index{
    WEAKSELF;
    switch (index) {
        case 1: {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.bottomLineView.frame = CGRectMake(self.picBtn.left-12, self.height-2, self.picBtn.width+20, 2);
            }];
            break;
        }
        case 2:{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.bottomLineView.frame = CGRectMake(self.parameterBtn.left-12, self.height-2, self.parameterBtn.width+20, 2);
            }];
            break;
        }
        case 3:{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.bottomLineView.frame = CGRectMake(self.guardBtn.left-12, self.height-2, self.guardBtn.width+20, 2);
            }];
        }
        default:
            break;
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelecteIndex" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSelctCellIndex" object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    WEAKSELF;
    [self.picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(31);
    }];
    
    [self.parameterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.guardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-31);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.bottomLineView.frame = CGRectMake(20, self.height-2, self.picBtn.width+20, 2);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsDetailInfo * detailInfo = [dict objectForKey:@"detailInfo"];
    if ([detailInfo.goodsInfo.seller isMeowGoods]) {
        [_guardBtn setTitle:@"交易说明" forState:UIControlStateNormal];
    } else {
        [_guardBtn setTitle:@"交易保障" forState:UIControlStateNormal];
    }
}

@end
