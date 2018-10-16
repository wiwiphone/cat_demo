//
//  PublishTakePhotoViewController.h
//  XianMao
//
//  Created by simon cai on 5/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface TakePhotoViewController : BaseViewController

@property(nonatomic,strong) NSArray *sampleList;
@property(nonatomic,assign) NSInteger cateId;
@property(nonatomic,assign) NSInteger userData;
@property(nonatomic,copy) void(^handleImagePicked)(NSInteger userData, UIImage *image, NSString *filePath);
@property(nonatomic,copy) void(^handleSampleListFetchedBlock)(NSInteger caiteId, NSArray *sampleList);

@end

@protocol PreviewControllerDelegate;
@interface PhotoPreviewController : BaseViewController

@property(nonatomic,assign) id<PreviewControllerDelegate> delegate;
@property(nonatomic,strong) UIImage *photo;
@property(nonatomic,assign) NSInteger userData;
@property(nonatomic,strong) NSArray *sampleList;
 
@end

@protocol PreviewControllerDelegate <NSObject>
@optional
- (void)previewUseThePhoto:(PhotoPreviewController*)viewController photo:(UIImage*)photo;
@end

