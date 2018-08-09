//
//  HBModel.m
//  StockMarket
//
//  Created by hibor on 2018/5/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBModel.h"

@implementation HBModel
@end

@implementation HBListModel

//将 “腾讯济安” 换成 “上证50指数”
-(void)setName:(NSString *)name{
    if ([name isEqualToString:FINE_NAME]) {
        _name = REPLACE_NAME;
        _code = REPLACE_CODE;
    }else{
        _name = name;
    }
}

@end

@implementation HBItemModel
@end

@implementation GangModel
@end

@implementation GangTModel
@end

@implementation QiuModel
@end

@implementation HBHQModel
@end

@implementation HBGGTModel
@end

@implementation BangModel
@end

@implementation MHYModel
@end

@implementation HBGGTModel2
@end

@implementation AroundModel
@end


@implementation HBSearchModel
@end

@implementation HBSModel
@synthesize code_h;
@synthesize code_f;
@synthesize stock_name;
@synthesize stock_name_simple;
@synthesize stock_gp;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:code_h forKey:@"code_h"];
    [aCoder encodeObject:code_f forKey:@"code_f"];
    [aCoder encodeObject:stock_name forKey:@"stock_name"];
    [aCoder encodeObject:stock_name_simple forKey:@"stock_name_simple"];
    [aCoder encodeObject:stock_gp forKey:@"stock_gp"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.code_h = [aDecoder decodeObjectForKey:@"code_h"];
        self.code_f = [aDecoder decodeObjectForKey:@"code_f"];
        self.stock_name = [aDecoder decodeObjectForKey:@"stock_name"];
        self.stock_name_simple = [aDecoder decodeObjectForKey:@"stock_name_simple"];
        self.stock_gp = [aDecoder decodeObjectForKey:@"stock_gp"];
    }
    return self;
}

#pragma mark NSCoping
- (id)copyWithZone:(NSZone *)zone {
    HBSModel *copy = [[[self class] allocWithZone:zone] init];
    copy.code_h = self.code_h;
    copy.code_f = [self.code_f copyWithZone:zone];
    copy.stock_name = [self.stock_name copyWithZone:zone];
    copy.stock_name_simple = [self.stock_name_simple copyWithZone:zone];
    copy.stock_gp = [self.stock_gp copyWithZone:zone];
    return copy;
}
@end
