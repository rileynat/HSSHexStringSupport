//
//  UIColor+HSSHexStringSupport.h
//  
//
//  Created by Nathan Riley on 1/17/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSHexStringPrefix) {
    HSHexStringPrefixNone  = 0,
    HSHexStringPrefixHTMLStyle     = 1,
    HSHexStringPrefixCStyle  = 2,
};

@interface UIColor (HSSHexStringSupport)


- (UIColor*)initWithHexString:(NSString*)hexString;

+ (UIColor*)colorWithHexString:(NSString*)hexString;

- (NSString*)hexStringWithPrefixStyle:(HSHexStringPrefix)prefix;

+ (NSString*)hexStringFromColor:(UIColor*)color withPrefixStyle:(HSHexStringPrefix)prefix;

+ (UIColor*)colorWithHexRGBValue:(uint32_t)rgbValue alphaComponent:(CGFloat)alpha;

+ (UIColor*)colorWithHexRGBValue:(uint32_t)rgbValue;

- (void)getRGBAComponentsStoreInto:(CGFloat*)rgbComponents;

UIColor * UIColorBlend(UIColor*color1,UIColor*color2,CGFloat ratio);

@end


