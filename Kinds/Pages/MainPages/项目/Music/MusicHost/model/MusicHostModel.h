//
//  MusicHostModel.h
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicHostContentModel.h"
@interface MusicHostModel : NSObject

@property(nonatomic,copy)NSString *sectionTitle;

@property(nonatomic,strong)NSMutableArray <MusicHostContentModel *>*contentArray;
//@property(nonatomic,assign)MusicHostContentModel *contentModel;

@end
