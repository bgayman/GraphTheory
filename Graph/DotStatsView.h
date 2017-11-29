//
//  DotStatsView.h
//  Graph
//
//  Created by MacBook on 10/21/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Matrix.h"

@interface DotStatsView : UIView
@property (nonatomic, strong) Matrix *matrix;
@property (nonatomic) NSUInteger numLines;
@property (nonatomic) NSUInteger numVertices;
@property (nonatomic) NSUInteger numSpanningTrees;
@property (nonatomic) BOOL bipartite;
@end
