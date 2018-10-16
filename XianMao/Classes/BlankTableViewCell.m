//
//  BlankTableViewCell.m
//  XianMao
//
//  Created by simon on 1/24/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BlankTableViewCell.h"

#import "LoadingView.h"

@implementation BlankTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BlankTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    UITableView *tableView = [dict objectForKey:[self cellKeyForTableView]];
    if ([tableView isKindOfClass:[UITableView class]]) {
        height = tableView.height-tableView.tableHeaderView.height;
    }
    if (height<100) {
        height = 100.f;
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(UITableView*)tableView title:(NSString*)title {
    return [self buildCellDict:tableView title:title isLoading:NO];
}

+ (NSMutableDictionary*)buildCellDict:(UITableView*)tableView title:(NSString*)title isLoading:(BOOL)isLoading {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BlankTableViewCell class]];
    if (tableView)[dict setObject:tableView forKey:[self cellKeyForTableView]];
    if (title) [dict setObject:title forKey:[self cellKeyForBlankTitle]];
    [dict setObject:[NSNumber numberWithBool:isLoading] forKey:[self cellKeyForLoading]];
    return dict;
}

+ (NSString*)cellKeyForTableView {
    return @"tableView";
}

+ (NSString*)cellKeyForBlankTitle {
    return @"blankTitle";
}

+ (NSString*)cellKeyForLoading {
    return @"loading";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [LoadingView loadingView:self.contentView].frame = self.contentView.bounds;;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    BOOL isLoading = [dict boolValueForKey:[[self class] cellKeyForLoading] defaultValue:NO];
    if (isLoading) {
       [LoadingView showLoadingView:self.contentView];
    } else {
        NSString *title = [dict stringValueForKey:[[self class] cellKeyForBlankTitle]];
        [LoadingView loadEndWithNoContent:self.contentView title:title&&title.length>0?title:@"暂无内容" image:nil];
    }
}

@end
