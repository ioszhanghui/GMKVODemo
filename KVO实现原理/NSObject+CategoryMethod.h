//
//  NSObject+ProtocolMethod.h
//  FBSnapshotTestCase
//
//  Created by 小飞鸟 on 2019/09/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CategoryMethod)

/*为某一个类 添加协议*/
+ (void)addProtocol:(NSString *)protocolName toClass:(Class)className;

/*替换某一个类方法的实现*/
+(void)swizzleClassMethod:(SEL)originSel SwizzleSel:(SEL)swizzleSel;

/*替换某一个对象方法的实现*/
+(void)swizzleInstanceMethod:(SEL)originSel SwizzleSel:(SEL)swizzleSel;

/*为某一个类 添加实例方法*/
+(void)addMethod:(SEL)sel Toclass:(Class)class FuncClass:(Class)funcClass;


/*执行 操作 参数大于两个  延迟执行*/
-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay argument:(nullable id)arg, ... NS_REQUIRES_NIL_TERMINATION ;

/*打印测试 一个类的方法*/
+(void)nslogMethod:(Class)objClass;

@end



NS_ASSUME_NONNULL_END
