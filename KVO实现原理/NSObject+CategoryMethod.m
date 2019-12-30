//
//  NSObject+ProtocolMethod.m
//  FBSnapshotTestCase
//
//  Created by 小飞鸟 on 2019/09/30.
//

#import "NSObject+CategoryMethod.h"
#import <objc/runtime.h>

@implementation NSObject (CategoryMethod)
/*为某一个类 添加协议*/
+ (void)addProtocol:(NSString *)protocolName toClass:(Class)className{
    if (!protocolName) {
        return;
    }
    if ([protocolName containsString:@"<"]) {
        //包含协议<>
        protocolName = [protocolName substringWithRange:NSMakeRange(1, protocolName.length-2)];
    }
    const char * c_name = [protocolName UTF8String];
   Protocol *  protocol =  objc_getProtocol(c_name);
    if (protocol) {
        //如果协议存在
        if (class_conformsToProtocol([className class], protocol)) {
            //如果返回 YES 准讯了协议
            return;
        }
        //没有准讯协议 直接y添加 协议 遵循
        class_addProtocol([className class], protocol);
    }else{
        //协议不存在 创建协议 并注册协议
       protocol = objc_allocateProtocol(c_name);
        objc_registerProtocol(protocol);
        class_addProtocol([className class], protocol);
    }
}


+(void)nslogAllProtocol:(Class)objClass{
    unsigned int count;
     __unsafe_unretained Protocol ** protocolList = class_copyProtocolList(objClass, &count);
    for (NSInteger i=0; i<count; i++) {
        Protocol * protocol = protocolList[i];
     const char *  protocolName =  protocol_getName(protocol);
        NSLog(@"%@",[NSString stringWithUTF8String:protocolName]);
    }
}

/*替换某一个类方法的实现*/
+(void)swizzleClassMethod:(SEL)originSel SwizzleSel:(SEL)swizzleSel{
     //初始方法
     Method originMethod = class_getClassMethod([self class], originSel);
     //需要替换的方法
     Method swiizzleMethod =  class_getClassMethod([self class], swizzleSel);

     
     //class_addMethod() 判断originalSEL是否在子类中实现，如果只是继承了父类的方法，没有重写，那么直接调用method_exchangeImplementations，则会交换父类中的方法和当前的实现方法。此时如果用父类调用originalSEL，因为方法已经与子类中调换，所以父类中找不到相应的实现，会抛出异常unrecognized selector.
     //当class_addMethod() 返回YES时，说明子类未实现此方法(根据SEL判断)，此时class_addMethod会添加（名字为originalSEL，实现为replaceMethod）的方法。此时在将replacementSEL的实现替换为originMethod的实现即可。
     //当class_addMethod() 返回NO时，说明子类中有该实现方法，此时直接调用method_exchangeImplementations交换两个方法的实现即可。
     //注：如果在子类中实现此方法了，即使只是单纯的调用super，一样算重写了父类的方法，所以class_addMethod() 会返回NO。
     //原始方法
     IMP originIMP = method_getImplementation(originMethod);
     //替换方法
     IMP swizzleIMP = method_getImplementation(swiizzleMethod);
    Class metaClass = objc_getMetaClass(object_getClassName(self));

     //添加方法成功 可以判断子类 是否实现该方法
     BOOL add = class_addMethod(metaClass, originSel,swizzleIMP, method_getTypeEncoding(swiizzleMethod));
     if (add) {
         class_replaceMethod(metaClass, swizzleSel, originIMP, method_getTypeEncoding(originMethod));
     }else{
         //如果替换方法 也存在 直接交换 实现
         method_exchangeImplementations(originMethod, swiizzleMethod);
     }
}

/*替换某一个对象方法的实现*/
+(void)swizzleInstanceMethod:(SEL)originSel SwizzleSel:(SEL)swizzleSel{
    
    //初始方法
    Method originMethod = class_getInstanceMethod([self class], originSel);
    //需要替换的方法
    Method swiizzleMethod =  class_getInstanceMethod([self class], swizzleSel);

    
    //class_addMethod() 判断originalSEL是否在子类中实现，如果只是继承了父类的方法，没有重写，那么直接调用method_exchangeImplementations，则会交换父类中的方法和当前的实现方法。此时如果用父类调用originalSEL，因为方法已经与子类中调换，所以父类中找不到相应的实现，会抛出异常unrecognized selector.
    //当class_addMethod() 返回YES时，说明子类未实现此方法(根据SEL判断)，此时class_addMethod会添加（名字为originalSEL，实现为replaceMethod）的方法。此时在将replacementSEL的实现替换为originMethod的实现即可。
    //当class_addMethod() 返回NO时，说明子类中有该实现方法，此时直接调用method_exchangeImplementations交换两个方法的实现即可。
    //注：如果在子类中实现此方法了，即使只是单纯的调用super，一样算重写了父类的方法，所以class_addMethod() 会返回NO。

    //原始方法
    IMP originIMP = method_getImplementation(originMethod);
    //替换方法
    IMP swizzleIMP =  method_getImplementation(swiizzleMethod);
    //添加方法成功 可以判断子类 是否实现该方法
    BOOL add = class_addMethod([self class], originSel,swizzleIMP, method_getTypeEncoding(swiizzleMethod));
        
    if (add) {
        class_replaceMethod([self class], swizzleSel, originIMP, method_getTypeEncoding(originMethod));
    }else{
        //如果替换方法 也存在 直接交换 实现
        method_exchangeImplementations(originMethod, swiizzleMethod);
    }
    
}

+(void)nslogMethod:(Class)objClass{
    unsigned int count;
    Method * methodList = class_copyMethodList(objClass, &count);
    for (int i=0; i<count; i++) {
        Method method = methodList[i];
      SEL sel =  method_getName(method);
        NSLog(@"%@",NSStringFromSelector(sel));
    }
}

/*为某一个类 添加实例方法*/
+(void)addMethod:(SEL)sel Toclass:(Class)class FuncClass:(Class)funcClass{
    //添加方法成功 可以判断子类 是否实现该方法
    IMP selIMP = class_getMethodImplementation(funcClass, sel);
    Method selMethod = class_getInstanceMethod(funcClass, sel);
    class_addMethod(class, sel,selIMP, method_getTypeEncoding(selMethod));
}


/*执行 操作 参数大于两个  延迟执行*/
-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay argument:(nullable id)arg, ... NS_REQUIRES_NIL_TERMINATION {
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    });
}

-(void)performSelector:(SEL)aSelector argument:(nullable id)arg, ... NS_REQUIRES_NIL_TERMINATION{

    NSMethodSignature * methodSignature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    invocation.selector = aSelector;
    va_list args;
    id object;
    va_start(args, arg);
    unsigned idx =2;
    [invocation setArgument:&arg atIndex:idx];
    while ((object=va_arg(args, id))) {
        ++idx;
        [invocation setArgument:&object atIndex:idx];
    }
    va_end(args);
    [invocation invoke];

}

@end
