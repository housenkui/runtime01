//
//  main.m
//  runtimeEx
//
//  Created by Code_Hou on 2017/3/24.
//  Copyright © 2017年 侯森魁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyClass.h"
#import <objc/runtime.h>

void imp_submethod1(id self,SEL _cmd){
    
    NSLog(@"run sub method 1");
    
    NSLog(@"%@  %@",[self class],NSStringFromSelector(_cmd));
    
}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyClass *myClass =[[MyClass alloc]init];
        
      
        
        unsigned int outCoount = 0;
        
        //Class 是一个结构体指针
        Class cls  = myClass.class;
        
        //类名
        NSLog(@"class name :%s",class_getName(cls));
        NSLog(@"================================================");
        
        //父类
        NSLog(@"super class name:%s",class_getName(class_getSuperclass(cls)));
        NSLog(@"================================================");

        //是否是元类
        NSLog(@"MyClass is %@ a meta-class",(class_isMetaClass(cls))?@"":@"not");
        NSLog(@"================================================");

        
        Class meta_class = objc_getMetaClass(class_getName(cls));
        NSLog(@"%s's meta-class is %s",class_getName(cls),class_getName(meta_class));
        
        //变量实例大小48字节 =(5+1)*8
        NSLog(@"instance size %zu",class_getInstanceSize(cls));
        NSLog(@"================================================");
        
        //成员变量列表
        Ivar *ivars = class_copyIvarList(cls, &outCoount);
        
        for (int i = 0 ; i<outCoount; i++) {
            
            Ivar ivar = ivars[i];
            NSLog(@"instance variable's name %s at index:%d",ivar_getName(ivar),i);
            
        }
        free(ivars);
        
        Ivar string = class_getInstanceVariable(cls, "_string");
        if (string!=NULL) {
            
            NSLog(@"instance variable %s",ivar_getName(string));
        }
        NSLog(@"================================================");
        
        //属性操作
        objc_property_t *properties = class_copyPropertyList(cls, &outCoount);
        
        for (int i = 0 ; i<outCoount; i++) {
            
            objc_property_t property = properties[i];
            
            NSLog(@"property's name :%s",property_getName(property));
        }
        free(properties);
        
        objc_property_t array  =class_getProperty(cls, "array");
        if (array!=NULL) {
            
            NSLog(@"property %s",property_getName(array));
        }
        NSLog(@"==========================================");
        
        //方法操作
        Method *methods  =class_copyMethodList(cls, &outCoount);
        
        for (int i = 0 ; i<outCoount; i++) {
            
            Method method = methods[i];
            
            NSLog(@"method's signature :%s",method_getName(method));
            
        }
        free(methods);
        
        Method method1 = class_getInstanceMethod(cls, @selector(method1));
        
        if (method1!=NULL) {
            NSLog(@"method %s",method_getName(method1));
        }
        Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
        if (classMethod!=NULL) {
            NSLog(@"class method :%s",method_getName(classMethod));
        }
        
        NSLog(@"MyClass is %@ responsd to selector:method3WithArg1:arg2",class_respondsToSelector(cls, @selector(method3WithArg1:arg2:))?@"":@"not");
        
        //拿到函数实现的方法 然后直接调用
        IMP imp = class_getMethodImplementation(cls, @selector(method1));
        
        imp();
        NSLog(@"====================================================");
        
        
        //协议
        //FIXME:这种写法第一次见，我去
        Protocol * __unsafe_unretained *protocols = class_copyProtocolList(cls, &outCoount);
        Protocol *protocol;
        
        for (int i = 0 ; i<outCoount ; i++) {
            
            protocol = protocols[i];
            
            NSLog(@"protocol name: %s",protocol_getName(protocol));
        }
        
        NSLog(@"MyClass is %@ responsed to protocol %s",class_conformsToProtocol(cls, protocol)?@"":@"not",protocol_getName(protocol));
        
        NSLog(@"==================================================");
        
        
#pragma mark---动态创建类和对象
        /*
           为了创建一个新类，我们需要调用objc_allocateClassPair。然后使用诸如class_addMethod，class_addIvar等函数来为新创建的类添加方法、实例变量和属性等。完成这些后，我们需要调用objc_registerClassPair函数来注册类，之后这个新类就可以在程序中使用了。
         
         */
        
        
        Class subcls = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
        
        class_addMethod(subcls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
        //IMP 函数实现的地址，就是函数名字
        class_replaceMethod(subcls, @selector(method1), (IMP)imp_submethod1, "v@:");
        //给类添加成员变量
        class_addIvar(subcls, "_ivar1", sizeof(NSString*), log(sizeof(NSString*)), "i");
        objc_property_attribute_t type ={"T","@\"NSString\""};
        
        objc_property_attribute_t ownership = {"C",""};
        
        objc_property_attribute_t backingivar = {"V","_ivar1"};
        
        objc_property_attribute_t attrs[] ={type,ownership,backingivar};
        
        class_addProperty(subcls, "property2", attrs, 3);
        
        objc_registerClassPair(subcls);
        
        NSObject *instance = [[subcls alloc ]init];
        
        [instance performSelector:@selector(submethod1)];
        
        [instance performSelector:@selector(method1)];

        
#pragma mark---打印动态创建的类的属性
        Class instanceClass  =instance.class;
        
        objc_property_t *propertys =   class_copyPropertyList(instanceClass, &outCoount);
        
        for (int i = 0 ; i<outCoount; i++) {
            
            NSLog(@" instanceClass property %s",property_getName(propertys[i]));
            
          NSLog(@"instanceClass property_Attributes %s",property_getAttributes(propertys[i]));
        }
        
        
        
#pragma mark---实例操作函数
        
        


        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        
    }
    return 0;
}

