//
//  ViewController.m
//  runtime01
//
//  Created by Code_Hou on 2017/3/24.
//  Copyright © 2017年 侯森魁. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    Test *test  =[[Test alloc]init];111
    
    //Class 结构体指针占用8个字节
    
     NSUInteger length =   sizeof(Class);
    
     NSLog(@"length = %lu",length);
    
    
    //都是类对象的指针 占用8个字节
    //FIXME:结构体占用多大的空间,这里的obj实际上是一个结构体指针NSObject *obj = [[NSObject alloc]init];？？

    NSUInteger size =   class_getInstanceSize([NSArray class]);
    
    NSLog(@"size  =%lu",size);
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
