//
//  QQPlayMoreView.h
//  Kinds
//
//  Created by hibor on 2018/9/13.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQPlayMoreView : UIView

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;


+(QQPlayMoreView *)sharedManager;

-(void)playShow;

-(void)playDismiss;


@end
