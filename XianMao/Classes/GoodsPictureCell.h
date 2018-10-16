//
//  GoodsPictureCell.h
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PictureItem.h"

typedef void(^showPicDetail)(XMWebImageView *imageView);

@interface GoodsPictureCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(PictureItem *)item index:(NSInteger)index;
-(void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) showPicDetail showPicDetail;

@end
