//
//  MBCommandInterceptor.h
//  XianMao
//
//  Created by simon on 12/29/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

//============================================================================

@protocol MBCommandInvocation;

@protocol MBCommandInterceptor <NSObject>
//拦截
- (id)intercept:(id <MBCommandInvocation>)invocation;
@end


