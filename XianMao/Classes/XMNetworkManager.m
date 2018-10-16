//
//  XMNetworkManager.m
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "XMNetworkManager.h"
#import "SynthesizeSingleton.h"
#import "NSMutableArray+WeakReferences.h"
#import "AFNetworking.h"
#import "Version.h"


NSString * const BaseURLString = @"http://127.0.0.1/xm";

@interface XMNetworkManager ()

@property(nonatomic,retain) NSMutableArray *delegates;

@end

@implementation XMNetworkManager

SYNTHESIZE_SINGLETON_FOR_CLASS(XMNetworkManager, sharedInstance);

- (void)initialize
{
    
}


@end





