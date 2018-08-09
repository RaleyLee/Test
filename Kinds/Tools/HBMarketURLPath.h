//
//  HBMarketURLPath.h
//  Market
//
//  Created by hibor on 2018/6/7.
//  Copyright © 2018年 hibor. All rights reserved.
//

#ifndef HBMarketURLPath_h
#define HBMarketURLPath_h


////////////
#pragma mark - 腾讯济安 更换成 上证50指数
#define FINE_NAME @"腾讯济安"
#define REPLACE_NAME @"上证50指数"
#define REPLACE_CODE @"000016"
////////////


#pragma mark - 排序箭头
#define SORT_DEFAULT @"sort_default"
#define SORT_UP @"sort_up_1"
#define SORT_DOWN @"sort_down_1"


#define HB_HEADER_URL @"http://quote.hibor.com.cn/"

//沪深主页请求数据  涨幅榜
#define HS_HOME_ZDF_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/index?type=zfb"]
//沪深主页请求数据  跌幅榜
#define HS_HOME_DF_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/index?type=dfb"]
//沪深主页请求数据  换手榜
#define HS_HOME_HSL_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/index?type=hsl"]
//沪深主页请求数据  涨速榜
#define HS_HOME_ZS_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/index?type=szb"]
//沪深主页请求数据  振幅榜
#define HS_HOME_ZF_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/index?type=zhenfub"]
//沪深主页请求数据  量比榜
#define HS_HOME_LB_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/index?type=lbb"]

//沪深表格数据
#define HS_TABLE_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/rankmore?ordertype=%@&order=%@"]

//沪深热门行业 - 全部板块
#define HS_HOT_ALL_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/plate?type=bkall&o=1"]
#define HS_HOT_DETAIL_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/plateitem?pt=%@"]
//沪深热门行业 - 行业
#define HS_HOT_HY_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/plate?type=hy&o=1"]
//沪深热门行业 - 概念
#define HS_HOT_GN_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/plate?type=gn&o=1"]

//沪深热门行业 Item
#define HS_ITEM_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHS/plateitem?pt=%@&o=%@"]
//港股热门板块 Item
#define GG_ITEM_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHk/industryitem?t=%@&s=%@"]


//港股 主页
#define GG_HOME_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHk/index"]
//港股 热门行业。。。
#define GG_MORE_HY_URL [HB_HEADER_URL stringByAppendingString:@"hangqingHk/industrymore?s=%@"]

/////////-----------------------------
//港股通 主页
#define GGT_HOME_URL [HB_HEADER_URL stringByAppendingString:@"hangqingGGT/index"]

//港股通 - 沪股通。。。
#define GGT_HGT_URL [HB_HEADER_URL stringByAppendingString:@"hangqingGGT/rankmore?type=hgt&order=%@"]
//港股通 - 深股通。。。
#define GGT_SGT_URL [HB_HEADER_URL stringByAppendingString:@"hangqingGGT/rankmore?type=sgt&order=%@"]
//港股通 - 港股通(沪)。。。
#define GGT_GGT_H_URL [HB_HEADER_URL stringByAppendingString:@"hangqingGGT/rankmore?type=ggt_h&order=%@"]
//港股通 - 港股通(深)。。。
#define GGT_GGT_S_URL [HB_HEADER_URL stringByAppendingString:@"hangqingGGT/rankmore?type=ggt_s&order=%@"]
//港股通 - AH股。。。
#define GGT_AH_URL [HB_HEADER_URL stringByAppendingString:@"hangqingGGT/rankmore?type=ahg&order=%@"]



//////------------------------------
//环球 主页
#define HQ_HOME_URL [HB_HEADER_URL stringByAppendingString:@"hangqingQQ/index"]
//环球 -环球股票指数
#define HQ_STOCK_URL [HB_HEADER_URL stringByAppendingString:@"hangqingQQ/rankmore?type=gpzs"]
//环球 -环球大宗商品
#define HQ_DZ_URL [HB_HEADER_URL stringByAppendingString:@"hangqingQQ/rankmore?type=dzsp"]
//环球 -外汇
#define HQ_WH_URL [HB_HEADER_URL stringByAppendingString:@"hangqingQQ/rankmore?type=whsc"]




#endif /* HBMarketURLPath_h */
