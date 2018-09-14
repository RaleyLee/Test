//
//  CCPhotLibraryViewController.h
//  Coco
//
//  Created by  on 13-1-12.
//  Copyright (c) 2013年  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCPhotLibraryViewControllerDelegate <NSObject>

- (void)getImage:(UIImage *)img;
- (void)popController;

@end

@interface CCPhotLibraryViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, assign) id<CCPhotLibraryViewControllerDelegate> delegate;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@end
