//
//  ExpandColorCell.m
//  yuncangcat
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExpandColorCell.h"
#import "Command.h"
#import "AttrListInfo.h"
#import "GoodsEditableInfo.h"

@interface ExpandColorCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ExpandColorCell

-(NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
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
        __reuseIdentifier = NSStringFromClass([ExpandColorCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 20+15+12;
    
    PublishAttrInfo *attrInfo = dict[@"attrInfo"];
    if (attrInfo.list.count-1 < 5) {
        height += (kScreenWidth/5);
    } else {
        if ((attrInfo.list.count-1)%5 == 0) {
            height += (kScreenWidth/5) * ((attrInfo.list.count-1)/5);
        } else {
            height += (kScreenWidth/5) * ((attrInfo.list.count-1)/5);
            height += kScreenWidth/5;
        }
    }
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo andDict:(NSDictionary *)attDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpandColorCell class]];
    if (attrInfo) {
        [dict setObject:attrInfo forKey:@"attrInfo"];
    }
    if (attDict) {
        [dict setObject:attDict forKey:@"attrDict"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        
    }
    return self;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    PublishAttrInfo *attrInfo = dict[@"attrInfo"];
    NSDictionary *attrDict = dict[@"attrDict"];
    self.titleLbl.text = attrInfo.attr_name;
    
    for (XMWebImageView *btn in self.contentView.subviews) {
        if ([btn isKindOfClass:[XMWebImageView class]]) {
            [btn removeFromSuperview];
        }
    }
    
    for (int i = 0; i < attrInfo.list.count-1; i++) {
        AttrListInfo *attrListInfo = [[AttrListInfo alloc] initWithJSONDictionary:attrInfo.list[i] error:nil];
        XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        [imageView setImageWithURL:attrListInfo.logoUrl XMWebImageScaleType:XMWebImageScale480x480];
        imageView.valueId = attrListInfo.valueId;
        imageView.attrId = attrInfo.attr_id;
        imageView.valueName = attrListInfo.valueName;
        imageView.isMutCho = attrInfo.is_multi_choice;
        imageView.frame = CGRectMake(6+(i%5)*(kScreenWidth/5), 45+(i/5)*(kScreenWidth/5), kScreenWidth/5-15, kScreenWidth/5-15);
        [self.array addObject:imageView];
        [self.contentView addSubview:imageView];
        
        if (attrDict[[NSString stringWithFormat:@"%ld", imageView.attrId]]) {
            AttrEditableInfo *attrEditInfo1 = attrDict[[NSString stringWithFormat:@"%ld", imageView.attrId]];
            for (int i = 0; i < self.array.count; i++) {
                XMWebImageView *sender = self.array[i];
                if ([sender.valueName isEqualToString:attrEditInfo1.attrValue]) {
                    sender.isSelecet = 1;
                    sender.isSelectBack = 1;
                } else {
                    sender.isSelecet = 0;
                    sender.isSelectBack = 0;
                }
            }
        }
        
        imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
            if (attrInfo.is_multi_choice == 1) {
                if (view.isSelecet == 0) {
                    view.isSelecet = 1;
                    view.isSelectBack = 1;
                } else {
                    view.isSelecet = 0;
                    view.isSelectBack = 0;
                }
            } else {
                for (XMWebImageView *sender in self.array) {
                    if (sender.valueId == view.valueId) {
                        if (sender.isSelecet == 0) {
                            sender.isSelecet = 1;
                            sender.isSelectBack = 1;
                        } else {
                            sender.isSelecet = 0;
                            sender.isSelectBack = 0;
                        }
                    } else {
                        sender.isSelecet = 0;
                        sender.isSelectBack = 0;
                    }
                }
//                for (int o = 0; o < attrInfo.list.count; o++) {
//                    AttrListInfo *attrListInfo1 = attrInfo.list[o];
//                    if (view.valueId == attrListInfo1.valueId) {
//                        view.isSelecet = 1;
//                        view.isSelectBack = 1;
//                    }
//                }
            }
            if (self.clickColor) {
                self.clickColor(view);
            }
        };
        
    }
    
}

@end
