//
//  Line+CoreDataProperties.h
//  Graph
//
//  Created by iMac on 9/27/15.
//  Copyright © 2015 iMac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Line.h"

NS_ASSUME_NONNULL_BEGIN

@interface Line (CoreDataProperties)

@property (nullable, nonatomic, retain) id color;
@property (nullable, nonatomic, retain) id controlPoint;
@property (nonatomic) BOOL curved;
@property (nonatomic) int16_t number;
@property (nullable, nonatomic, retain) id path;
@property (nullable, nonatomic, retain) id orginalViewSizeOfControlPoint;
@property (nullable, nonatomic, retain) NSSet<Dot *> *endpoints;
@property (nullable, nonatomic, retain) Graph *inGraph;

@end

@interface Line (CoreDataGeneratedAccessors)

- (void)addEndpointsObject:(Dot *)value;
- (void)removeEndpointsObject:(Dot *)value;
- (void)addEndpoints:(NSSet<Dot *> *)values;
- (void)removeEndpoints:(NSSet<Dot *> *)values;

@end

NS_ASSUME_NONNULL_END
