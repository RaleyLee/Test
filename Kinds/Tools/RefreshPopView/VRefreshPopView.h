//
//  VRefreshPopView.h
//  PopupViewExample
//
//  Created by Vols on 2017/6/30.
//  Copyright © 2017年 vols. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickHandlerBlock) (NSUInteger selectedIndex);

@interface VRefreshPopView : UIView

@property (nonatomic, copy) ClickHandlerBlock clickHandler;

@property (nonatomic, assign) NSUInteger  selectedIndex;

+ (VRefreshPopView *)showWithView:(UIView *)view;

@end
