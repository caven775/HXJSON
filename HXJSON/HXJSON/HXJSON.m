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

id hxUnwrap(id object)
{
    if ([object isKindOfClass:[HXJSON class]]) {
        return hxUnwrap([(HXJSON *)object object]);
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray * unwrapArray = [[NSMutableArray alloc] initWithCapacity:0];
        [(NSArray *)object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [unwrapArray addObject:hxUnwrap(obj)];
        }];
        return unwrapArray;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary * unwrapDictionary = [[NSMutableDictionary alloc] init];
        [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            unwrapDictionary[key] = hxUnwrap(obj);
        }];
        return unwrapDictionary;
    }
    return object;
}

#pragma mark  HXJSONError 

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


#pragma mark  HXJSON 

@interface HXJSON ()
{
    id _object;
}

@property (nonatomic, strong) NSArray * rawArray;
@property (nonatomic, strong) NSDictionary * rawDctionary;
@property (nonatomic, copy) NSString * rawString;
@property (nonatomic, assign) BOOL rawBool;
@property (nonatomic, strong) NSNumber * rawNumber;
@property (nonatomic, strong) NSNull * rawNull;

@end

@implementation HXJSON

@dynamic object;

+ (HXJSON *)nullJSON
{
    return [HXJSON null];
}

+ (HXJSON *)null
{
    return [[self alloc] _initWithObject:[NSNull null]];
}

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
        if (!object) { object = [NSNull null];}
        self.object = object;
    }
    return self;
}

- (void)setObject:(id)object
{
    _object = object;
    id x = hxUnwrap(_object);
    if ([x isKindOfClass:[NSNull class]] || !x) {
        _type = HXJSONNull;
        self.rawNull = (NSNull *)x;
    } else if ([x isKindOfClass:[NSNumber class]]) {
        if ([(NSNumber *)x isBool]) {
            _type = HXJSONBOOL;
            self.rawBool = [(NSNumber *)x boolValue];
        } else {
            _type = HXJSONNumber;
            self.rawNumber = (NSNumber *)x;
        }
    } else if ([x isKindOfClass:[NSString class]]) {
        _type = HXJSONString;
        self.rawString = (NSString *)x;
    } else if ([x isKindOfClass:[NSArray class]]) {
        _type = HXJSONArray;
        self.rawArray = (NSArray *)x;
    } else if ([x isKindOfClass:[NSDictionary class]]) {
        _type = HXJSONDictionary;
        self.rawDctionary = (NSDictionary *)x;
    } else {
        _type = HXJSONUnknow;
        _error = [HXJSONError UnSupportedType];
    }
}

- (id)object
{
    switch (self.type) {
        case HXJSONNumber: { return self.rawNumber; break;}
        case HXJSONBOOL: { return @(self.rawBool); break;}
        case HXJSONString: { return self.rawString; break;}
        case HXJSONArray: { return self.rawArray; break;}
        case HXJSONDictionary: { return self.rawDctionary; break;}
        case HXJSONNull: { return self.rawNull; break;}
        default: {return self.rawNull; break;}
    }
}

@end


#pragma mark  NSNumber 

@implementation NSNumber (HXNumberType)

- (BOOL)isBool
{
    NSNumber * tureNumber = @(YES);
    NSNumber * falseNumber = @(NO);
    NSString * objctype = [NSString stringWithCString:self.objCType encoding:NSUTF8StringEncoding];
    NSString * tureObjcType = [NSString stringWithCString:tureNumber.objCType encoding:NSUTF8StringEncoding];
    NSString * falseObjcType = [NSString stringWithCString:falseNumber.objCType encoding:NSUTF8StringEncoding];
    if (([self compare:tureNumber] == NSOrderedSame && objctype == tureObjcType) ||
        ([self compare:falseNumber] == NSOrderedSame && objctype == falseObjcType)) {
        return YES;
    }
    return NO;
}

@end
