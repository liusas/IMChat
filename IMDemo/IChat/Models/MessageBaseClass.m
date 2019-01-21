//
//  MessageBaseClass.m
//
//  Created by 峰 刘 on 2018/11/23
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "MessageBaseClass.h"


NSString *const kMessageBaseClassType = @"type";
NSString *const kMessageBaseClassText = @"text";
NSString *const kMessageBaseClassBmiddle = @"bmiddle";
NSString *const kMessageBaseClassWidth = @"width";
NSString *const kMessageBaseClassThumbnail = @"thumbnail";
NSString *const kMessageBaseClassHeight = @"height";


@interface MessageBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MessageBaseClass

@synthesize type = _type;
@synthesize text = _text;
@synthesize bmiddle = _bmiddle;
@synthesize width = _width;
@synthesize thumbnail = _thumbnail;
@synthesize height = _height;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.type = [self objectOrNilForKey:kMessageBaseClassType fromDictionary:dict];
            self.text = [self objectOrNilForKey:kMessageBaseClassText fromDictionary:dict];
            self.bmiddle = [self objectOrNilForKey:kMessageBaseClassBmiddle fromDictionary:dict];
            self.width = [self objectOrNilForKey:kMessageBaseClassWidth fromDictionary:dict];
            self.thumbnail = [self objectOrNilForKey:kMessageBaseClassThumbnail fromDictionary:dict];
            self.height = [self objectOrNilForKey:kMessageBaseClassHeight fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.type forKey:kMessageBaseClassType];
    [mutableDict setValue:self.text forKey:kMessageBaseClassText];
    [mutableDict setValue:self.bmiddle forKey:kMessageBaseClassBmiddle];
    [mutableDict setValue:self.width forKey:kMessageBaseClassWidth];
    [mutableDict setValue:self.thumbnail forKey:kMessageBaseClassThumbnail];
    [mutableDict setValue:self.height forKey:kMessageBaseClassHeight];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.type = [aDecoder decodeObjectForKey:kMessageBaseClassType];
    self.text = [aDecoder decodeObjectForKey:kMessageBaseClassText];
    self.bmiddle = [aDecoder decodeObjectForKey:kMessageBaseClassBmiddle];
    self.width = [aDecoder decodeObjectForKey:kMessageBaseClassWidth];
    self.thumbnail = [aDecoder decodeObjectForKey:kMessageBaseClassThumbnail];
    self.height = [aDecoder decodeObjectForKey:kMessageBaseClassHeight];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_type forKey:kMessageBaseClassType];
    [aCoder encodeObject:_text forKey:kMessageBaseClassText];
    [aCoder encodeObject:_bmiddle forKey:kMessageBaseClassBmiddle];
    [aCoder encodeObject:_width forKey:kMessageBaseClassWidth];
    [aCoder encodeObject:_thumbnail forKey:kMessageBaseClassThumbnail];
    [aCoder encodeObject:_height forKey:kMessageBaseClassHeight];
}

- (id)copyWithZone:(NSZone *)zone
{
    MessageBaseClass *copy = [[MessageBaseClass alloc] init];
    
    if (copy) {

        copy.type = [self.type copyWithZone:zone];
        copy.text = [self.text copyWithZone:zone];
        copy.bmiddle = [self.bmiddle copyWithZone:zone];
        copy.width = [self.width copyWithZone:zone];
        copy.thumbnail = [self.thumbnail copyWithZone:zone];
        copy.height = [self.height copyWithZone:zone];
    }
    
    return copy;
}


@end
