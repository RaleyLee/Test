//
//  LLDownLoadView.h
//  Kinds
//
//  Created by hibor on 2018/8/17.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDownLoadModel.h"


@interface LLDownLoadView : UIView

+(LLDownLoadView *)createDownLoadView;

@property(nonatomic,strong)LLDownLoadModel *downModel;

-(void)offLineResumeDownLoadAction;

@end
