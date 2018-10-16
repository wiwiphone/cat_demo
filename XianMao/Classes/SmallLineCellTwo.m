//
//  SmallLineCellTwo.m
//  XianMao
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SmallLineCellTwo.h"

@implementation SmallLineCellTwo

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SmallLineCellTwo class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 1;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SmallLineCellTwo class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 1)];
        view.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
        [self.contentView addSubview:view];
        
    }
    return self;
}

- (void)updateCellWithDict{
    
    
    [self setNeedsDisplay];
}

@end
