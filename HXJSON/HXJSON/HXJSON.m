//
//  HXJSON.m
//  HXJSON
//
//  Created by TAL on 2018/7/11.
//  Copyright © 2018年 TAL. All rights reserved.
//

#import "HXJSON.h"

typedef NS_ENUM(NSInteger, HXJSONErrorType) {
    HXJSONErrorUnSupportedType = 999,
    HXJSONErrorElementTooDeep = 902,
    HXJSONErrorWrongType = 901,
    HXJSONErrorNotExist = 500,
    HXJSONErrorInvalidJSON = 490
};

@implementation HXJSONError

+ (instancetype)errorWithCode:(NSInteger)code reason:(NSString *)reason
{
    return [[HXJSONError alloc] initWithErrorCode:code reason:reason];
}

- (instancetype)initWithErrorCode:(NSInteger)code reason:(NSString *)reason
{
    return [[HXJSONError alloc] initWithDomain:@"com.hx.HXJSON" code:code userInfo:@{NSLocalizedDescriptionKey: reason}];
}

+ (HXJSONError *)UnSupportedType { return [HXJSONError errorWithCode:HXJSONErrorUnSupportedType reason:@"不支持的类型"];}

+ (HXJSONError *)ElementTooDeep { return [HXJSONError errorWithCode:HXJSONErrorElementTooDeep reason:@"元素太深"];}

+ (HXJSONError *)WrongType { return [HXJSONError errorWithCode:HXJSONErrorWrongType reason:@"类型错误"];}

+ (HXJSONError *)NotExist { return [HXJSONError errorWithCode:HXJSONErrorNotExist reason:@"不存在的类型"];}

+ (HXJSONError *)InvalidJSON { return [HXJSONError errorWithCode:HXJSONErrorInvalidJSON reason:@"无效的JSON"];}

@end

@implementation HXJSON

+ (instancetype)jsonWithObject:(id)object
{
    return [[self alloc] _initWithObject:object];
}

+ (instancetype)jsonWithString:(NSString *)jsonString
{
    return [[self alloc] _initWithObject:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (instancetype)jsonWithData:(NSData *)data options:(NSJSONReadingOptions)options
{
    return [[self alloc] _initWithObject:[NSJSONSerialization JSONObjectWithData:data options:options error:nil]];
}

- (instancetype)initWithObject:(id)object
{
    return [[HXJSON alloc] _initWithObject:object];
}

- (instancetype)initWithJSON:(NSString *)jsonString
{
    return [[HXJSON alloc] _initWithObject:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (instancetype)initWithData:(NSData *)data options:(NSJSONReadingOptions)options
{
    return [[HXJSON alloc] _initWithObject:[NSJSONSerialization JSONObjectWithData:data options:options error:nil]];
}

- (instancetype)_initWithObject:(id)object
{
    self = [super init];
    if (self) {
        self.object = object;
    }
    return self;
}


@end
