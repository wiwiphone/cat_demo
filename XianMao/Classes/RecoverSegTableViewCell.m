//
//  RecoverSegTableViewCell.m
//  XianMao
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverSegTableViewCell.h"
#import "Masonry.h"

@interface RecoverSegTableViewCell ()

@property (nonatomic, strong) UIView *segView;

@end

@implementation RecoverSegTableViewCell

-(UIView *)segView{
    if (!_segView) {
        _segView = [[UIView alloc] initWithFrame:CGRectZero];
        _segView.backgroundColor = [UIColor colorWithHexString:@"c7c7c7"];
    }
    return _segView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverSegTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverSegTableViewCell class]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat height = 1;
    return height;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.segView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
}

@end
