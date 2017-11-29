//
//  Graph.h
//  Graph
//
//  Created by iMac on 9/25/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Annotation, Dot, Line;

@interface Graph : NSManagedObject

@property (nonatomic) NSTimeInterval lastModified;
@property (nonatomic, retain) NSSet *dots;
@property (nonatomic, retain) NSSet *lines;
@property (nonatomic, retain) NSSet *texts;
@end

@interface Graph (CoreDataGeneratedAccessors)

- (void)addDotsObject:(Dot *)value;
- (void)removeDotsObject:(Dot *)value;
- (void)addDots:(NSSet *)values;
- (void)removeDots:(NSSet *)values;

- (void)addLinesObject:(Line *)value;
- (void)removeLinesObject:(Line *)value;
- (void)addLines:(NSSet *)values;
- (void)removeLines:(NSSet *)values;

- (void)addTextsObject:(Annotation *)value;
- (void)removeTextsObject:(Annotation *)value;
- (void)addTexts:(NSSet *)values;
- (void)removeTexts:(NSSet *)values;

@end
