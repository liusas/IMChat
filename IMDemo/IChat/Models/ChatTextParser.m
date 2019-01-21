//
//  ChatTextParser.m
//  IMDemo
//
//  Created by 刘峰 on 2018/12/7.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ChatTextParser.h"

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@implementation ChatTextParser {
    
    NSDictionary *_mapper;
    dispatch_semaphore_t _lock;
    
    /** 匹配文本中的表情 */
    NSRegularExpression *_regex;
    
    /** 匹配文本中链接 */
    NSRegularExpression *_regexLink;
}

- (instancetype)init {
    self = [super init];
    
    _lock = dispatch_semaphore_create(1);
    _alignFont = [UIFont systemFontOfSize:14.f];
    _emotionSize = CGSizeMake(24, 24);
    _alignment = YYTextVerticalAlignmentCenter;
    
#define regexp(reg, option) [NSRegularExpression regularExpressionWithPattern : @reg options : option error : NULL]
    _regexLink = regexp("([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])", 0);
#undef regexp
    return self;
}

- (void)setEmoticonArray:(NSArray *)emoticonArray {
    LOCK(
         _emoticonArray = [emoticonArray copy];
         _mapper = [self getAllMapper];
         if (!_emoticonArray.count) {
             _regex = nil;
         } else {
             NSMutableString *pattern = @"(".mutableCopy;
             NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"$^?+*.,#|{}[]()\\"];
             for (NSUInteger i = 0, max = emoticonArray.count; i < max; i++) {
                 NSDictionary *pngDic = emoticonArray[i];
                 NSMutableString *one = [pngDic.allKeys[0] mutableCopy];
                 // escape regex characters
                 for (NSUInteger ci = 0, cmax = one.length; ci < cmax; ci++) {
                     unichar c = [one characterAtIndex:ci];
                     if ([charset characterIsMember:c]) {
                         [one insertString:@"\\" atIndex:ci];
                         ci++;
                         cmax++;
                     }
                 }
                 
                 [pattern appendString:one];
                 if (i != max - 1) [pattern appendString:@"|"];
             }
             [pattern appendString:@")"];
             _regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
         }
    );
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    NSDictionary *mapper;
    NSRegularExpression *regex;
    
    LOCK(mapper = _mapper; regex = _regex);
    
    if (mapper.count == 0 || regex == nil) return NO;
    
    //匹配结果数组
    NSArray *matches = [regex matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.length)];
    if (matches.count == 0) return NO;
    
    NSRange selectedRange = range ? *range : NSMakeRange(0, 0);
    NSUInteger cutLength = 0;
    for (NSUInteger i = 0, max = matches.count; i < max; i++) {
        NSTextCheckingResult *one = matches[i];
        NSRange oneRange = one.range;
        if (oneRange.length == 0) continue;
        oneRange.location -= cutLength;
        NSString *subStr = [text.string substringWithRange:oneRange];
        UIImage *emoticon = mapper[subStr];
        if (!emoticon) continue;
        /** 使用了自定义的添加表情的解析 */
        NSMutableAttributedString *atr = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:emoticon attachmentSize:self.emotionSize alignToFont:self.alignFont alignment:self.alignment];
        [atr yy_setTextBackedString:[YYTextBackedString stringWithString:subStr] range:NSMakeRange(0, atr.length)];
        [text replaceCharactersInRange:oneRange withString:atr.string];
        [text yy_removeDiscontinuousAttributesInRange:NSMakeRange(oneRange.location, atr.length)];
        [text addAttributes:atr.yy_attributes range:NSMakeRange(oneRange.location, atr.length)];
        selectedRange = [self _replaceTextInRange:oneRange withLength:atr.length selectedRange:selectedRange];
        cutLength += oneRange.length - 1;
    }
    if (range) *range = selectedRange;
    
    return YES;
}

- (NSDictionary *)getAllMapper {
    NSMutableDictionary *mappers = [NSMutableDictionary dictionary];
    for (NSDictionary *pngDic in self.emoticonArray) {
        mappers[pngDic.allKeys[0]] = [pngDic objectForKey:pngDic.allKeys[0]];
    }
    return mappers;
}

@end
