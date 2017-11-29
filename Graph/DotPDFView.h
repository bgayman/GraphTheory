//
//  DotPDFView.h
//  Graph
//
//  Created by MacBook on 10/21/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"

@interface DotPDFView : UIView
@property (strong,nonatomic)NSMutableArray *dots;
@property (strong, nonatomic)NSMutableArray *lines;
@property (strong, nonatomic)NSMutableArray *texts;
@property (strong, nonatomic)Graph *graph;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)UIBezierPath *tempLine;
@property (nonatomic) CGPoint touchBegin;
@property (nonatomic) CGPoint touchChanged;
@property (nonatomic) CGPoint touchEnd;
@property (nonatomic) CGFloat height;
@property (nonatomic) BOOL showBack;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic, strong)NSMutableArray *endpoints;

@end
