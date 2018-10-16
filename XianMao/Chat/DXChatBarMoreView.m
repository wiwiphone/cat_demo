/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXChatBarMoreView.h"

#import "Command.h"

//#define CHAT_BUTTON_SIZE 60
#define INSETS 8

#define CHAT_BUTTON_SIZE 70
//#define INSETS 15

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame isForChat:(BOOL)isForChat isGuwen:(BOOL)isGuwen isJimai:(BOOL)isJimai
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:isForChat isGuwen:isGuwen isJimai:isJimai];
    }
    return self;
}

- (void)setupSubviewsForType:(BOOL)isForChat isGuwen:(BOOL)isGuwen isJimai:(BOOL)isJimai
{
    if (isForChat) {
            self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
        
        VerticalCommandButton *photoButton =[VerticalCommandButton buttonWithType:UIButtonTypeCustom];
        photoButton.imageTextSepHeight = 7.f;
        //add code
        photoButton.contentMarginTop = 0.f;
        _photoButton = photoButton;
        _photoButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_photoButton setFrame:CGRectMake(insets, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        //    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
        [_photoButton setImage:[UIImage imageNamed:@"photoNew"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
        [_photoButton setTitle:@"图片" forState:UIControlStateNormal];
        [_photoButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        
        [self addSubview:_photoButton];
        
        VerticalCommandButton *takePicButton =[VerticalCommandButton buttonWithType:UIButtonTypeCustom];
        takePicButton.imageTextSepHeight = 7.f;
        takePicButton.contentMarginTop = 0.f;
        _takePicButton = takePicButton;
        _takePicButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        //    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
        [_takePicButton setImage:[UIImage imageNamed:@"cameraNew"] forState:UIControlStateNormal];
        [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
        [_takePicButton setTitle:@"相机" forState:UIControlStateNormal];
        [_takePicButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        
        [self addSubview:_takePicButton];
        
        VerticalCommandButton *selectGoods =[VerticalCommandButton buttonWithType:UIButtonTypeCustom];
        selectGoods.imageTextSepHeight = 7.f;
        selectGoods.contentMarginTop = 0.f;
        _selectGoods = selectGoods;
        _selectGoods.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_selectGoods setFrame:CGRectMake(insets * 3 + 2*CHAT_BUTTON_SIZE, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        //    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
        [_selectGoods setImage:[UIImage imageNamed:@"recomGoodsNew_MF"] forState:UIControlStateNormal];
        [_selectGoods addTarget:self action:@selector(selectGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectGoods setTitle:@"我卖的" forState:UIControlStateNormal];
        [_selectGoods setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        
        [self addSubview:_selectGoods];
        
        VerticalCommandButton *likeGoods =[VerticalCommandButton buttonWithType:UIButtonTypeCustom];
        likeGoods.imageTextSepHeight = 7.f;
        likeGoods.contentMarginTop = 0.f;
        _likeGoods = likeGoods;
        _likeGoods.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_likeGoods setFrame:CGRectMake(insets * 4 + 3*CHAT_BUTTON_SIZE, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        //    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
        [_likeGoods setImage:[UIImage imageNamed:@"ChatBar_Like_MF"] forState:UIControlStateNormal];
        [_likeGoods addTarget:self action:@selector(likeGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [_likeGoods setTitle:@"心动的" forState:UIControlStateNormal];
        [_likeGoods setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];

        [self addSubview:_likeGoods];
        
        
        if (isJimai) {
            VerticalCommandButton *jiMaiGoods =[VerticalCommandButton buttonWithType:UIButtonTypeCustom];
            jiMaiGoods.imageTextSepHeight = 7.f;
            jiMaiGoods.contentMarginTop = 0.f;
            _jiMaiGoods = jiMaiGoods;
            _jiMaiGoods.titleLabel.font = [UIFont systemFontOfSize:10.f];
            [_jiMaiGoods setImage:[UIImage imageNamed:@"ChatBar_Jimai_MF"] forState:UIControlStateNormal];
            [_jiMaiGoods addTarget:self action:@selector(jiMaiGoodsAction) forControlEvents:UIControlEventTouchUpInside];
            [_jiMaiGoods setTitle:@"发布寄卖" forState:UIControlStateNormal];
            [_jiMaiGoods setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];

            [self addSubview:_jiMaiGoods];
        }
        
        if (isGuwen) {
            VerticalCommandButton *seekGoods =[VerticalCommandButton buttonWithType:UIButtonTypeCustom];
            seekGoods.imageTextSepHeight = 7.f;
            seekGoods.contentMarginTop = 0.f;
            _seekGoods = seekGoods;
            _seekGoods.titleLabel.font = [UIFont systemFontOfSize:10.f];
            [_seekGoods setFrame:CGRectMake(insets, 15*2 + CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
            //    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
            [_seekGoods setImage:[UIImage imageNamed:@"ChatBar_Seek_MF"] forState:UIControlStateNormal];
            [_seekGoods addTarget:self action:@selector(seekGoodsAction) forControlEvents:UIControlEventTouchUpInside];
            [_seekGoods setTitle:@"全球找货" forState:UIControlStateNormal];
            [_seekGoods setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
            
            [self addSubview:_seekGoods];
            
            if ([[Session sharedInstance] isNeedShowRedPoint]) {
                UIView *redPointView = [[UIView alloc] initWithFrame:CGRectMake(insets+CHAT_BUTTON_SIZE-5, 15*2-2 + CHAT_BUTTON_SIZE, 7 , 7)];
                redPointView.layer.masksToBounds = YES;
                redPointView.layer.cornerRadius = 7/2;
                redPointView.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
                [self addSubview:redPointView];
            }
            if (isJimai) {
                [_jiMaiGoods setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 15*2 + CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
            }
            
        } else{
            
            if (isJimai) {
                [_jiMaiGoods setFrame:CGRectMake(insets, 15*2 + CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
            }
        }
        
        
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
        
        VerticalCommandButton *selectGoods =[VerticalCommandButton buttonWithType:UIButtonTypeCustom];
        selectGoods.imageTextSepHeight = 6.f;
        // add code
        selectGoods.contentMarginTop = 15.f;
        
        _selectGoods = selectGoods;
        _selectGoods.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_selectGoods setFrame:CGRectMake(insets, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        //    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
        [_selectGoods setImage:[UIImage imageNamed:@"chatBar_colorMore_goodsSelected"] forState:UIControlStateNormal];
        [_selectGoods addTarget:self action:@selector(selectGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectGoods setTitle:@"推荐商品" forState:UIControlStateNormal];
        [_selectGoods setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        
        //add code
        _selectGoods.layer.cornerRadius = 4;
        _selectGoods.layer.borderWidth = 1;
        _selectGoods.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _selectGoods.clipsToBounds = YES;
        _selectGoods.layer.backgroundColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        
        [self addSubview:_selectGoods];
    }

//    CGRect frame = self.frame;
////    frame.size.height = 100;
//    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)selectGoodsAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewGoodsAction:)]) {
        [_delegate moreViewGoodsAction:self];
    }
}

-(void)likeGoodsAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLikeAction:)]) {
        [_delegate moreViewLikeAction:self];
    }
}

-(void)seekGoodsAction{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kRedPoint];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewSeekAction:)]) {
        [_delegate moreViewSeekAction:self];
    }
}

- (void)jiMaiGoodsAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewJimaiAction:)]) {
        [_delegate moreViewJimaiAction:self];
    }
}

@end
