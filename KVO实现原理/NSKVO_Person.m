//
//  NSKVONotifying_Person.m
//  KVO实现原理
//
//  Created by 小飞鸟 on 2019/12/30.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSKVO_Person.h"
#import <objc/runtime.h>

@implementation NSKVO_Person

-(void)setName:(NSString *)name{
    
//    _NSSetObjectValueAndNotify(self,,name);
    [self _NSSetObjectValueAndNotify:name];
}

-(void)willChangeValueForKey:(NSString *)key{
    [super willChangeValueForKey:key];
    NSLog(@"%s",__func__);
    
}


-(void)didChangeValueForKey:(NSString *)key{
    [super didChangeValueForKey:key];

    NSLog(@"%s",__func__);
    
}

-(void)_NSSetObjectValueAndNotify:(NSString *)name{
    
        [self willChangeValueForKey:name];
        [super setName:name];
        [self didChangeValueForKey:name];
}

//void _NSSetObjectValueAndNotify(NSKVO_Person * self,id super,NSString * key){
//
//    [self willChangeValueForKey:key];
//    [super setName:key];
//    [self didChangeValueForKey:key];
//}
@end
