//
//  OneViewController.h
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaseViewController.h"

@interface DemoModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)BOOL canPush;
@property(nonatomic,copy)NSString *page;

@end

@interface OneViewController : BaseViewController

@end
