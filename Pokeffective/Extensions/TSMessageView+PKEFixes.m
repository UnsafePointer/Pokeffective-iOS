//
//  TSMessageView+PKEFixes.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 28/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "TSMessageView+PKEFixes.h"
#import <objc/runtime.h>

@implementation TSMessageView (PKEFixes)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(handleTap:);
        SEL swizzledSelector = @selector(PKE_handleTap:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)PKE_handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self PKE_handleTap:tapGestureRecognizer];
    if (tapGestureRecognizer.state == UIGestureRecognizerStateRecognized)
    {
        [self fadeMeOut];
    }
}

@end
