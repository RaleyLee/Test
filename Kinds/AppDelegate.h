//
//  AppDelegate.h
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

typedef enum : NSUInteger{
    OritationTypeUP,  //朝上
    OritationTypeLeft,  //朝左
    OritationTypeRight,  //朝右
    OritationTypeALL,  //朝上/左/右
}OritationType;

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)OritationType orientation;

@end

