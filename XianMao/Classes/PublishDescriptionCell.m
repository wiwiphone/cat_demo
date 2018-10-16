//
//  PublishDescriptionCell.m
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishDescriptionCell.h"
#import "Command.h"
#import "HPGrowingTextView.h"

@interface PublishDescriptionCell () <HPGrowingTextViewDelegate>

@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) NSMutableString *str;

@end

@implementation PublishDescriptionCell

-(NSMutableString *)str{
    if (!_str) {
        _str = [[NSMutableString alloc] init];
    }
    return _str;
}

-(HPGrowingTextView *)textView{
    if (!_textView) {
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.autoRefreshHeight = NO;
        _textView.animateHeightChange = NO;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.font = [UIFont systemFontOfSize:15.f];
        _textView.placeholder = @"描述一下你的商品吧";
    }
    return _textView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishDescriptionCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 160.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray *)goodsDesc andDesc:(NSString *)desc
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishDescriptionCell class]];
    if (goodsDesc) {
        [dict setObject:goodsDesc forKey:@"goodsDesc"];
    }
    if (desc) {
        [dict setObject:desc forKey:@"desc"];
    }
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
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-50);
    }];
    
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
    NSArray *arr = dict[@"goodsDesc"];
    NSString *desc = dict[@"desc"];
    WEAKSELF;
    if (desc.length>0) {
        self.textView.text = desc;
    }
    
    for (CommandButton *btn in self.contentView.subviews) {
        if ([btn isKindOfClass:[CommandButton class]]) {
            [btn removeFromSuperview];
        }
    }
    
    for (UIImageView *imageView in self.contentView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            [imageView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < [arr count]; i++) {
        CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(10, 10+self.textView.height+10, 0, 0)];
        btn.tag = i+1;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        [btn sizeToFit];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10+self.textView.height+10, 0, 0)];
        bgImageView.image = [UIImage imageNamed:@"Publish_fornt"];
        
        [self.contentView addSubview:bgImageView];
        [self.contentView addSubview:btn];
        
        CommandButton *forntBtn = [self viewWithTag:i];
        NSLog(@"%f", forntBtn.width);
        if (i > 0) {
            btn.frame = CGRectMake(10+forntBtn.width+5+20+10, 10+self.textView.height+10, btn.width, btn.height);
            bgImageView.frame = CGRectMake(10+forntBtn.width+5+18, 10+self.textView.height+10+3, btn.width+20, btn.height-6);
        } else {
            btn.frame = CGRectMake(10+10, 10+self.textView.height+10, btn.width, btn.height);
            bgImageView.frame = CGRectMake(10, 10+self.textView.height+10+3, btn.width+20, btn.height-6);
        }
        
        btn.handleClickBlock = ^(CommandButton *sender){
            weakSelf.str = nil;
            [weakSelf.str appendFormat:@"%@%@", weakSelf.textView.text, sender.titleLabel.text];
            [weakSelf.str appendFormat:@" "];
            weakSelf.textView.text = weakSelf.str;//sender.titleLabel.text;
            [weakSelf.textView becomeFirstResponder];
        };
        
    }
}

@end
