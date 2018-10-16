//
//  EditProfileViewController.h
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"
#import "Command.h"

@class UserDetailInfo;
@class EditProfileViewController;

@protocol EditProfileViewControllerDelegate <NSObject>
@optional
- (void)editProfileGalleryChanged:(EditProfileViewController*)viewController gallery:(NSArray*)gallary;
@end

@interface EditProfileViewController : BaseViewController
@property(nonatomic,assign) id<EditProfileViewControllerDelegate> delegate;
@property(nonatomic,strong) UserDetailInfo *userDetailInfo;
@end

typedef enum {
    EditProfileTypeAvatar = 1,
    EditProfileTypeOther = 5,
} EditProfileType;

@interface EditProfileTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow;
+ (NSString*)cellDictKeyForValue;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end


@interface EditBirthdayTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow;
+ (NSString*)cellDictKeyForValue;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface EditPhoneTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow;
+ (NSString*)cellDictKeyForValue;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface EditUserCountTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value isBind:(NSInteger)isBind;
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow;
+ (NSString*)cellDictKeyForValue;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface EditRetryPasswordTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow;
+ (NSString*)cellDictKeyForValue;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface EditSafeTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value
                          isShowArrow:(BOOL)isShowArrow;
+ (NSString*)cellDictKeyForValue;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface SegTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;
+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type
                                title:(NSString*)title
                                value:(NSString*)value;
+ (NSString*)cellDictKeyForValue;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end


@interface EditAvatarTableViewCell : EditProfileTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;

@end

@interface EditSummaryTableViewCell : EditProfileTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;

@end

@interface  EditWecatIDTableViewCell: EditProfileTableViewCell

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value;

@end

@class PictureItemsEditView;
@interface EditGalleryTableViewCell : EditProfileTableViewCell
@property(nonatomic,strong) PictureItemsEditView *editView;
@property(nonatomic,weak) BaseViewController *viewController;

+ (NSMutableDictionary*)buildCellDict:(EditProfileType)type title:(NSString*)title value:(NSString*)value
                       userDetailInfo:(UserDetailInfo*)userDetailInfo;

@end

@interface EditUserNameViewController : BaseViewController

@property (nonatomic, assign) BOOL isEditUserName;

@property(nonatomic,copy) void(^handleDidEditUserName)(EditUserNameViewController *viewController, NSString *userName);

@end

@interface EditGenderViewController : BaseViewController

@property(nonatomic,copy) void(^handleDidEditGender)(EditGenderViewController *viewController, NSInteger gender);

@end

@interface EditSummaryViewController : BaseViewController

@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) void(^handleDidEditSummary)(EditSummaryViewController *viewController, NSString *summary);

@end

@interface UIBirthdayPicker: UIDatePicker

@end


@interface EditUserSummaryViewController : BaseViewController

@property(nonatomic,copy) void(^handleDidEditUserName)(EditUserSummaryViewController *viewController, NSString *summary);

@end




