//
//  ReturnGoodsReturnReasonCell.m
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsReturnReasonCell.h"
#import "Masonry.h"

@interface ReturnGoodsReturnReasonCell ()<UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate>
{
    NSArray * _reasonArray;
    UIPickerView * _reasonPicker;
}
@property (nonatomic, strong) UILabel *starLbl;
@property (nonatomic,strong) UITextField * reasonTf;

@property (nonatomic, assign) BOOL isYes;
@end

@implementation ReturnGoodsReturnReasonCell

-(UIImageView *)chooseImageView{
    if (!_chooseImageView) {
        _chooseImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _chooseImageView.image = [UIImage imageNamed:@"Return_Choose_Down"];
        [_chooseImageView sizeToFit];
    }
    return _chooseImageView;
}

-(UIButton *)chooseReasonBtn{
    if (!_chooseReasonBtn) {
        _chooseReasonBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLbl.frame)+2, self.titleLbl.origin.y, kScreenWidth/375*265, 27)];
        [_chooseReasonBtn setTitle:@"请选择退货原因" forState:UIControlStateNormal];
        _chooseReasonBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_chooseReasonBtn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
        _chooseReasonBtn.layer.borderWidth = 1.f;
        _chooseReasonBtn.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
        
        [_chooseReasonBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseReasonBtn;
}

-(UITextField *)reasonTf
{
    if (!_reasonTf) {
        _reasonTf = [[UITextField alloc] init];
        _reasonTf.delegate = self;
    }
    return _reasonTf;
}

-(void)buttonClick
{
    
    [_reasonTf becomeFirstResponder];
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, kScreenWidth/375*80, 27)];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _titleLbl.text = @"*  退货原因";
    }
    return _titleLbl;
}


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ReturnGoodsReturnReasonCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSMutableArray *)reasonArr{
    CGFloat height = 44.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)reasonArr
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ReturnGoodsReturnReasonCell class]];
    if (reasonArr) {
        [dict setObject:reasonArr forKey:@"reasonArr"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.isYes = NO;
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.chooseReasonBtn];
        [self.contentView addSubview:self.chooseImageView];
        [self.contentView addSubview:self.reasonTf];
        [self customResonTfKeyBord];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chooseReasonBtn.mas_centerY);
        make.right.equalTo(self.chooseReasonBtn.mas_right).offset(-8);
    }];

}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
}



#pragma mark - textfileDelegat
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.isYes == NO) {
        [_chooseReasonBtn setTitle:[NSString stringWithFormat:@"%@",_reasonArray[0]] forState:UIControlStateNormal];
        if (self.returnReason) {
            self.returnReason(_reasonArray[0]);
        }
    }
    
}

#pragma mark - pickerView and Delegate
-(void)customResonTfKeyBord
{
    _reasonArray = @[@"大小/尺寸与商品描述不符",
                     @"颜色/图案/款式/材质与商品不符",
                     @"成色问题",
                     @"少件/漏发",
                     @"发错货",
                     @"其他原因"];
    _reasonPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 225)];
    _reasonPicker.dataSource = self;
    _reasonPicker.delegate = self;
    _reasonTf.inputView = _reasonPicker;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.isYes = YES;
    _reasonTf.text = _reasonArray[row];
    [_chooseReasonBtn setTitle:[NSString stringWithFormat:@"%@",_reasonArray[row]] forState:UIControlStateNormal];
    
    if (self.returnReason) {
        self.returnReason(_reasonArray[row]);
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _reasonArray[row];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _reasonArray.count;
}


@end
