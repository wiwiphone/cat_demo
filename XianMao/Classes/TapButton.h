//
//  TapButton.h
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "Command.h"

@interface TapButton : CommandButton

@property (nonatomic, assign) BOOL Seclecting;

-(void)setSeclecting:(BOOL)Seclecting;
- (void)loadWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

@end
