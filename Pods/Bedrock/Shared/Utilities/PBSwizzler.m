//
//  TCSwizzler.m
//  Bedrock
//
//  Created by Nick Bolton on 3/9/14.
//
//

#import "PBSwizzler.h"
#import <objc/runtime.h>

void PBReplaceSelectorForTargetWithSourceImpAndSwizzle(Class c, SEL orig, SEL new) {

    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@implementation PBSwizzler

@end
