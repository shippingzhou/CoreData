//
//  ZZRegular.h
//  CoreData


#import <Foundation/Foundation.h>

@interface ZZRegular : NSObject
+ (BOOL)regularEmail:(NSString *)string;

+ (BOOL)regularPhone:(NSString *)string;

+ (BOOL)regularFloatNumber:(NSString *)string;
@end
