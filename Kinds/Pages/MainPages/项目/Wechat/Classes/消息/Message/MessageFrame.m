//
//  MessageFrame.m
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MessageFrame.h"

@implementation MessageFrame

-(void)setMessage:(MessageModel *)message{
    _message = message;
    
    //统一间距
    CGFloat margin = 5;
    
    //计算每个控件的frame和行高
    
    //计算时间label的frame
    CGFloat timeX = 0;
    CGFloat timeY = 5;
    CGFloat timeH = 20;
    if (!message.hideTime) {
        CGSize si = [self getTheSiziWithSize:CGSizeMake(200, 20) content:message.time font:12];
//        _timeFrame = CGRectMake(timeX, timeY, SCREEN_WIDTH, timeH);
        _timeFrame = CGRectMake((SCREEN_WIDTH-(si.width+10))/2, timeY, si.width+10, timeH);
    }
    
    //计算头像的frame
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + margin;
    CGFloat iconX = message.type == CZMessageTypeOther ? margin : (SCREEN_WIDTH-margin-iconW);
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    //计算消息正文的frame
    //1.正文大小
    CGSize textSize = [self getTheSiziWithSize:CGSizeMake(SCREEN_WIDTH-150, MAXFLOAT) content:message.text font:15];
    CGFloat textW = textSize.width+25;
    CGFloat textH = textSize.height+20;
    //2.计算x,y
    CGFloat textX = message.type == CZMessageTypeOther ? (margin+CGRectGetMaxX(_iconFrame)+margin) : (SCREEN_WIDTH-(margin*2)-iconW-textW);
    CGFloat textY = iconY;
    _textFrame = CGRectMake(textX, textY, textW, textH);
    
    
    //计算行高
    //    if (textH > iconH) {
    //        _rowHeight = textH+margin;
    //    }else{
    //        _rowHeight = iconH+margin;
    //    }
    
    CGFloat maxY = MAX(CGRectGetMaxY(_textFrame), CGRectGetMaxY(_iconFrame));
    _rowHeight = maxY+margin;
    
}

-(CGSize)getTheSiziWithSize:(CGSize)size content:(NSString *)content font:(int)font{
    CGSize qsize = [content boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_9_REGULAR(font)} context:nil].size;
 
    return qsize;
}

@end
