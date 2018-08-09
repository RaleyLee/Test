//
//  ModalViewController.h
//  Kinds
//
//  Created by hibor on 2018/6/21.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaseViewController.h"

@interface ModalViewController : BaseViewController

typedef void (^backToNormalBlock)(void);
@property(nonatomic,copy)backToNormalBlock block;

@end
