//
//  Singleton.h
//  Test
//
//  Created by hibor on 2018/3/12.
//  Copyright © 2018年 hibor. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h


#define singleton_interface(className) \
+ (className *)shared##className;

#define singleton_implementation(className) \
static className *_instance; \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \


#endif /* Singleton_h */
