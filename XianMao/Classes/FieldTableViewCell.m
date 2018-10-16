//
//  FieldTableViewCell.m
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FieldTableViewCell.h"
#import "HPGrowingTextView.h"
#import "Masonry.h"

@interface FieldTableViewCell () <HPGrowingTextViewDelegate>

@property (nonatomic, strong) HPGrowingTextView *textField;
@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation FieldTableViewCell

-(UILabel *)numLbl{
    if (!_numLbl) {
        _numLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLbl.textColor = [UIColor colorWithHexString:@"c8c9ca"];
        _numLbl.font = [UIFont systemFontOfSize:12.f];
        _numLbl.text = @"0/500";
        [_numLbl sizeToFit];
    }
    return _numLbl;
}

-(HPGrowingTextView *)textField {
    if (!_textField) {
        _textField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 62)];
//        _textField.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _textField.placeholder = @"描述下你要求回收的宝贝吧...";
        _textField.isScrollable = NO;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDefault;
        _textField.enablesReturnKeyAutomatically = NO;
        _textField.animateHeightChange = NO;
        _textField.autoRefreshHeight = NO;
        
    }
    return _textField;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([FieldTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
//    CGFloat rowHeight = 62;
    //修改高度解决下面cell的图片部分被覆盖问题
    CGFloat rowHeight = 72;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsEditableInfo *)editInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[FieldTableViewCell class]];
    if (editInfo) {
        [dict setObject:editInfo forKey:@"editInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textField.delegate = self;
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.numLbl];
    }
    return self;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    return NO;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *newtxt = [NSMutableString stringWithString:growingTextView.text];
    [newtxt replaceCharactersInRange:range withString:text];
    return [newtxt length]<=500;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    _numLbl.text = [NSString stringWithFormat:@"%ld/500",(long)[growingTextView.text length]];
    if ([self.fieldDelegate respondsToSelector:@selector(getData:)]) {
        [self.fieldDelegate getData:growingTextView.text];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.top.equalTo(self.contentView.mas_top).offset(15);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
//    }];
    
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textField.mas_right).offset(-5);
        make.bottom.equalTo(self.textField.mas_bottom).offset(-5);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    if (dict) {
        GoodsEditableInfo *editInfo = dict[@"editInfo"];
        if (editInfo.summary) {
            self.textField.text = editInfo.summary;
        }
    }
    [self setNeedsDisplay];
}

@end
