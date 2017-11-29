//
//  GraphIAPHelper.m
//  Graph
//
//  Created by MacBook on 2/3/15.
//  Copyright (c) 2015 iMac. All rights reserved.
//

#import "GraphIAPHelper.h"

@implementation GraphIAPHelper

+ (GraphIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static GraphIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                     @"com.bradgayman.graph.adfree",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
