//
//  NSObject+Extension.m
//  OC混合开发
//
//  Created by 沈强 on 16/9/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (id)sq_performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    // 通过选择器获取方法签名
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if (signature == nil) {
        NSString *reason = [NSString stringWithFormat:@"***** The method[%@] is not find ******", NSStringFromSelector(aSelector)];
        @throw [NSException exceptionWithName:@"错误" reason:reason userInfo:nil];
    }
    
    // 直接调用某个对象的消息，2种，1：NSInvocation(>2个参数或者后返回值的处理) 2:performSelector:withObject
    // NSInvocation利用一个NSInvocation对象包装一次方法调用(方法调用者、方法名、方法参数、方法返回值)
     NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    NSInteger paras = signature.numberOfArguments - 2;
    paras = MIN(paras, objects.count);
    for (NSInteger i = 0; i < paras; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) {
            continue;
        }
        [invocation setArgument:&object atIndex:i+2];
    }
    // 调用方法
    [invocation invoke];
    
    id returnValue = nil;
    if (signature.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}










@end
