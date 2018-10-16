//
//  PhotoTableViewCell.m
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import "Masonry.h"
#import "UIActionSheet+Blocks.h"
#import "PictureItemsEditView.h"

@interface PhotoTableViewCell ()

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *picItemViewsArray;

@end

@implementation PhotoTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PhotoTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 167;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PhotoTableViewCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"photo" object:self];
    }
    return self;
}

- (void)updateCellWithDict{
    
    [self setNeedsDisplay];
}

@end
