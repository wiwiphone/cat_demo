//
//  PublishMeasurementCell.m
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishMeasurementCell.h"
#import "AttrListInfo.h"

@interface PublishMeasurementCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) PublishAttrInfo *attrInfo;
@property (nonatomic, copy) NSString *longMM;
@property (nonatomic, copy) NSString *widthMM;
@property (nonatomic, copy) NSString *heightMM;

@property (nonatomic, copy) NSMutableString *text;
@property (nonatomic, strong) NSMutableArray *textFidleArr;
@end

@implementation PublishMeasurementCell

-(NSMutableArray *)textFidleArr{
    if (!_textFidleArr) {
        _textFidleArr = [[NSMutableArray alloc] init];
    }
    return _textFidleArr;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishMeasurementCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 62.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo dict:(NSDictionary *)textDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishMeasurementCell class]];
    
    if (attrInfo) {
        [dict setObject:attrInfo forKey:@"attrInfo"];
    }
    
    if (textDict) {
        [dict setObject:textDict forKey:@"textDict"];
    }
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

//-(void)clickControlBtn{
//    
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}

-(void)endEdit{
    [self.contentView endEditing:YES];
    NSDictionary *dict = @{@"attr_id":@(self.attrInfo.attr_id), @"textFidleArr":self.textFidleArr};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"inputTextField" object:dict];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEdit];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    NSMutableString *str = [[NSMutableString alloc] init];
//    for (int i = 0; i < self.textFidleArr.count; i++) {
//        UITextField *textField = self.textFidleArr[i];
//        if (textField.text.length == 0) {
//            return;
//        }
//        [str appendString:textField.text];
//        if (i < self.textFidleArr.count - 1) {
//            [str appendString:@"X"];
//        }
//        NSLog(@"%@", str);
//        if (self.inputText) {
//            self.inputText(str);
//        }
//    }
    
//    if (self.inputText) {
//        self.inputText(self.textFidleArr);
//    }
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    PublishAttrInfo *attrInfo = dict[@"attrInfo"];
    NSString *textStr = dict[[NSString stringWithFormat:@"%ld", attrInfo.attr_id]];
    
    NSArray *textStrArr = [textStr componentsSeparatedByString:@"X"];
    self.attrInfo = attrInfo;
    
    for (UITextField *textField in self.contentView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField removeFromSuperview];
        }
    }
    
    for (UILabel *lbl in self.contentView.subviews) {
        if ([lbl isKindOfClass:[UILabel class]]) {
            [lbl removeFromSuperview];
        }
    }
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    self.titleLbl.text = attrInfo.attr_name;
    CGFloat margin = 12;
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:15.f];
    lbl.text = attrInfo.attr_name;
    [lbl sizeToFit];
    margin += lbl.width;
    
    if (attrInfo.list.count == 0) {
        NSMutableArray *attrArr = [[NSMutableArray alloc] init];
        AttrListInfo *attrListInfo = [[AttrListInfo alloc] init];
        attrListInfo.valueName = @"长 mm";
        [attrArr addObject:attrListInfo];
        attrInfo.list = attrArr;
    }
    for (int i = 0; i < attrInfo.list.count; i++) {
        AttrListInfo *attrListInfo = [[AttrListInfo alloc] initWithJSONDictionary:attrInfo.list[i] error:nil];;
        
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.borderColor = [UIColor colorWithHexString:@"cbcbcb"].CGColor;
        textField.layer.borderWidth = 1.f;
        textField.tag = i+1;
        textField.delegate = self;
        textField.placeholder = attrListInfo.valueName;
        textField.font = [UIFont systemFontOfSize:13.f];
        textField.returnKeyType = UIReturnKeyDone;
        [self.textFidleArr addObject:textField];
        
        [self.contentView addSubview:textField];
        margin += 5;
        textField.frame = CGRectMake(margin, (self.contentView.height-30)/2, 70, 30);
        margin += textField.width;
        
        if (textStrArr[i]) {
            textField.text = textStrArr[i];
        }
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.font = [UIFont systemFontOfSize:15.f];
        lbl.textColor = [UIColor colorWithHexString:@"434342"];
        [lbl sizeToFit];
        if (i < attrInfo.list.count - 1) {
            lbl.text = @"×";
        } else {
            lbl.text = @"mm";
        }
        [self.contentView addSubview:lbl];
        lbl.frame = CGRectMake(margin, (self.contentView.height-lbl.height)/2, lbl.width, lbl.height);
        margin += lbl.width;
        margin += 5;
        
        
        if (self.textFidleArr.count > 3) {
            [self.textFidleArr removeAllObjects];
            textField.text = @"";
        }
        
    }
}

@end
