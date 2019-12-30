//
//  ViewController.m
//  KVO实现原理
//
//  Created by 小飞鸟 on 2019/12/30.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person * p1 = [Person new];
    Person * p2 = [Person new];
    
    NSLog(@"前----p1----%s",object_getClassName(p1));
    NSLog(@"前----p2----%s",object_getClassName(p2));
    NSLog(@"前----是否 是子类p1----%d",[p1 isKindOfClass:[Person class]]);
    NSLog(@"前----是否 是子类p2----%d",[p2 isKindOfClass:[Person class]]);
    IMP p1IMP = [p1 methodForSelector:@selector(setName:)];
    IMP p2IMP = [p2 methodForSelector:@selector(setName:)];
    
    NSLog(@"前----p1的Setter方法%p",p1IMP);
    NSLog(@"前----p2的Setter方法%p",p2IMP);
    
    
    NSLog(@"-------------------");
//    [p1 gm_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    [p1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"后----p1----%s",object_getClassName(p1));
    NSLog(@"后----p2----%s",object_getClassName(p2));
    
    
    NSLog(@"后父类----p1----%@",class_getSuperclass(object_getClass(p1)));
    NSLog(@"后父类----p2----%@",class_getSuperclass(object_getClass(p2)));
    
    NSLog(@"后----是否 是子类p1----%d",[p1 isKindOfClass:[Person class]]);
    NSLog(@"后----是否 是子类p2----%d",[p2 isKindOfClass:[Person class]]);
    IMP p11IMP = [p1 methodForSelector:@selector(setName:)];
    IMP p22IMP = [p2 methodForSelector:@selector(setName:)];
    
    NSLog(@"后----p1的Setter方法%p",p11IMP);
    NSLog(@"后----p2的Setter方法%p",p22IMP);
    
    p1.name = @"li";
    p2.name = @"王";
    
    
//    [self nslogIvalist:[p1 class]];
//
//
//    NSLog(@"-----------------------");
//
//    [self nslogIvalist:[p2 class]];

    
    NSLog(@"-----------+++++++++------------");
    
//    [self nslogMethodList:[p1 class]];
     
     NSLog(@"-----------+++++++++=========------------");

         
//     [self nslogMethodList:[p2 class]];
    
    //(Foundation`_NSSetObjectValueAndNotify)
    
    
    p1.name = @"xxx";
    [p1 setValue:@"xxx" forKey:@"name"];

}


-(void)nslogMethodList:(Class)class{
    
    unsigned count;
   Method * methodList = class_copyMethodList(class, &count);
    for (int i=0; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"%@",NSStringFromSelector(method_getName(method)));
    }
}

-(void)nslogIvalist:(Class)class{
    
    unsigned count;
   Ivar * ivarList = class_copyIvarList(class, &count);
    for (NSInteger i=0; i<count; i++) {
       const char * _Nullable ivarName = ivar_getName(ivarList[i]);
        NSLog(@"%s",ivarName);
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@----%@---%@",object,keyPath,change);
}


@end
