//
//  MessageBaseClass.h
//
//  Created by 峰 刘 on 2018/11/23
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBaseClass.h"

@interface MessageBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *bmiddle;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *height;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
