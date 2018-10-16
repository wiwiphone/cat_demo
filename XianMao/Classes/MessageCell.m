//
//  MessageCell.m
//  XianMao
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MessageCell.h"
#import "CommentView.h"
#import "CommentVo.h"

@interface MessageCell ()

@property (nonatomic, strong) XMWebImageView *failImageView;
@property (nonatomic, strong) UILabel *noMessageLbl;

@end

@implementation MessageCell

-(UILabel *)noMessageLbl{
    if (!_noMessageLbl) {
        _noMessageLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _noMessageLbl.font = [UIFont systemFontOfSize:13.f];
        _noMessageLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_noMessageLbl sizeToFit];
        _noMessageLbl.text = @"还没有人留言";
    }
    return _noMessageLbl;
}

-(XMWebImageView *)failImageView{
    if (!_failImageView) {
        _failImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _failImageView.image = [UIImage imageNamed:@"Goods_New_Message"];
        [_failImageView sizeToFit];
    }
    return _failImageView;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([MessageCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 126;
    
    NSMutableArray *commentArr = dict[@"commentArr"];
    if (commentArr.count > 0) {
//        if (commentArr.count <= 3) {
//            height += 72*commentArr.count;
//        } else {
//            height += 72*3;
//        }
        height = 0;
        
        for (int i = 0; i < commentArr.count; i++) {
            CommentVo *commentVo = commentArr[i];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, kScreenWidth-50-12, 50)];
            lbl.font = [UIFont systemFontOfSize:11.f];
            lbl.text = commentVo.content;
            lbl.numberOfLines = 0;
            [lbl sizeToFit];
            CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-50-12, CGFLOAT_MAX)];
            height += 60+size.height;
        }
        
    }
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)commentArr andSellerId:(NSInteger)sellerId
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[MessageCell class]];
    if (commentArr) {
        [dict setObject:commentArr forKey:@"commentArr"];
    }
    [dict setObject:@(sellerId) forKey:@"sellerId"];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.failImageView];
        [self.contentView addSubview:self.noMessageLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.failImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-15);
    }];
    
    [self.noMessageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.failImageView.mas_bottom).offset(14);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSMutableArray *commentArr = dict[@"commentArr"];
    NSInteger sellerId = ((NSNumber *)dict[@"sellerId"]).integerValue;
    if (commentArr.count > 0) {
        self.failImageView.hidden = YES;
        self.noMessageLbl.hidden = YES;
    } else {
        self.failImageView.hidden = NO;
        self.noMessageLbl.hidden = NO;
    }
    
    for (CommentView *comView in self.subviews) {
        if ([comView isKindOfClass:[CommentView class]]) {
            [comView removeFromSuperview];
        }
    }
    
//    if (commentArr.count <= 3) {
    CGFloat margin = 0;
        for (int i = 0; i < commentArr.count; i++) {
            CommentVo *commentVo = commentArr[i];
            CommentView *comView = [[CommentView alloc] initWithFrame:CGRectMake(0, 0+72*i, kScreenWidth, 72)];
            comView.backgroundColor = [UIColor whiteColor];
            if (i == commentArr.count-1) {
                comView.i = 1;
            } else {
                comView.i = 0;
            }
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, kScreenWidth-50-12, 50)];
            lbl.font = [UIFont systemFontOfSize:11.f];
            lbl.text = commentVo.content;
            lbl.numberOfLines = 0;
            [lbl sizeToFit];
            CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-50-12, CGFLOAT_MAX)];
            comView.frame = CGRectMake(0, margin, kScreenWidth, 60+size.height);
            margin += size.height+60;
            
            comView.sellerId = sellerId;
            comView.commentVo = commentVo;
            [self addSubview:comView];
        }
//    } else {
//        for (int i = 0; i < 3; i++) {
//            CommentVo *commentVo = commentArr[i];
//            CommentView *comView = [[CommentView alloc] initWithFrame:CGRectMake(0, 0+72*i, kScreenWidth, 72)];
//            comView.backgroundColor = [UIColor whiteColor];
//            comView.commentVo = commentVo;
//            [self addSubview:comView];
//        }
//    }
    
    
}

@end
