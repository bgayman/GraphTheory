//
//  DotColorPickView.m
//  Graph
//
//  Created by iMac on 2/8/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotColorPickView.h"

@implementation DotColorPickView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 40.0
#define DOT_SCALE_FACTOR .04
#define BLEND_MODE kCGBlendModeDarken
#define LINE_WIDTH 5.0
#define BUFFER 1.5
#define CIRCLE_STROKE_WIDTH 4.0
#define STROKE_COLOR [UIColor colorWithWhite:0.75 alpha:1.0]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    if (currentColor) {
        _currentColor = currentColor;
    }else{
        _currentColor = [UIColor blackColor];
    }
    [self setNeedsDisplay];
}

-(CGFloat)cornerScaleFactor{return self.bounds.size.height/CORNER_FONT_STANDARD_HEIGHT;}
-(CGFloat)cornerRadius{return CORNER_RADIUS * [self cornerScaleFactor];}
-(CGFloat)cornerOffset{return [self cornerRadius]/3.0;}

- (void)drawRect:(CGRect)rect
{
    [self.paths removeAllObjects];
    [[UIColor blackColor]setStroke];
    [[UIColor whiteColor]setFill];
    CGFloat width = 0.0;
    CGFloat y =0.0;
    CGFloat x = 0.0;
    if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.bounds.size.width>self.bounds.size.height)
    {
        width = self.bounds.size.width/(14+BUFFER);
        if (width>self.bounds.size.height) {
            width = self.bounds.size.height;
        }
        y=1.0;
        x= (self.bounds.size.width-(14*BUFFER+14*width))*0.5;

    }else if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad && self.bounds.size.width<self.bounds.size.height){
        width = self.bounds.size.height/(14+BUFFER);
        if (width>self.bounds.size.width) {
            width = self.bounds.size.width;
        }
        x=1.0;
        y =(self.bounds.size.width-(14*BUFFER+14*width)*0.5);
    }
    else if((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) && self.bounds.size.width>self.bounds.size.height){
        width = self.bounds.size.width/(9.0+BUFFER);
        if (width>self.bounds.size.height) {
            width = self.bounds.size.height;
        }
        x = (self.bounds.size.width-(9*BUFFER+9*width))*0.5f;
        y = (self.bounds.size.height-width)*0.5;
    }else{
        width = self.bounds.size.height/(9.0+BUFFER);
        if (width>self.bounds.size.width) {
            width = self.bounds.size.width;
        }
        y = (self.bounds.size.height-(9*BUFFER+9*width))*0.5f;
        x = (self.bounds.size.width-width)*0.5;
    }
    if (self.bounds.size.width>self.bounds.size.height) {
        UIBezierPath *circle1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+BUFFER, y, width-2.0f, width-2.0f)];
        [circle1 stroke];
        [circle1 fill];
        [[UIImage imageNamed:@"erase"]drawInRect:CGRectMake(x+BUFFER, y, width-2.0f, width-2.0f)];
        if ([self.currentColor isEqual:[UIColor clearColor]]) {
            [STROKE_COLOR setStroke];
            circle1.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle1 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+2*BUFFER+width, y, width-2.0f, width-2.0f)];
        [circle2 stroke];
        [[UIColor blackColor]setFill];
        [circle2 fill];
        if ([self.currentColor isEqual:[UIColor blackColor]]) {
            [STROKE_COLOR setStroke];
            circle2.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle2 stroke];
            [[UIColor blackColor] setStroke];

        }
        
        UIBezierPath *circle3 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+3*BUFFER+2*width, y, width-2.0f, width-2.0f)];
        [circle3 stroke];
        [[UIColor redColor] setFill];
        [circle3 fill];
        if ([self.currentColor isEqual:[UIColor redColor]]) {
            [STROKE_COLOR setStroke];
            circle3.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle3 stroke];
            [[UIColor blackColor] setStroke];

        }
        
        UIBezierPath *circle4 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+4*BUFFER+3*width, y, width-2.0f, width-2.0f)];
        [[UIColor colorWithRed:24.0/255.0 green:102.0/255.0 blue:214.0/255.0 alpha:1.0] setFill];

        [circle4 stroke];
        [circle4 fill];
        if ([self.currentColor isEqual:[UIColor colorWithRed:24.0/255.0 green:102.0/255.0 blue:214.0/255.0 alpha:1.0]]) {
            [STROKE_COLOR setStroke];
            circle4.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle4 stroke];
            [[UIColor blackColor] setStroke];

        }
        
        UIBezierPath *circle5 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+5*BUFFER+4*width, y, width-2.0f, width-2.0f)];
        [[UIColor colorWithRed:224.0/255.0 green:190.0/255.0 blue:7.0/255.0 alpha:1.0] setFill];
        
        [circle5 stroke];
        [circle5 fill];
        if ([self.currentColor isEqual:[UIColor colorWithRed:224.0/255.0 green:190.0/255.0 blue:7.0/255.0 alpha:1.0]]) {
            [STROKE_COLOR setStroke];
            circle5.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle5 stroke];
            [[UIColor blackColor] setStroke];

        }
        
        
        UIBezierPath *circle6 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+6*BUFFER+5*width, y, width-2.0f, width-2.0f)];
        [[UIColor colorWithRed:8.0/255.0 green:120.0/255.0 blue:62.0/255.0 alpha:1.0] setFill];

        [circle6 stroke];
        [circle6 fill];
        if ([self.currentColor isEqual:[UIColor colorWithRed:8.0/255.0 green:120.0/255.0 blue:62.0/255.0 alpha:1.0]]) {
            [STROKE_COLOR setStroke];
            circle6.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle6 stroke];
            [[UIColor blackColor] setStroke];

        }
        
        UIBezierPath *circle7 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+7*BUFFER+6*width, y, width-2.0f, width-2.0f)];
        [[UIColor orangeColor] setFill];
        [circle7 stroke];
        [circle7 fill];
        if ([self.currentColor isEqual:[UIColor orangeColor] ]) {
            [STROKE_COLOR setStroke];
            circle7.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle7 stroke];
            [[UIColor blackColor] setStroke];

        }
        
        UIBezierPath *circle8 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+8*BUFFER+7*width, y, width-2.0f, width-2.0f)];
        [[UIColor magentaColor] setFill];
        [circle8 stroke];
        [circle8 fill];
        if ([self.currentColor isEqual:[UIColor magentaColor] ]) {
            [STROKE_COLOR setStroke];
            circle8.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle8 stroke];
            [[UIColor blackColor] setStroke];

        }

        
        UIBezierPath* circle9 = nil;
        UIBezierPath* circle10 = [[UIBezierPath alloc]init];
        UIBezierPath* circle11 = [[UIBezierPath alloc]init];
        UIBezierPath* circle12 = [[UIBezierPath alloc]init];
        UIBezierPath* circle13 = [[UIBezierPath alloc]init];
        UIBezierPath* circle14 = [[UIBezierPath alloc]init];


        if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
        {
            circle10 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+9*BUFFER+8*width, y, width-2.0f, width-2.0f)];
            [[UIColor cyanColor] setFill];
            [circle10 stroke];
            [circle10 fill];
            if ([self.currentColor isEqual:[UIColor cyanColor] ]) {
                [STROKE_COLOR setStroke];
                circle10.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle10 stroke];
                [[UIColor blackColor] setStroke];

            }
            
            circle11 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+10*BUFFER+9*width, y, width-2.0f, width-2.0f)];
            [[UIColor yellowColor] setFill];
            [circle11 stroke];
            [circle11 fill];
            if ([self.currentColor isEqual:[UIColor yellowColor] ]) {
                [STROKE_COLOR setStroke];
                circle11.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle11 stroke];
                [[UIColor blackColor] setStroke];

            }
            
            circle12 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+11*BUFFER+10*width, y, width-2.0f, width-2.0f)];
            [[UIColor greenColor] setFill];
            [circle12 stroke];
            [circle12 fill];
            if ([self.currentColor isEqual:[UIColor greenColor] ]) {
                
                [STROKE_COLOR setStroke];
                circle12.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle12 stroke];
                [[UIColor blackColor] setStroke];

            }
            
            circle13 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+12*BUFFER+11*width, y, width-2.0f, width-2.0f)];
            [[UIColor colorWithRed:154/255.0 green:18.0/255.0 blue:179.0/255.0 alpha:1.0] setFill];
            [circle13 stroke];
            [circle13 fill];
            if ([self.currentColor isEqual:[UIColor colorWithRed:154/255.0 green:18.0/255.0 blue:179.0/255.0 alpha:1.0] ]) {
                [STROKE_COLOR setStroke];
                circle13.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle13 stroke];
                [[UIColor blackColor] setStroke];

            }
            
            
            circle14 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+13*BUFFER+12*width, y, width-2.0f, width-2.0f)];
            [[UIColor colorWithRed:51.0/255.0 green:110.0/255.0 blue:123.0/255.0 alpha:1.0] setFill];
            [circle14 stroke];
            [circle14 fill];
            if ([self.currentColor isEqual:[UIColor colorWithRed:51.0/255.0 green:110.0/255.0 blue:123.0/255.0 alpha:1.0] ]) {
                [STROKE_COLOR setStroke];
                circle14.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle14 stroke];
                [[UIColor blackColor] setStroke];

            }
            
            circle9 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+14*BUFFER+13*width, y, width-2.0f, width-2.0f)];
            //[circle1 stroke];
            [[UIColor whiteColor] setFill];
            [circle9 fill];
            [circle9 stroke];
            [circle9 addClip];
            [[UIImage imageNamed:@"text"]drawInRect:CGRectMake(x+14*BUFFER+13*width, y, width-2.0f, width-2.0f)];
            if ([self.currentColor isEqual:[UIColor purpleColor] ]) {
                [STROKE_COLOR setStroke];
                circle9.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle9 stroke];
                [[UIColor blackColor] setStroke];

            }
            
        }else{
            circle9 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+9*BUFFER+8*width, y, width-2.0f, width-2.0f)];
            //[circle1 stroke];
            [[UIColor whiteColor] setFill];
            [circle9 fill];
            [circle9 stroke];
            [circle9 addClip];
            [[UIImage imageNamed:@"text"]drawInRect:CGRectMake(x+9*BUFFER+8*width, y, width-2.0f, width-2.0f)];
            if ([self.currentColor isEqual:[UIColor purpleColor] ]) {
                [STROKE_COLOR setStroke];
                circle9.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle9 stroke];
                [[UIColor blackColor] setStroke];

            }
        }
        
        
        [self.paths addObject:circle2];
        [self.paths addObject:circle5];
        [self.paths addObject:circle3];
        [self.paths addObject:circle7];
        [self.paths addObject:circle4];
        [self.paths addObject:circle6];
        [self.paths addObject:circle8];
        [self.paths addObject:circle1];
        [self.paths addObject:circle9];
        [self.paths addObject:circle10];
        [self.paths addObject:circle11];
        [self.paths addObject:circle12];
        [self.paths addObject:circle13];
        [self.paths addObject:circle14];
    }else{
        NSLog(@"TALL");
        UIBezierPath *circle1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+BUFFER, width-2.0f, width-2.0f)];
        [circle1 stroke];
        [circle1 fill];
        [[UIImage imageNamed:@"erase"]drawInRect:CGRectMake(x+BUFFER, y, width-2.0f, width-2.0f)];
        if ([self.currentColor isEqual:[UIColor clearColor]]) {
            [STROKE_COLOR setStroke];
            circle1.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle1 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+2*BUFFER+width, width-2.0f, width-2.0f)];
        [circle2 stroke];
        [[UIColor blackColor]setFill];
        [circle2 fill];
        if ([self.currentColor isEqual:[UIColor blackColor]]) {
            [STROKE_COLOR setStroke];
            circle2.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle2 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle3 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+3*BUFFER+2*width, width-2.0f, width-2.0f)];
        [circle3 stroke];
        [[UIColor redColor] setFill];
        
        [circle3 fill];
        if ([self.currentColor isEqual:[UIColor redColor]]) {
            [STROKE_COLOR setStroke];
            circle3.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle3 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle4 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+4*BUFFER+3*width, width-2.0f, width-2.0f)];
        [[UIColor colorWithRed:24.0/255.0 green:102.0/255.0 blue:214.0/255.0 alpha:1.0] setFill];
        
        [circle4 stroke];
        [circle4 fill];
        if ([self.currentColor isEqual:[UIColor colorWithRed:24.0/255.0 green:102.0/255.0 blue:214.0/255.0 alpha:1.0]]) {
            [STROKE_COLOR setStroke];
            circle4.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle4 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle5 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+5*BUFFER+4*width, width-2.0f, width-2.0f)];
        [[UIColor colorWithRed:224.0/255.0 green:190.0/255.0 blue:7.0/255.0 alpha:1.0] setFill];
        
        [circle5 stroke];
        [circle5 fill];
        if ([self.currentColor isEqual:[UIColor colorWithRed:224.0/255.0 green:190.0/255.0 blue:7.0/255.0 alpha:1.0]]) {
            [STROKE_COLOR setStroke];
            circle5.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle5 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle6 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+6*BUFFER+5*width, width-2.0f, width-2.0f)];
        [[UIColor colorWithRed:8.0/255.0 green:120.0/255.0 blue:62.0/255.0 alpha:1.0] setFill];
        
        [circle6 stroke];
        [circle6 fill];
        if ([self.currentColor isEqual:[UIColor colorWithRed:8.0/255.0 green:120.0/255.0 blue:62.0/255.0 alpha:1.0]]) {
            [STROKE_COLOR setStroke];
            circle6.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle6 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle7 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+7*BUFFER+6*width, width-2.0f, width-2.0f)];
        [[UIColor orangeColor] setFill];
        [circle7 stroke];
        [circle7 fill];
        if ([self.currentColor isEqual:[UIColor orangeColor]]) {
            [STROKE_COLOR setStroke];
            circle7.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle7 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath *circle8 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+8*BUFFER+7*width, width-2.0f, width-2.0f)];
        [[UIColor magentaColor] setFill];
        [circle8 stroke];
        [circle8 fill];
        if ([self.currentColor isEqual:[UIColor magentaColor]]) {
            [STROKE_COLOR setStroke];
            circle8.lineWidth = CIRCLE_STROKE_WIDTH;
            [circle8 stroke];
            [[UIColor blackColor] setStroke];
        }
        
        UIBezierPath* circle9 = nil;
        UIBezierPath* circle10 = [[UIBezierPath alloc]init];
        UIBezierPath* circle11 = [[UIBezierPath alloc]init];
        UIBezierPath* circle12 = [[UIBezierPath alloc]init];
        UIBezierPath* circle13 = [[UIBezierPath alloc]init];
        UIBezierPath* circle14 = [[UIBezierPath alloc]init];
        
        
        if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            circle10 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+9*BUFFER+8*width, width-2.0f, width-2.0f)];
            [[UIColor cyanColor] setFill];
            [circle10 stroke];
            [circle10 fill];
            if ([self.currentColor isEqual:[UIColor cyanColor]]) {
                [STROKE_COLOR setStroke];
                circle10.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle10 stroke];
                [[UIColor blackColor] setStroke];
            }
            
            circle11 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+10*BUFFER+9*width, width-2.0f, width-2.0f)];
            [[UIColor yellowColor] setFill];
            [circle11 stroke];
            [circle11 fill];
            if ([self.currentColor isEqual:[UIColor yellowColor]]) {
                [STROKE_COLOR setStroke];
                circle11.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle11 stroke];
                [[UIColor blackColor] setStroke];
            }
            
            circle12 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+11*BUFFER+10*width, width-2.0f, width-2.0f)];
            [[UIColor greenColor] setFill];
            [circle12 stroke];
            [circle12 fill];
            if ([self.currentColor isEqual:[UIColor greenColor]]) {
                [STROKE_COLOR setStroke];
                circle12.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle12 stroke];
                [[UIColor blackColor] setStroke];
            }
            
            circle13 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+12*BUFFER+11*width, width-2.0f, width-2.0f)];
            [[UIColor colorWithRed:154/255.0 green:18.0/255.0 blue:179.0/255.0 alpha:1.0] setFill];
            [circle13 stroke];
            [circle13 fill];
            if ([self.currentColor isEqual:[UIColor colorWithRed:154/255.0 green:18.0/255.0 blue:179.0/255.0 alpha:1.0]]) {
                [STROKE_COLOR setStroke];
                circle13.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle13 stroke];
                [[UIColor blackColor] setStroke];
            }
            
            
            circle14 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+13*BUFFER+12*width, width-2.0f, width-2.0f)];
            [[UIColor colorWithRed:51.0/255.0 green:110.0/255.0 blue:123.0/255.0 alpha:1.0] setFill];
            [circle14 stroke];
            [circle14 fill];
            if ([self.currentColor isEqual:[UIColor colorWithRed:51.0/255.0 green:110.0/255.0 blue:123.0/255.0 alpha:1.0]]) {
                [STROKE_COLOR setStroke];
                circle14.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle14 stroke];
                [[UIColor blackColor] setStroke];
            }
            
            circle9 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+14*BUFFER+13*width, width-2.0f, width-2.0f)];
            //[circle1 stroke];
            [[UIColor whiteColor] setFill];
            [circle9 fill];
            [circle9 stroke];
            [circle9 addClip];
            [[UIImage imageNamed:@"text"]drawInRect:CGRectMake(x, y+14*BUFFER+13*width, width-2.0f, width-2.0f)];
            if ([self.currentColor isEqual:[UIColor purpleColor]]) {
                [STROKE_COLOR setStroke];
                circle9.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle9 stroke];
                [[UIColor blackColor] setStroke];
            }
            
        }else{
            circle9 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y+9*BUFFER+8*width, width-2.0f, width-2.0f)];
            //[circle1 stroke];
            [[UIColor whiteColor] setFill];
            [circle9 fill];
            [circle9 stroke];
            [circle9 addClip];
            [[UIImage imageNamed:@"text"]drawInRect:CGRectMake(x, y+9*BUFFER+8*width, width-2.0f, width-2.0f)];
            if ([self.currentColor isEqual:[UIColor purpleColor]]) {
                [STROKE_COLOR setStroke];
                circle9.lineWidth = CIRCLE_STROKE_WIDTH;
                [circle9 stroke];
                [[UIColor blackColor] setStroke];
            }
        }
        
        
        [self.paths addObject:circle2];
        [self.paths addObject:circle5];
        [self.paths addObject:circle3];
        [self.paths addObject:circle7];
        [self.paths addObject:circle4];
        [self.paths addObject:circle6];
        [self.paths addObject:circle8];
        [self.paths addObject:circle1];
        [self.paths addObject:circle9];
        [self.paths addObject:circle10];
        [self.paths addObject:circle11];
        [self.paths addObject:circle12];
        [self.paths addObject:circle13];
        [self.paths addObject:circle14];
    }


    //UIRectFill(self.bounds);
    //UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    //roundRect.lineWidth = LINE_WIDTH;
    //[roundRect stroke];
    //[roundRect fill];
    /*UIBezierPath *roundRectInset = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 2.0, 2.0) cornerRadius:[self cornerRadius]];
    roundRectInset.lineWidth = LINE_WIDTH;
    [roundRectInset stroke];
    [roundRectInset addClip];*/
    
    
    /*UIBezierPath *roundRectInset = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.bounds.size.height * 0.33, self.bounds.size.height * 0.08) cornerRadius:[self cornerRadius]];
    roundRectInset.lineWidth = 5.0;
    [roundRectInset stroke];
    [roundRectInset addClip];*/
    
    /*[[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper"]]setFill];
    UIRectFill(self.bounds);*/
    
        /*UIBezierPath *outlinePath = [[UIBezierPath alloc]init];
    [outlinePath moveToPoint:CGPointZero];
    [outlinePath addLineToPoint:CGPointMake(self.bounds.size.width *6.0/7.0, 0.0)];
    [outlinePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [outlinePath addLineToPoint:CGPointMake(self.bounds.size.width/7.0, self.bounds.size.height)];
    [outlinePath closePath];
    
    //[[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper"]] setStroke];
    //[outlinePath setLineWidth:12.0];
    //[outlinePath stroke];
    
    for (int i=0; i<3; i++) {
        UIBezierPath *triangle = [[UIBezierPath alloc]init];
        [triangle moveToPoint:CGPointMake(i*2.0/7.0*self.bounds.size.width, 0.0)];
        [triangle addLineToPoint:CGPointMake((i+1)*2.0/7.0*self.bounds.size.width, 0.0)];
        [triangle addLineToPoint:CGPointMake(((i+1)*2.0-1.0)/7.0*self.bounds.size.width, self.bounds.size.height)];
        [triangle closePath];
        [self.paths addObject:triangle];
        if (i==0) {
            [[UIColor blackColor] setFill];
        }else if(i==1){
            [[UIColor colorWithRed:224.0/255.0 green:190.0/255.0 blue:7.0/255.0 alpha:1.0] setFill];
        }else{
            [[UIColor colorWithRed:213.0/255.0 green:3.0/255.0 blue:22.0/255.0 alpha:1.0] setFill];
        }
        triangle.lineWidth =12.0;
        //[triangle stroke];
        [triangle fillWithBlendMode:BLEND_MODE alpha:1.0];
    }
    for (int i=0; i<3; i++) {
        UIBezierPath *triangle = [[UIBezierPath alloc]init];
        [triangle moveToPoint:CGPointMake(((i*2.0)+1.0)/7.0*self.bounds.size.width, self.bounds.size.height)];
        [triangle addLineToPoint:CGPointMake(((i*2.0)+3.0)/7.0*self.bounds.size.width, self.bounds.size.height)];
        [triangle addLineToPoint:CGPointMake(((i*2.0)+2.0)/7.0*self.bounds.size.width, 0.0)];
        [triangle closePath];
        [self.paths addObject:triangle];
        if (i==0) {
            [[UIColor colorWithRed:196.0/255.0 green:62.0/255.0 blue:24.0/255.0 alpha:1.0] setFill];
        }else if(i==1){
            [[UIColor colorWithRed:24.0/255.0 green:102.0/255.0 blue:214.0/255.0 alpha:1.0] setFill];
        }else{
            [[UIColor colorWithRed:8.0/255.0 green:120.0/255.0 blue:62.0/255.0 alpha:1.0] setFill];
        }
        triangle.lineWidth = 12.0;
        //[triangle stroke];
        [triangle fillWithBlendMode:BLEND_MODE alpha:1.0];
    }
    
    UIBezierPath *clearTriangle = [[ UIBezierPath alloc]init];
    [clearTriangle moveToPoint:CGPointZero];
    [clearTriangle addLineToPoint:CGPointMake(self.bounds.size.width/7, self.bounds.size.height)];
    [clearTriangle addLineToPoint:CGPointMake(0.0, self.bounds.size.height)];
    [clearTriangle closePath];
    [self.paths addObject:clearTriangle];
    [[UIColor clearColor] setFill];
    //[clearTriangle stroke];
    [clearTriangle fill];
    
    UIBezierPath *lastTriangle = [[UIBezierPath alloc]init];
    [lastTriangle moveToPoint: CGPointMake(self.bounds.size.width*6.0/7.0,0.0)];
    [lastTriangle addLineToPoint:CGPointMake(self.bounds.size.width, 0.0)];
    [lastTriangle addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [lastTriangle closePath];
    
    [self.paths addObject:lastTriangle];
    
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSDictionary *attributes = [[NSDictionary alloc]initWithObjects:@[font] forKeys:@[NSFontAttributeName]];
    
    [lastTriangle appendPath:clearTriangle];
    [lastTriangle addClip];
    //[[UIColor blackColor]setStroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, -1*M_PI/4.0);*/
    
        /*for (int i=0; i<20;i++) {
        [[[NSBundle mainBundle]localizedStringForKey:@"Text Text Text Text Text" value:@"Text Text Text Text Text" table:@"Entities"] drawAtPoint:CGPointMake(self.bounds.size.width*5.50/7.0+8.0*i, -1.0+i*14.0) withAttributes:attributes];
        [@"Clear Clear Clear Clear" drawAtPoint:CGPointMake(-20.0-8.0*i, 5.0+i*14.0) withAttributes:attributes];
    }
    lastTriangle.lineWidth = 8.0;
    //[[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper"]]setStroke];
    //[lastTriangle stroke];
    //CGContextRestoreGState(UIGraphicsGetCurrentContext());
   */
}

-(void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.clipsToBounds = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.layer.masksToBounds = NO;
    //self.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.layer.shadowOpacity = 1.0f;
    //self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    //self.layer.shadowRadius = 5.0f;
    //self.layer.masksToBounds = NO;
    CGFloat width = 0.0;
    CGFloat y =0.0;
    CGFloat x = 0.0;
    if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        width = self.bounds.size.height;
        y=1.0;
        x= (self.bounds.size.width-(14*BUFFER+14*width))*0.5;
        
    }else{
        width = self.bounds.size.width/(8.0+BUFFER);
        y = (self.bounds.size.height-width) *0.5f;
        x = 0.0;
        
        
    }
    //self.layer.shadowPath = [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+2*BUFFER+width, y, width-2.0f, width-2.0f)] CGPath];
    //self.layer.shadowOffset = CGSizeMake(2.0, 5.0);
    //self.layer.shadowRadius = 5;
    //self.layer.shadowOpacity = 0.5;
    ///self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.paths = [[NSMutableArray alloc]init];
    
}

-(void)awakeFromNib
{
    [self setup];
}

@end
