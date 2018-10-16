//
//  FeedsCell.m
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "FeedsTableViewCell.h"
#import "FeedsItem.h"
#import "GoodsInfo.h"

@implementation FeedsTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([FeedsTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (NSMutableDictionary*)buildCellDict:(FeedsItem*)info
{
    return [super buildCellDict:(GoodsInfo*)[info item]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    [super updateCellWithDict:dict];
}

@end

