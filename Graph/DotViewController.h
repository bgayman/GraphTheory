//
//  DotViewController.h
//  Graph
//
//  Created by iMac on 2/7/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"
#import <CoreData/CoreData.h>
#import "DotCardView.h"

@interface DotViewController : UIViewController
@property (nonatomic, strong) Graph *graph;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet DotCardView *dotCardView;

@end
