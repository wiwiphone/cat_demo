//
//  UserAddressTableViewCell.m
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "UserAddressTableViewCell.h"
#import "AddressInfo.h"
#import "DataSources.h"

@interface UserAddressTableViewCell ()

@property(nonatomic,strong) UILabel *receiverLbl;
@property(nonatomic,strong) UILabel *phoneNumberLbl;
@property(nonatomic,strong) UILabel *areaDetailLbl;
@property(nonatomic,strong) UILabel *addressLbl;
@property(nonatomic,strong) CALayer *selctedFlag;
@property(nonatomic,strong) CALayer *bottomLine;
@end

@implementation UserAddressTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserAddressTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = [self calculateHeightAndLayoutSubviews:nil addressInfo:[dict objectForKey:[self cellDictKeyForAddressInfo]] isForSelectAddress:YES];
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(AddressInfo*)addressInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserAddressTableViewCell class]];
    if (addressInfo)[dict setObject:addressInfo forKey:[self cellDictKeyForAddressInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForAddressInfo {
    return @"addressInfo";
}

+ (NSString*)cellDictKeyForSelected {
    return @"selected";
}

+ (NSString*)cellDictKeyForSelectAddress {
    return @"forSecletAddress";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _receiverLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _receiverLbl.font = [UIFont boldSystemFontOfSize:15.5f];
        _receiverLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _receiverLbl.textAlignment = NSTextAlignmentLeft;
        _receiverLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_receiverLbl];
        
        _phoneNumberLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _phoneNumberLbl.font = [UIFont boldSystemFontOfSize:15.5f];
        _phoneNumberLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _phoneNumberLbl.textAlignment = NSTextAlignmentRight;
        _phoneNumberLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_phoneNumberLbl];
        
        _areaDetailLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _areaDetailLbl.font = [UIFont systemFontOfSize:13.f];
        _areaDetailLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _areaDetailLbl.backgroundColor = [UIColor clearColor];
        _areaDetailLbl.numberOfLines = 0;
        _areaDetailLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_areaDetailLbl];
        
        _addressLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _addressLbl.font = [UIFont systemFontOfSize:13.f];
        _addressLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _addressLbl.backgroundColor = [UIColor clearColor];
        _addressLbl.textAlignment = NSTextAlignmentLeft;
        _addressLbl.numberOfLines = 0;
        [self.contentView addSubview:_addressLbl];
        
        UIImage *image = [UIImage imageNamed:@"checked_big_wjh"];
        _selctedFlag = [CALayer layer];
        _selctedFlag.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _selctedFlag.contents = (id)image.CGImage;
        _selctedFlag.backgroundColor = [UIColor clearColor].CGColor;
        [self.contentView.layer addSublayer:_selctedFlag];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_bottomLine];
    }
    return self;
}

- (void)dealloc {
    //    _nameLbl = nil;
    //    _selectedIconView = nil;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.receiverLbl.frame = CGRectNull;
    self.phoneNumberLbl.frame = CGRectNull;
    self.areaDetailLbl.frame = CGRectNull;
    self.addressLbl.frame = CGRectNull;
    self.bottomLine.frame = CGRectNull;
    
    self.selctedFlag.hidden = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(UserAddressTableViewCell*)cell
                                addressInfo:(AddressInfo*)addressInfo
                         isForSelectAddress:(BOOL)isForSelectAddress
{
    CGFloat maginLeft = 15.f;
    CGFloat marginTop = 0.f;
    marginTop += 20.f;
    
    CGFloat marginRight = isForSelectAddress?65.f:15.f;
    
    NSString *phoneNumber = cell?cell.phoneNumberLbl.text:addressInfo.phoneNumber;
    NSString *receiverName = cell?cell.receiverLbl.text:addressInfo.receiver;
    
    if ([phoneNumber length]>0 && [receiverName length]>0) {
        CGSize phoneNumberSize = [phoneNumber sizeWithFont:[UIFont systemFontOfSize:13.5f]
                              constrainedToSize:CGSizeMake(kScreenWidth-marginRight-15,MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        if (cell) {
            cell.receiverLbl.frame = CGRectMake(maginLeft, marginTop, kScreenWidth-marginRight-phoneNumberSize.width-maginLeft-15, phoneNumberSize.height);
            [cell.receiverLbl sizeToFit];
            cell.receiverLbl.frame = CGRectMake(maginLeft, marginTop, cell.receiverLbl.width, cell.receiverLbl.height);
        }
        
        if (cell) {
            cell.phoneNumberLbl.frame = CGRectMake(maginLeft + cell.receiverLbl.width + 10, marginTop, phoneNumberSize.width, phoneNumberSize.height);
            [cell.phoneNumberLbl sizeToFit];
            cell.phoneNumberLbl.frame = CGRectMake(maginLeft + cell.receiverLbl.width + 10, marginTop, cell.phoneNumberLbl.width, cell.phoneNumberLbl.height);
        }
        
        marginTop += phoneNumberSize.height;
        marginTop += 14.f;
    }
    
    NSString *areaDetail = cell?cell.areaDetailLbl.text:[NSString stringWithFormat:@"%@%@",addressInfo.areaDetail,addressInfo.address];
    if ([areaDetail length]>0) {
        CGSize areaDetailSize = [areaDetail sizeWithFont:[UIFont systemFontOfSize:13.5f]
                                       constrainedToSize:CGSizeMake(kScreenWidth-marginRight-15,MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
        
        if (cell) {
            cell.areaDetailLbl.frame = CGRectMake(maginLeft, marginTop, areaDetailSize.width, areaDetailSize.height);
        }
        
        marginTop += areaDetailSize.height;
        marginTop += 0.f;
    }
    
    
//    NSString *address = cell?cell.addressLbl.text:addressInfo.address;
//    if ([address length]>0) {
//        CGSize addressSize = [address sizeWithFont:[UIFont systemFontOfSize:13.5f]
//                                 constrainedToSize:CGSizeMake(kScreenWidth-15-marginRight,MAXFLOAT)
//                                     lineBreakMode:NSLineBreakByWordWrapping];
    
//        if (cell) cell.addressLbl.frame = CGRectMake(15, marginTop,kScreenWidth-15-marginRight, addressSize.height);
//        
//        marginTop += addressSize.height;
//        marginTop += 20.f;
//    }
    
    
    if (cell) cell.bottomLine.frame = CGRectMake(0, cell.contentView.bounds.size.height-1, cell.contentView.bounds.size.width, 1);
    if (cell) cell.selctedFlag.frame = CGRectMake(kScreenWidth-65+(65-cell.selctedFlag.bounds.size.width)/2, (cell.bounds.size.height-cell.selctedFlag.bounds.size.height)/2, cell.selctedFlag.bounds.size.width, cell.selctedFlag.bounds.size.height);
    
//    if (marginTop<101.f) {
//        marginTop = 101.f;
//    }
    marginTop += 20;
    return marginTop;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [[self class] calculateHeightAndLayoutSubviews:self addressInfo:nil isForSelectAddress:self.isForSelectAddress];
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    AddressInfo *addressInfo = [dict objectForKey:[[self class] cellDictKeyForAddressInfo]];
    
    BOOL isDefault = addressInfo.isDefault;
    BOOL isSelected = [dict boolValueForKey:[[self class] cellDictKeyForSelected] defaultValue:NO];
    if (addressInfo) {
        
        if (self.isForSelectAddress) {
            isDefault = NO; //如果是选择地址，那么强制不显示默认背景
            self.selctedFlag.hidden = !isSelected;
            self.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            self.selctedFlag.hidden = YES;
            self.contentView.backgroundColor = isDefault?[UIColor colorWithHexString:@"626879"]:[UIColor whiteColor];
        }
        
        self.receiverLbl.text = addressInfo.receiver;
        self.receiverLbl.textColor = isDefault?[UIColor whiteColor]:[UIColor colorWithHexString:@"1a1a1a"];
        
        self.phoneNumberLbl.text = addressInfo.phoneNumber;
        self.phoneNumberLbl.textColor = isDefault?[UIColor whiteColor]:[UIColor colorWithHexString:@"1a1a1a"];
        
        self.areaDetailLbl.text = [NSString stringWithFormat:@"%@%@",addressInfo.areaDetail,addressInfo.address];
        self.areaDetailLbl.textColor = isDefault?[UIColor whiteColor]:[UIColor colorWithHexString:@"1a1a1a"];
//        
//        self.addressLbl.text = addressInfo.address;
//        self.addressLbl.textColor = isDefault?[UIColor whiteColor]:[UIColor colorWithHexString:@"181818"];
        
        [self setNeedsDisplay];
    }
}

@end





