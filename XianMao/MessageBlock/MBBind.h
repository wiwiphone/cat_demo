//
//  MBBind.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBUtil.h"
#import "MB_metamacros.h"

//一个observer用来表示 可以用来remove
@protocol MBBindObserver <NSObject>
@end

//当绑定init的时候old的值就是这个,可以用来判断是否是初次绑定
@interface MBBindInitValue : NSObject
+ (MBBindInitValue *)value;
@end

//设定是否在绑定主体dealloc自动解绑它上面的所有observer 默认是YES
extern void MBSetAutoUnbind(BOOL yesOrNO);

//设定绑定执行的线程是不是绑定时的线程,默认是NO
//如果你想把ViewDO直接传到Model层请把这个设为YES,防止在非主线程修改UI
extern void MBSetBindableRunThreadIsBindingThread(BOOL yesOrNO);

typedef enum {
    MBBindableRunSafeThreadStrategy_Retain = 0,
    MBBindableRunSafeThreadStrategy_Ignore
} MBBindableRunSafeThreadStrategy;

//当MBSetBindableRunThreadIsBindingThread 设为YES时 ,bind触发的执行是异步的,那么可能导致弱引用的changeBlock执行时
//外部参数已经被dealloc 这个策略就是对这个情况下的处理做分离 ,默认策略是 MBBindableRunSafeThreadStrategy_Retain
// MBBindableRunSafeThreadStrategy_Retain 在异步执行前对bindable retain一把,执行完后在release,并发高时占会用很多内存,
//      因为会在异步执行阶段bindable对象不会被dealloc
// MBBindableRunSafeThreadStrategy_Ignore 在异步执行前判断bindable是否dealloc 已经dealloc就不执行了 ,对内存友好
extern void MBSetBindableRunSafeThreadStrategy(MBBindableRunSafeThreadStrategy strategy);

typedef void (^MB_CHANGE_BLOCK)(id old, id new);

typedef void (^MB_HOST_CHANGE_BLOCK)(id host, id old, id new);

typedef void (^MB_DEALLOC_BLOCK)();

//这个宏 可以用来在编译期就判断这个OBJ下的这个keyPath是否存在,可以避免出错
#define tbKeyPath(OBJ,PATH) OBJ , @(((void)(NO && ((void)OBJ.PATH, NO)), #PATH))
#pragma mark  - Binding
//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行
extern inline id <MBBindObserver> MBBindObject(id bindable, NSString *keyPath, MB_CHANGE_BLOCK changeBlock);

//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行 ,其中 host 是弱引用
extern inline id <MBBindObserver> MBBindObjectWeak(id bindable, NSString *keyPath, id host, MB_HOST_CHANGE_BLOCK changeBlock);

//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行 ,其中 host 是强引用
extern inline id <MBBindObserver> MBBindObjectStrong(id bindable, NSString *keyPath, id host, MB_HOST_CHANGE_BLOCK changeBlock);

//将一个MBBindObserver Attach到一个obj 使observer的生命周期<=这个obj
extern inline void MBAttachBindObserver(id <MBBindObserver> observer, id obj);
#pragma mark  - UnBinding

//解绑bindable上的所有observer
extern inline void MBUnbindObject(id bindable);

//解绑bindable上keyPath对应的所有observer
extern inline void MBUnbindObjectWithKeyPath(id bindable, NSString *keyPath);

//直接解绑一个Observer
extern inline void MBUnbindObserver(id <MBBindObserver> observer);

//创建一个在bindable dealloc的时候出发的操作
extern inline id <MBBindObserver> MBCreateDeallocObserver(id bindable, MB_DEALLOC_BLOCK deallocBlock);

//取消一个DeallocObserver的执行
extern inline void MBCancelDeallocObserver(id <MBBindObserver> observer);
#pragma mark  - Marco for Easy Use
//设置可以自动在delegate被release的时候,置为nil的方法
#define MBAutoNilDelegate(hostType,host,delegateProperty,delegate)                                                  \
    {                                                                                                                 \
        (host).delegateProperty=(delegate);                                                                           \
        __block __unsafe_unretained hostType _____host = (host);                                                      \
        id <MBBindObserver> ___observer=MBCreateDeallocObserver((delegate),                                       \
                               ^(){                                                                                   \
                                   MB_LOG(@"NeedAutoNil host[%@] delegateProperty[%@]",                             \
                                                _____host, @#delegateProperty);                                       \
                                   _____host.delegateProperty=nil;                                                    \
                                  });                                                                                 \
        MBCreateDeallocObserver(host,                                                                               \
            ^() {                                                                                                     \
                MB_LOG(@"NeedAutoNil cancelDeallocObserver[%@]", ___observer);                                      \
                MBCancelDeallocObserver(___observer);                                                               \
            }                                                                                                         \
            );                                                                                                        \
}


//直接绑定变量 ,对方对象是弱引用
#define MBBindPropertyWeak(bindable , keyPath , type , host , property)                                     \
    {                                                                                                         \
        MBBindObjectWeak(tbKeyPath(bindable,keyPath),host,^(type ____host ,id ____old,id ____new) {         \
                                    (____host).property = ____new;                                            \
                            });                                                                               \
}

//直接绑定变量 ,对方对象是强引用
#define MBBindPropertyStrong(bindable , keyPath , host , property)                                          \
        {                                                                                                     \
            MBBindObject(tbKeyPath(bindable,keyPath) , ^(id ____old, id ____new) {                          \
                            (host).property = ____new;                                                        \
            });                                                                                               \
}

#pragma mark  - Auto KeyPath Change Binding

#define  __MBAutoKeyPathChangeMethodNameSEP $_$
#define  __MBAutoKeyPathChangeMethodNameSEP_STR @MB_metamacro_stringify(__MBAutoKeyPathChangeMethodNameSEP)

#define __MBAutoKeyPathChangeMethodName(...)      \
    MB_metamacro_foreach_concat(,__MBAutoKeyPathChangeMethodNameSEP,__VA_ARGS__)


#define __MB_foreach_concat_iter(INDEX, BASE, ARG) .ARG

#define __MB_get_self_property(...)                                                                \
    self MB_metamacro_foreach_cxt_recursive(__MB_foreach_concat_iter, , ,__VA_ARGS__)

//编译时判断字段是否存在
#ifdef DEBUG
#define __MBTryWhenThisKeyPathChange(...)                                                                            \
    MB_metamacro_concat(-(void)__$$tryKeyPathChangeOnlyExistInDebugOn_, __MBAutoKeyPathChangeMethodName(__VA_ARGS__)) \
{(void)(NO && ((void)__MB_get_self_property(__VA_ARGS__), NO));}
#else
#define __MBTryWhenThisKeyPathChange(...)
#endif


#define MBWhenThisKeyPathChange(...)                                                             \
    __MBTryWhenThisKeyPathChange(__VA_ARGS__)                                                   \
    MB_metamacro_concat(-(void)__$$keyPathChange_, __MBAutoKeyPathChangeMethodName(__VA_ARGS__))    \
    :(BOOL)isInit old:(id)old new:(id)new


