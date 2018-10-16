//
//  TitleTableViewCell.m
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TitleTableViewCell.h"
#import "Masonry.h"

@interface TitleTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *QuestionBtn;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation TitleTableViewCell

-(UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = [UIFont systemFontOfSize:15.f];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.textColor = [UIColor colorWithHexString:@"595757"];
    }
    return _promptLabel;
}

-(UIButton *)QuestionBtn{
    if (!_QuestionBtn) {
        _QuestionBtn = [[UIButton alloc] init];
        [_QuestionBtn setImage:[UIImage imageNamed:@"Question_Recover_MF"] forState:UIControlStateNormal];
    }
    return _QuestionBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"595757"];
    }
    return _titleLabel;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([TitleTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 35;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)title andPrompTitle:(NSString *)promptTitle{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[TitleTableViewCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    if (promptTitle) {
        [dict setObject:promptTitle forKey:@"promptTitle"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.QuestionBtn];
        [self.contentView addSubview:self.promptLabel];
        
        [self.QuestionBtn addTarget:self action:@selector(clickQuestionBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    //适配iOS7.0
    if (self.promptLabel.hidden == YES) {
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
    } else {
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
        }];
    }
    
    if (self.promptLabel.text.length > 0) {
        [self.QuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.left.equalTo(self.promptLabel.mas_right).offset(10);
        }];
    } else {
        [self.QuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
        }];
    }
    
    
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    if (dict) {
        NSString *title = dict[@"title"];
        NSString *promptTitle = dict[@"promptTitle"];
        NSString *promptTitleTwo = [NSString stringWithFormat:@"(%@)", promptTitle];
        
        if (title) {
            self.titleLabel.text = title;
            self.QuestionBtn.hidden = YES;
        } else {
            self.titleLabel.text = @"商品成色";
            self.QuestionBtn.hidden = NO;
        }
        
        if (![promptTitleTwo isEqualToString:@"()"]) {
            self.promptLabel.text = promptTitleTwo;
        } else if (promptTitle.length == 0) {
//            self.promptLabel.width = 0;
            self.promptLabel.hidden = YES;
        }
        
    }
    [self setNeedsDisplay];
}

-(void)clickQuestionBtn{
    if ([self.titleDelegate respondsToSelector:@selector(sheetQuaView)]) {
        [self.titleDelegate sheetQuaView];
    }
}

@end
