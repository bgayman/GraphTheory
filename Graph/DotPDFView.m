//
//  DotPDFView.m
//  Graph
//
//  Created by MacBook on 10/21/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotPDFView.h"
#import "Line.h"
#import "Dot.h"
#import "Annotation.h"
#import "Line+CoreDataProperties.h"

@implementation DotPDFView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 5.0
#define DOT_SCALE_FACTOR .025
#define BLEND_MODE kCGBlendModeDarken
#define LINE_WIDTH 0.0095 *self.bounds.size.height
#define LOOP_CONTROL_POINTS_FACTOR 150.0
#define DOT_FUDGE_FACTOR -20.0
#define CONTENT_BUFFER 5.0


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

- (void)drawRect:(CGRect)rect {
    for (Line *line in self.lines) {
        if (![line.color isEqual:[UIColor clearColor]]) {
            NSArray *endPoints = [line.endpoints allObjects];
            if ([endPoints count] == 2) {
                CGRect dotRect1 = [[(Dot *)endPoints[0] boundingRect] CGRectValue];
                CGRect dotRect2 = [[(Dot *)endPoints[1] boundingRect] CGRectValue];
                
                CGPoint dotPoint1 = CGPointMake(CGRectGetMidX(dotRect1), CGRectGetMidY(dotRect1));
                CGPoint dotPoint2 = CGPointMake(CGRectGetMidX(dotRect2), CGRectGetMidY(dotRect2));
                
                int x = ((int)dotPoint1.x-self.height*DOT_SCALE_FACTOR/2) / (self.height*DOT_SCALE_FACTOR)+0.5;
                int y = ((int)dotPoint1.y-self.height*DOT_SCALE_FACTOR/2) / (self.height*DOT_SCALE_FACTOR)+0.5;
                CGRect newRect1 = CGRectMake(x * self.height*DOT_SCALE_FACTOR, y * self.height*DOT_SCALE_FACTOR, self.height*DOT_SCALE_FACTOR, self.height*DOT_SCALE_FACTOR);
                
                int x2 = ((int)dotPoint2.x-self.height*DOT_SCALE_FACTOR/2) / (self.height*DOT_SCALE_FACTOR)+0.5;
                int y2 = ((int)dotPoint2.y-self.height*DOT_SCALE_FACTOR/2) / (self.height*DOT_SCALE_FACTOR)+0.5;
                CGRect newRect2 = CGRectMake(x2 * self.height*DOT_SCALE_FACTOR, y2 * self.height*DOT_SCALE_FACTOR, self.height*DOT_SCALE_FACTOR, self.height*DOT_SCALE_FACTOR);
                
                UIBezierPath *path = [[UIBezierPath alloc] init];
                [path moveToPoint:dotPoint1];
                [path addLineToPoint:dotPoint2];
    
                if (!CGRectContainsRect(CGRectInset(CGPathGetBoundingBox(path.CGPath),-5.0,-5.0), CGPathGetBoundingBox([(UIBezierPath *)line.path CGPath]))) {
                    if (line.curved) {
                        NSArray *endPoints = [line.endpoints allObjects];
                        if ([endPoints count] == 2 && line.controlPoint) {
                            CGRect dotRect1 = [[(Dot *)endPoints[0] boundingRect] CGRectValue];
                            CGRect dotRect2 = [[(Dot *)endPoints[1] boundingRect] CGRectValue];
                            
                            CGPoint dotPoint1 = CGPointMake(CGRectGetMidX(dotRect1), CGRectGetMidY(dotRect1));
                            CGPoint dotPoint2 = CGPointMake(CGRectGetMidX(dotRect2), CGRectGetMidY(dotRect2));
                            
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
                            [path addQuadCurveToPoint:CGPointMake(CGRectGetMidX(newRect2), CGRectGetMidY(newRect2)) controlPoint:[line.controlPoint CGPointValue]];
                            [path setLineWidth:LINE_WIDTH];
                            [line.color setStroke];
                            [path setLineCapStyle:kCGLineCapRound];
                            [path strokeWithBlendMode:BLEND_MODE alpha:1.0];
                        }
                        
                    }else{
                        [line.path setLineWidth:LINE_WIDTH];
                        [line.color setStroke];
                        [line.path setLineCapStyle:kCGLineCapRound];
                        [line.path strokeWithBlendMode:BLEND_MODE alpha:1.0];
                    }
                    
                }else{
                    NSLog(@"HERE DRAWRect");
                    UIBezierPath *path2 = [[UIBezierPath alloc] init];
                    [path2 moveToPoint:CGPointMake(CGRectGetMidX(newRect1), CGRectGetMidY(newRect1))];
                    [path2 addLineToPoint:CGPointMake(CGRectGetMidX(newRect2), CGRectGetMidY(newRect2))];
                    [path2 setLineWidth:LINE_WIDTH];
                    [line.color setStroke];
                    [path2 setLineCapStyle:kCGLineCapRound];
                    [path2 strokeWithBlendMode:BLEND_MODE alpha:1.0];
                }
            }else{
                [line.path setLineWidth:LINE_WIDTH];
                [line.color setStroke];
                [line.path setLineCapStyle:kCGLineCapRound];
                [line.path strokeWithBlendMode:BLEND_MODE alpha:1.0];
            }
            
        }
        
    }
    
    Dot *clearDot = nil;
    for (Dot *dot in self.dots) {
        if (![dot.color isEqual:[UIColor clearColor]]) {
            CGRect dotRect = [dot.boundingRect CGRectValue];
            CGPoint dotPoint = CGPointMake(CGRectGetMidX(dotRect), CGRectGetMidY(dotRect));
            int x = ((int)dotPoint.x-self.height*DOT_SCALE_FACTOR/2) / (self.height*DOT_SCALE_FACTOR)+0.5;
            int y = ((int)dotPoint.y-self.height*DOT_SCALE_FACTOR/2) / (self.height*DOT_SCALE_FACTOR)+0.5;
            CGRect newRect = CGRectMake(x * self.height*DOT_SCALE_FACTOR, y * self.height*DOT_SCALE_FACTOR, self.height*DOT_SCALE_FACTOR, self.height*DOT_SCALE_FACTOR);
            UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:newRect];
            [dot.color   setStroke];
            [dot.color setFill];
            [dotPath strokeWithBlendMode:BLEND_MODE alpha:1.0];
            [dotPath fillWithBlendMode:BLEND_MODE alpha:1.0];
        }else{
            clearDot = dot;
        }
        
    }
    for (Annotation *annotation in self.texts) {
        BOOL alreadyExists = NO;
        for (UITextView *textV in self.subviews) {
            if (CGRectEqualToRect(textV.frame, [annotation.frame CGRectValue])) {
                alreadyExists = YES;
            }
        }
        CGRect annotationRect = [annotation.frame CGRectValue];
        CGPoint annotationPoint = annotationRect.origin;
        if (!alreadyExists) {
            UITextView *textView = [[UITextView alloc] initWithFrame:[annotation.frame CGRectValue]];
            textView.backgroundColor = [UIColor clearColor];
            textView.opaque = NO;
            textView.editable = YES;
            textView.text = annotation.text;
            UIFont *annotationFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            /// Set line break mode
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            /// Set text alignment
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attribs = @{NSFontAttributeName: annotationFont, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor darkTextColor]};
            [annotation.text drawAtPoint:annotationPoint withAttributes:attribs];
            
            //[self addSubview:textView];
        }
    }

}


@end
