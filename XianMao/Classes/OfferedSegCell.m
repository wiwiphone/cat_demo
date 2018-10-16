//
//  OfferedSegCell.m
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OfferedSegCell.h"
#import "Masonry.h"

@interface OfferedSegCell ()

@property (nonatomic, strong) UIView *segView;

@end

@implementation OfferedSegCell

-(UIView *)segView{
    if (!_segView) {
        _segView = [[UIView alloc] initWithFrame:CGRectZero];
        _segView.backgroundColor = [UIColor colorWithHexString:@"b4b4b5"];
    }
    return _segView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OfferedSegCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OfferedSegCell class]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
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
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

@end
