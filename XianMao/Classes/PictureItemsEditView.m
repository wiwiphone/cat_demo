//
//  PictureItemsEditView.m
//  XianMao
//
//  Created by simon cai on 10/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "PictureItemsEditView.h"
#import "ActionSheet.h"
#import "UIImage+Resize.h"
#import "AppDirs.h"
#import "AssetPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "UIActionSheet+Blocks.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "masonry.h"
#import "TOCropViewController.h"

#define kADMChatMaxImageSize 800
#define kADMPublishGoodsImageSize 800
#define kADMConsignImageSize 640
#define kADMAvatarSize 400
#define kADMFrontImageSize 640

#define kADMUserNameMinLength 1

@interface PictureItemsImagePickerController : UIImagePickerController
@property(nonatomic,assign) NSInteger userData;
@end
@implementation PictureItemsImagePickerController
@end

@interface PictureItemsAssetPickerController : AssetPickerController
@property(nonatomic,assign) NSInteger userData;
@end
@implementation PictureItemsAssetPickerController
@end

@interface PictureItemView()<TOCropViewControllerDelegate>

@end

@implementation PictureItemView {
    
}

- (id)init {
    self = [super init];
    if (self) {
        _isMainPicture = NO;
    }
    return self;
}

- (void)setIsMainPicture:(BOOL)isMainPicture {
    if (_isMainPicture != isMainPicture) {
        _isMainPicture = isMainPicture;
        
        if (isMainPicture) {
            if (![self viewWithTag:11001]) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-30, self.width, 30)];
                lbl.font = [UIFont systemFontOfSize:14.f];
                lbl.text = @"主图";
                lbl.textColor = [UIColor whiteColor];
                lbl.textAlignment = NSTextAlignmentCenter;
                [lbl sizeToFit];
                lbl.frame = CGRectMake(0, self.height-lbl.height-8, self.width, lbl.height+8);
                lbl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
                lbl.tag = 11001;
                [self addSubview:lbl];
            }
            
            if (![self viewWithTag:11002]) {
                UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
                [editBtn setTitle:@"点击裁剪" forState:UIControlStateNormal];
                [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [editBtn sizeToFit];
                editBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
                editBtn.tag = 11002;
                [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:editBtn];
            }
            
            if (![self viewWithTag:11003]) {
                UIImageView * mainPicIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainPictrue"]];
                mainPicIcon.tag = 11003;
                [self addSubview:mainPicIcon];
            }
            
            
            [self viewWithTag:11001].hidden = NO;
            [self viewWithTag:11002].hidden = NO;
            [self viewWithTag:11003].hidden = NO;
            [self bringSubviewToFront:self.delBtn];
            [self setNeedsLayout];
        } else {
            [self viewWithTag:11001].hidden = YES;
            [self viewWithTag:11002].hidden = YES;
            [self viewWithTag:11003].hidden = YES;
            [self setNeedsLayout];
        }
    }
}

-(void)setIsEdit:(BOOL)isEdit
{
    [self viewWithTag:11002].hidden = isEdit;
}

- (void)editBtnClick:(UIButton *)button
{
    UIImage * image = self.imageView.image;
    if (image) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
        cropController.isHiddenSizeMenu = YES;
        [cropController.toolbar.doneTextButton setTitle:@"完成" forState:UIControlStateNormal];
        [cropController.toolbar.cancelTextButton setTitle:@"取消" forState:UIControlStateNormal];
        cropController.delegate = self;
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        [[CoordinatingController sharedInstance] presentViewController:cropController animated:YES completion:nil];
    }
    
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    
    NSString * imageFileName = [[self.pictureItem.picUrl lastPathComponent] stringByDeletingPathExtension];
    [AppDirs removeFile:self.pictureItem.picUrl];
    [self saveEditImage:image dir:[AppDirs publishGoodsCacheFilePath] fileName:imageFileName fileExtention:@".jpg"];
    [self setImage:image forState:UIControlStateNormal];
    self.contentMode = UIViewContentModeScaleAspectFill;
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatePictureItemView:)]) {
        [self.delegate updatePictureItemView:self];
    }
}

- (NSString*)saveEditImage:(UIImage*)image
                       dir:(NSString*)dir
                  fileName:(NSString*)fileName
             fileExtention:(NSString*)fileExtention
{
    if (image) {
        NSString *path = [dir stringByAppendingPathComponent:fileName];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",path,fileExtention];
        float initCompress = 90.f;
        BOOL ret = [UIImageJPEGRepresentation(image,initCompress/100.f) writeToFile:filePath atomically:YES];
        return filePath;
    }
    return nil;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        _delBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _delBtn.backgroundColor = [UIColor clearColor];
        [_delBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        [self addSubview:_delBtn];
        
        WEAKSELF;
        _delBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleDeleteTapDetected) {
                weakSelf.handleDeleteTapDetected(weakSelf);
            }
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _delBtn.frame = CGRectMake(-_delBtn.height/2+6, -_delBtn.width/2+6, _delBtn.width, _delBtn.height);
    UIView *lbl = [self viewWithTag:11001];
    if (lbl) {
        lbl.frame = CGRectMake(0, self.height-lbl.height, self.width, lbl.height);
    }
    UIView *editBtn = [self viewWithTag:11002];
    if (editBtn) {
        editBtn.frame = CGRectMake(0, 0, self.width, self.height);
    }
    
    UIView *mainPicIcon = [self viewWithTag:11003];
    if (mainPicIcon) {
        mainPicIcon.frame = CGRectMake(self.width-33, 0, 33, 33);
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(_delBtn.frame, point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

@end


@interface PictureItemsEditView () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,AssetPickerControllerDelegate,PictureItemViewDelegate>
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) NSMutableArray *picItemViewsArray;
@property (nonatomic, assign) BOOL isHaveFengM;
@property (nonatomic, strong) UIButton *credentialsBtn;//购物凭证按钮
@property (nonatomic, strong) NSMutableArray *credentialsArray;
@end

@implementation PictureItemsEditView {
    BOOL _isContain;
    CGPoint _startPoint;
    CGPoint _originPoint;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame isShowMainPicTip:YES];
}

- (id)initWithFrame:(CGRect)frame isShowMainPicTip:(BOOL)isShowMainPicTip
{
    self = [super initWithFrame:frame];
    if (self) {
        _isShowMainPicTip = isShowMainPicTip;
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, [[self class] itemViewWidth], [[self class] itemViewHeight])];
        _addBtn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, _addBtn.width, _addBtn.height-30)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:@"publish_add_pic"];
        [_addBtn addTarget:self action:@selector(addPics:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addBtn];
        _addBtn.hidden = NO;
        _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _addBtn.height-30, _addBtn.width, 30)];
        lbl.font = [UIFont systemFontOfSize:14.f];
        lbl.text = @"添加图片";
        lbl.textColor = [UIColor colorWithHexString:@"7b7b7b"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [lbl sizeToFit];
        lbl.frame = CGRectMake(0, _addBtn.height-lbl.height-8, _addBtn.width, lbl.height+8);
        lbl.tag = 100;
        [_addBtn addSubview:lbl];
        [_addBtn addSubview:imageView];
        [_addBtn viewWithTag:100].hidden = NO;
        
        _picItemViewsArray = [[NSMutableArray alloc] init];
        
//        _maxItemsCount = 21;
        _maxItemsCount = MAXPICCOUNT;
        
        //

        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame isShowMainPicTip:(BOOL)isShowMainPicTip isHaveFengM:(BOOL)isHave
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isHaveFengM = isHave;
        
        _isShowMainPicTip = isShowMainPicTip;
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, [[self class] itemViewWidth], [[self class] itemViewHeight])];
        _addBtn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [_addBtn setImage:[UIImage imageNamed:@"publish_add_pic"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addPics:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self addSubview:_addBtn];
        _addBtn.hidden = NO;
        _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _addBtn.height-30, _addBtn.width, 30)];
        lbl.font = [UIFont systemFontOfSize:14.f];
        if (isHave) {
            lbl.text = @"添加图片";
        } else {
            lbl.text = @"主图";
        }
        lbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        [lbl sizeToFit];
        lbl.frame = CGRectMake(0, _addBtn.height-lbl.height-8, _addBtn.width, lbl.height+8);
        lbl.tag = 100;
        [_addBtn addSubview:lbl];
        [_addBtn viewWithTag:100].hidden = NO;
        
        if (isHave) {
            //右上角封面小图标
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_pic_right"]];
            
            [imageView sizeToFit];
            imageView.tag = 101;
            [_addBtn addSubview:imageView];
            [_addBtn viewWithTag:101].hidden = YES;
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_addBtn.mas_top);
                make.right.equalTo(_addBtn.mas_right);
//                make.width.equalTo(@26);
//                make.height.equalTo(@15);
            }];
        }
        
        _picItemViewsArray = [[NSMutableArray alloc] init];
        
//        _maxItemsCount = 21;
        _maxItemsCount = MAXPICCOUNT;

        /*
         显示拍卖技巧购物凭证
         _credentialsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addBtn.frame) + 10, CGRectGetMinY(_addBtn.frame), CGRectGetWidth(_addBtn.frame), CGRectGetHeight(_addBtn.frame))];
         _credentialsBtn.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
         //change
         //[_credentialsBtn setImage:[UIImage imageNamed:@"credentials_pic_new"] forState:UIControlStateNormal];
         [_credentialsBtn addTarget:self action:@selector(photoShootTechnique:) forControlEvents:UIControlEventTouchUpInside];
         CAShapeLayer *border1 = [CAShapeLayer layer];
         border1.frame = _credentialsBtn.bounds;
         border1.path = [UIBezierPath bezierPathWithRect:_credentialsBtn.bounds].CGPath;
         border1.strokeColor = [UIColor colorWithHexString:@"C9C9C9"].CGColor;
         border1.fillColor = nil;
         border1.lineDashPattern = @[@3, @3];
         [_credentialsBtn.layer addSublayer:border1];
         [self addSubview:_credentialsBtn];
         _credentialsBtn.hidden = NO;
         _credentialsBtn.layer.masksToBounds = YES;
         _credentialsBtn.layer.cornerRadius = CGRectGetWidth(_addBtn.frame)/2;
         _credentialsBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
         _credentialsBtn.tag = 10000;
         
         
         UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, _credentialsBtn.height-30, _credentialsBtn.width, 30)];
         lbl1.font = [UIFont systemFontOfSize:14.f];
         lbl1.backgroundColor = [UIColor clearColor];
         lbl1.text = @"更好卖的\n拍照技巧";
         lbl1.numberOfLines = 0;
         lbl1.textColor = [UIColor colorWithHexString:@"AAAAAA"];
         lbl1.textAlignment = NSTextAlignmentCenter;
         [lbl1 sizeToFit];
         lbl1.frame = CGRectMake(0, 0, _credentialsBtn.width, _credentialsBtn.height);
         lbl1.tag = 200;
         [_credentialsBtn addSubview:lbl1];
         */
        
    }
    return self;
}

-(void)photoShootTechnique:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPhotoShootTechniqueView)]) {
        [self.delegate showPhotoShootTechniqueView];
    }
}

- (void)dealloc
{
    _viewController = nil;
    _addBtn = nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[PictureItemView class]]) {
            PictureItemView *itemView = (PictureItemView*)view;
            if (CGRectContainsPoint(itemView.delBtn.frame, point)) {
                return YES;
            }
        }
    }
    return [super pointInside:point withEvent:event];
}

- (void)setPicItemsArray:(NSArray *)picItemsArray {
    [_picItemViewsArray removeAllObjects];
    //
//    [_credentialsArray removeAllObjects];
    for (NSInteger i=0;i<[picItemsArray count];i++) {
        PictureItem *item = [picItemsArray objectAtIndex:i];
        if ([item isKindOfClass:[PictureItem class]]) {
            PictureItemView *itemView = [self createPictureItemView:item];
            itemView.isEdit = self.isEdit;
            [_picItemViewsArray addObject:itemView];
        }
        //add code
//        if (item.isCer) {
//            [self.credentialsArray addObject:item];
//        }
        
    }
    
    [self layoutPictureItemEditView];
}

//- (NSMutableArray *)credentialsArray {
//    if (!_credentialsArray) {
//        _credentialsArray = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _credentialsArray;
//}

- (NSArray*)picItemsArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PictureItemView *itemView in _picItemViewsArray) {
        [array addObject:itemView.pictureItem];
    }
    return array;
}

- (PictureItemView*)createPictureItemView:(PictureItem*)item {
    
    PictureItemView *itemView = [[PictureItemView alloc] initWithFrame:CGRectMake(0, 0, [[self class] itemViewWidth], [[self class] itemViewHeight])];
    itemView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewLongPressed:)];
    [itemView addGestureRecognizer:longGesture];
    itemView.backgroundColor = [UIColor whiteColor];
    if (item.picId == kPictureItemLocalPicId) {
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:item.picUrl]]];
        [itemView setImage:img forState:UIControlStateNormal];
        itemView.pictureItem.width = img.size.width;
        itemView.pictureItem.height = img.size.height;
    } else {
        NSString *url = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(240, 240)];
       [itemView sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:nil];
//        [itemView setImageWithURL:url placeholderImage:nil size:CGSizeMake(320, 320) progressBlock:nil succeedBlock:nil failedBlock:nil];
    }
    itemView.pictureItem = item;
    WEAKSELF;
    itemView.handleDeleteTapDetected = ^(PictureItemView *view) {
        if (weakSelf.isEdit) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"编辑商品不能删除图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            [weakSelf handlePictureItemViewDeleteTap:view];
        }
    };
    itemView.handleClickBlock = ^(CommandButton *sender) {
        if ([sender isKindOfClass:[PictureItemView class]]) {
            NSInteger currentPhotoIndex = 0;
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            for (NSInteger i=0;i<[weakSelf.picItemViewsArray count];i++) {
                PictureItemView *itemView = [weakSelf.picItemViewsArray objectAtIndex:i];
                
                MJPhoto * photo = [[MJPhoto alloc] init];
                [photos addObject:photo];
                
                photo.srcImageView = itemView.imageView; // 来源于哪个UIImageView
                if (itemView.pictureItem.picId == kPictureItemLocalPicId) {
                    photo.url = [NSURL fileURLWithPath:itemView.pictureItem.picUrl];
                    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:photo.url];
                    [[SDImageCache sharedImageCache] removeImageForKey:key];
                } else {
                    photo.url = [NSURL URLWithString:itemView.pictureItem.picUrl];
                }
                if (itemView == sender) {
                    currentPhotoIndex = i;
                }
            }
            
            if ([photos count]>0) {
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.photos = photos; // 设置所有的图片
                browser.isHaveGoodsDetailBtn = 1;
                browser.currentPhotoIndex = currentPhotoIndex; // 弹出相册时显示的第一张图片是？
                [browser show];
            }
        }
    };
    return itemView;
}

- (void)layoutPictureItemEditView
{
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[PictureItemView class]]) {
            PictureItemView *itemView = (PictureItemView*)view;
            [itemView removeFromSuperview];
        }
    }
    
    CGFloat X = 15.f;
    CGFloat Y = 20.f;
    
    for (NSInteger i=0;i<[_picItemViewsArray count];i++) {
        PictureItemView *itemView = [_picItemViewsArray objectAtIndex:i];
        itemView.tag  = i;
        if (X+10+[[self class] itemViewWidth]>kScreenWidth) {
            X = 15;
            Y += [[self class] itemViewHeight];
            Y += 10;
        }
        itemView.frame = CGRectMake(X, Y, itemView.width, itemView.height);
        X += 10;
        X += itemView.width;
        [self addSubview:itemView];
        
        if (_isShowMainPicTip) {
            [itemView setIsMainPicture:i==0?YES:NO];
            itemView.delegate = self;
        } else {
            itemView.isMainPicture = NO;
        }
        itemView.isEdit = self.isEdit;
    }
    
    _addBtn.tag = [_picItemViewsArray count];
    
//    if ([_picItemViewsArray count] + 1 >= _maxItemsCount) {
//        _credentialsBtn.hidden = YES;
//    } else {
//        _credentialsBtn.hidden = NO;
//    }
    
    if ([_picItemViewsArray count]>=_maxItemsCount) {//+1 要不然会少一张 _picItemViewsArray count]>=_maxItemsCount +1 显示拍卖技巧购物凭证
        _addBtn.hidden = YES;
    } else {
        if (X+10+[[self class] itemViewWidth]>kScreenWidth) {
            X = 15;
            Y += [[self class] itemViewWidth];
            Y += 10;
        }
        _addBtn.frame = CGRectMake(X, Y, [[self class] itemViewWidth], [[self class] itemViewHeight]);
        _addBtn.hidden = NO;
        
        //add code
        if (_isHaveFengM) {
            X += (10 + [[self class] itemViewWidth]);
            if (X+10+[[self class] itemViewWidth]>kScreenWidth) {
                X = 15;
                Y += [[self class] itemViewWidth];
                Y += 10;
            }
            _credentialsBtn.frame = CGRectMake(X, Y, [[self class] itemViewWidth], [[self class] itemViewHeight]);
            _credentialsBtn.hidden = NO;
        }
    }
    
    
    if (_isShowMainPicTip) {
        [_addBtn viewWithTag:100].hidden = NO;//[_picItemViewsArray count]>0?YES:NO;
        [_addBtn viewWithTag:101].hidden = [_picItemViewsArray count]>0?YES:NO;
    } else {
        [_addBtn viewWithTag:100].hidden = YES;
        [_addBtn viewWithTag:101].hidden = YES;
    }
    
    
    
    
    CGFloat orginHeight = self.height;
    self.frame = CGRectMake(self.left, self.top, self.width, Y+[[self class] itemViewHeight]);
    
    if (orginHeight!=self.height) {
        if (_delegate && [_delegate respondsToSelector:@selector(picturesEditViewHeightChanged:height:)]) {
            [_delegate picturesEditViewHeightChanged:self height:self.height];
        }
    }
}


- (void)itemViewLongPressed:(UILongPressGestureRecognizer *)sender
{
    UIView *btn = (UIView *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        for (NSInteger i=0;i<self.picItemViewsArray.count;i++) {
            PictureItemView *itemView = [self.picItemViewsArray objectAtIndex:i];
            itemView.isMainPicture = NO;
        }
        
        UIView *superview = sender.view.superview;
        [superview bringSubviewToFront:sender.view];
        _startPoint = [sender locationInView:sender.view];
        _originPoint = btn.center;
        [UIView animateWithDuration:0.15 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.8;
        }];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-_startPoint.x;
        CGFloat deltaY = newPoint.y-_startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
       
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            _isContain = NO;
        }
        else
        {
            //互换位置
            NSInteger indexDragging = [self indexOfDraggingView:sender.view];
            UIView *button = _picItemViewsArray[index];
            CGPoint center = button.center;
            [self swichPosition:indexDragging index:index];
            
            [UIView animateWithDuration:0.25f animations:^{
                CGPoint temp = CGPointZero;
                temp = center;
                button.center = _originPoint;
                btn.center = temp;
                _originPoint = center;
                _isContain = YES;
            } completion:^(BOOL finished) {
            }];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2f animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!_isContain)
            {
                btn.center = _originPoint;
            }
        }];
        
        for (NSInteger i=0;i<self.picItemViewsArray.count;i++) {
            PictureItemView *itemView = [self.picItemViewsArray objectAtIndex:i];
            if (_isShowMainPicTip) {
                itemView.isMainPicture = i==0?YES:NO;
            } else {
                itemView.isMainPicture = NO;
            }
        }
    }
}

- (void)swichPosition:(NSInteger)draggingIndex index:(NSInteger)index {
    if (draggingIndex >=0&&draggingIndex<[_picItemViewsArray count]
        && index>=0 && index<[_picItemViewsArray count]) {
        UIView *view = _picItemViewsArray[draggingIndex];
        [_picItemViewsArray replaceObjectAtIndex:draggingIndex withObject:_picItemViewsArray[index]];
        [_picItemViewsArray replaceObjectAtIndex:index withObject:view];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(picturesEditViewPictureItemOrdersChanged:)]) {
        [_delegate picturesEditViewPictureItemOrdersChanged:self];
    }
}

- (NSInteger)indexOfDraggingView:(UIView*)draggingView {
    for (NSInteger i = 0;i<_picItemViewsArray.count;i++) {
        UIView *view = _picItemViewsArray[i];
        if (view == draggingView) {
            return i;
        }
    }
    return -1;
}

- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIView *)draggingView
{
    for (NSInteger i = 0;i<_picItemViewsArray.count;i++) {
        UIView *view = _picItemViewsArray[i];
        if (view != draggingView) {
            if (CGRectContainsPoint(view.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

+ (CGFloat)itemViewWidth {
    return (kScreenWidth-30-28)/4;
}

+ (CGFloat)itemViewHeight {
    return [self itemViewWidth];
}

+ (CGFloat)heightForOrientationPortrait:(NSInteger)totalCount maxItemsCount:(NSInteger)maxItemsCount {
    CGFloat height = [self itemViewWidth];
    if (totalCount<maxItemsCount) {
        totalCount+=1;
    }
    if (totalCount > 0) {
        CGFloat rowNum = (totalCount%3+totalCount/3);
        return (totalCount%3+totalCount/3)*height+(rowNum>0?(rowNum-1)*10:0);
    } else {
        return height;
    }
}

- (void)updatePictureItemView:(PictureItemView *)picItemView{

    for (int i = 0; i < self.picItemViewsArray.count; i++) {
        PictureItemView *tmpItemView = [self.picItemViewsArray objectAtIndex:i];
        if ([tmpItemView isKindOfClass:[PictureItemView class]]) {
            if (tmpItemView==picItemView) {
                [tmpItemView removeFromSuperview];
                [_picItemViewsArray replaceObjectAtIndex:i withObject:picItemView];
                break;
            }
        }
    }
    [self layoutPictureItemEditView];
}

- (void)handlePictureItemViewDeleteTap:(PictureItemView*)itemView
{
    for (PictureItemView *tmpItemView in _picItemViewsArray) {
        if ([tmpItemView isKindOfClass:[PictureItemView class]]) {
            if (tmpItemView==itemView) {
                [tmpItemView removeFromSuperview];
                [_picItemViewsArray removeObject:tmpItemView];
                break;
            }
        }
    }
    [self layoutPictureItemEditView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(picturesEditViewPictureItemDeleted:item:)]) {
        [self.delegate picturesEditViewPictureItemDeleted:self item:itemView.pictureItem];
    }
}

- (void)handleImagePicked:(NSInteger)userData image:(UIImage*)image filePath:(NSString*)filePath {
    if (!_picItemViewsArray) {
        _picItemViewsArray = [[NSMutableArray alloc] init];
    }
    PictureItem *item = [[PictureItem alloc] init];
    item.picId = kPictureItemLocalPicId;
    item.picUrl = filePath;
    item.width = image.size.width;
    item.height = image.size.height;
    //add code
    if (userData - 10000 == 0) {
        item.isCer = YES;
//        [self.credentialsArray addObject:item];
    }
    
    [_picItemViewsArray addObject:[self createPictureItemView:item]];
    [self layoutPictureItemEditView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(picturesEditViewPictureItemAdded:)]) {
        [_delegate picturesEditViewPictureItemAdded:self];
    }
}

//-(void)cammer{
//    PictureItemsImagePickerController *imagePicker = [[PictureItemsImagePickerController alloc] init];
//    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
//}

- (void)addPics:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    WEAKSELF;
    [UIActionSheet showInView:weakSelf
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:[NSArray arrayWithObjects:@"从手机相册选择", @"拍照",nil]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex == 0 ) {
                             [weakSelf handlePikeImageFromAlum:tag];
                         } else if (buttonIndex==1) {
                             [weakSelf handlePikeImageFromCamera:tag];
                         }
                         
                     }];
    
}

// add code
//- (void)addPicsByCredentials:(UIButton*)sender
//{
//    NSInteger tag = sender.tag;
//    WEAKSELF;
//    [UIActionSheet showInView:weakSelf
//                    withTitle:nil
//            cancelButtonTitle:@"取消"
//       destructiveButtonTitle:nil
//            otherButtonTitles:[NSArray arrayWithObjects:@"从手机相册选择", @"拍照",nil]
//                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                         if (buttonIndex == 0 ) {
//                             [weakSelf handlePikeImageFromAlum:tag];
//                         } else if (buttonIndex==1) {
//                             [weakSelf handlePikeImageFromCamera:tag];
//                         }
//                         
//                     }];
//    
//}

- (void)handlePikeImageFromAlum:(NSInteger)tag
{
    WEAKSELF;
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
        //从手机相册选择
        PictureItemsAssetPickerController * imagePicker =  [[PictureItemsAssetPickerController alloc] init];
        imagePicker.userData = tag;
        imagePicker.minimumNumberOfSelection = 1;
        imagePicker.maximumNumberOfSelection = _maxItemsCount-(self.subviews.count-1);
        imagePicker.delegate = weakSelf;
        imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
        imagePicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                return NO;
            } else {
                return YES;
            }
        }];
        [weakSelf.viewController presentViewController:imagePicker animated:YES completion:^{
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示"
                                                             message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)handlePikeImageFromCamera:(NSInteger)tag
{
    WEAKSELF;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
                PictureItemsImagePickerController *imagePicker = [[PictureItemsImagePickerController alloc] init];
                imagePicker.userData = tag;
                imagePicker.delegate = weakSelf;
                imagePicker.allowsEditing = NO;
                imagePicker.sourceType = sourceType;
                imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                imagePicker.showsCameraControls = YES;
                [weakSelf.viewController presentViewController:imagePicker animated:YES completion:^{
                }];
            }];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
                                                             message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许爱丁猫访问你的相机"
                                                            delegate:weakSelf
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSInteger userData = -1;
    if ([picker isKindOfClass:[PictureItemsImagePickerController class]]) {
        userData = ((PictureItemsImagePickerController*)picker).userData;
    }
    WEAKSELF;
    UIImage *originalImage= info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    if (originalImage) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *image = originalImage;
            
//            {
//                CGSize originalSize = originalImage.size;
//                CGRect cropFrame = CGRectZero;
//                if (originalSize.width>originalSize.height) {
//                    cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
//                    image = [originalImage croppedImage:cropFrame];
//                } else if (originalSize.width<originalSize.height) {
//                    cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
//                    image = [originalImage croppedImage:cropFrame];
//                }
//            }
            
            CGSize originalSize = originalImage.size;
            if (originalSize.width == kADMPublishGoodsImageSize && originalSize.height== kADMPublishGoodsImageSize) {
                //... originalImage
            } else {
                if (originalSize.width == originalSize.height) {
                    if (originalSize.width>kADMPublishGoodsImageSize) {
                        CGSize size = CGSizeMake(kADMPublishGoodsImageSize, kADMPublishGoodsImageSize);
                        UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    } else {
                        //... originalImage
                    }
                } else {
                    if (originalSize.width < kADMPublishGoodsImageSize && originalSize.height<kADMPublishGoodsImageSize) {
                        //... originalImage
                    } else {
//                        CGRect cropFrame = CGRectZero;
//                        if (originalSize.width>originalSize.height) {
//                            cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
//                        } else {
//                            cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
//                        }
//                        UIImage *croppedImage = [originalImage croppedImage:cropFrame];
                        CGSize size = CGSizeMake(kADMPublishGoodsImageSize, kADMPublishGoodsImageSize);
                        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    }
                }
            }
            
            NSString *filePath = [AppDirs savePublishGoodsPicture:image fileName:nil];
            //float fileSize =  [AppDirs fileSizeK:filePath];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [weakSelf handleImagePicked:userData image:image filePath:filePath];
            });
        });
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


-(void)assetPickerController:(AssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count == 0) return;
    
    __block NSInteger userData = -1;
    if ([picker isKindOfClass:[PictureItemsAssetPickerController class]]) {
        userData = ((PictureItemsAssetPickerController*)picker).userData;
    }
    
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *originalImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            UIImage *image = originalImage;
            
//            {
//                CGSize originalSize = originalImage.size;
//                CGRect cropFrame = CGRectZero;
//                if (originalSize.width>originalSize.height) {
//                    cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
//                    image = [originalImage croppedImage:cropFrame];
//                } else if (originalSize.width<originalSize.height) {
//                    cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
//                    image = [originalImage croppedImage:cropFrame];
//                }
//            }
            
            CGSize originalSize = originalImage.size;
            if (originalSize.width == kADMPublishGoodsImageSize && originalSize.height== kADMPublishGoodsImageSize) {
                //... originalImage
            } else {
                if (originalSize.width == originalSize.height) {
                    if (originalSize.width>kADMPublishGoodsImageSize) {
                        CGSize size = CGSizeMake(kADMPublishGoodsImageSize, kADMPublishGoodsImageSize);
                        UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    } else {
                        //... originalImage
                    }
                } else {
                    if (originalSize.width < kADMPublishGoodsImageSize && originalSize.height<kADMPublishGoodsImageSize) {
                        //... originalImage
                    } else {
//                        CGSize scaledSize = CGSizeZero;
//                        if (originalSize.width>originalSize.height) {
//                            CGFloat scaledHeight = originalSize.height<kADMPublishGoodsImageSize?originalSize.height:kADMPublishGoodsImageSize;
//                            scaledSize = CGSizeMake(scaledHeight, scaledHeight);
//                        } else {
//                            CGFloat scaledWidth = originalSize.width<kADMPublishGoodsImageSize?originalSize.width:kADMPublishGoodsImageSize;
//                            scaledSize = CGSizeMake(scaledWidth, scaledWidth);
//                        }
                        CGSize size = CGSizeMake(kADMPublishGoodsImageSize, kADMPublishGoodsImageSize);
                        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                        
//                        CGRect cropFrame = CGRectZero;
//                        if (originalSize.width>originalSize.height) {
//                            cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
//                        } else {
//                            cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
//                        }
//                        UIImage *croppedImage = [originalImage croppedImage:cropFrame];
//                        CGSize size = CGSizeMake(kADMConsignImageSize, kADMConsignImageSize);
//                        UIImage *scaledImage = [croppedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationMedium];
//                        image = scaledImage;
                    }
                }
            }
            
            NSString *filePath = [AppDirs savePublishGoodsPicture:image fileName:nil];
//            CGSize size = image.size;
//            float fileSize =  [AppDirs fileSizeK:filePath];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [weakSelf handleImagePicked:userData image:image filePath:filePath];
                if (userData - 10000 != 0) {
                    userData += 1;
                }
            });
        }
    });
    
    //double fileSize =  [AppDirs fileSizeK:filePath];
}

-(void)assetPickerControllerDidCancel:(AssetPickerController *)picker {
    
}

-(void)assetPickerController:(AssetPickerController *)picker didSelectAsset:(ALAsset*)asset {
    
}

-(void)assetPickerController:(AssetPickerController *)picker didDeselectAsset:(ALAsset*)asset {
    
}

-(void)assetPickerControllerDidMaximum:(AssetPickerController *)picker {
    
    //    WEAKSELF;
    //    [[CoordinatingController sharedInstance] showHUD:[NSString stringWithFormat:@"最多只能选%ld张图片",(long)(_maxItemsCount-(self.subviews.count-1))] hideAfterDelay:0.8f];
    
}

-(void)assetPickerControllerDidMinimum:(AssetPickerController *)picker {
    
}


@end

