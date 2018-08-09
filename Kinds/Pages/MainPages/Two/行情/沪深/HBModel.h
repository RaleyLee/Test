//
//  HBModel.h
//  StockMarket
//
//  Created by hibor on 2018/5/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBListModel,HBItemModel,GangModel,GangTModel,QiuModel,HBHQModel,HBGGTModel,BangModel,MHYModel,HBGGTModel2,AroundModel,HBSearchModel,HBSModel;

@interface HBModel : NSObject

@end

#pragma mark - 列表显示的Model类

@interface HBListModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *zxj;
@property(nonatomic,copy)NSString *zd;
@property(nonatomic,copy)NSString *zdf;
@property(nonatomic,copy)NSString *hsl;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *zf;
@property(nonatomic,copy)NSString *cjl;
@property(nonatomic,copy)NSString *lb;
@property(nonatomic,copy)NSString *zs;

@end

#pragma mark - 存放Item的Model类

@interface HBItemModel : NSObject

@property(nonatomic,copy)NSString *bd_name;
@property(nonatomic,copy)NSString *bd_code;
@property(nonatomic,copy)NSString *bd_zxj;
@property(nonatomic,copy)NSString *bd_zd;
@property(nonatomic,copy)NSString *bd_zdf;
@property(nonatomic,copy)NSString *nzg_name;
@property(nonatomic,copy)NSString *nzg_code;
@property(nonatomic,copy)NSString *nzg_zxj;
@property(nonatomic,copy)NSString *nzg_zd;
@property(nonatomic,copy)NSString *nzg_zdf;

@end

#pragma mark - 港股存放的Model类
@interface GangModel : NSObject

@property(nonatomic,copy)NSString *cje;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *zd;
@property(nonatomic,copy)NSString *zdf;
@property(nonatomic,copy)NSString *zxj;

@end

#pragma mark - 港股通存放的Model类
@interface GangTModel : NSObject

@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *bd_code;
@property(nonatomic,copy)NSString *bd_name;
@property(nonatomic,copy)NSString *bd_zd;
@property(nonatomic,copy)NSString *bd_zdf;
@property(nonatomic,copy)NSString *bd_zxj;
@property(nonatomic,copy)NSString *corps;
@property(nonatomic,copy)NSString *nzg_code;
@property(nonatomic,copy)NSString *nzg_name;
@property(nonatomic,copy)NSString *nzg_zd;
@property(nonatomic,copy)NSString *nzg_zdf;
@property(nonatomic,copy)NSString *nzg_zxj;
@property(nonatomic,copy)NSString *sz;
@property(nonatomic,copy)NSString *volume;

@end

#pragma mark - 环球存放的Model类

@interface QiuModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *qtcode;
@property(nonatomic,copy)NSString *zxj;
@property(nonatomic,copy)NSString *zdf;
@property(nonatomic,copy)NSString *zd;

@property(nonatomic,copy)NSString *hbuy;
@property(nonatomic,copy)NSString *cbuy;

@end


@interface HBHQModel : NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *isdelay;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *zd;
@property(nonatomic,copy)NSString *zdf;
@property(nonatomic,copy)NSString *zxj;

@end


@interface HBGGTModel : NSObject

@property(nonatomic,copy)NSString *acode;
@property(nonatomic,copy)NSString *aname;
@property(nonatomic,copy)NSString *azd;
@property(nonatomic,copy)NSString *azdf;
@property(nonatomic,copy)NSString *azxj;
@property(nonatomic,copy)NSString *hayj;
@property(nonatomic,copy)NSString *hcode;
@property(nonatomic,copy)NSString *hname;
@property(nonatomic,copy)NSString *hzd;
@property(nonatomic,copy)NSString *hzdf;
@property(nonatomic,copy)NSString *hzxj;

@end


@interface BangModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *zxj;
@property(nonatomic,copy)NSString *zd;
@property(nonatomic,copy)NSString *zdf;
@property(nonatomic,copy)NSString *cje;

@end



@interface MHYModel : NSObject

@property(nonatomic,copy)NSString *bd_name;
@property(nonatomic,copy)NSString *bd_code;
@property(nonatomic,copy)NSString *bd_zxj;
@property(nonatomic,copy)NSString *bd_zdf;
@property(nonatomic,copy)NSString *bd_zd;
@property(nonatomic,copy)NSString *corps;
@property(nonatomic,copy)NSString *volume;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *sz;
@property(nonatomic,copy)NSString *nzg_code;
@property(nonatomic,copy)NSString *nzg_zd;
@property(nonatomic,copy)NSString *nzg_zdf;
@property(nonatomic,copy)NSString *nzg_zxj;
@property(nonatomic,copy)NSString *nzg_name;

@end


@interface HBGGTModel2 : NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *zxj;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *zdf;
@property(nonatomic,copy)NSString *zd;

@end


#pragma mark - 存放股票表格的Model

@interface AroundModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *zxj;
@property(nonatomic,copy)NSString *zdf;
@property(nonatomic,copy)NSString *hsl;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *cjl;
@property(nonatomic,copy)NSString *cje;
@property(nonatomic,copy)NSString *lb;
@property(nonatomic,copy)NSString *zf;
@property(nonatomic,copy)NSString *syl;
@property(nonatomic,copy)NSString *ltsz;
@property(nonatomic,copy)NSString *zsz;
@property(nonatomic,copy)NSString *zde;
@property(nonatomic,copy)NSString *zs;

@end



@interface HBSearchModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *gp;
@property(nonatomic,copy)NSString *hot;

@end

@interface HBSModel : NSObject

@property(nonatomic,copy)NSString *code_h; //代码头部
@property(nonatomic,copy)NSString *code_f; //代码尾部
@property(nonatomic,copy)NSString *stock_name; //股票名称
@property(nonatomic,copy)NSString *stock_name_simple; //股票名称英文
@property(nonatomic,copy)NSString *stock_gp;

@end

