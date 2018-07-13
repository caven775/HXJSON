//
//  HXJSON.h
//  HXJSON
//
//  Created by TAL on 2018/7/11.
//  Copyright © 2018年 TAL. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (nonatomic, strong) id object;
@property (nonatomic, strong, readwrite, nullable) HXJSONError * error;

+ (instancetype)jsonWithObject:(id)object;
+ (instancetype)jsonWithString:(NSString *)jsonString;
+ (instancetype)jsonWithData:(NSData *)data options:(NSJSONReadingOptions)options;

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithJSON:(NSString *)jsonString;
- (instancetype)initWithData:(NSData *)data options:(NSJSONReadingOptions)options;

@end
