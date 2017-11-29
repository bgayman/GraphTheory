//
//  DotCollectionViewCell.h
//  Graph
//
//  Created by iMac on 9/25/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DotCardView.h"

@interface DotCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet DotCardView *dotCardView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
