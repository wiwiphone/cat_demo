//
//  GoodsAboutCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsAboutCell.h"
#import "Command.h"

@interface GoodsAboutCell()

@property (nonatomic, strong) UILabel * attrNameLbl;
@property (nonatomic, strong) UILabel * attrValueLbl;
@property (nonatomic, strong) UIImageView * squareImg;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) TapDetectingImageView * doubtImageView;

@end

@implementation GoodsAboutCell

-(UIImageView *)squareImg
{
    if (!_squareImg) {
        _squareImg = [[UIImageView alloc] init];
        _squareImg.image = [UIImage imageNamed:@"square_wjh_new"];
        _squareImg.hidden = YES;
//        _squareImg.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return _squareImg;
}

- (TapDetectingImageView *)doubtImageView{
    if (!_doubtImageView) {
        _doubtImageView = [[TapDetectingImageView alloc] init];
        _doubtImageView.image = [UIImage imageNamed:@"questionIcon"];
        _doubtImageView.hidden = YES;
        _doubtImageView.contentMode = UIViewContentModeCenter;
    }
    return _doubtImageView;
}

-(UILabel *)attrNameLbl
{
    if (!_attrNameLbl) {
        _attrNameLbl = [[UILabel alloc] init];
        _attrNameLbl.font = [UIFont systemFontOfSize:13];
        _attrNameLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _attrNameLbl.textAlignment = NSTextAlignmentLeft;
        [_attrNameLbl sizeToFit];
    }
    return _attrNameLbl;
}


-(UILabel *)attrValueLbl
{
    if (!_attrValueLbl) {
        _attrValueLbl = [[UILabel alloc] init];
        _attrValueLbl.font = [UIFont systemFontOfSize:13];
        _attrValueLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _attrValueLbl.textAlignment = NSTextAlignmentRight;
        [_attrValueLbl sizeToFit];
    }
    return _attrValueLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsAboutCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 42;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)attrName attrValue:(NSString *)attrValue isExpand:(NSInteger)isExpand
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsAboutCell class]];
    if (attrName.length > 0) {
        [dict setObject:attrName forKey:@"attrName"];
    }
    
    if (attrValue.length > 0) {
        [dict setObject:attrValue forKey:@"attrValue"];
    }
    
    [dict setObject:[NSNumber numberWithInteger:isExpand] forKey:@"expand"];

    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    if (dict[@"attrName"]) {
        self.attrNameLbl.text = dict[@"attrName"];
    }
    
    if (dict[@"attrValue"]) {
        self.attrValueLbl.text = dict[@"attrValue"];
    }
    
    if ([dict[@"expand"] integerValue] == 1) {
        self.squareImg.hidden = NO;
        self.doubtImageView.hidden = NO;
    }else{
        self.squareImg.hidden = YES;
        self.doubtImageView.hidden = YES;
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.squareImg.hidden) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goodsAboutCellNotification" object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            if (self.isShow) {
                self.squareImg.transform = CGAffineTransformMakeRotation(0);
            } else {
                self.squareImg.transform = CGAffineTransformMakeRotation(M_PI);
            }
            self.isShow = !self.isShow;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.attrNameLbl];
        [self.contentView addSubview:self.attrValueLbl];
        [self.contentView addSubview:self.squareImg];
        [self.contentView addSubview:self.doubtImageView];
        
        WEAKSELF;
        self.doubtImageView.handleSingleTapDetected =^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
            if (weakSelf.handleDoubtImageViewBlock) {
                weakSelf.handleDoubtImageViewBlock();
            }
        };
        
    }
    return self;
}

-(void)layoutSubviews
{
    [self.attrNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    [self.attrValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
    [self.squareImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.attrValueLbl.mas_left).offset(-5);
    }];
    
    [self.doubtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attrNameLbl.mas_right).offset(5);
        make.centerY.equalTo(self.attrNameLbl.mas_centerY);
    }];
}



@end
