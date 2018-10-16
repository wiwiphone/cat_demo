//
//  ExpandCell.m
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExpandCell.h"
#import "GoodsEditableInfo.h"

@interface ExpandCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSMutableArray *attrMutArr;

@end

@implementation ExpandCell

-(NSMutableArray *)attrMutArr{
    if (!_attrMutArr) {
        _attrMutArr = [[NSMutableArray alloc] init];
    }
    return _attrMutArr;
}

-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
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

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ExpandCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 20+15+12;
    CGFloat width = 12;
    PublishAttrInfo *attrInfo = dict[@"attrInfo"];
    if (attrInfo.list.count > 0) {
        for (int i = 0; i < attrInfo.list.count; i++) {
            AttrListInfo *attrListInfo = [[AttrListInfo alloc] initWithJSONDictionary:attrInfo.list[i] error:nil];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [btn sizeToFit];
            [btn setTitle:attrListInfo.valueName forState:UIControlStateNormal];
            
//            if (i > 0) {
                width += btn.width+10;
//            }
            if (width > kScreenWidth-24) {
                width = 12;
                height += btn.height + 12;
            } else {
                if (i==0) {
                    height += btn.height;
                }
            }
        }
    } else {
        height += 12;
    }
    return height+8;
}

+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo dict:(NSDictionary *)attrDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpandCell class]];
    if (attrInfo) {
        [dict setObject:attrInfo forKey:@"attrInfo"];
    }
    if (attrDict) {
        [dict setObject:attrDict forKey:@"attrDict"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.titleLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    CGFloat width = 12;
    CGFloat height = 12;
    
    PublishAttrInfo *attrInfo = dict[@"attrInfo"];
    NSDictionary *attrDict = dict[@"attrDict"];
    
    self.titleLbl.text = attrInfo.attr_name;
    
    for (CommandButton *btn in self.contentView.subviews) {
        if ([btn isKindOfClass:[CommandButton class]]) {
            [btn removeFromSuperview];
        }
    }
    
//    if (self.contentView.subviews.count < 2) {
        for (int i = 0; i < attrInfo.list.count; i++) {
            AttrListInfo *attrListInfo = [[AttrListInfo alloc] initWithJSONDictionary:attrInfo.list[i] error:nil];
            CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectZero];
            btn.tag = i+1;
            btn.attrId = attrInfo.attr_id;
            btn.isMultiSelected = attrInfo.is_multi_choice;
            btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [btn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [btn setTitle:attrListInfo.valueName forState:UIControlStateNormal];
            [btn sizeToFit];
            [self.contentView addSubview:btn];
            
            if (attrDict[[NSString stringWithFormat:@"%ld", btn.attrId]]) {
                AttrEditableInfo *attrEditInfo = attrDict[[NSString stringWithFormat:@"%ld", btn.attrId]];
                if (btn.isMultiSelected == 1) {
                    NSArray *array= [attrEditInfo.attrValue componentsSeparatedByString:@","];
                    if (array.count > 0) {
                        for (int i = 0; i < array.count; i++) {
                            NSString *str = array[i];
                            if ([str isEqualToString:btn.titleLabel.text]) {
                                btn.isSelectedYes = 1;
                                btn.backgroundColor = [UIColor colorWithHexString:@"7b7b7b"];
                                [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                            }
                        }
                    } else {
                        btn.isSelectedYes = 0;
                        btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                        [btn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
                    }
                } else {
                    if (btn.attrId == attrEditInfo.attrId && [btn.titleLabel.text isEqualToString:attrEditInfo.attrValue]) {
                        btn.isSelectedYes = 1;
                        btn.backgroundColor = [UIColor colorWithHexString:@"7b7b7b"];
                        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                    } else {
                        btn.isSelectedYes = 0;
                        btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                        [btn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
                    }
                }
            }
            
            CommandButton *firstBtn = nil;
            if (i > 0) {
                firstBtn = [self.contentView viewWithTag:i];
                width += firstBtn.width+10;
            }
            
            if (width+btn.width > kScreenWidth-24) {
                width = 12;
                height += btn.height;
                height += 8;
            }
            
            [self.btnArr addObject:btn];
            
            NSLog(@"%.2f", firstBtn.width);
            btn.frame = CGRectMake(width, 20+15+6+height, btn.width+10, btn.height);
            [self.contentView addSubview:btn];
            
            btn.handleClickBlock = ^(CommandButton *sender){
                if (attrInfo.is_multi_choice == 0) {
                    for (int i = 0; i < self.btnArr.count; i++) {
                        CommandButton *button = self.btnArr[i];
                        if (sender.tag == button.tag) {
                            if (button.isSelectedYes == 0) {
                                button.backgroundColor = [UIColor colorWithHexString:@"7b7b7b"];
                                [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                                button.isSelectedYes = 1;
                            } else {
                                button.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                                [button setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
                                button.isSelectedYes = 0;
                            }
                           
                        } else {
                            button.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                            [button setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
                            button.isSelectedYes = 0;
                        }
                    }
                } else {
                    for (int i = 0; i < self.btnArr.count; i++) {
                        CommandButton *button = self.btnArr[i];
                        if (sender.tag == button.tag) {
                            if (button.isSelectedYes == 0) {
                                button.backgroundColor = [UIColor colorWithHexString:@"7b7b7b"];
                                [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                                button.isSelectedYes = 1;
                            } else {
                                button.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                                [button setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
                                button.isSelectedYes = 0;
                            }
                            
                        }
                    }
                }
                
//                AttrListInfo *attrListInfo = attrInfo.list[sender.tag-1];
                if (self.getAttrInfo) {
                    self.getAttrInfo(sender, attrInfo.is_multi_choice);
                }
            };
        }
//    }
    
}

@end
