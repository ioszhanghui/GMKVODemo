//
//  Person.m
//  KVO实现原理
//
//  Created by 小飞鸟 on 2019/12/30.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "NSKVO_Person.h"

#import "NSObject+CategoryMethod.h"


@implementation Person


//+(void)load{
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleInstanceMethod:@selector(addObserver:forKeyPath:options:context:) SwizzleSel:@selector(gm_addObserver:forKeyPath:options:context:)];
//    });
//}

-(void)setName:(NSString *)name{
    _name =[name copy];
    NSLog(@"%s",__func__);
}

-(void)gm_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
    object_setClass(self,NSClassFromString(@"NSKVO_Person"));
    
//    // a创建子类 需要在子类的set方法中实现通知观察者observer
//    NSString*subname = [NSString stringWithFormat:@"JK_%@",NSStringFromClass([self class])] ;
//    Class newclass = NSClassFromString(subname);
//    if (!newclass)
//     {
//        newclass = objc_allocateClassPair([self class], subname.UTF8String, 0);
//     }
//    objc_registerClassPair(newclass);
//
//     object_setClass(self, newclass);
    
    objc_setAssociatedObject(self, @"observer", observer, OBJC_ASSOCIATION_ASSIGN);
}

-(void)willChangeValueForKey:(NSString *)key{
    [super willChangeValueForKey:key];
    NSLog(@"%s",__func__);
    
}

-(void)didChangeValueForKey:(NSString *)key{
   NSLog(@"开始----%s",__func__);
    
    [super didChangeValueForKey:key];
    
    id observer =   objc_getAssociatedObject(self, @"observer");
    
    [observer observeValueForKeyPath:key ofObject:self change:@{@"kind":@(1),@"new":key} context:nil];
    
    NSLog(@"结束----%s",__func__);
}

@end
