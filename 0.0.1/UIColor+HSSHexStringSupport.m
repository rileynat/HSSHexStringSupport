//
//  UIColor+HSSHexStringSupport.m
//  
//
//  Created by Nathan Riley on 1/17/14.
//
//

#import "UIColor+HSSHexStringSupport.h"

@implementation UIColor (HSSHexStringSupport)

- (UIColor*)initWithHexString:(NSString*)hexString {
    if([hexString length] < 6)
    return nil;
    
    NSUInteger startIndex = 0;
    
    if ([[hexString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"])
    {
        if([hexString length] < 7) {
        
            return nil;
        }
        
        startIndex = 1;
    } else if ( [[hexString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"0x"] ) {
        if( ([hexString length]) < 8) {
            
            return nil;
        }
        startIndex = 2;
    }
    
    unsigned red   = 0;
    unsigned green = 0;
    unsigned blue  = 0;
    
    NSScanner * scanner;
    
    scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(startIndex, 2)]];
    [scanner scanHexInt:&red];
    
    scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(startIndex+2, 2)]];
    [scanner scanHexInt:&green];
    
    scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(startIndex+4, 2)]];
    [scanner scanHexInt:&blue];
    
    static const CGFloat inverse = 1 / 255.0f;
    
    self = [self initWithRed:(CGFloat)red   * inverse
                                     green:(CGFloat)green * inverse
                                      blue:(CGFloat)blue  * inverse
                                     alpha:1.0f];
    return self;
    
}

+(UIColor *)colorWithHexString:(NSString *)hexString{
    
    return [[UIColor alloc] initWithHexString:hexString];
    
}

- (NSString*)hexStringWithPrefixStyle:(HSHexStringPrefix)prefix {
    
    static const CGFloat muliplier = 255.0f;
    
    NSMutableString* returnString = [NSMutableString new];
    
    if ( prefix == HSHexStringPrefixHTMLStyle ) {
        
        [returnString appendString:@"#"];
        
    } else if ( prefix == HSHexStringPrefixCStyle ) {
        
        [returnString appendString:@"0x"];
        
    }
    
    CGFloat colorComponents[4] = {0};
    [self getRGBAComponentsStoreInto:colorComponents];
    
    for ( int i = 0; i < 3; i++ ) {
        
        [returnString appendString:convertFloatToHexString(colorComponents[i] * muliplier)];
    }
    
    return returnString;
    
}


+ (NSString*)hexStringFromColor:(UIColor*)color withPrefixStyle:(HSHexStringPrefix)prefix {

    return [color hexStringWithPrefixStyle:prefix];
}


+ (UIColor*)colorWithHexRGBValue:(uint32_t)rgbValue  alphaComponent:(CGFloat)alpha {
    
    static const CGFloat inverse = 1 / 255.0f;
    
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) * inverse
                           green:((float)((rgbValue & 0xFF00) >> 8)) * inverse
                            blue:((float)(rgbValue & 0xFF))* inverse
                           alpha:alpha];
    
}

+ (UIColor*)colorWithHexRGBValue:(uint32_t)rgbValue {
    
    return [self colorWithHexRGBValue:rgbValue alphaComponent:1.0f];

}

-  (void)getRGBAComponentsStoreInto:(CGFloat*)rgbComponents {
    
    int componentCount = CGColorGetNumberOfComponents([self CGColor]);
    
    const CGFloat * components = CGColorGetComponents([self CGColor]);
    
    if ( componentCount == 2 ) {
        
        for ( int i = 0; i < 2; i++ ) {
            rgbComponents[i] = components[0];
        }
        
    } else {
        
        for ( int i = 0; i < 4; i++ ) {
            rgbComponents[i] = components[i];
        }
        
    }
}


UIColor * UIColorBlend(UIColor*color1, UIColor*color2, CGFloat ratio) {
    UIColor * newColor = nil;
    
    if(!color1)
    {
        newColor = color2;
    }
    else if(!color2)
    {
        newColor = color1;
    }
    else if(CGColorEqualToColor(color1.CGColor, color2.CGColor))
    {
        newColor = color1;
    }
    
    if(!newColor)
    {
        ratio = MIN(1.0f,ratio);
        ratio = MAX(0.0f,ratio);
        
        CGFloat color1Components[4]     = {0};
        CGFloat color2Components[4]     = {0};
        
        [color1 getRGBAComponentsStoreInto:color1Components];
        [color2 getRGBAComponentsStoreInto:color2Components];
        
        CGFloat newColorComponents[4] = {0};
        
        for(int i = 0; i < 4; i++)
        {
            newColorComponents[i] = color1Components[i] + ((color2Components[i]-color1Components[i])*ratio);
        }
        
        newColor =  [UIColor colorWithRed:newColorComponents[0]
                                    green:newColorComponents[1]
                                     blue:newColorComponents[2]
                                    alpha:newColorComponents[3]];
    }
    
    return newColor;
}


NSString* convertFloatToHexString(CGFloat floatValue) {
    
    NSString* string = [NSString stringWithFormat:@"%x", (int)floatValue];
    
    if ( string.length < 2 ) {
        return [NSString stringWithFormat:@"0%@", string];
    }
    return string;
}

@end
