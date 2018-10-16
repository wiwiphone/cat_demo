//
//  ReceiveCell.m
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReceiveCell.h"
#import "Command.h"
#import "WCAlertView.h"
#import "NetworkManager.h"
#import "Error.h"

@interface ReceiveCell ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) CommandButton *receiveBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *leftView;
@end

@implementation ReceiveCell

-(UIImageView *)leftView{
    if (!_leftView) {
        _leftView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftView.image = [UIImage imageNamed:@"Receive_Field_Left_Image"];
        [_leftView sizeToFit];
    }
    return _leftView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    }
    return _lineView;
}

-(CommandButton *)receiveBtn{
    if (!_receiveBtn) {
        _receiveBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _receiveBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_receiveBtn setTitle:@"激活领券" forState:UIControlStateNormal];
        [_receiveBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _receiveBtn.layer.borderColor = [UIColor colorWithHexString:@"434342"].CGColor;
        _receiveBtn.layer.borderWidth = 1.f;
    }
    return _receiveBtn;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.leftView = self.leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = @"输入邀请码";
        _textField.font = [UIFont systemFontOfSize:15.f];
    }
    return _textField;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ReceiveCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 60;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(InvitationVo *)invitationVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ReceiveCell class]];
    if (invitationVo)[dict setObject:invitationVo forKey:@"invitationVo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAKSELF;
        [self.contentView addSubview:self.receiveBtn];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.lineView];
        
        self.receiveBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf.textField endEditing:YES];
            [[CoordinatingController sharedInstance] showProcessingHUD:@""];
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"invitation" path:@"input_code" parameters:@{@"code":weakSelf.textField.text} completionBlock:^(NSDictionary *data) {
                [[CoordinatingController sharedInstance] hideHUD];
                
                if (weakSelf.handleRecriveBtn) {
                    weakSelf.handleRecriveBtn(data);
                }
                
            } failure:^(XMError *error) {
                [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:1.6];
            } queue:nil]];
            
            
        };
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.receiveBtn.mas_left).offset(-10);
        make.height.equalTo(@25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(3);
        make.left.equalTo(self.textField.mas_left);
        make.right.equalTo(self.textField.mas_right);
        make.height.equalTo(@1);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    InvitationVo *invationVo = dict[@"invitationVo"];
    
    
}

@end
