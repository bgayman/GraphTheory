//
//  DotCardView.m
//  Graph
//
//  Created by iMac on 2/7/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotCardView.h"
#import "Dot.h"
#import "Line.h"
#import "Annotation.h"
#import "Matrix.h"
#import "Line+CoreDataProperties.h"
#import "Dot+CoreDataProperties.h"
#import "Annotation+CoreDataProperties.h"

@interface DotCardView()
@property (nonatomic, strong) UITextView *activeTextView;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGPoint midpoint;
@property (nonatomic) BOOL curvingLine;
@property (nonatomic, strong) NSMutableArray *curvingLines;
@property (nonatomic, strong) NSMutableArray *endPointTouches;
@property (nonatomic, strong) NSMutableArray *endpoints;

@end

@implementation DotCardView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 0.0
#define DOT_SCALE_FACTOR .025
#define BLEND_MODE kCGBlendModeNormal
#define LINE_WIDTH 0.011 *self.bounds.size.height
#define LOOP_CONTROL_POINTS_FACTOR 150.0
#define DOT_FUDGE_FACTOR -15.0
#define CONTENT_BUFFER 3.0

int static number = 1;

-(void)setEdgeString:(NSString *)edgeString
{
    _edgeString = edgeString;
    [self setNeedsDisplay];
}

-(void)setVertexString:(NSString *)vertexString
{
    _vertexString = vertexString;
    [self setNeedsDisplay];
}

-(void)setSpanningString:(NSString *)spanningString
{
    _spanningString = spanningString;
    [self setNeedsDisplay];
}

-(void)setDots:(NSMutableArray *)dots
{
    _dots = dots;
    [self setNeedsDisplay];
}

-(void)setLines:(NSMutableArray *)lines
{
    _lines = lines;
    [self setNeedsDisplay];
}

-(void)setTexts:(NSMutableArray *)texts
{
    _texts = texts;
    //[self registerForKeyboardNotifications];
}

-(CGSize)originalSize
{
    if (!_originalSize.width) {
        _originalSize = CGSizeMake(768.0, 1024-44.0);
    }
    return _originalSize;
}

-(NSMutableArray *)endpoints
{
    if (!_endpoints) {
        _endpoints = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return _endpoints;
}

-(NSMutableArray *)endPointTouches
{
    if (!_endPointTouches) {
        _endPointTouches = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return _endPointTouches;
}

-(NSMutableArray *)curvingLines
{
    if (!_curvingLines) {
        _curvingLines = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _curvingLines;
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    for (UITextView *textView in self.subviews) {
        if ([self.currentColor isEqual:[UIColor purpleColor]]) {
            textView.editable = YES;
        }else{
            textView.editable = NO;
        }
    }
    [self setNeedsDisplay];
}

-(void)setTouchBegin:(CGPoint)touchBegin
{
    NSLog(@"TOUCH BEGIN");
    for (Dot *dot in self.dots) {
        CGRect dotRect = [(NSValue*)dot.boundingRect CGRectValue];
        CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
        dotPoint = [self pointForOriginalSize:[dot.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint];
        int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        if (CGRectContainsPoint(CGRectInset(newRect,DOT_FUDGE_FACTOR,DOT_FUDGE_FACTOR), touchBegin)) {
            _touchBegin =CGPointMake(CGRectGetMidX(newRect), CGRectGetMidY(newRect));
            return;
        }else{
            _touchBegin = CGPointZero;
        }
    }
    for (Line *line in self.lines) {
        
        if ([[self tapTargetForPath:line.path] containsPoint:touchBegin])
        {
            NSLog(@"HERE LINE");
            self.curvingLine = YES;
            [self.curvingLines addObject:line];
            _touchBegin = touchBegin;
        }
    }
}

-(void)setTempLine:(UIBezierPath *)tempLine
{
    _tempLine = tempLine;
    [self setNeedsDisplay];
}

-(void)setTouchChanged:(CGPoint)touchChanged
{
    _touchChanged = touchChanged;
    if (self.touchBegin.x && !self.curvingLine) {
        UIBezierPath *touchPath = [[UIBezierPath alloc]init];
        [touchPath moveToPoint:self.touchBegin];
        [touchPath addLineToPoint:touchChanged];
        self.tempLine = touchPath;
    }else if (self.touchBegin.x && self.curvingLine){
        NSLog(@"CHANGE LINE");
        for (Line *line in self.curvingLines) {
            NSArray *endPoints = [line.endpoints allObjects];
            if ([endPoints count] == 2) {
                NSLog(@"CHANGE LINE ENDPOINTS");
                CGRect dotRect1 = [[(Dot *)endPoints[0] boundingRect] CGRectValue];
                CGRect dotRect2 = [[(Dot *)endPoints[1] boundingRect] CGRectValue];
                
                CGPoint dotPoint1 = CGPointMake(CGRectGetMidX(dotRect1), CGRectGetMidY(dotRect1));
                CGPoint dotPoint2 = CGPointMake(CGRectGetMidX(dotRect2), CGRectGetMidY(dotRect2));
                
                dotPoint1 = [self pointForOriginalSize:[[(Dot *)endPoints[0] orginalViewSize] CGSizeValue] andOriginalPoint:dotPoint1];
                dotPoint2 = [self pointForOriginalSize:[[(Dot *)endPoints[0] orginalViewSize] CGSizeValue] andOriginalPoint:dotPoint2];
                
                int x = ((int)dotPoint1.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                int y = ((int)dotPoint1.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                CGRect newRect1 = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
                
                int x2 = ((int)dotPoint2.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                int y2 = ((int)dotPoint2.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                CGRect newRect2 = CGRectMake(x2 * self.bounds.size.height*DOT_SCALE_FACTOR, y2 * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
                NSLog(@"CHANGE RECT1: %f %f %f %f",newRect1.origin.x,newRect1.origin.y,newRect1.size.width,newRect1.size.height);
                NSLog(@"CHANGE RECT2: %f %f %f %f",newRect2.origin.x,newRect2.origin.y,newRect2.size.width,newRect2.size.height);
                
                UIBezierPath *path = [[UIBezierPath alloc] init];
                [path moveToPoint:dotPoint1];
                [path addQuadCurveToPoint:dotPoint2 controlPoint:CGPointMake(touchChanged.x+3.0, touchChanged.y+3.0)];
                line.path = path;
                line.curved = YES;
                line.orginalViewSizeOfControlPoint = [NSValue valueWithCGSize:self.bounds.size];
                line.controlPoint = [NSValue valueWithCGPoint:CGPointMake(touchChanged.x+15.0, touchChanged.y+15.0)];
                [self setNeedsDisplayInRect:CGRectInset(CGPathGetBoundingBox(path.CGPath),-80,-80)];
            }
        }

    }
}

-(void)setTouchEnd:(CGPoint)touchEnd
{
    Dot *midpoint = [NSEntityDescription insertNewObjectForEntityForName:@"Dot" inManagedObjectContext:self.managedObjectContext];
    for (Dot *dot in self.dots) {
        CGRect dotRect = [dot.boundingRect CGRectValue];
        CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
        dotPoint = [self pointForOriginalSize:[dot.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint];
        int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        if (CGRectContainsPoint(CGRectInset(newRect,DOT_FUDGE_FACTOR,DOT_FUDGE_FACTOR), touchEnd)) {
            _touchEnd = touchEnd;
            UIBezierPath *touchPath = [[UIBezierPath alloc]init];
            [touchPath moveToPoint:self.touchBegin];
            CGPoint endPoint = CGPointMake(CGRectGetMidX(newRect), CGRectGetMidY(newRect));
            if (self.touchBegin.x == endPoint.x && self.touchBegin.y == endPoint.y) {
                /*if (<#condition#>) {
                    [touchPath addLineToPoint:<#(CGPoint)#>
                }*/
            }else if(self.touchBegin.x){
                [touchPath addLineToPoint:endPoint];
                CGRect midpointRect = CGRectMake((self.touchBegin.x + endPoint.x)/2.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, (self.touchBegin.y + endPoint.y)/2.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, DOT_SCALE_FACTOR*self.bounds.size.height, DOT_SCALE_FACTOR*self.bounds.size.height);
                midpoint.boundingRect = [NSValue valueWithCGRect:midpointRect];
                Line *line = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
                line.path = touchPath;
                UIBezierPath *lineOtherPath = [[UIBezierPath alloc]init];
                [lineOtherPath moveToPoint:endPoint];
                [lineOtherPath addLineToPoint:self.touchBegin];
                Line *lineOther = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
                lineOther.path =  lineOtherPath;
                line. color =  self.currentColor;
                lineOther.color =  self.currentColor;
                NSUInteger lineIndex;
                NSUInteger lineOtherIndex;
                BOOL sameLine = NO;
                for (Line *lineTemp in self.lines) {
                    if (CGPathEqualToPath([lineTemp.path CGPath], [line.path CGPath])) {
                        sameLine = YES;
                        lineIndex = [self.lines indexOfObject:lineTemp];
                        lineTemp.color = self.currentColor;
                        //[self.lines replaceObjectAtIndex:[self.lines indexOfObject:lineTemp] withObject:line];
                    }
                    if (CGPathEqualToPath([lineTemp.path CGPath], [lineOther.path CGPath])) {
                        sameLine = YES;
                        lineOtherIndex = [self.lines indexOfObject:lineTemp];
                        lineTemp.color = self.currentColor;
                        //[self.lines replaceObjectAtIndex:[self.lines indexOfObject:lineTemp] withObject:lineOther];
                    }
                }
                if (!sameLine) {
                    [self.lines addObject:line];
                    [self.lines addObject:lineOther];
                    [dot addLinesObject:line];
                    [dot addLinesObject:lineOther];
                    for (Dot *endDot in self.dots) {
                        CGRect endRect = [endDot.boundingRect CGRectValue];
                        CGPoint endDotPoint = CGPointMake(CGRectGetMidX(endRect), CGRectGetMidY(endRect));
                        endDotPoint = [self pointForOriginalSize:[endDot.orginalViewSize CGSizeValue] andOriginalPoint:endDotPoint];
                        int x = ((int)endDotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                        int y = ((int)endDotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                        CGRect newEndRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
                        if (CGRectContainsPoint(newEndRect, self.touchBegin)) {
                            [endDot addLinesObject:lineOther];
                            [endDot addLinesObject:line];
                            [endDot addAdjacentObject:dot];
                            [dot addAdjacentObject:endDot];
                            break;
                        }
                    }
                    [self.graph addLinesObject:line];
                    [self.graph addLinesObject:lineOther];
                }else{
                    [self.lines replaceObjectAtIndex:lineIndex withObject:line];
                    [self.lines replaceObjectAtIndex:lineOtherIndex withObject:lineOther];
                }
                [self setNeedsDisplay];
            }
        }
    }
    /*if (midpoint.dotRect.size.height) {
        [self.dots addObject:midpoint];
        [self setNeedsDisplay];
    }*/
    self.tempLine = nil;
    self.touchBegin = CGPointZero;
    [self.curvingLines removeAllObjects];
    self.curvingLine = NO;
    
}

-(void)tapOnView:(CGPoint)tapPoint
{
    BOOL newDot = YES;
    /*for (UITextView *text in self.texts) {
        if ([text isFirstResponder]) {
            [text resignFirstResponder];
        }
    }*/
    for (Dot * dot in self.dots) {
        CGRect dotRect = [dot.boundingRect CGRectValue];
        //NEW CODE
        CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
        dotPoint = [self pointForOriginalSize:[dot.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint];
        int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        if (CGRectContainsPoint(CGRectInset(newRect,DOT_FUDGE_FACTOR,DOT_FUDGE_FACTOR), tapPoint) && ![self.currentColor isEqual:[UIColor purpleColor]]) {
            newDot = NO;
            dot.color = self.currentColor;
            [self setNeedsDisplayInRect:CGRectInset(newRect,-2.0,-2.0)];
            if ([self.currentColor isEqual:[UIColor clearColor]]) {

                [self clearDot:dot];
            }
            return;
        }
    }
    for (Line *line in self.lines) {
        
        if ([[self tapTargetForPath:line.path] containsPoint:tapPoint])
        {
            line.color = self.currentColor;
            [self setNeedsDisplayInRect:CGRectInset(CGPathGetBoundingBox([(UIBezierPath *)line.path CGPath]), -75.0, -75.0)];
            newDot = NO;
        }
    }
    if (newDot && !([self.currentColor isEqual:[UIColor purpleColor]] || [self.currentColor isEqual:[UIColor clearColor]])) {
        int x = ((int)tapPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)tapPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        //CGPoint dotPoint = [self originalPointForOriginalSize:self.originalSize withPoint:tapPoint];
        CGRect dotRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        Dot *dot = (Dot*)[NSEntityDescription insertNewObjectForEntityForName:@"Dot" inManagedObjectContext:self.managedObjectContext];
        number++;
        dot.boundingRect  = [NSValue valueWithCGRect:dotRect];
        dot.color = self.currentColor;
        dot.orginalViewSize = [NSValue valueWithCGSize:self.bounds.size];
        [self.dots addObject:dot];
        [self.graph addDotsObject:dot];
        [self setNeedsDisplayInRect:CGRectInset(dotRect,-2.0,-2.0)];
    }
    if (newDot && [self.currentColor isEqual:[UIColor purpleColor]]) {
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(tapPoint.x-10.0, tapPoint.y-10.0, 20.0, 20.0)];
        textView.delegate = self;
        textView.backgroundColor = [UIColor clearColor];
        textView.opaque = NO;
        textView.editable = YES;
        textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        Annotation *annotation = (Annotation*)[NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:self.managedObjectContext];
        annotation.text = textView.text;
        annotation.frame = [NSValue valueWithCGRect:CGRectMake(tapPoint.x-5.0, tapPoint.y-5.0, 20.0, 20.0)];
        annotation.originalViewSize = [NSValue valueWithCGSize:self.bounds.size];
        [self.graph addTextsObject:annotation];
        [self.texts addObject:annotation];
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, 44)];
        [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)]] animated:NO];
        textView.inputAccessoryView = toolbar;
        self.activeTextView = textView;
        [self addSubview:textView];
        [textView becomeFirstResponder];
    }
}



-(BOOL)doubleTapOnView: (CGPoint)tapPoint
{
    NSLog(@"Double Tap");
    for (Dot * dot in self.dots) {
        CGRect dotRect = [dot.boundingRect CGRectValue];
        CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
        int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        if (CGRectContainsPoint(CGRectInset(newRect,DOT_FUDGE_FACTOR, DOT_FUDGE_FACTOR),tapPoint)) {
            UIBezierPath *loop = [[UIBezierPath alloc] init];
            [loop moveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0)];
            [loop addCurveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0) controlPoint1:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0+LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0-LOOP_CONTROL_POINTS_FACTOR) controlPoint2:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0-LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0-LOOP_CONTROL_POINTS_FACTOR)];
            Line *newLine = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine.path = loop;
            newLine.color = self.currentColor;
            [self.lines addObject:newLine];
            [self.graph addLinesObject:newLine];
            Line *newLine2 = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine2.path = loop;
            newLine2.color = self.currentColor;
            [self.lines addObject:newLine2];
            [self.graph addLinesObject:newLine2];
            [dot addAdjacentObject:dot];
            [self setNeedsDisplay];
            return TRUE;
        }
    }
    return FALSE;
}

-(void)tripleTapOnView:(CGPoint)tapPoint
{
    for (Dot * dot in self.dots) {
        CGRect dotRect = [dot.boundingRect CGRectValue];
        CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
        int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        if (CGRectContainsPoint(CGRectInset(newRect,DOT_FUDGE_FACTOR, DOT_FUDGE_FACTOR),tapPoint)) {
            UIBezierPath *loop = [[UIBezierPath alloc] init];
            [loop moveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0)];
            [loop addCurveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0) controlPoint1:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0+LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0+LOOP_CONTROL_POINTS_FACTOR) controlPoint2:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0-LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0+LOOP_CONTROL_POINTS_FACTOR)];
            Line *newLine = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine.path = loop;
            newLine.color = self.currentColor;
            [self.lines addObject:newLine];
            [self.graph addLinesObject:newLine];
            Line *newLine2 = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine2.path = loop;
            newLine2.color = self.currentColor;
            [self.lines addObject:newLine2];
            [self.graph addLinesObject:newLine2];
            [dot addAdjacentObject:dot];
            [self setNeedsDisplay];
            break;
        }
    }
}

-(void)fourTapsOnView:(CGPoint)tapPoint
{
    for (Dot * dot in self.dots) {
        CGRect dotRect = [dot.boundingRect CGRectValue];
        CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
        int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        if (CGRectContainsPoint(CGRectInset(newRect,DOT_FUDGE_FACTOR, DOT_FUDGE_FACTOR),tapPoint)) {
            UIBezierPath *loop = [[UIBezierPath alloc] init];
            [loop moveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0)];
            [loop addCurveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0) controlPoint1:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0+LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0-LOOP_CONTROL_POINTS_FACTOR) controlPoint2:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0+LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0+LOOP_CONTROL_POINTS_FACTOR)];
            Line *newLine = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine.path = loop;
            newLine.color = self.currentColor;
            [self.lines addObject:newLine];
            [self.graph addLinesObject:newLine];
            Line *newLine2 = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine2.path = loop;
            newLine2.color = self.currentColor;
            [self.lines addObject:newLine2];
            [self.graph addLinesObject:newLine2];
            [dot addAdjacentObject:dot];
            [self setNeedsDisplay];
            break;
        }
    }
}

-(void)fiveTapsOnView:(CGPoint)tapPoint
{
    for (Dot * dot in self.dots) {
        CGRect dotRect = [dot.boundingRect CGRectValue];
        CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
        int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
        CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
        if (CGRectContainsPoint(CGRectInset(newRect,DOT_FUDGE_FACTOR, DOT_FUDGE_FACTOR),tapPoint)) {
            UIBezierPath *loop = [[UIBezierPath alloc] init];
            [loop moveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0)];
            [loop addCurveToPoint:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0, dotRect.origin.y+dotRect.size.height/2.0) controlPoint1:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0-LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0+LOOP_CONTROL_POINTS_FACTOR) controlPoint2:CGPointMake(dotRect.origin.x+dotRect.size.width/2.0-LOOP_CONTROL_POINTS_FACTOR, dotRect.origin.y+dotRect.size.height/2.0-LOOP_CONTROL_POINTS_FACTOR)];
            Line *newLine = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine.path = loop;
            newLine.color = self.currentColor;
            [self.lines addObject:newLine];
            [self.graph addLinesObject:newLine];
            Line *newLine2 = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:self.managedObjectContext];
            newLine2.path = loop;
            newLine2.color = self.currentColor;
            [self.lines addObject:newLine2];
            [self.graph addLinesObject:newLine2];
            [dot addAdjacentObject:dot];
            [self setNeedsDisplay];
            break;
        }
    }
}




-(CGFloat)cornerScaleFactor{return self.bounds.size.height/CORNER_FONT_STANDARD_HEIGHT;}
-(CGFloat)cornerRadius{return CORNER_RADIUS * [self cornerScaleFactor];}
-(CGFloat)cornerOffset{return [self cornerRadius]/3.0;}

-(BOOL)checkSimple
{
    for (Dot *dot in self.dots) {
        if ([dot.adjacent containsObject:dot]) {
            return false;
        }
    }
    if (![self.dots count]) {
        return false;
    }
    return true;
}

- (void)drawRect:(CGRect)rect
{
    /*UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundRect addClip];*/
    
    [[UIColor whiteColor]setFill];
    UIRectFill(self.bounds);
    
    //[[UIColor blackColor] setFill];
    //[[UIColor blackColor] setStroke];
    //[roundRect strokeWithBlendMode:BLEND_MODE alpha:1.0];
    
    
    
        
        
    UIBezierPath *roundRectStroke = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.bounds.size.height*.001, self.bounds.size.height*.001) cornerRadius:[self cornerRadius]];
    [self.currentColor setStroke];
    [roundRectStroke setLineWidth:3.0];
    [roundRectStroke strokeWithBlendMode:BLEND_MODE alpha:1.0];
    [roundRectStroke addClip];
    
    for(int i = 0; i<self.bounds.size.height/(DOT_SCALE_FACTOR*self.bounds.size.height) || i<self.bounds.size.width/(DOT_SCALE_FACTOR*self.bounds.size.height);i++){
        UIBezierPath *vertLine = [[UIBezierPath alloc] init];
        UIBezierPath *horizonLine = [[UIBezierPath alloc] init];
        
        [vertLine moveToPoint:CGPointMake(i*DOT_SCALE_FACTOR*self.bounds.size.height, 0.0)];
        [vertLine addLineToPoint:CGPointMake(i*DOT_SCALE_FACTOR*self.bounds.size.height, self.bounds.size.height)];
        
        [horizonLine moveToPoint:CGPointMake(0.0, i*DOT_SCALE_FACTOR*self.bounds.size.height)];
        [horizonLine addLineToPoint:CGPointMake(self.bounds.size.width, i*DOT_SCALE_FACTOR*self.bounds.size.height)];
        
        vertLine.lineWidth = 0.5;
        horizonLine.lineWidth = 0.5;
        
        [[UIColor lightGrayColor]setStroke];
        
        [vertLine strokeWithBlendMode:BLEND_MODE alpha:1.0];
        [horizonLine strokeWithBlendMode:BLEND_MODE alpha:1.0];
    }
    
    [[UIColor grayColor] setStroke];
    CGFloat dashPattern[] = {2,17};
    [self.tempLine setLineWidth:LINE_WIDTH];
    [self.tempLine setLineCapStyle:kCGLineCapRound];
    [self.tempLine setLineDash:dashPattern count:2 phase:0];
    
    if (self.tempLine) {
        
        [self.tempLine strokeWithBlendMode:BLEND_MODE alpha:1.0];
    }
    
    Line *clearLine = nil;
    for (Line *line in self.lines) {
        if (![line.color isEqual:[UIColor clearColor]]) {
            NSArray *endPoints = [line.endpoints allObjects];
            if ([endPoints count] == 2) {
                Dot *dot1 = (Dot *)endPoints[0];
                Dot *dot2 = (Dot *)endPoints[1];
                CGRect dotRect1 = [[dot1 boundingRect] CGRectValue];
                CGRect dotRect2 = [[dot2 boundingRect] CGRectValue];
                
                CGPoint dotPoint1 = CGPointMake(CGRectGetMidX(dotRect1), CGRectGetMidY(dotRect1));
                CGPoint dotPoint2 = CGPointMake(CGRectGetMidX(dotRect2), CGRectGetMidY(dotRect2));
                if ([dot1 orginalViewSize] && [dot2 orginalViewSize]) {
                    dotPoint1 = [self pointForOriginalSize:[dot1.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint1];
                    dotPoint2 = [self pointForOriginalSize:[dot2.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint2];
                }else{
                    dot1.orginalViewSize = [NSValue valueWithCGSize:self.bounds.size];
                    dot2.orginalViewSize = [NSValue valueWithCGSize:self.bounds.size];
                }
                
                int x = ((int)dotPoint1.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                int y = ((int)dotPoint1.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                CGRect newRect1 = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
                
                int x2 = ((int)dotPoint2.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                int y2 = ((int)dotPoint2.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                CGRect newRect2 = CGRectMake(x2 * self.bounds.size.height*DOT_SCALE_FACTOR, y2 * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
                //NSLog(@"RECT1: %f %f %f %f",newRect1.origin.x,newRect1.origin.y,newRect1.size.width,newRect1.size.height);
                //NSLog(@"RECT2: %f %f %f %f",newRect2.origin.x,newRect2.origin.y,newRect2.size.width,newRect2.size.height);

                UIBezierPath *path = [[UIBezierPath alloc] init];
                [path moveToPoint:dotPoint1];
                [path addLineToPoint:dotPoint2];
                if (line.curved) {
                    NSArray *endPoints = [line.endpoints allObjects];
                    if ([endPoints count] == 2 && line.controlPoint) {
                        Dot *dot1 = (Dot *)endPoints[0];
                        Dot *dot2 = (Dot *)endPoints[1];
                        CGRect dotRect1 = [[dot1 boundingRect] CGRectValue];
                        CGRect dotRect2 = [[dot2 boundingRect] CGRectValue];
                        
                        CGPoint dotPoint1 = CGPointMake(CGRectGetMidX(dotRect1), CGRectGetMidY(dotRect1));
                        CGPoint dotPoint2 = CGPointMake(CGRectGetMidX(dotRect2), CGRectGetMidY(dotRect2));
                        if ([dot1 orginalViewSize] && [dot2 orginalViewSize]) {
                            dotPoint1 = [self pointForOriginalSize:[dot1.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint1];
                            dotPoint2 = [self pointForOriginalSize:[dot2.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint2];
                        }else{
                            dot1.orginalViewSize = [NSValue valueWithCGSize:self.bounds.size];
                            dot2.orginalViewSize = [NSValue valueWithCGSize:self.bounds.size];
                        }
                        
                        int x = ((int)dotPoint1.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                        int y = ((int)dotPoint1.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                        CGRect newRect1 = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
                        
                        int x2 = ((int)dotPoint2.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                        int y2 = ((int)dotPoint2.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
                        CGRect newRect2 = CGRectMake(x2 * self.bounds.size.height*DOT_SCALE_FACTOR, y2 * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
                        //NSLog(@"RECT1: %f %f %f %f",newRect1.origin.x,newRect1.origin.y,newRect1.size.width,newRect1.size.height);
                        //NSLog(@"RECT2: %f %f %f %f",newRect2.origin.x,newRect2.origin.y,newRect2.size.width,newRect2.size.height);
                        
                        UIBezierPath *path = [[UIBezierPath alloc] init];
                        [path moveToPoint:CGPointMake(CGRectGetMidX(newRect1), CGRectGetMidY(newRect1))];
                        CGPoint controlPoint;
                        if (line.orginalViewSizeOfControlPoint) {
                            controlPoint = [self pointForOriginalSize:[line.orginalViewSizeOfControlPoint CGSizeValue] andOriginalPoint:[line.controlPoint CGPointValue]];
                        }else{
                            line.orginalViewSizeOfControlPoint = [NSValue valueWithCGSize:self.bounds.size];
                            controlPoint = [line.controlPoint CGPointValue];
                        }
                        
                        [path addQuadCurveToPoint:CGPointMake(CGRectGetMidX(newRect2), CGRectGetMidY(newRect2)) controlPoint:controlPoint];
                        [path setLineWidth:LINE_WIDTH];
                        [line.color setStroke];
                        [path setLineCapStyle:kCGLineCapRound];
                        [path strokeWithBlendMode:BLEND_MODE alpha:1.0];
                    }
                    
                }else{
                    if ([self.curvingLines containsObject:line]) {
                        [line.path setLineWidth:LINE_WIDTH];
                        [line.color setStroke];
                        [line.path setLineCapStyle:kCGLineCapRound];
                        [line.path strokeWithBlendMode:BLEND_MODE alpha:1.0];
                        line.orginalViewSizeOfControlPoint = [NSValue valueWithCGSize:self.bounds.size];
                        
                    }else{
                        UIBezierPath *path2 = [[UIBezierPath alloc] init];
                        [path2 moveToPoint:CGPointMake(CGRectGetMidX(newRect1), CGRectGetMidY(newRect1))];
                        [path2 addLineToPoint:CGPointMake(CGRectGetMidX(newRect2), CGRectGetMidY(newRect2))];
                        [path2 setLineWidth:LINE_WIDTH];
                        [line.color setStroke];
                        [path2 setLineCapStyle:kCGLineCapRound];
                        [path2 strokeWithBlendMode:BLEND_MODE alpha:1.0];
                        line.curved = NO;
                        line.controlPoint = nil;
                        line.path = path2;
                    }
                }
            }else{
                [line.path setLineWidth:LINE_WIDTH];
                [line.color setStroke];
                [line.path setLineCapStyle:kCGLineCapRound];
                [line.path strokeWithBlendMode:BLEND_MODE alpha:1.0];
            }
            
            
        }else{
            clearLine = line;
        }
        
    }
    
    if (clearLine) {
        NSArray *endDots = [clearLine.endpoints allObjects];
        if ([endDots count]==2) {
            [endDots[0] removeAdjacentObject:endDots[1]];
            [endDots[1] removeAdjacentObject:endDots[0]];
            [endDots[0] removeLinesObject:clearLine];
            [endDots[1] removeLinesObject:clearLine];
        }

        [self.lines removeObject:clearLine];
        [self.graph removeLinesObject:clearLine];
    }
    
    Dot *clearDot = nil;
    for (Dot *dot in self.dots) {
        if (![dot.color isEqual:[UIColor clearColor]]) {
            CGRect dotRect = [dot.boundingRect CGRectValue];
            CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
            if (dot.orginalViewSize) {
                dotPoint = [self pointForOriginalSize:[dot.orginalViewSize CGSizeValue] andOriginalPoint:dotPoint];
            }else{
                dot.orginalViewSize = [NSValue valueWithCGSize:self.bounds.size];
            }
            int x = ((int)dotPoint.x-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
            int y = ((int)dotPoint.y-self.bounds.size.height*DOT_SCALE_FACTOR/2) / (self.bounds.size.height*DOT_SCALE_FACTOR)+0.5;
            CGRect newRect = CGRectMake(x * self.bounds.size.height*DOT_SCALE_FACTOR, y * self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR, self.bounds.size.height*DOT_SCALE_FACTOR);
            UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:newRect];
            [dot.color   setStroke];
            [dot.color setFill];
            [dotPath strokeWithBlendMode:BLEND_MODE alpha:1.0];
            [dotPath fillWithBlendMode:BLEND_MODE alpha:1.0];
        }else{
            clearDot = dot;
        }
        
    }
    [self clearDot:clearDot];
    if ([self.subviews count]>[self.texts count]) {
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        [self setNeedsDisplay];
        
    }
    for (Annotation *annotation in self.texts) {
        BOOL alreadyExists = NO;
        for (UITextView *textV in self.subviews) {
            NSLog(@"LOOKING AT TEXT HERE");
            CGRect annotationFrame = [annotation.frame CGRectValue];
            CGPoint newOrigin;
            if (annotation.originalViewSize) {
                newOrigin = [self pointForOriginalSize:[annotation.originalViewSize CGSizeValue] andOriginalPoint:annotationFrame.origin];
            }else{
                annotation.originalViewSize = [NSValue valueWithCGSize:self.bounds.size];
            }
            annotationFrame = CGRectMake(newOrigin.x, newOrigin.y, annotationFrame.size.width, annotationFrame.size.height);
    
            CGPoint tevtViewOriginalPoint = [self originalPointForOriginalSize:[annotation.originalViewSize CGSizeValue] withPoint:textV.frame.origin];
            if (CGRectContainsRect(CGRectInset([annotation.frame CGRectValue], -5.0, -5.0), CGRectMake(tevtViewOriginalPoint.x, tevtViewOriginalPoint.y, textV.frame.size.width, textV.frame.size.height))&& !self.changingSize) {
                NSLog(@"IN HERE");
                NSLog(@"%@",textV.text);
                alreadyExists = YES;
                textV.text = annotation.text;
                textV.contentOffset = CGPointMake(0, 0);
                textV.frame = annotationFrame;
            }else if (self.changingSize && [textV.text isEqualToString:annotation.text]){
                NSLog(@"%@",textV.text);
                NSLog(@"IN HERE2");
                NSLog(@"%@",textV.text);
                textV.frame = annotationFrame;
            }
        }
        if (!alreadyExists && !self.changingSize) {
            NSLog(@"NOT ALREADY EXISTS HERE");
            CGRect annotationFrame = [annotation.frame CGRectValue];
            CGPoint newOrigin;
            if (annotation.originalViewSize) {
                newOrigin = [self pointForOriginalSize:[annotation.originalViewSize CGSizeValue] andOriginalPoint:annotationFrame.origin];
            }else{
                annotation.originalViewSize = [NSValue valueWithCGSize:self.bounds.size];
            }
            annotationFrame = CGRectMake(newOrigin.x, newOrigin.y, annotationFrame.size.width, annotationFrame.size.height);
            UITextView *textView = [[UITextView alloc] initWithFrame:annotationFrame];
            textView.delegate = self;
            textView.backgroundColor = [UIColor clearColor];
            textView.opaque = NO;
            textView.editable = YES;
            textView.text = annotation.text;
            NSLog(@"%@",annotation.text);
            UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, 44)];
            [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)]] animated:NO];
            textView.inputAccessoryView = toolbar;
            [self addSubview:textView];

        }
    }
    

}

-(void)clearDot:(Dot*)clearDot
{
    if (clearDot) {
        for (Line *line in [clearDot.lines allObjects]) {
            line.color = [UIColor clearColor];
            [self.lines removeObject:line];
            [self.graph removeLinesObject:line];
        }
        for (Dot *dot in [clearDot.adjacent allObjects]) {
            [dot removeAdjacentObject:clearDot];
        }
        [self.dots removeObject:clearDot];
        [self.graph removeDotsObject:clearDot];
        [self setNeedsDisplay];
    }
}

-(void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.layer.masksToBounds = NO;
    self.currentColor = [UIColor blackColor];
    
    //self.layer.shadowOffset = CGSizeMake(2.0, 5.0);
    //self.layer.shadowRadius = 5;
    //self.layer.shadowOpacity = 0.5;
    //self.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]].CGPath;
    /*Dot *dotOne = [[Dot alloc]initWithCGRect:CGRectMake(self.bounds.size.width/3.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, self.bounds.size.height/4.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, DOT_SCALE_FACTOR*self.bounds.size.height, DOT_SCALE_FACTOR*self.bounds.size.height)];
    Dot *dotTwo = [[Dot alloc]initWithCGRect:CGRectMake(self.bounds.size.width/3.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, self.bounds.size.height*3.0/4.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, DOT_SCALE_FACTOR*self.bounds.size.height, DOT_SCALE_FACTOR*self.bounds.size.height)];
    Dot *dotThree = [[Dot alloc]initWithCGRect:CGRectMake(self.bounds.size.width*2.0/3.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, self.bounds.size.height*2.0/4.0-DOT_SCALE_FACTOR*self.bounds.size.height/2.0, DOT_SCALE_FACTOR*self.bounds.size.height, DOT_SCALE_FACTOR*self.bounds.size.height)];*/
    self.dots = [[NSMutableArray alloc]init];
    
    self.lines = [[NSMutableArray alloc]init];
    self.texts = [[NSMutableArray alloc]init];
    /*for (Annotation *annotation in self.texts) {
        UITextView *textView = [[UITextView alloc] initWithFrame:[annotation.frame CGRectValue]];
        textView.delegate = self;
        textView.backgroundColor = [UIColor clearColor];
        textView.opaque = NO;
        textView.editable = YES;
        textView.text = annotation.text;
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, 44)];
        [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)]] animated:NO];
        textView.inputAccessoryView = toolbar;
        
        [self addSubview:textView];
    }*/
    NSLog(@"CardView");
    /*if (!self.managedObjectContext) {
        [self useGraphDocument];
    }
    NSLog(@"%@",self.managedObjectContext);*/
}

- (UIBezierPath *)tapTargetForPath:(UIBezierPath *)path
{
    if (path == nil) {
        return nil;
    }
    path.lineWidth = LINE_WIDTH;
    CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL, fmaxf(55.0f, path.lineWidth), path.lineCapStyle, path.lineJoinStyle, path.miterLimit);
    if (tapTargetPath == NULL) {
        return nil;
    }
    
    UIBezierPath *tapTarget = [UIBezierPath bezierPathWithCGPath:tapTargetPath];
    CGPathRelease(tapTargetPath);
    return tapTarget;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView) {
        self.activeTextView = textView;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.activeTextView = nil;
    
    for (Annotation *annotation in self.texts) {
        if (CGRectIntersectsRect(textView.frame, [annotation.frame CGRectValue])) {
            NSLog(@"HERE2!");
            if (![textView.text length]) {
                [self.managedObjectContext deleteObject:annotation];
                [textView removeFromSuperview];
            }
            else{
                NSLog(@"Done editing with text");
                annotation.frame = [NSValue valueWithCGRect:textView.frame];
                annotation.text = textView.text;
            }
            break;
        }
    }
    
}



- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"%@",aNotification);
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    self.originalFrame = self.frame;
    CGRect aRect = self.superview.frame;
    aRect.size.height -= kbSize.height;
    NSLog(@"%@",self.activeTextView);
    if (!CGRectContainsPoint(aRect, self.activeTextView.frame.origin) ) {
        [UIView animateWithDuration:.25
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-kbSize.height+44.0-15.0, self.frame.size.width, self.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = self.originalFrame;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize textViewSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    //[UIView animateWithDuration:0.1 animations: ^{
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textViewSize.width + 10.0, textViewSize.height+2.0);
    [textView sizeToFit];
    for (Annotation *annotation in self.texts) {
        if (CGRectContainsRect(textView.frame, [annotation.frame CGRectValue])||CGRectContainsRect([annotation.frame CGRectValue],textView.frame)) {
            annotation.frame = [NSValue valueWithCGRect:textView.frame];
            annotation.text = textView.text;
            annotation.originalViewSize = [NSValue valueWithCGSize:self.bounds.size];
        }
    }
    //[textView layoutIfNeeded];
    //}];
}

-(void)doneEditing
{
    NSLog(@"HERE!");
    for (UITextView *textView in self.subviews) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
            /*for (Annotation *annotation in self.texts) {
                if (CGRectIntersectsRect(textView.frame, [annotation.frame CGRectValue])) {
                    NSLog(@"HERE2!");
                    if (![textView.text length]) {
                        [self.managedObjectContext deleteObject:annotation];
                        [textView removeFromSuperview];
                    }
                    else{
                        NSLog(@"Done editing with text");
                        annotation.frame = [NSValue valueWithCGRect:textView.frame];
                        annotation.text = textView.text;
                    }
                    break;
                }
            }*/
        }
    }
}

-(void)useGraphDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Graph Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  NSLog(@"New Doc");
                  self.managedObjectContext = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Open Doc");
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        NSLog(@"Use Doc");
        self.managedObjectContext = document.managedObjectContext;
    }
}

-(CGPoint) pointForOriginalSize:(CGSize)originalSize andOriginalPoint:(CGPoint)originalPoint
{
    return CGPointMake(self.bounds.size.width*originalPoint.x/originalSize.width, self.bounds.size.height*originalPoint.y/originalSize.height);
}

-(CGPoint) originalPointForOriginalSize:(CGSize)originalSize withPoint:(CGPoint)point
{
    return CGPointMake(point.x*originalSize.width/self.bounds.size.width, point.y*originalSize.height/self.bounds.size.height);
}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
