//
//  Line.h
//  Graph
//
//  Created by iMac on 9/29/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dot, Graph;

@interface Line : NSManagedObject

@property (nonatomic, retain) id color;
@property (nonatomic, retain) id path;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) Graph *inGraph;
@property (nonatomic, retain) NSSet *endpoints;
@end

@interface Line (CoreDataGeneratedAccessors)

- (void)addEndpointsObject:(Dot *)value;
- (void)removeEndpointsObject:(Dot *)value;
- (void)addEndpoints:(NSSet *)values;
- (void)removeEndpoints:(NSSet *)values;

@end
