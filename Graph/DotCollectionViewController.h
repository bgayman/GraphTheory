//
//  DotCollectionViewController.h
//  Graph
//
//  Created by iMac on 9/25/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <iAd/iAd.h>

@interface DotCollectionViewController : UICollectionViewController <ADBannerViewDelegate>
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
