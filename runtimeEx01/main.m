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
        
        
        
        
    }
    return 0;
}
