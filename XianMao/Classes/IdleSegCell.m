//
//  IdleSegCell.m
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IdleSegCell.h"

@implementation IdleSegCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([IdleSegCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 12.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[IdleSegCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return self;
}

@end
