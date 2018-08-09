//
//  IDCPageViewController.h
//  IDCPageViewController
//
//  Created by idol_ios on 2017/6/19.
//  Copyright © 2017年 idol_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDCPageViewControllerDelegate;

@interface IDCPageViewController : UIViewController
@property(nonatomic,assign)BOOL isStop;
@property (nonatomic, weak) id<IDCPageViewControllerDelegate> pageViewControllerDelegate;
-(void)scrollToIndexViewController:(NSInteger)index animated:(BOOL)animated;
-(NSArray<__kindof UIViewController *> *)getRealAllChildViewControllers;
@end



@protocol IDCPageViewControllerDelegate <NSObject>

-(void)idcPageViewController:(IDCPageViewController*)vc didScrollToViewControllerAtIndex:(NSInteger)index;

@end
