//
//  MyClass.h
//  runtime01
//
//  Created by Code_Hou on 2017/3/24.
//  Copyright © 2017年 侯森魁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,copy)NSString *string;

- (void)method1;
- (void)method2;
+ (void)classMethod1;
@end
