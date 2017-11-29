//
//  Graph+CoreDataProperties.h
//  Graph
//
//  Created by iMac on 9/27/15.
//  Copyright © 2015 iMac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Graph.h"

NS_ASSUME_NONNULL_BEGIN

@interface Graph (CoreDataProperties)

@property (nonatomic) NSTimeInterval lastModified;
@property (nullable, nonatomic, retain) id originalViewSize;
@property (nullable, nonatomic, retain) NSSet<Dot *> *dots;
@property (nullable, nonatomic, retain) NSSet<Line *> *lines;
@property (nullable, nonatomic, retain) NSSet<Annotation *> *texts;

@end

@interface Graph (CoreDataGeneratedAccessors)

- (void)addDotsObject:(Dot *)value;
- (void)removeDotsObject:(Dot *)value;
- (void)addDots:(NSSet<Dot *> *)values;
- (void)removeDots:(NSSet<Dot *> *)values;

- (void)addLinesObject:(Line *)value;
- (void)removeLinesObject:(Line *)value;
- (void)addLines:(NSSet<Line *> *)values;
- (void)removeLines:(NSSet<Line *> *)values;

- (void)addTextsObject:(Annotation *)value;
- (void)removeTextsObject:(Annotation *)value;
- (void)addTexts:(NSSet<Annotation *> *)values;
- (void)removeTexts:(NSSet<Annotation *> *)values;

@end

NS_ASSUME_NONNULL_END
