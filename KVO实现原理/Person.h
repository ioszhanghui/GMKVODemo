//
//  Person.h
//  KVO实现原理
//
//  Created by 小飞鸟 on 2019/12/30.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(nonatomic,copy)NSString * name;

-(void)gm_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
@end

NS_ASSUME_NONNULL_END
