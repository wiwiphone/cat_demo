//
//  BaseTableViewCell.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NSDictionary+Additions.h"

@implementation BaseTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BaseTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [self rowHeightForPortrait];
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict index:(NSInteger)index {
    return [self rowHeightForPortrait:dict];
}

+ (NSString*)dictKeyOfClsName
{
    return @"clsName";
}

+ (Class)clsTableViewCell:(NSDictionary*)dict
{
    NSString *clsName = [dict stringValueForKey:[[self class] dictKeyOfClsName]];
    if (clsName != nil && [clsName length] > 0) {
        return NSClassFromString(clsName);
    }
    return [BaseTableViewCell class];
}

+ (NSMutableDictionary*)buildBaseCellDict:(Class)cls
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            NSStringFromClass(cls), [[self class] dictKeyOfClsName],nil];
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    
}

- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}
@end


