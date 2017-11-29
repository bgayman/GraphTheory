//
//  DotBackgroundView.m
//  Graph
//
//  Created by MacBook on 10/24/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotBackgroundView.h"

@implementation DotBackgroundView
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 0.0
#define DOT_SCALE_FACTOR .025
#define BLEND_MODE kCGBlendModeDarken
#define LINE_WIDTH 6.0
#define LOOP_CONTROL_POINTS_FACTOR 150.0
#define DOT_FUDGE_FACTOR -20.0
#define CONTENT_BUFFER 5.0

-(CGFloat)cornerScaleFactor{return self.bounds.size.height/CORNER_FONT_STANDARD_HEIGHT;}
-(CGFloat)cornerRadius{return CORNER_RADIUS * [self cornerScaleFactor];}
-(CGFloat)cornerOffset{return [self cornerRadius]/3.0;}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundRect addClip];
    
    [[UIColor whiteColor]setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setFill];
    [[UIColor blackColor] setStroke];
    [roundRect strokeWithBlendMode:BLEND_MODE alpha:1.0];
    UIBezierPath *roundRectStroke = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.bounds.size.height*.001, self.bounds.size.height*.001) cornerRadius:[self cornerRadius]];
    [[UIColor blackColor] setStroke];
    [roundRectStroke setLineWidth:3.0];
    [roundRectStroke strokeWithBlendMode:BLEND_MODE alpha:1.0];
    [roundRectStroke addClip];
}


@end
