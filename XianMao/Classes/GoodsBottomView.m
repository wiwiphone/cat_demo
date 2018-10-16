//
//  GoodsBottomView.m
//  XianMao
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsBottomView.h"
#import "Session.h"
#import "NetworkAPI.h"
#import "GoodsMemCache.h"

@interface GoodsBottomView () 

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) CommandButton *chatBtn;
@property (nonatomic, strong) CommandButton *editBtn;
@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) VerticalCommandButton *leaveBtn;
@property (nonatomic, strong) VerticalCommandButton *likeBtn;

@end

@implementation GoodsBottomView

-(VerticalCommandButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        [_likeBtn setTitle:@"心动" forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"Goods_Like"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"Goods_Like_Selected"] forState:UIControlStateSelected];
        _likeBtn.imageTextSepHeight = 5;
        [_likeBtn sizeToFit];
    }
    return _likeBtn;
}

-(VerticalCommandButton *)leaveBtn{
    if (!_leaveBtn) {
        _leaveBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        [_leaveBtn setTitle:@"留言" forState:UIControlStateNormal];
        _leaveBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_leaveBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_leaveBtn setImage:[UIImage imageNamed:@"Goods_Leave"] forState:UIControlStateNormal];
        _leaveBtn.imageTextSepHeight = 5;
        [_leaveBtn sizeToFit];
    }
    return _leaveBtn;
}

-(CommandButton *)addShopBag{
    if (!_addShopBag) {
        _addShopBag = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_addShopBag setTitle:@"加入购物袋" forState:UIControlStateNormal];
        [_addShopBag setTitle:@"已加入购物袋" forState:UIControlStateSelected];
        [_addShopBag setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_addShopBag setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        _addShopBag.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _addShopBag.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
//        _addShopBag.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
//        _addShopBag.layer.borderWidth = 1.f;
        _addShopBag.layer.masksToBounds = YES;
        _addShopBag.layer.cornerRadius = 2;
    }
    return _addShopBag;
}

-(CommandButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_chatBtn setTitle:@"聊一聊" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _chatBtn.layer.masksToBounds = YES;
        _chatBtn.layer.cornerRadius = 2;
        _chatBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    }
    return _chatBtn;
}

-(CommandButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 2;
        _editBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    }
    return _editBtn;
}

-(UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    }
    return _topLineView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.topLineView];
        [self addSubview:self.chatBtn];
        [self addSubview:self.addShopBag];
        [self addSubview:self.leaveBtn];
        [self addSubview:self.likeBtn];
        [self addSubview:self.editBtn];
        
        WEAKSELF;
        self.chatBtn.handleClickBlock = ^(CommandButton *sender){
            
            NSLog(@"%@", weakSelf.goodsId);
            [UserSingletonCommand chatBalance:weakSelf.goodsId];
            
        };
        
        self.addShopBag.handleClickBlock = ^(CommandButton *sender){
            
            if (weakSelf.handleAddShopBag) {
                weakSelf.handleAddShopBag();
            }
            
        };
        
        self.likeBtn.handleClickBlock = ^(CommandButton *sender){
            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                
            }];
            if (!isLoggedIn) {
                return;
            }
            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
            if (goodsInfo) {
                [MobClick event:@"click_want_from_detail"];
                if (goodsInfo.isLiked) {
                    weakSelf.likeBtn.selected = NO;
                    [GoodsSingletonCommand unlikeGoods:goodsInfo.goodsId];
                    [weakSelf.likeBtn setTitle:[NSString stringWithFormat:@"%ld", goodsInfo.stat.likeNum] forState:UIControlStateNormal];
                } else {
                    weakSelf.likeBtn.selected = YES;
                    [GoodsSingletonCommand likeGoods:goodsInfo.goodsId];
                    [weakSelf.likeBtn setTitle:[NSString stringWithFormat:@"%ld", goodsInfo.stat.likeNum] forState:UIControlStateNormal];
                }
            }
            if (goodsInfo.stat.likeNum == 0) {
                [weakSelf.likeBtn setTitle:@"心动" forState:UIControlStateNormal];
            }
            
//            if (weakSelf.clickLikeBtn) {
//                weakSelf.clickLikeBtn();
//            }
            
        };
        
        self.leaveBtn.handleClickBlock = ^(CommandButton *sender){
            
            if (weakSelf.commentGoods) {
                weakSelf.commentGoods();
            }
            
        };
        
        self.editBtn.handleClickBlock = ^(CommandButton *sender) {
            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                
            }];
            if (isLoggedIn) {
                if (weakSelf.handleEditGoodsBlock) {
                    weakSelf.handleEditGoodsBlock(weakSelf.goodsInfo);
                }
            }
            
        };
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(@104);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(@104);
    }];
    
    [self.addShopBag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chatBtn.mas_left).offset(-8);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(@104);
    }];
    
    [self.leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.centerY.equalTo(self.mas_centerY).offset(-6);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leaveBtn.mas_right).offset(20);
        make.centerY.equalTo(self.mas_centerY).offset(-6);
        make.width.equalTo(@25);
        make.height.equalTo(@21);
    }];
    
}

-(void)getGoodsInfo:(GoodsInfo *)goodsInfo{
    
    _goodsInfo = goodsInfo;
    
    if (goodsInfo.stat.likeNum > 0) {
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld", goodsInfo.stat.likeNum] forState:UIControlStateNormal];
    } else {
        [self.likeBtn setTitle:@"心动" forState:UIControlStateNormal];
    }
    
    if (goodsInfo.isLiked) {
        self.likeBtn.selected = YES;
    } else {
        self.likeBtn.selected = NO;
    }
    
    BOOL isEabled = ![[Session sharedInstance] isExistInShoppingCart:goodsInfo.goodsId];
    if (!isEabled) {
        self.addShopBag.enabled = NO;
        self.addShopBag.selected = YES;
        [_addShopBag setTitle:@"已加入购物袋" forState:UIControlStateNormal];
        [_addShopBag setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    } else {
        self.addShopBag.enabled = YES;
        self.addShopBag.selected = NO;
        [_addShopBag setTitle:@"加入购物袋" forState:UIControlStateNormal];
        [_addShopBag setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    }
    
    if (goodsInfo.seller.userId == [Session sharedInstance].currentUserId) {
        _addShopBag.hidden = YES;
        _chatBtn.hidden = YES;
        _editBtn.hidden = NO;
    }else{
        _addShopBag.hidden = NO;
        _chatBtn.hidden = NO;
        _editBtn.hidden = YES;
    }
}

@end
