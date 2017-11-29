//
//  DotStatsView.m
//  Graph
//
//  Created by MacBook on 10/21/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotStatsView.h"

@interface DotStatsView()
@property (nonatomic) BOOL spanningSet;
@end

@implementation DotStatsView
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 0.0
#define DOT_SCALE_FACTOR .025
#define BLEND_MODE kCGBlendModeDarken
#define LINE_WIDTH 6.0
#define LOOP_CONTROL_POINTS_FACTOR 150.0
#define DOT_FUDGE_FACTOR -20.0
#define CONTENT_BUFFER 5.0

-(void)setMatrix:(Matrix *)matrix
{
    _matrix = matrix;
    [self setNeedsDisplay];
}

-(void)setNumLines:(NSUInteger)numLines
{
    _numLines = numLines;
    [self setNeedsDisplay];
}

-(void)setNumVertices:(NSUInteger)numVertices
{
    _numVertices = numVertices;
    [self setNeedsDisplay];
}

-(void)setNumSpanningTrees:(NSUInteger)numSpanningTrees
{
    _numSpanningTrees = numSpanningTrees;
    self.spanningSet = TRUE;
    [self setNeedsDisplay];
}

-(void)setBipartite:(BOOL)bipartite
{
    _bipartite = bipartite;
    [self setNeedsDisplay];
}

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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    NSDictionary *titleAttribs = @{NSFontAttributeName: titleFont, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor darkTextColor]};
    NSString *title = [[NSBundle mainBundle]localizedStringForKey:@"Graph Stats" value:@"Graph Stats" table:@"Entities"];
    CGSize titleSize = [title sizeWithAttributes:titleAttribs];
    [title drawInRect:CGRectMake(self.bounds.size.width*0.5-titleSize.width*0.5, self.bounds.size.height*.15, titleSize.width, titleSize.height) withAttributes:titleAttribs];
    
    UIBezierPath *lineBreak = [[UIBezierPath alloc]init];
    [lineBreak moveToPoint:CGPointMake(self.bounds.size.width*.25, self.bounds.size.height*.15+CONTENT_BUFFER+titleSize.height)];
    [lineBreak addLineToPoint:CGPointMake(self.bounds.size.width*.75, self.bounds.size.height*.15+CONTENT_BUFFER+titleSize.height)];
    [[UIColor grayColor]setStroke];
    lineBreak.lineWidth =1.0;
    lineBreak.lineCapStyle = kCGLineCapRound;
    [lineBreak stroke];
    
    UIFont *statsFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    NSDictionary *attribs = @{NSFontAttributeName: statsFont, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor darkTextColor]};
    
    NSString *vertexString = [NSString stringWithFormat:@"%@: %lu",[[NSBundle mainBundle]localizedStringForKey:@"Number of Vertices" value:@"Number of Vertices" table:@"Entities"],(unsigned long)self.numVertices];
    CGSize vertexSize = [vertexString sizeWithAttributes:attribs];
    [vertexString drawInRect:CGRectMake(self.bounds.size.width*0.5-vertexSize.width*0.5, self.bounds.size.height*0.25-vertexSize.height*0.5, vertexSize.width, vertexSize.height) withAttributes:attribs];
    
    NSString *edgeString = [NSString stringWithFormat:@"%@: %lu",[[NSBundle mainBundle]localizedStringForKey:@"Number of Edges" value:@"Number of Edges" table:@"Entities"],(unsigned long)self.numLines/2];
    CGSize edgeSize = [edgeString sizeWithAttributes:attribs];
    [edgeString drawInRect:CGRectMake(self.bounds.size.width*0.5-edgeSize.width*0.5, self.bounds.size.height*0.25+vertexSize.height*0.5+CONTENT_BUFFER, edgeSize.width, edgeSize.height) withAttributes:attribs];
    
    //NSString *followingString = @"Following Applies to Simple Connected Graphs";
    //CGSize followingSize = [followingString sizeWithAttributes:attribs];
    //[followingString drawInRect:CGRectMake(self.bounds.size.width*0.5-followingSize.width*0.5, self.bounds.size.height*0.40, followingSize.width, followingSize.height) withAttributes:attribs];
    
    NSString *spanningString = [NSString stringWithFormat:@"%@: %lu",[[NSBundle mainBundle]localizedStringForKey:@"Number of Spanning Trees" value:@"Number of Spanning Trees" table:@"Entities"],(unsigned long)self.numSpanningTrees];
    CGSize spanningSize = [spanningString sizeWithAttributes:attribs];
    
    NSString *bijectionString = [[NSBundle mainBundle]localizedStringForKey:@"Graph is Bipartite" value:@"Graph is Bipartite" table:@"Entities"];
    CGSize bijectionSize = [bijectionString sizeWithAttributes:attribs];
    
    if (self.bipartite) {
        [bijectionString drawInRect:CGRectMake(self.bounds.size.width*0.5-bijectionSize.width *0.5, self.bounds.size.height*0.50-bijectionSize.height-CONTENT_BUFFER*2.5 , bijectionSize.width, bijectionSize.height) withAttributes:attribs];
    }
    else if(self.spanningSet){
        
        [spanningString drawInRect:CGRectMake(self.bounds.size.width*0.5-spanningSize.width *0.5, self.bounds.size.height*0.50-spanningSize.height-CONTENT_BUFFER*2.5 , spanningSize.width, spanningSize.height) withAttributes:attribs];
    }
    
    if (self.bipartite && self.spanningSet) {
        [spanningString drawInRect:CGRectMake(self.bounds.size.width*0.5-spanningSize.width *0.5, self.bounds.size.height*0.50-spanningSize.height-CONTENT_BUFFER*3.5-bijectionSize.height , spanningSize.width, spanningSize.height) withAttributes:attribs];
    }
    
    NSString *kirchhoff = [[NSBundle mainBundle]localizedStringForKey:@"Kirchhoff's Matrix:" value:@"Kirchhoff's Matrix:" table:@"Entities"];
    CGSize kirchhoffSize = [kirchhoff sizeWithAttributes:attribs];
    [kirchhoff drawInRect:CGRectMake(self.bounds.size.width*0.5-kirchhoffSize.width*0.5, self.bounds.size.height*0.50, kirchhoffSize.width, kirchhoffSize.height) withAttributes:attribs];
    
    CGSize elementSize = [@"123" sizeWithAttributes:attribs];

    for (int i=0; i<self.matrix.rows; i++) {
        for (int j=0; j<self.matrix.columns; j++) {
            NSString *element = [NSString stringWithFormat:@"%li",(long)[(NSNumber *)[self.matrix getElementAtRow:i andColumn:j] integerValue]];
            CGFloat farOffMidpoint = j-self.matrix.columns/2.0;
            [element drawInRect:CGRectMake(self.bounds.size.width*0.5+elementSize.width*0.5-elementSize.width*0.5+farOffMidpoint*CONTENT_BUFFER+farOffMidpoint*elementSize.width, self.bounds.size.height*0.5+CONTENT_BUFFER+kirchhoffSize.height+(CONTENT_BUFFER+1)*i+elementSize.height*i, elementSize.width, elementSize.height) withAttributes:attribs];
            
            
        }
    }
    CGFloat farOffMidpoint = self.matrix.columns/2.0;
    farOffMidpoint *= -1;
    
    UIBezierPath *matrixLeft = [[UIBezierPath alloc] init];
    UIBezierPath *matrixRight = [[UIBezierPath alloc] init];
    
    if (self.matrix.rows) {
        [matrixLeft moveToPoint:CGPointMake(self.bounds.size.width*0.5+elementSize.width*0.5-elementSize.width*0.5+farOffMidpoint*CONTENT_BUFFER+farOffMidpoint*elementSize.width, self.bounds.size.height*0.5+CONTENT_BUFFER+kirchhoffSize.height)];
        [matrixLeft addQuadCurveToPoint:CGPointMake(self.bounds.size.width*0.5+elementSize.width*0.5-elementSize.width*0.5+farOffMidpoint*CONTENT_BUFFER+farOffMidpoint*elementSize.width, self.bounds.size.height*0.5+CONTENT_BUFFER+kirchhoffSize.height+(CONTENT_BUFFER)*(self.matrix.rows-1)+(elementSize.height+2)*(self.matrix.rows)) controlPoint:CGPointMake(self.bounds.size.width*0.5+elementSize.width*0.5-elementSize.width*0.5+farOffMidpoint*CONTENT_BUFFER+farOffMidpoint*elementSize.width-20.0, self.bounds.size.height*0.5+CONTENT_BUFFER+kirchhoffSize.height+(CONTENT_BUFFER+1)*(self.matrix.rows/2.0)+elementSize.height*(self.matrix.rows/2.0))];
        
        farOffMidpoint *= -1;
        
        [matrixRight moveToPoint:CGPointMake(self.bounds.size.width*0.5+elementSize.width*0.5-elementSize.width*0.5+farOffMidpoint*CONTENT_BUFFER+farOffMidpoint*elementSize.width, self.bounds.size.height*0.5+CONTENT_BUFFER+kirchhoffSize.height)];
        [matrixRight addQuadCurveToPoint:CGPointMake(self.bounds.size.width*0.5+elementSize.width*0.5-elementSize.width*0.5+farOffMidpoint*CONTENT_BUFFER+farOffMidpoint*elementSize.width, self.bounds.size.height*0.5+CONTENT_BUFFER+kirchhoffSize.height+(CONTENT_BUFFER)*(self.matrix.rows-1)+(elementSize.height+2)*(self.matrix.rows)) controlPoint:CGPointMake(self.bounds.size.width*0.5+elementSize.width*0.5-elementSize.width*0.5+farOffMidpoint*CONTENT_BUFFER+farOffMidpoint*elementSize.width+20.0, self.bounds.size.height*0.5+CONTENT_BUFFER+kirchhoffSize.height+(CONTENT_BUFFER+1)*(self.matrix.rows/2.0)+elementSize.height*(self.matrix.rows/2.0))];

    }
    
    [[UIColor blackColor]setStroke];
    matrixLeft.lineWidth =2.0;
    matrixLeft.lineCapStyle = kCGLineCapRound;
    [matrixLeft stroke];
    
    
    
    
    
    
    [[UIColor blackColor]setStroke];
    matrixRight.lineWidth =2.0;
    matrixRight.lineCapStyle = kCGLineCapRound;
    [matrixRight stroke];
}

-(void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.layer.masksToBounds = YES;
    
}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


@end
