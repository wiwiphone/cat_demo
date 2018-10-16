/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "DXRecordView.h"
#import "EMCDDeviceManager.h"
@interface DXRecordView ()
{
    NSTimer *_timer;
    // 显示动画的ImageView
    UIImageView *_recordAnimationView;
    // 提示文字
    UILabel *_textLabel;
}

@end

@implementation DXRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 20)];
        _recordAnimationView.image = [UIImage imageNamed:@"voicesearching_01"];
        [self addSubview:_recordAnimationView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               self.bounds.size.height - 30,
                                                               self.bounds.size.width - 10,
                                                               25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

// 录音按钮按下
-(void)recordButtonTouchDown
{
    // 需要根据声音大小切换recordView动画
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
}
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
}
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    _textLabel.backgroundColor = [UIColor clearColor];
    [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_01"]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];


}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
    _textLabel.backgroundColor = [UIColor redColor];
    [_recordAnimationView setImage:[UIImage imageNamed:@"voice_cancel@2x"]];
    [_timer invalidate];

}

-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:@"voicesearching_01"];
    double voiceSound = 0;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    if (0 < voiceSound<=0.10) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_01"]];
    }else if (0.10<voiceSound<=0.20) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_02"]];
    }else if (0.20<voiceSound<=0.30) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_03"]];
    }else if (0.30<voiceSound<=0.40) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_04"]];
    }else if (0.40<voiceSound<=0.50) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_05"]];
    }else if (0.50<voiceSound<=0.60) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_06"]];
    }else if (0.60<voiceSound<=0.70) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_07"]];
    }else if (0.70<voiceSound<=0.80) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_08"]];
    }else if (0.80<voiceSound<=0.90) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_09"]];
    }else {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voicesearching_10"]];
    }
}

@end
