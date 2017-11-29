//
//  DotStatsViewController.m
//  Graph
//
//  Created by MacBook on 10/21/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotStatsViewController.h"
#import "DotStatsView.h"
#import "Matrix.h"
#import "Dot.h"

@interface DotStatsViewController ()
@property (weak, nonatomic) IBOutlet DotStatsView *statsView;
@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@end

@implementation DotStatsViewController

#define ANIMATION_DURATION 1.50f


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[NSBundle mainBundle]localizedStringForKey:@"Graph Stats" value:@"Graph Stats" table:@"Entities"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.statsView.numLines = [self.graph.lines count];
    self.statsView.numVertices = [self.graph.dots count];
    NSArray *dots = [self.graph.dots allObjects];
    Matrix *matrix = [[Matrix alloc]initWithValue:[NSNumber numberWithInt:0] andRows:(int)[self.graph.dots count] byColumns:(int)[self.graph.dots count]];
    Matrix *colorMatrix = [[Matrix alloc]initWithValue:[NSNumber numberWithInt:0] andRows:(int)[self.graph.dots count] byColumns:(int)[self.graph.dots count]];
    for (int i=0; i<(int)[self.graph.dots count]; i++) {
        for (int j=0; j<(int)[self.graph.dots count]; j++) {
            if (i==j) {
                [matrix setElementAtRow:i andColumn:j withObject:[NSNumber numberWithInteger:[[[dots objectAtIndex:i] adjacent] count]]];
                [colorMatrix setElementAtRow:i andColumn:j withObject:[NSNumber numberWithInteger:0]];
            }else{
                if ([[[dots objectAtIndex:i] adjacent] containsObject:[dots objectAtIndex:j]]) {
                    [matrix setElementAtRow:i andColumn:j withObject:[NSNumber numberWithInt:-1]];
                    [colorMatrix setElementAtRow:i andColumn:j withObject:[NSNumber numberWithInt:1]];
                }
            }
        }
    }
    self.statsView.matrix = matrix;
    matrix = [matrix removeColumnAtIndex:0];
    matrix = [matrix removeRowAtIndex:0];
    if ([dots count]<11) {
        self.animationLayer = [CALayer layer];
        self.animationLayer.frame = CGRectMake(self.view.bounds.size.width*0.5f-15.0f, self.view.bounds.size.height*0.5-25.0f,
                                               50.0f,
                                               50.0f);
        [self.view.layer addSublayer:self.animationLayer];
        [self setupDrawingLayer];
        [self startAnimation];
        dispatch_queue_t spanQ = dispatch_queue_create("span", NULL);
        dispatch_async(spanQ, ^{
            NSNumber *numSpanning = [matrix getDeterminant];
            BOOL bijection = [self graphIsBijection:colorMatrix];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statsView.bipartite = bijection;
                if (numSpanning) {
                    self.statsView.numSpanningTrees = [numSpanning integerValue];
                }
                [self stopAnimation];
            });
            
        });
    }else{
        self.statsView.bipartite = [self graphIsBijection:colorMatrix];
    }
}

-(void)setupDrawingLayer
{
    if (self.pathLayer != nil) {
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
    }
    
    //// Color Declarations
    UIColor* fillColor = [UIColor clearColor];
    UIColor* strokeColor = [UIColor darkGrayColor];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(14.5, 3, 6, 6)];
    [fillColor setFill];
    [ovalPath fill];
    [strokeColor setStroke];
    ovalPath.lineWidth = 2.5;
    [ovalPath stroke];
    
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(29.5, 3, 6, 6)];
    [fillColor setFill];
    [oval2Path fill];
    [strokeColor setStroke];
    oval2Path.lineWidth = 2.5;
    [oval2Path stroke];
    
    
    //// Oval 3 Drawing
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(22.5, 21.5, 6, 6)];
    [fillColor setFill];
    [oval3Path fill];
    [strokeColor setStroke];
    oval3Path.lineWidth = 2.5;
    [oval3Path stroke];
    
    
    //// Oval 4 Drawing
    UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(7, 17.5, 6, 6)];
    [fillColor setFill];
    [oval4Path fill];
    [strokeColor setStroke];
    oval4Path.lineWidth = 2.5;
    [oval4Path stroke];
    
    
    //// Oval 5 Drawing
    UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(36.5, 17.5, 6, 6)];
    [fillColor setFill];
    [oval5Path fill];
    [strokeColor setStroke];
    oval5Path.lineWidth = 2.5;
    [oval5Path stroke];
    
    
    //// Oval 6 Drawing
    UIBezierPath* oval6Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1, 32.5, 6, 6)];
    [fillColor setFill];
    [oval6Path fill];
    [strokeColor setStroke];
    oval6Path.lineWidth = 2.5;
    [oval6Path stroke];
    
    
    //// Oval 7 Drawing
    UIBezierPath* oval7Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(43.5, 32.5, 6, 6)];
    [fillColor setFill];
    [oval7Path fill];
    [strokeColor setStroke];
    oval7Path.lineWidth = 2.5;
    [oval7Path stroke];
    
    
    //// Oval 8 Drawing
    UIBezierPath* oval8Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(10, 40.5, 6, 6)];
    [fillColor setFill];
    [oval8Path fill];
    [strokeColor setStroke];
    oval8Path.lineWidth = 2.5;
    [oval8Path stroke];
    
    
    //// Oval 9 Drawing
    UIBezierPath* oval9Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(22.5, 40.5, 6, 6)];
    [fillColor setFill];
    [oval9Path fill];
    [strokeColor setStroke];
    oval9Path.lineWidth = 2.5;
    [oval9Path stroke];
    
    
    //// Oval 10 Drawing
    UIBezierPath* oval10Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(33.5, 40.5, 6, 6)];
    [fillColor setFill];
    [oval10Path fill];
    [strokeColor setStroke];
    oval10Path.lineWidth = 2.5;
    [oval10Path stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(18, 6.5)];
    [bezierPath addLineToPoint: CGPointMake(33, 6.5)];
    [bezierPath addLineToPoint: CGPointMake(39.5, 20.5)];
    [bezierPath addLineToPoint: CGPointMake(46.5, 35.5)];
    [bezierPath addLineToPoint: CGPointMake(36.5, 44)];
    [bezierPath addLineToPoint: CGPointMake(25.5, 44)];
    [bezierPath addLineToPoint: CGPointMake(13, 44)];
    [bezierPath addLineToPoint: CGPointMake(4, 35.5)];
    [bezierPath addLineToPoint: CGPointMake(10, 20.5)];
    [bezierPath addLineToPoint: CGPointMake(18, 6.5)];
    [fillColor setFill];
    [bezierPath fill];
    [strokeColor setStroke];
    bezierPath.lineWidth = 1.5;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(10, 21)];
    [bezier2Path addLineToPoint: CGPointMake(25.5, 24.5)];
    [bezier2Path addLineToPoint: CGPointMake(40, 21)];
    [fillColor setFill];
    [bezier2Path fill];
    [strokeColor setStroke];
    bezier2Path.lineWidth = 1.5;
    [bezier2Path stroke];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(4, 36)];
    [bezier3Path addLineToPoint: CGPointMake(47, 35.5)];
    [fillColor setFill];
    [bezier3Path fill];
    [strokeColor setStroke];
    bezier3Path.lineWidth = 1.5;
    [bezier3Path stroke];
    
    
    //// Bezier 4 Drawing
    UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint: CGPointMake(17.5, 6)];
    [bezier4Path addLineToPoint: CGPointMake(36.5, 44)];
    [fillColor setFill];
    [bezier4Path fill];
    [strokeColor setStroke];
    bezier4Path.lineWidth = 1.5;
    [bezier4Path stroke];
    
    
    //// Bezier 5 Drawing
    UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
    [bezier5Path moveToPoint: CGPointMake(32.5, 6.5)];
    [bezier5Path addLineToPoint: CGPointMake(13, 44)];
    [fillColor setFill];
    [bezier5Path fill];
    [strokeColor setStroke];
    bezier5Path.lineWidth = 1.5;
    [bezier5Path stroke];
    
    //// Bezier 6 Drawing
    UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
    [bezier6Path moveToPoint: CGPointMake(25.5, 24.5)];
    [bezier6Path addCurveToPoint: CGPointMake(25.5, 44.5) controlPoint1: CGPointMake(25.5, 44.5) controlPoint2: CGPointMake(25.5, 44.5)];
    [fillColor setFill];
    [bezier6Path fill];
    [strokeColor setStroke];
    bezier6Path.lineWidth = 1.5;
    [bezier6Path stroke];
    
    [ovalPath appendPath:oval2Path];
    [ovalPath appendPath:oval3Path];
    [ovalPath appendPath:oval4Path];
    [ovalPath appendPath:oval5Path];
    [ovalPath appendPath:oval6Path];
    [ovalPath appendPath:oval7Path];
    [ovalPath appendPath:oval8Path];
    [ovalPath appendPath:oval9Path];
    [ovalPath appendPath:oval10Path];
    [ovalPath appendPath:bezierPath];
    [ovalPath appendPath:bezier2Path];
    [ovalPath appendPath:bezier3Path];
    [ovalPath appendPath:bezier4Path];
    [ovalPath appendPath:bezier5Path];
    [ovalPath appendPath:bezier6Path];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    //pathLayer.bounds = pathRect;
    //pathLayer.geometryFlipped = YES;
    pathLayer.path = ovalPath.CGPath;
    pathLayer.strokeColor = [[UIColor darkGrayColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 2.0f;
    pathLayer.lineCap = kCALineCapRound;
    
    [self.animationLayer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
}

-(void)startAnimation
{
    self.pathLayer.hidden = NO;
    [self drawIn];
}

-(void)stopAnimation
{
    self.pathLayer.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawIn
{
    [self.pathLayer removeAllAnimations];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = ANIMATION_DURATION;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    self.pathLayer.strokeEnd = 1.0;
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    [self performSelector:@selector(drawOut) withObject:nil afterDelay:ANIMATION_DURATION];
}

-(void)drawOut
{
    [self.pathLayer removeAllAnimations];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = ANIMATION_DURATION;
    pathAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    self.pathLayer.strokeEnd = 0.0;
    pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    [self performSelector:@selector(drawIn) withObject:nil afterDelay:ANIMATION_DURATION];
}

-(void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)graphIsBijection:(Matrix *)matrix
{
    if ([self.graph.dots count]) {
        NSMutableArray *colors = [[NSMutableArray alloc]initWithCapacity:[[self.graph.dots allObjects] count]];
        NSMutableArray *vertexQueue = [[NSMutableArray alloc]init];
        for (NSUInteger i = 0; i<[[self.graph.dots allObjects] count]; i++) {
            [colors addObject:[NSNumber numberWithInteger:-1]];
        }
        
        int vertex = 0;
        
        [vertexQueue addObject:[NSNumber numberWithInt:vertex]];
        
        [colors replaceObjectAtIndex:vertex withObject:[NSNumber numberWithInteger:1]];
        
        while ([vertexQueue count]>0) {
            vertex = [[vertexQueue firstObject]intValue];
            [vertexQueue removeObjectAtIndex:0];
            NSLog(@"%@",vertexQueue);
            for (int v=0; v<[[self.graph.dots allObjects]count]; ++v) {
                if ([[matrix getElementAtRow:vertex andColumn:v]integerValue]!=0 && [[colors objectAtIndex:v]integerValue] == -1)
                {
                    // Assign alternate color to this adjacent v of u
                    [colors replaceObjectAtIndex:v withObject:[NSNumber numberWithInteger:1-[[colors objectAtIndex:vertex]integerValue]]];
                    [vertexQueue addObject:[NSNumber numberWithInt:v]];
                    NSLog(@"%@",[colors description]);
                }else if ([[matrix getElementAtRow:vertex andColumn:v]integerValue]!=0 && [[colors objectAtIndex:v]integerValue] == [[colors objectAtIndex:vertex]integerValue])
                {
                    return FALSE;
                }
            }
        }
        
        return TRUE;
    }
    return FALSE;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
