//
//  NSObject+Extension.h
//  OC混合开发
//
//  Created by 沈强 on 16/9/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Extension)

- (id)sq_performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end
