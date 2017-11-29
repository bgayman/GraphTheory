//
//  Dot+CoreDataProperties.h
//  Graph
//
//  Created by iMac on 9/27/15.
//  Copyright © 2015 iMac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dot.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dot (CoreDataProperties)

@property (nullable, nonatomic, retain) id boundingRect;
@property (nullable, nonatomic, retain) id color;
@property (nonatomic) int16_t number;
@property (nullable, nonatomic, retain) id orginalViewSize;
@property (nullable, nonatomic, retain) NSSet<Dot *> *adjacent;
@property (nullable, nonatomic, retain) Graph *inGraph;
@property (nullable, nonatomic, retain) NSSet<Line *> *lines;

@end

@interface Dot (CoreDataGeneratedAccessors)

- (void)addAdjacentObject:(Dot *)value;
- (void)removeAdjacentObject:(Dot *)value;
- (void)addAdjacent:(NSSet<Dot *> *)values;
- (void)removeAdjacent:(NSSet<Dot *> *)values;

- (void)addLinesObject:(Line *)value;
- (void)removeLinesObject:(Line *)value;
- (void)addLines:(NSSet<Line *> *)values;
- (void)removeLines:(NSSet<Line *> *)values;

@end

NS_ASSUME_NONNULL_END
