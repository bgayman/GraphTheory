//
//  DotCardView.h
//  Graph
//
//  Created by iMac on 2/7/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"
#import <CoreData/CoreData.h>

@interface DotCardView : UIView <UITextViewDelegate>
@property (strong,nonatomic)NSMutableArray *dots;
@property (strong, nonatomic)NSMutableArray *lines;
@property (strong, nonatomic)NSMutableArray *texts;
@property (strong, nonatomic)Graph *graph;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)UIBezierPath *tempLine;
@property (nonatomic) CGPoint touchBegin;
@property (nonatomic) CGPoint touchChanged;
@property (nonatomic) CGPoint touchEnd;
@property (nonatomic) BOOL showBack;
@property (nonatomic) BOOL changingSize;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic, strong) NSString *edgeString;
@property (nonatomic, strong) NSString *vertexString;
@property (nonatomic, strong) NSString *spanningString;
@property (nonatomic) CGSize originalSize;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

-(void)tapOnView:(CGPoint)tapPoint;
-(BOOL)doubleTapOnView: (CGPoint)tapPoint;
-(void)tripleTapOnView: (CGPoint)tapPoint;
-(void)fourTapsOnView:(CGPoint)tapPoint;
-(void)fiveTapsOnView:(CGPoint)tapPoint;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;


@end
