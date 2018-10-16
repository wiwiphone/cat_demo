//
//  ConsignmentDescriptionCell.m
//  XianMao
//
//  Created by WJH on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ConsignmentDescriptionCell.h"
#import "HPGrowingTextView.h"

@interface ConsignmentDescriptionCell()<HPGrowingTextViewDelegate>

@property (nonatomic, strong) HPGrowingTextView *textView;

@end

@implementation ConsignmentDescriptionCell

-(HPGrowingTextView *)textView{
    if (!_textView) {
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.autoRefreshHeight = NO;
        _textView.animateHeightChange = NO;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.font = [UIFont systemFontOfSize:13.f];
        _textView.placeholder = @"关于商品的介绍, 有利于估价";
    }
    return _textView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ConsignmentDescriptionCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 110.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ConsignmentDescriptionCell class]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEdit) name:@"endEdit" object:nil];
    }
    return self;
}

-(void)endEdit{
    if (self.returnText) {
        self.returnText(self.textView.text);
    }
    [self.contentView endEditing:YES];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
}

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
    [self endEdit];
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        [self endEdit];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


-(void)updateCellWithDict:(NSDictionary *)dict{


}



@end
