//
//  Annotation+CoreDataProperties.h
//  Graph
//
//  Created by iMac on 9/27/15.
//  Copyright © 2015 iMac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Annotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Annotation (CoreDataProperties)

@property (nullable, nonatomic, retain) id frame;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) id originalViewSize;
@property (nullable, nonatomic, retain) Graph *inGraph;

@end

NS_ASSUME_NONNULL_END
