//
//  main.m
//  runtimeEx01
//
//  Created by Code_Hou on 2017/3/24.
//  Copyright © 2017年 侯森魁. All rights reserved.
//
/*
 
 使用class_createInstance 函数获取的是NSString实例，而不是类簇中的默认占位符类_NSCFConstantString.
 
 
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //去掉ARC模式
        id theObject = class_createInstance(NSString.class,sizeof(unsigned));
        
#pragma mark---动态创建对象
        
        id str1 = [theObject init];
        
        NSLog(@"%@",[str1 class]);
        
        id str2  =[[NSString alloc]initWithString:@"test"];
        
        NSLog(@"%@",[str2 class]);
        
#pragma mark---获取类的定义
        
        /*
         
         objc_getClassList函数：获取已注册的类定义的列表。我们不能假设从该函数中获取的类对象是继承自NSObject体系的，所以在这些类上调用方法是，都应该先检测一下这个方法是否在这个类中实现。

         */
        NSLog(@"获取类的定义======================================");
        int numClasses;
        Class *classes  =NULL;
        // 获取已注册的类定义的列表
        numClasses = objc_getClassList(NULL, 0);
        if (numClasses>0) {
            
            classes = malloc(sizeof(Class)*numClasses);
            
            numClasses = objc_getClassList(classes, numClasses);
            
            NSLog(@"number of classes :%d",numClasses);
            
            for (int i = 0 ; i<numClasses; i++) {
                
                Class cls =classes[i];
                
                NSLog(@"class name:%s",class_getName(cls));
            }
            free(classes);
        }
        /*
         2017-03-24 19:30:07.337492 runtimeEx01[4264:705458] number of classes :1667
         2017-03-24 19:30:07.337529 runtimeEx01[4264:705458] class name:NSLeafProxy
         2017-03-24 19:30:07.337544 runtimeEx01[4264:705458] class name:NSProxy
         2017-03-24 19:30:07.337679 runtimeEx01[4264:705458] class name:NSUndoManagerProxy
         2017-03-24 19:30:07.337727 runtimeEx01[4264:705458] class name:NSProtocolChecker
         2017-03-24 19:30:07.337758 runtimeEx01[4264:705458] class name:NSConcreteProtocolChecker
         2017-03-24 19:30:07.337785 runtimeEx01[4264:705458] class name:NSAutoContentAccessingProxy
         2017-03-24 19:30:07.337810 runtimeEx01[4264:705458] class name:NSDistantObject
         2017-03-24 19:30:07.337834 runtimeEx01[4264:705458] class name:NSMutableStringProxy
         
         ...........后续大量输出..........
         */
        /*
         获取类定义的方法有三个：objc_lookUpClass, objc_getClass和objc_getRequiredClass。如果类在运行时未注册，则objc_lookUpClass会返回nil，而objc_getClass会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。而objc_getRequiredClass函数的操作与objc_getClass相同，只不过如果没有找到类，则会杀死进程。
         
         objc_getMetaClass函数：如果指定的类没有注册，则该函数会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。不过，每个类定义都必须有一个有效的元类定义，所以这个函数总是会返回一个元类定义，不管它是否有效。
         

         在这一章中我们介绍了Runtime运行时中与类和对象相关的数据结构，通过这些数据函数，我们可以管窥Objective-C底层面向对象实现的一些信息。另外，通过丰富的操作函数，可以灵活地对这些数据进行操作。
              http://southpeak.github.io/2014/10/25/objective-c-runtime-1/ 
         */


        
        
    }
    return 0;
}
