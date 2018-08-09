//
//  Const.h
//  Market
//
//  Created by hibor on 2018/6/7.
//  Copyright © 2018年 hibor. All rights reserved.
//

#ifndef Const_h
#define Const_h

//请求超时时间 20s
#define TIMEOUT 20


#define RefreshButtonEnable(enable) self.navigationItem.rightBarButtonItem.enabled = enable;


#define FONT_9_MEDIUM(fontSize) IS_IOS9 ? [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize] : [UIFont systemFontOfSize:fontSize]
#define FONT_9_BOLD(fontSize) IS_IOS9 ? [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize] : [UIFont boldSystemFontOfSize:fontSize]
#define FONT_9_REGULAR(fontSize) IS_IOS9 ? [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize] : [UIFont systemFontOfSize:fontSize]


#define RGB_random [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1]

#define RGB(r,g,b) ([UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0])
#define RGB_color(color) ([UIColor colorWithRed:(color/255.0) green:(color/255.0) blue:(color/255.0) alpha:1.0])
#define RGB_alpha(r,g,b,a) ([UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)])

#define COLOR_NAME RGB_color(45)
#define COLOR_SOURCE RGB_color(152)
#define COLOR_CONTENT RGB_color(63)







#define STOCK_NAVGATION_BGCOLOR RGB(228, 19, 72) //导航条颜色
#define TABLEVIE_BACKGROUNDCOLOR RGB(244,244,244) //tabelview背景颜色

//TableViewCell
#define STOCK_CELL_SEP_BGCOLOR RGB(218,218,218) //分割线颜色
#define SECTION_UNDERLINE_COLOR RGB(218,218,218) //section下划线颜色


#define MARKET_SPACING 15 //边距


//-----------------行情折叠 Section--------------------------------
#define STOCK_ZDSECTION_HEIGHT 45 //section高度
#define STOCK_ZDSECTION_TITLECOLOR RGB(51,51,51) //section文字颜色
#define STOCK_ZDSECTION_BGCOLOR RGB(244,244,244)  //section背景颜色
#define STOCK_ZDSECTION_TITLEFONTSIZE 15  //section文字字体


//-----------------行情 单元格 CELL--------------------------------
#define STOCK_CELL_HEIGHT_1 44 //一行文字
#define STOCK_CELL_HEIGHT_2 47 //两行文字
#define STOCK_SECTION_HEADER_TITLECOLOR RGB(118,118,118) //单元格表头文字颜色
#define STOCK_SECTION_HEADER_TITLEFONT 14 //单元格表头文字字体
#define STOCK_SECTION_HEADER_HEIGHT 35 //单元格表头高度

//-----------------行情 单元格 内容 -------------------------------
#define STOCK_CONTENT_NAME_FONT 15 //显示的股票字体
#define STOCK_CONTENT_NAME_MINFONT 12 //显示股票的最小字体 ...
#define STOCK_CONTENT_NAME_MINPERCENT 0.8 //通过缩放显示最小的字体

#define STOCK_CONTENT_NAME_COLOR RGB(51,51,51) //显示的股票颜色
#define STOCK_CONTENT_CODE_FONT 10 //显示的股票代码字体
#define STOCK_CONTENT_CODE_COLOR RGB(153,153,153)//RGB(182,182,182)//显示的股票代码颜色
#define STOCK_CONTENT_MIDDLE_FONT 14 //cell中间值
#define STOCK_CONTENT_MIDDLE_COLOR RGB(51,51,51) //cell中间值



#define STOCK_TABLE_TOP_LEFT_COLOR RGB(118,118,118) //表格左上角
#define STOCK_TABLE_TOP_LEFT_FONT 15
#define STOCK_TABLE_HEADER_HEIGHT 35


#define STOCK_CONTENT_REDCOLOR RGB(228, 19, 72) //内容>0红色
#define STOCK_CONTENT_GREENCOLOR RGB(15, 151, 28) //内容<0绿色
#define STOCK_CONTENT_DEFAULTCOLOR RGB(51,51,51) //内容=0颜色



//----------------行情菜单 颜色 (沪深 港股 港股通 环球)-----------------
#define STOCK_MUTIMENU_BG_COLOR RGB(244,244,244) //多菜单背景颜色
#define STOCK_MUTIMENU_BG_HEIGHT 40 //多菜单高度  35
#define STOCK_MUTIMENU_BUTTON_HEIGHT 38 //多菜单button高度
#define STOCK_MUTIMENU_LINE_HEIGHT 2 //多菜单line高度
#define STOCK_MUTIMENU_LINE_BGCOLOR RGB(228, 19, 72) //多菜单line颜色
#define STOCK_MUTIMEMU_FONT 15 //多菜单字体
#define STOCK_MUTIMENU_TEXTCOLOR RGB(118, 118, 118)//多菜单文字颜色
//-----------------------------------------------------------------



#define HBWIDTH_MIDDLE (SCREEN_WIDTH * 0.26)    //三列的界面 中间26%
#define HBWIDTH_SIDE (SCREEN_WIDTH * 0.37)      //三列的界面 两边各37%


//刷新方式  loading / 普通不可点击
#define REFRESH_WAY_LOADING YES

//点击状态栏响应的通知
static NSString * const kStatusBarTappedNotification = @"statusBarTappedNotification";
//tableView滚动动画duration
#define TABLEVIEW_SCROLLTOTOP_DURATION 0.38


#endif /* Const_h */
