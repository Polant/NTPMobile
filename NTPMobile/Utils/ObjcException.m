//
//  ObjcException.m
//  NTPiosUI
//
//  Created by GlebRadchenko on 2/9/17.
//  Copyright © 2017 Gleb Radchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjcException.h"

@implementation ObjC

+ (void)catchException:(void(^)())tryBlock; {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
    }
}

@end
