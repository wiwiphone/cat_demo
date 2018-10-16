//
//  SharedItem.h
//  XianMao
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedItem : NSObject <UIActivityItemSource>

-(instancetype)initWithData:(UIImage*)img andFile:(NSURL*)file;

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *path;

@end
