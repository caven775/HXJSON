//
//  HXJSON.h
//  HXJSON
//
//  Created by TAL on 2018/7/11.
//  Copyright © 2018年 TAL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXJSONType) {
    HXJSONNumber,
    HXJSONString,
    HXJSONBOOL,
    HXJSONArray,
    HXJSONDictionary,
    HXJSONNull,
    HXJSONUnknow
};

@interface HXJSONError: NSError

@property (nonatomic, strong, readonly, class) HXJSONError * UnSupportedType;
@property (nonatomic, strong, readonly, class) HXJSONError * ElementTooDeep;
@property (nonatomic, strong, readonly, class) HXJSONError * WrongType;
@property (nonatomic, strong, readonly, class) HXJSONError * NotExist;
@property (nonatomic, strong, readonly, class) HXJSONError * InvalidJSON;

+ (instancetype)errorWithCode:(NSInteger)code reason:(NSString *)reason;
- (instancetype)initWithErrorCode:(NSInteger)code reason:(NSString *)reason;

@end

@interface HXJSON : NSObject

#pragma mark  properties 

@property (nonatomic, strong) id object;
@property (nonatomic, assign, readonly) HXJSONType type;
@property (nonatomic, strong, readonly, nullable) HXJSONError * error;

@property (nonatomic, strong, class, readonly) HXJSON * nullJSON;
@property (nonatomic, strong, class, readonly) HXJSON * null;

#pragma mark  init 

+ (instancetype)jsonWithObject:(id)object;
+ (instancetype)jsonWithString:(NSString *)jsonString;
+ (instancetype)jsonWithData:(NSData *)data options:(NSJSONReadingOptions)options;

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithJSON:(NSString *)jsonString;
- (instancetype)initWithData:(NSData *)data options:(NSJSONReadingOptions)options;

#pragma mark  Array 

@property (nonatomic, strong, nullable) NSArray <HXJSON *>* array;
@property (nonatomic, strong, nonnull, readonly) NSArray <HXJSON *> * arrayValue;
@property (nonatomic, strong, nullable) NSArray <id>* arrayObject;

#pragma mark  Dictionary 

@property (nonatomic, strong, nullable) NSDictionary <NSString *, HXJSON *>* dictionary;
@property (nonatomic, strong, nonnull, readonly) NSDictionary <NSString *, HXJSON *>* dictionaryValue;
@property (nonatomic, strong, nullable) NSDictionary <NSString *, id>* dictionaryObject;

#pragma mark  String 

@property (nonatomic, nullable) NSString * string;
@property (nonatomic, nonnull, readonly) NSString * stringValue;

#pragma mark  Number 

//@property (readonly) char charValue;
//@property (readonly) unsigned char unsignedCharValue;
//@property (readonly) short shortValue;
//@property (readonly) unsigned short unsignedShortValue;
//@property (readonly) int intValue;
//@property (readonly) unsigned int unsignedIntValue;
//@property (readonly) long longValue;
//@property (readonly) unsigned long unsignedLongValue;
//@property (readonly) long long longLongValue;
//@property (readonly) unsigned long long unsignedLongLongValue;
//@property (readonly) float floatValue;
//@property (readonly) double doubleValue;
//@property (readonly) BOOL boolValue;

@property (nonatomic, readonly) double doubleValue;
@property (nonatomic, readonly) float floatValue;
@property (nonatomic, readonly) int intValue;


@end

@interface NSNumber (HXNumberType)

@property (nonatomic, assign, readonly) BOOL isBool;

@end
