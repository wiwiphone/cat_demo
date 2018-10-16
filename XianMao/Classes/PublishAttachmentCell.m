//
//  PublishAttachmentCell.m
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishAttachmentCell.h"

@interface PublishAttachmentCell ()

@property (nonatomic, strong) UILabel *attachmentLbl;

@end

@implementation PublishAttachmentCell

-(UILabel *)attachmentLbl{
    if (!_attachmentLbl) {
        _attachmentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _attachmentLbl.font = [UIFont systemFontOfSize:15.f];
        _attachmentLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_attachmentLbl sizeToFit];
        _attachmentLbl.text = @"附件(多选)";
    }
    return _attachmentLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishAttachmentCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 100.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSDictionary *)data
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishAttachmentCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.attachmentLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.attachmentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
}

@end
