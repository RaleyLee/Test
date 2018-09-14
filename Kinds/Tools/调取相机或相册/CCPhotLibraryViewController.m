//
//  CCPhotLibraryViewController.m
//  Coco
//
//  Created by cao xiaofeng on 13-1-12.
//  Copyright (c) 2013年 365rili.com. All rights reserved.
//

#import "CCPhotLibraryViewController.h"
#import "UIImage+Cut.h"

@interface CCPhotLibraryViewController ()

@end

@implementation CCPhotLibraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imagePickerController = [[UIImagePickerController alloc] init];
        /**去除毛玻璃效果 否则导航条会遮挡相册*/
        self.imagePickerController.navigationBar.translucent = NO;
        
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.imagePickerController.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    
    self.imagePickerController.sourceType = sourceType;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (self.delegate)
        [self.delegate popController];
        [self.delegate getImage:[image scaleAndRotateImage]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.delegate)
    {
        [self.delegate popController];
    }
}

@end
