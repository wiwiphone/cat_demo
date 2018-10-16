//
//  RecoverCateView.m
//  XianMao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverCateView.h"
#import "GoodsService.h"

@interface RecoverCateView ()

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, strong) NSMutableArray *cateChildArr;
@property (nonatomic, strong) NSMutableArray *paramArr;
@property (nonatomic, strong) NSArray *InJsonArr;

@property (nonatomic, strong) NSMutableArray *cateArr;
@property (nonatomic, strong) NSMutableArray *prefereArr;
@end

@implementation RecoverCateView

-(NSMutableArray *)prefereArr{
    if (!_prefereArr) {
        _prefereArr = [[NSMutableArray alloc] init];
    }
    return _prefereArr;
}

-(NSMutableArray *)cateArr{
    if (!_cateArr) {
        _cateArr = [[NSMutableArray alloc] init];
    }
    return _cateArr;
}

-(NSMutableArray *)paramArr{
    if (!_paramArr) {
        _paramArr = [[NSMutableArray alloc] init];
    }
    return _paramArr;
}

-(NSMutableArray *)cateChildArr{
    if (!_cateChildArr) {
        _cateChildArr = [[NSMutableArray alloc] init];
    }
    return _cateChildArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.margin = 0;
//        [self getRecoverPreference];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetMenu) name:@"resetMenu" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureMenuArr:) name:@"sureMenuArr" object:nil];
    }
    return self;
}

-(void)getInJsonArr:(NSArray *)arr{
    self.InJsonArr = arr;
    for (int i = 0; i < self.InJsonArr.count; i++) {
        NSDictionary *dict = self.InJsonArr[i];
        NSString *qk = dict[@"qk"];
        NSString *qv = [NSString stringWithFormat:@"%@", dict[@"qv"]];
        for (int i = 0; i < self.cateChildArr.count; i++) {
            CateButton *cateBtn = self.cateChildArr[i];
            if ([qk isEqualToString:cateBtn.parenceQueryKey] && [qv isEqualToString:cateBtn.item.query_value]) {
                cateBtn.layer.borderWidth = 1;
                cateBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
            } else {
//                cateBtn.layer.borderWidth = 0;
//                cateBtn.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }
    }
}



-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sureMenuArr" object:nil];
}

//-(void)sureMenuArr:(NSNotification *)notify{
//    NSMutableArray *cateArr = notify.object;
//    if ([self.cateDelegate respondsToSelector:@selector(setSuccess:)]) {
//        [self.cateDelegate setSuccess:self.cateChildArr];
//    }
//    
//}

-(void)getRecoverArr:(NSMutableArray *)arr{
    if ([self.cateDelegate respondsToSelector:@selector(setSuccess:)]) {
        [self.cateDelegate setSuccess:self.cateChildArr];
    }
}

-(void)resetMenu{
    for (int i = 0; i < self.cateChildArr.count; i++) {
        CateButton *cateBtn = self.cateChildArr[i];
        if (cateBtn.item.is_selected == 1) {
            cateBtn.layer.borderWidth = 1;
            cateBtn.layer.borderColor = [UIColor clearColor].CGColor;
            cateBtn.item.is_selected = 0;
        }
    }
    [self setNeedsDisplay];
}

-(void)setPreference:(RecoveryPreference *)preference{
    _preference = preference;
    
    for (int i = 0; i < preference.items.count; i++) {
        RecoveryPreference *preferenceItem = preference.items[i];
        self.margin += 25;
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, self.margin, kScreenWidth - 50, 30)];
        [cateBtn setTitle:preferenceItem.name forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor colorWithHexString:@"adadad"] forState:UIControlStateNormal];
        cateBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [cateBtn sizeToFit];
        [self addSubview:cateBtn];
        self.margin += cateBtn.height;
        if (preferenceItem.type == 0) {
            
            for (int i = 0; i < preferenceItem.items.count; i++) {
                if (i % 3 == 0) {
                    self.margin += 50;
                }
                RecoveryItem *item = preferenceItem.items[i];
                CateButton *cateChildBtn = [[CateButton alloc] initWithFrame:CGRectMake(15 * (i%3), self.margin, 100, 30)];
                [cateChildBtn setTitle:item.title forState:UIControlStateNormal];
                [cateChildBtn setTitleColor:[UIColor colorWithHexString:@"414141"] forState:UIControlStateNormal];
                cateChildBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
                cateChildBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                cateChildBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
                [cateChildBtn sizeToFit];
                cateChildBtn.frame = CGRectMake(15 + (i % 3) * (kScreenWidth / 3), self.margin - 25, cateChildBtn.width, cateChildBtn.height);
                [self addSubview:cateChildBtn];
                
                cateChildBtn.tag = i;
                cateChildBtn.item = item;
                cateChildBtn.preferenceItem = preferenceItem;
                cateChildBtn.parenceQueryKey = preference.query_key;
                [self.cateChildArr addObject:cateChildBtn];
                //                if (cateChildBtn.item.is_selected == 1) {
                //                    cateChildBtn.layer.borderWidth = 2;
                //                    cateChildBtn.layer.borderColor = [UIColor colorWithHexString:@"ac7e33"].CGColor;
                //                } else {
                //                    cateChildBtn.layer.borderWidth = 2;
                //                    cateChildBtn.layer.borderColor = [UIColor clearColor].CGColor;
                //                }
                [cateChildBtn addTarget:self action:@selector(clickCataChildBtn:) forControlEvents:UIControlEventTouchUpInside];
                if (i == preferenceItem.items.count - 1) {
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.margin + 25, kScreenWidth, 0.5)];
                    lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
                    [self addSubview:lineView];
                    self.margin += 25;
                    self.margin += lineView.height;
                }
            }
            preferenceItem.items = nil;
        }
    }
    preference.items = nil;
    self.contentSize = CGSizeMake(kScreenWidth, self.margin);
}

-(void)getRecoverPreference:(RecoveryPreference *)preference{

}

-(void)clickCataChildBtn:(UIButton *)sender{
    CateButton *cateBtn = (CateButton *)sender;
    RecoveryItem *item = cateBtn.item;
    RecoveryPreference *preferenceItem = cateBtn.preferenceItem;
    
    if (preferenceItem.query_key == item.query_value) {
        for (int i = 0; i < self.cateChildArr.count; i++) {
            CateButton *cateBtn = self.cateChildArr[i];
            if (cateBtn.preferenceItem.query_key == item.query_value) {
                if (cateBtn == sender) {
                    if (cateBtn.item.is_selected == 0) {
                        cateBtn.layer.borderWidth = 1;
                        cateBtn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
                        cateBtn.item.is_selected = 1;
                    } else {
                        cateBtn.layer.borderWidth = 1;
                        cateBtn.layer.borderColor = [UIColor clearColor].CGColor;
                        cateBtn.item.is_selected = 0;
                    }
                } else {
                    cateBtn.layer.borderWidth = 1;
                    cateBtn.layer.borderColor = [UIColor clearColor].CGColor;
                    cateBtn.item.is_selected = 0;
                }
            }
        }
        return;
    }
    
    if (preferenceItem.multi_selected == 1) {
        if (cateBtn.item.is_selected == 0) {
            cateBtn.layer.borderWidth = 1;
            cateBtn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
            cateBtn.item.is_selected = 1;
            for (int i = 0; i < self.cateChildArr.count; i++) {
                CateButton *cateBtn = self.cateChildArr[i];
                if (cateBtn.item.query_value == preferenceItem.query_key) {
                    cateBtn.layer.borderWidth = 1;
                    cateBtn.layer.borderColor = [UIColor clearColor].CGColor;
                    cateBtn.item.is_selected = 0;
                    return;
                }
            }
        } else {
            cateBtn.layer.borderWidth = 1;
            cateBtn.layer.borderColor = [UIColor clearColor].CGColor;
            cateBtn.item.is_selected = 0;
        }
    } else {
        for (int i = 0; i < self.cateChildArr.count; i++) {
            CateButton *cateBtn1 = self.cateChildArr[i];
            if (cateBtn1 == cateBtn) {
                if (cateBtn1.item.is_selected == 0) {
                    cateBtn1.layer.borderWidth = 1;
                    cateBtn1.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
                    cateBtn1.item.is_selected = 1;
                } else {
                    cateBtn1.layer.borderWidth = 1;
                    cateBtn1.layer.borderColor = [UIColor clearColor].CGColor;
                    cateBtn1.item.is_selected = 0;
                }
            } else {
                cateBtn1.layer.borderWidth = 1;
                cateBtn1.layer.borderColor = [UIColor clearColor].CGColor;
                cateBtn1.item.is_selected = 0;
            }
        }
    }
}

@end

@interface CateButton ()

@end

@implementation CateButton



@end