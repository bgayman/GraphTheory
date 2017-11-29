//
//  Dot.h
//  Graph
//
//  Created by iMac on 9/29/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dot, Graph, Line;

@interface Dot : NSManagedObject

@property (nonatomic, retain) id boundingRect;
@property (nonatomic, retain) id color;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) Graph *inGraph;
@property (nonatomic, retain) NSSet *lines;
@property (nonatomic, retain) NSSet *adjacent;
@end

@interface Dot (CoreDataGeneratedAccessors)

- (void)addLinesObject:(Line *)value;
- (void)removeLinesObject:(Line *)value;
- (void)addLines:(NSSet *)values;
- (void)removeLines:(NSSet *)values;

- (void)addAdjacentObject:(Dot *)value;
- (void)removeAdjacentObject:(Dot *)value;
- (void)addAdjacent:(NSSet *)values;
- (void)removeAdjacent:(NSSet *)values;

@end
