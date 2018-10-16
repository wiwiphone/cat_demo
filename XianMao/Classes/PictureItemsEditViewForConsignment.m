//
//  PictureItemsEditViewForConsignment.m
//  XianMao
//
//  Created by WJH on 17/2/7.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "PictureItemsEditViewForConsignment.h"
#import "LxGridViewFlowLayout.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import "UIActionSheet+Blocks.h"
#import "TakePhotoViewController.h"
#import "WCAlertView.h"
#import "Command.h"


#define MaxImagesCount 15

@interface PictureItemsEditViewForConsignment()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) VerticalCommandButton * addPicButton;

@end

@implementation PictureItemsEditViewForConsignment{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
- (VerticalCommandButton *)addPicButton{
    if (!_addPicButton) {
        _addPicButton = [[VerticalCommandButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _addPicButton.backgroundColor = [UIColor whiteColor];
        [_addPicButton setImage:[UIImage imageNamed:@"publish_add_pic"] forState:UIControlStateNormal];
        [_addPicButton setTitle:@"添加图片" forState:UIControlStateNormal];
        _addPicButton.contentMarginTop = 40;
        _addPicButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addPicButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _addPicButton.imageTextSepHeight = 6;
    }
    return _addPicButton;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.allowsEditing = YES;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = [UIColor blueColor];
        _imagePickerVc.navigationBar.tintColor = [UIColor blueColor];
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)configCollectionView {

    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 0;
    CGFloat marginLeft = 3;
    CGFloat marginRight = 7;
    _itemWH = (self.tz_width - 2 * _margin - (marginLeft+marginRight)) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.tz_width, self.tz_height) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(5, marginLeft, 0, marginRight);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_collectionView];
    [self addSubview:self.addPicButton];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configCollectionView];
        _selectedPhotos = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        _defautViewHeight = 145;
        WEAKSELF;
        _addPicButton.handleClickBlock = ^(CommandButton *sender){
            [weakSelf addPictures];
        };
    }
    return self;
}


#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    BOOL isValid = [self checkIsValid];
    if (isValid) {
        return _selectedPhotos.count + 1;
    }else{
        return _selectedPhotos.count ;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _selectedPhotos.count){
        [UIActionSheet showInView:self withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"去相册选择"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self takePhoto];
            }else if (buttonIndex == 1){
                [self pushImagePickerController];
            }
        }];
    } else {

        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = self.maxImagesCount > 0 ? self.maxImagesCount:MaxImagesCount;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        WEAKSELF;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            [weakSelf layoutCollectionView];
        }];
        [[CoordinatingController sharedInstance] presentViewController:imagePickerVc animated:YES completion:nil];
    }
}


- (void)addPictures{
    [UIActionSheet showInView:self withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"去相册选择"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self takePhoto];
        }else if (buttonIndex == 1){
            [self pushImagePickerController];
        }
    }];
}

- (void)takePhoto {
    
    WEAKSELF;
    
    TakePhotoViewController *viewController = [[TakePhotoViewController alloc] init];
    if (self.selectedCate) {
        NSInteger cateId = self.selectedCate.cateId;
        viewController.title = self.selectedCate?weakSelf.selectedCate.name:@"";
        viewController.cateId = cateId;
    }
    viewController.userData = 1;
    
    
    viewController.handleImagePicked = ^(NSInteger userData, UIImage *image, NSString *filePath) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImagesCount > 0 ? self.maxImagesCount:MaxImagesCount delegate:self];
        [tzImagePickerVc showProgressHUD];
        [[TZImageManager manager] savePhotoWithImage:image completion:^(){
            
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models lastObject];
                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                }];
            }];
        }];
        
    };
    if (self.isNeedPushViewCtrl) {
        if (self.selectedCate) {
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        }else{
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择商品类目"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if ([self.delegate respondsToSelector:@selector(pulishSelectCate)] && self.delegate) {
                                 [self.delegate pulishSelectCate];
                             }
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } else {
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    }
}



- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    [self layoutCollectionView];
}


- (void)pushImagePickerController {
    
    TZImagePickerController * imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImagesCount > 0 ? self.maxImagesCount:MaxImagesCount delegate:self];
    // 目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets;
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;

    
    [[CoordinatingController sharedInstance] presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    [self layoutCollectionView];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"Consignment_new"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.promptLbl.hidden = YES;
    cell.titleLbl.hidden = YES;
    cell.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.imageView.clipsToBounds  = YES;
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView reloadData];
    [self layoutCollectionView];

}

- (void)layoutCollectionView{
    
    CGFloat itemViewHeight = 0;
    if ((_selectedPhotos.count + 1)%4 == 0) {
        itemViewHeight = ((_selectedPhotos.count+ 1) / 4)*(_margin + _itemWH);//+ 1是为了添加图片的cell
    }else{
        itemViewHeight = ((_selectedPhotos.count+ 1) / 4)*(_margin + _itemWH) + (_margin + _itemWH);
    }
    
    if (_selectedPhotos.count > 0) {
        self.addPicButton.hidden = YES;
    }else{
        self.addPicButton.hidden = NO;
        itemViewHeight = _defautViewHeight;
    }

    _collectionView.contentSize = CGSizeMake(0, itemViewHeight);
    _collectionView.frame = CGRectMake(0, 0, self.width, itemViewHeight + 20);
    _addPicButton.frame = _collectionView.frame;
    if ([self.delegate respondsToSelector:@selector(imagePickerDidFinishPickingPhotos:picTrueItem:)] &&
        self.delegate) {
        [self.delegate imagePickerDidFinishPickingPhotos:itemViewHeight+20 picTrueItem:_selectedPhotos];
    }
    
}

- (BOOL)checkIsValid{
    BOOL isValid = YES;
    NSInteger imageCount = self.maxImagesCount > 0 ? self.maxImagesCount : MaxImagesCount;
    if (_selectedPhotos.count + 1>= imageCount) {
        isValid = NO;
    }
    return isValid;
}

@end
