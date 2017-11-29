//
//  Annotation.h
//  Graph
//
//  Created by iMac on 9/26/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Graph;

@interface Annotation : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) id frame;
@property (nonatomic, retain) Graph *inGraph;

@end
