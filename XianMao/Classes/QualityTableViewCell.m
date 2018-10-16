//
//  QualityTableViewCell.m
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "QualityTableViewCell.h"
#import "Masonry.h"
#import "GoodsEditableInfo.h"

@interface QualityTableViewCell ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;

@property (nonatomic, strong) UIButton *seleBtn;

@end

@implementation QualityTableViewCell

-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setTitle:@"全新" forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_btn.layer setBorderColor:[UIColor colorWithHexString:@"b4b4b5"].CGColor];
        [_btn.layer setBorderWidth:1];
        [_btn.layer setMasksToBounds:YES];
        _btn.tag = 1;
        
    }
    return _btn;
}

-(UIButton *)btn1{
    if (!_btn1) {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setTitle:@"98成新" forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn1 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_btn1.layer setBorderColor:[UIColor colorWithHexString:@"b4b4b5"].CGColor];
        [_btn1.layer setBorderWidth:1];
        [_btn1.layer setMasksToBounds:YES];
        _btn1.tag = 5;
    }
    return _btn1;
}

-(UIButton *)btn2{
    if (!_btn2) {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setTitle:@"95成新" forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn2 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_btn2.layer setBorderColor:[UIColor colorWithHexString:@"b4b4b5"].CGColor];
        [_btn2.layer setBorderWidth:1];
        [_btn2.layer setMasksToBounds:YES];
        _btn2.tag = 2;
        
    }
    return _btn2;
}

-(UIButton *)btn3{
    if (!_btn3) {
        _btn3 = [[UIButton alloc] init];
        [_btn3 setTitle:@"9成新" forState:UIControlStateNormal];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn3 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
        [_btn3 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_btn3.layer setBorderColor:[UIColor colorWithHexString:@"b4b4b5"].CGColor];
        [_btn3.layer setBorderWidth:1];
        [_btn3.layer setMasksToBounds:YES];
        _btn3.tag = 3;
    }
    return _btn3;
}

-(UIButton *)btn4{
    if (!_btn4) {
        _btn4 = [[UIButton alloc] init];
        [_btn4 setTitle:@"85成新" forState:UIControlStateNormal];
        _btn4.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _btn4.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn4 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
        [_btn4 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_btn4.layer setBorderColor:[UIColor colorWithHexString:@"b4b4b5"].CGColor];
        [_btn4.layer setBorderWidth:1];
        [_btn4.layer setMasksToBounds:YES];
        _btn4.tag = 6;
    }
    return _btn4;
}

-(UIButton *)btn5{
    if (!_btn5) {
        _btn5 = [[UIButton alloc] init];
        [_btn5 setTitle:@"8成新" forState:UIControlStateNormal];
        _btn5.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _btn5.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn5 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
        [_btn5 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        [_btn5.layer setBorderColor:[UIColor colorWithHexString:@"b4b4b5"].CGColor];
        [_btn5.layer setBorderWidth:1];
        [_btn5.layer setMasksToBounds:YES];
        _btn5.tag = 4;
    }
    return _btn5;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([QualityTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 3 * 27 + 4 * 15;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsEditableInfo *)editInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[QualityTableViewCell class]];
    if (editInfo) {
        [dict setObject:editInfo forKey:@"editInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.btn];
        [self.contentView addSubview:self.btn1];
        [self.contentView addSubview:self.btn2];
        [self.contentView addSubview:self.btn3];
        [self.contentView addSubview:self.btn4];
        [self.contentView addSubview:self.btn5];
        
        [self.btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn3 addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn4 addTarget:self action:@selector(clickBtn4:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn5 addTarget:self action:@selector(clickBtn5:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)clickBtn:(UIButton *)sender{
    sender.selected = YES;
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.btn4.selected = NO;
    self.btn5.selected = NO;
    if ([self.quaDelegate respondsToSelector:@selector(getQuaData:)]) {
        [self.quaDelegate getQuaData:sender];
    }
}

-(void)clickBtn1:(UIButton *)sender{
    sender.selected = YES;
    self.btn.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.btn4.selected = NO;
    self.btn5.selected = NO;
    if ([self.quaDelegate respondsToSelector:@selector(getQuaData:)]) {
        [self.quaDelegate getQuaData:sender];
    }
}

-(void)clickBtn2:(UIButton *)sender{
    sender.selected = YES;
    self.btn1.selected = NO;
    self.btn.selected = NO;
    self.btn3.selected = NO;
    self.btn4.selected = NO;
    self.btn5.selected = NO;
    if ([self.quaDelegate respondsToSelector:@selector(getQuaData:)]) {
        [self.quaDelegate getQuaData:sender];
    }
}

-(void)clickBtn3:(UIButton *)sender{
    sender.selected = YES;
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn.selected = NO;
    self.btn4.selected = NO;
    self.btn5.selected = NO;
    if ([self.quaDelegate respondsToSelector:@selector(getQuaData:)]) {
        [self.quaDelegate getQuaData:sender];
    }
}

-(void)clickBtn4:(UIButton *)sender{
    sender.selected = YES;
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.btn.selected = NO;
    self.btn5.selected = NO;
    if ([self.quaDelegate respondsToSelector:@selector(getQuaData:)]) {
        [self.quaDelegate getQuaData:sender];
    }
}

-(void)clickBtn5:(UIButton *)sender{
    sender.selected = YES;
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.btn4.selected = NO;
    self.btn.selected = NO;
    if ([self.quaDelegate respondsToSelector:@selector(getQuaData:)]) {
        [self.quaDelegate getQuaData:sender];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.equalTo(@27);
        make.right.equalTo(self.contentView.mas_centerX).offset(-10);
    }];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@27);
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
    }];
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.equalTo(@27);
        make.right.equalTo(self.contentView.mas_centerX).offset(-10);
    }];
    
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn1.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@27);
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
    }];
    
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn2.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.equalTo(@27);
        make.right.equalTo(self.contentView.mas_centerX).offset(-10);
    }];
    
    [self.btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn3.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@27);
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsEditableInfo *editInfo = dict[@"editInfo"];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:self.btn, self.btn1, self.btn2, self.btn3, self.btn4, self.btn5, nil];
    for (int i = 0; i < 6; i++) {
        UIButton *btn = arr[i];
        if (editInfo.grade == btn.tag) {
            btn.selected = YES;
        }
    }
    [self setNeedsDisplay];
}

@end
