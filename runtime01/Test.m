//
//  Test.m
//  runtime01
//
//  Created by Code_Hou on 2017/3/24.
//  Copyright © 2017年 侯森魁. All rights reserved.
//

#import "Test.h"
#import <objc/runtime.h>


/*
 
 这个例子是在运行时创建了一个NSError的子类TestClass，然后为这个子类添加一个方法testMetaClass，这个方法的实现是TestMetaClass函数。
 
 */
void TestMetaClass(id self,SEL _cmd){
    
    NSLog(@"This object is %p",self);
    NSLog(@"Class is %@,super class is %@",[self class],[self superclass]);
    Class currentClass = [self class];
    
    for (int i = 0 ; i<4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p",i,currentClass);
        
        currentClass = objc_getClass((__bridge void *)currentClass);
        
    }
    NSLog(@"NSObject's class is %p",[NSObject class]);
    NSLog(@"NSObject's meta class is %p",objc_getClass((__bridge void *)[NSObject class]));
    
}
/*
 我们在for循环中，我们通过objc_getClass来获取对象的isa，并将其打印出来，依此一直回溯到NSObject的meta-class。分析打印结果，可以看到最后指针指向的地址是0x0，即NSObject的meta-class的类地址。
 
 这里需要注意的是：我们在一个类对象调用class方法是无法获取meta-class，它只是返回类而已。
 */

@implementation Test

- (instancetype)init{
    
    if (self=[super init]) {
        
        [self ex_registerClassPair];
    }
    return self;
}

- (void)ex_registerClassPair{
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance  =[[newClass alloc]initWithDomain:@"some domain" code:0 userInfo:nil];
    
    [instance performSelector:@selector(testMetaClass)];
}






























@end
