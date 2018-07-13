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



@end

@interface NSNumber (HXNumberType)

@property (nonatomic, assign, readonly) BOOL isBool;

@end
