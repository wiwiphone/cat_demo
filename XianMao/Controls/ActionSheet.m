//
//  ActionSheet.m
//  XianMao
//
//  Created by simon on 12/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ActionSheet.h"

#define TBSCREEN_SIZE   [[UIScreen mainScreen] bounds].size
#define TBBUTTON_CORNER_RADIUS  4.0
#define TBBUTTON_BORDER_WIDTH   0.5

#define TBBUTTON_HEIGHT         45.0
#define TBBUTTON_EDGE_MARGIN    16.0            //水平边缘方向的
#define TBBUTTON_HEIGHT_MARGIN  8.0            //垂直方向的间距

@interface ADMActionSheet ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) ActionSheetButtonClickedBlock   cancelBlock;
@property (nonatomic, copy) ActionSheetButtonClickedBlock   destructiveBlock;
@property (nonatomic, copy) ActionSheetOtherButtonClickedBlock    otherBlock;
@property (nonatomic, copy) ActionSheetButtonClickedBlock    tapMaskBlock;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *cancelButton;
@property (nonatomic, strong) UIButton  *destructiveButton;
@property (nonatomic, strong) NSArray   *otherButtons;
@property (nonatomic, assign) CGFloat    positionY;

@end


@implementation ADMActionSheet

- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitlesArray
        cancelBlock:(ActionSheetButtonClickedBlock)cancelBlock
   destructiveBlock:(ActionSheetButtonClickedBlock)destructiveBlock
         otherBlock:(ActionSheetOtherButtonClickedBlock)otherBlock
       tapMaskBlock:(ActionSheetButtonClickedBlock)tapMaskBlock
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];

    if (self) {
//        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        [self addGestureRecognizer:tapGesture];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.userInteractionEnabled = YES;
        
        self.backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:self.backView];
        
        self.cancelBlock = cancelBlock;
        self.otherBlock  = otherBlock;
        self.destructiveBlock = destructiveBlock;
        self.tapMaskBlock = tapMaskBlock;
        
        [self baseInitWithTitle:title
              cancelButtonTitle:cancelButtonTitle
         destructiveButtonTitle:destructiveButtonTitle
              otherButtonTitles:otherButtonTitlesArray];
    }
    return self;
}


- (void)showInView:(UIView *)view{
    if (view == nil) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    } else {
        [view addSubview:self];
    }
    
    CGRect rect = self.backView.frame;
    self.alpha = 0.0;
    [self.backView setFrame:CGRectMake(0, TBSCREEN_SIZE.height - self.positionY, TBSCREEN_SIZE.width, self.positionY)];
    [UIView animateWithDuration:0.3 animations:^{
        [self.backView setFrame:rect];
        [self setAlpha:1.0];
    }];
}

#pragma mark - Getter
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TBBUTTON_EDGE_MARGIN, 20, TBSCREEN_SIZE.width - TBBUTTON_EDGE_MARGIN*2, 34)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset =  CGSizeMake(0, 0.8f);
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)destructiveButton{
    if (_destructiveButton == nil) {
        _destructiveButton = [[UIButton alloc] initWithFrame:CGRectMake(TBBUTTON_EDGE_MARGIN, 0, TBSCREEN_SIZE.width - TBBUTTON_EDGE_MARGIN*2, TBBUTTON_HEIGHT)];
        _destructiveButton.layer.masksToBounds = YES;
        _destructiveButton.layer.cornerRadius = TBBUTTON_CORNER_RADIUS;
        
        _destructiveButton.layer.borderWidth = TBBUTTON_BORDER_WIDTH;
        _destructiveButton.layer.borderColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor;
        _destructiveButton.backgroundColor = [UIColor colorWithRed:185/255.00f green:45/255.00f blue:39/255.00f alpha:1];
        _destructiveButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_destructiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_destructiveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_destructiveButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _destructiveButton;
}


- (UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(TBBUTTON_EDGE_MARGIN, 0, TBSCREEN_SIZE.width - TBBUTTON_EDGE_MARGIN*2, TBBUTTON_HEIGHT)];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = TBBUTTON_CORNER_RADIUS;
        _cancelButton.layer.borderWidth = TBBUTTON_BORDER_WIDTH;
        _cancelButton.layer.borderColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0].CGColor;
        
        _cancelButton.backgroundColor = [UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelButton;
}

- (UIButton *)creatOtherButtonWithTitle:(NSString *)otherButtonTitle{
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(TBBUTTON_EDGE_MARGIN, 0, TBSCREEN_SIZE.width - TBBUTTON_EDGE_MARGIN*2, TBBUTTON_HEIGHT)];
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.cornerRadius = TBBUTTON_CORNER_RADIUS;
    
    otherButton.layer.borderWidth = TBBUTTON_BORDER_WIDTH;
    otherButton.layer.borderColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor;
    
    otherButton.backgroundColor =  [UIColor whiteColor];
    [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [otherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [otherButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return otherButton;
}

#pragma mark - Private Method
- (void)baseInitWithTitle:(NSString *)title
        cancelButtonTitle:(NSString *)cancelButtonTitle
   destructiveButtonTitle:(NSString *)destructiveButtonTitle
        otherButtonTitles:(NSArray *)otherButtonTitlesArray
{
    CGFloat positionY = TBSCREEN_SIZE.height - 20;
    if ([cancelButtonTitle length] >0) {
        [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        CGRect rect = self.cancelButton.frame;
        positionY = positionY - rect.size.height;
        rect.origin.y = positionY;
        [self.cancelButton setFrame:rect];
        [self.backView addSubview:self.cancelButton];
    }
    
    if ([otherButtonTitlesArray count] >0) {
        NSInteger index = 0;
        for (NSString *otherTitle in otherButtonTitlesArray) {
            UIButton *button = [self creatOtherButtonWithTitle:otherTitle];
            button.tag = index++;
            CGRect rect = button.frame;
            positionY = positionY - rect.size.height - TBBUTTON_HEIGHT_MARGIN;
            rect.origin.y = positionY;
            [button setFrame:rect];
            [self.backView addSubview:button];
        }
    }
    
    if ([destructiveButtonTitle length] >0) {
        [self.destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
        CGRect rect = self.destructiveButton.frame;
        positionY = positionY - rect.size.height - TBBUTTON_HEIGHT_MARGIN;
        rect.origin.y = positionY;
        [self.destructiveButton setFrame:rect];
        //positionY = positionY + rect.size.height + TBBUTTON_HEIGHT_MARGIN;
        [self.backView addSubview:self.destructiveButton];
    }
    
    if ([title length] >0) {
        self.titleLabel.text = title;
        positionY = positionY - self.titleLabel.frame.size.height ;
        CGRect rect = self.titleLabel.frame;
        rect.origin.y = positionY;
        self.titleLabel.frame = rect;
        //positionY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + TBBUTTON_HEIGHT_MARGIN;
        [self.backView addSubview:self.titleLabel];
    }
    
    self.positionY = positionY;
}

#pragma mark - Button Pressed Event
- (void)buttonPressed:(UIButton*)sender{
//    if (sender == self.destructiveButton) {
//        if (self.destructiveBlock) {
//            self.destructiveBlock();
//        }
//    } else if (sender == self.cancelButton) {
//        if (self.cancelBlock) {
//            self.cancelBlock();
//        }
//    } else {
//        if (self.otherBlock) {
//            self.otherBlock(sender.tag);
//        }
//    }
//    [self removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.backView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
        if (sender == self.destructiveButton) {
            if (self.destructiveBlock) {
                self.destructiveBlock();
            }
        } else if (sender == self.cancelButton) {
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        } else {
            if (self.otherBlock) {
                self.otherBlock(sender.tag);
            }
        }
    }];
}

#pragma mark - Tap Gesture
- (void)tappedCancel:(UIGestureRecognizer*)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.backView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
        if (self.tapMaskBlock) {
            self.tapMaskBlock();
        }
    }];
}

@end
