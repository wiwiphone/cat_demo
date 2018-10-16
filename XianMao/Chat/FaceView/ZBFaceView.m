//
//  ZBFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//


#import "ZBFaceView.h"

#define NumPerLine (IS_GT_IPHONE_6 ? 8 : 7)
#define Lines    3
#define FaceSize  40
/*
** 两边边缘间隔
 */
#define EdgeDistance 20
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 5

@implementation ZBFaceView

- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // 水平间隔
        CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-NumPerLine*FaceSize -2*EdgeDistance)/(NumPerLine-1);
        // 上下垂直间隔
        CGFloat verticalInterval = (CGRectGetHeight(self.bounds)-2*EdgeInterVal -Lines*FaceSize)/(Lines-1);
        
        NSInteger pageTotal = (NumPerLine * Lines - 1) * index;
        
        for (int i = 0; i<Lines; i++)
        {
            for (int x = 1;x<=NumPerLine;x++)
            {
                UIButton *expressionButton =[UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:expressionButton];
                [expressionButton setFrame:CGRectMake((x-1)*FaceSize+EdgeDistance+(x-1)*horizontalInterval,
                                                      i*FaceSize +i*verticalInterval+EdgeInterVal,
                                                      FaceSize,
                                                      FaceSize)];
                
                if (pageTotal + i*NumPerLine + x == 86) {
                    [expressionButton setImage:[UIImage imageNamed:@"chat_delete"]
                                      forState:UIControlStateNormal];
                    expressionButton.tag = 0;
                    [expressionButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
                    [expressionButton addTarget:self
                                         action:@selector(faceClick:)
                               forControlEvents:UIControlEventTouchUpInside];

                    break;
                }
                
                if (i*NumPerLine+x == (IS_GT_IPHONE_6 ? 24 : 21)) {
                    [expressionButton setImage:[UIImage imageNamed:@"chat_delete"]
                                      forState:UIControlStateNormal];
                    expressionButton.tag = 0;
                    [expressionButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
                }else{
                    NSString *imageStr = [NSString stringWithFormat:@"%03ld",pageTotal + i*NumPerLine + x ];
                    [expressionButton setImage: [UIImage imageNamed:imageStr]
                                                forState:UIControlStateNormal];
                    expressionButton.tag = pageTotal + i*NumPerLine + x ;
                    [expressionButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
                    
                }

                [expressionButton addTarget:self
                                     action:@selector(faceClick:)
                           forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return self;
}

- (void)faceClick:(UIButton *)button{
    
    NSString *faceName;
    BOOL isDelete;
    if (button.tag ==0){
        faceName = nil;
        isDelete = YES;
    }else{
        NSString *expressstring = [NSString stringWithFormat:@"%03ld",button.tag];
        NSString *plistStr = [[NSBundle mainBundle]pathForResource:@"faceMap_ch" ofType:@"plist"];
        NSDictionary *plistDic = [[NSDictionary  alloc]initWithContentsOfFile:plistStr];
        
        for (int j = 0; j<[[plistDic allKeys]count]-1; j++)
        {
            if ([[plistDic objectForKey:[[plistDic allKeys]objectAtIndex:j]]
                 isEqualToString:[NSString stringWithFormat:@"%@",expressstring]])
            {
                faceName = [[plistDic allKeys]objectAtIndex:j];
            }
        }
        isDelete = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelecteFace:andIsSelecteDelete:)]) {
        [self.delegate didSelecteFace:faceName andIsSelecteDelete:isDelete];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
