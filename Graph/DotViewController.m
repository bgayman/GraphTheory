//
//  DotViewController.m
//  Graph
//
//  Created by iMac on 2/7/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotViewController.h"
#import "DotColorPickView.h"
#import "DotStatsViewController.h"
#import "DotPDFViewController.h"
#import "DotPDFView.h"
#import <iAd/iAd.h>

@interface DotViewController () <UIActionSheetDelegate, UIDocumentInteractionControllerDelegate,ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorPickerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorPickerBottonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotCardTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotCardLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotCardTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotCardBottom;
@property (strong, nonatomic) UIColor *currentColor;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tripleTapGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *fourTapGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *fiveTapGesture;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) UIDocumentInteractionController *documentController;
@property (weak, nonatomic) IBOutlet DotColorPickView *dotColorPickView;
@property (strong, nonatomic) NSMutableData *pdfData;
@property (nonatomic) CGRect colorPickerFrame;
@property (nonatomic) CGFloat scale;
@property (nonatomic) BOOL bannerIsVisible;
@property (nonatomic, weak) ADBannerView *adBanner;
@property (nonatomic) CGPoint dotCardViewCenter;
@property (nonatomic) CGPoint newDotCardViewCenter;
@end

@implementation DotViewController

#define MAX_SCALING 2.0
#define MIN_SCALING 0.5
#define LONG_PRESS_DURATION 0.25

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.dotCardView.touchBegin = [sender locationInView:self.dotCardView];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        if (!self.dotCardView.touchBegin.x) {
            [self handleTwoFingerPan:sender];
        }else{
            self.dotCardView.touchChanged = [sender locationInView:self.dotCardView];
        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        if (!self.dotCardView.touchBegin.x) {
            [self handleTwoFingerPan:sender];
        }else{
            self.dotCardView.touchEnd = [sender locationInView:self.dotCardView];
        }
    }
}

- (IBAction)handleTwoFingerPan:(UIPanGestureRecognizer *)sender {
    self.dotCardView.center = CGPointMake(self.newDotCardViewCenter.x+[sender translationInView:self.view].x, self.newDotCardViewCenter.y+[sender translationInView:self.view].y);
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.newDotCardViewCenter = self.dotCardView.center;
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.dotCardView tapOnView:[sender locationInView:self.dotCardView]];
}

-(void)viewDidLayoutSubviews{
    self.dotCardViewCenter = self.dotCardView.center;
    self.newDotCardViewCenter =self.dotCardView.center;
    self.dotColorPickView.currentColor = self.currentColor;
    self.dotCardView.originalSize = self.dotCardView.bounds.size;
    //self.dotColorPickView.layer.shadowPath = [(UIBezierPath *)self.dotColorPickView.paths[0] CGPath];
}

- (IBAction)tapColor:(UITapGestureRecognizer *)sender {
    
    for (UIBezierPath *path in self.dotColorPickView.paths) {
        if (CGPathContainsPoint(path.CGPath, NULL, [sender locationInView:self.dotColorPickView], FALSE)) {
            NSUInteger index = [self.dotColorPickView.paths indexOfObject:path];
            
            if (index == 0) {
                self.currentColor = [UIColor blackColor];
                
            }else if(index ==1){
                self.currentColor = [UIColor colorWithRed:224.0/255.0 green:190.0/255.0 blue:7.0/255.0 alpha:1.0];
                


            }else if(index ==2){
                self.currentColor = [UIColor redColor];
                


            }else if(index ==3){
                self.currentColor = [UIColor orangeColor];
                


            }else if(index ==4){
                self.currentColor = [UIColor colorWithRed:24.0/255.0 green:102.0/255.0 blue:214.0/255.0 alpha:1.0];
                


            }else if(index ==5){
                self.currentColor = [UIColor colorWithRed:8.0/255.0 green:120.0/255.0 blue:62.0/255.0 alpha:1.0];
                


            }else if (index == 6){
                self.currentColor = [UIColor magentaColor];
                


            }else if(index == 7){
                self.currentColor = [UIColor clearColor];
                


            }else if(index == 8){
                self.currentColor = [UIColor purpleColor];
                


            }else if(index == 9){
                self.currentColor = [UIColor cyanColor];
                


            }else if(index == 10){
                self.currentColor = [UIColor yellowColor];
                


                
            }else if(index == 11){
                self.currentColor = [UIColor greenColor];
                


                
            }else if(index == 12){
                self.currentColor = [UIColor colorWithRed:154/255.0 green:18.0/255.0 blue:179.0/255.0 alpha:1.0];
                


                
            }else if (index == 13){
                self.currentColor = [UIColor colorWithRed:51.0/255.0 green:110.0/255.0 blue:123.0/255.0 alpha:1.0];
                


            }
            break;
        }
    }
    self.dotColorPickView.currentColor = self.currentColor;
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
    self.dotCardView.changingSize = YES;
    [UIView animateWithDuration:LONG_PRESS_DURATION animations:^{
        self.dotCardTop.constant = 0.0;
        self.dotCardLeading.constant = -20.0;
        self.dotCardTrailing.constant = -20.0;
        self.dotCardBottom.constant = 0.0;
        self.dotCardView.center = self.dotCardViewCenter;
    }completion:^(BOOL complete){
        self.dotCardView.changingSize = NO;
    }];
    
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender {
    if ([self.dotCardView doubleTapOnView:[sender locationInView:self.dotCardView]]) {
    
    }
    
}

- (IBAction)tripleTap:(UITapGestureRecognizer *)sender {
    [self.dotCardView tripleTapOnView:[sender locationInView:self.dotCardView]];
}

- (IBAction)fourTaps:(UITapGestureRecognizer *)sender {
    [self.dotCardView fourTapsOnView:[sender locationInView:self.dotCardView]];
}

- (IBAction)fiveTaps:(UITapGestureRecognizer *)sender {
    [self.dotCardView fiveTapsOnView:[sender locationInView:self.dotCardView]];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.dotCardView.changingSize = YES;
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
        CGFloat scale = [sender scale];
        CGFloat newWidth = CGRectGetWidth(self.dotCardView.frame)*scale;
        CGFloat newHeight = CGRectGetHeight(self.dotCardView.frame)*scale;
        CGFloat widthOffset = (self.dotCardView.frame.size.width-newWidth)*0.5;
        CGFloat heightOffset = (self.dotCardView.frame.size.height-newHeight)*0.5;
        
        self.dotCardTop.constant+=heightOffset;
        self.dotCardLeading.constant+=widthOffset;
        self.dotCardTrailing.constant+=widthOffset;
        self.dotCardBottom.constant+=heightOffset;
        
        CGAffineTransform currentTransform = CGAffineTransformIdentity;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        self.dotCardView.transform = newTransform;
        
        
        sender.scale = 1;
    }else if (sender.state == UIGestureRecognizerStateEnded){
        self.dotCardView.changingSize = NO;

    }
}

@synthesize currentColor =_currentColor;

-(UIColor *)currentColor
{
    if (!_currentColor) {
        _currentColor = [[UIColor alloc]initWithWhite:0.0 alpha:1.0];
    }
    return _currentColor;
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    self.dotCardView.currentColor = currentColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"com.bradgayman.graph.adfree"]) {
        NSLog(@"SHOW ADS");
        self.canDisplayBannerAds = YES;
    }
    self.dotCardView.managedObjectContext = self.managedObjectContext;
    self.dotCardView.graph = self.graph;
    
    self.colorPickerFrame = self.dotColorPickView.frame;
    self.scale = 1.0;
    self.title = [[NSBundle mainBundle]localizedStringForKey:@"Graph" value:@"Graph" table:@"Entities"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];
    self.dotCardView.dots = [NSMutableArray arrayWithArray:[self.graph.dots allObjects]];
    self.dotCardView.lines = [NSMutableArray arrayWithArray:[self.graph.lines allObjects]];
    self.dotCardView.texts = [NSMutableArray arrayWithArray:[self.graph.texts allObjects]];
    //[self.tapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    [self.doubleTapGesture requireGestureRecognizerToFail:self.tripleTapGesture];
    [self.tripleTapGesture requireGestureRecognizerToFail:self.fourTapGesture];
    [self.fourTapGesture requireGestureRecognizerToFail:self.fiveTapGesture];
    [self setNeedsStatusBarAppearanceUpdate];
    [self registerForKeyboardNotifications];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dotCardView setNeedsDisplay];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"com.bradgayman.graph.adfree"]) {
        self.dotColorPickView.frame = self.colorPickerFrame;
        self.colorPickerHeightConstraint.constant = 50;
        [self.dotColorPickView setNeedsDisplay];
        /*ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        self.adBanner = adView;
        [self.view addSubview:adView];
        self.adBanner.delegate = self;*/
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [self.dotCardView keyboardWasShown:aNotification];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.dotCardView keyboardWillBeHidden:aNotification];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:[[NSBundle mainBundle]localizedStringForKey:@"Cancel" value:@"Cancel" table:@"Entities"]
                                               destructiveButtonTitle:[[NSBundle mainBundle]localizedStringForKey:@"Delete Graph" value:@"Delete Graph" table:@"Entities"]
                                                    otherButtonTitles:[[NSBundle mainBundle]localizedStringForKey:@"Graph Stats" value:@"Graph Stats" table:@"Entities"],[[NSBundle mainBundle]localizedStringForKey:@"Calculator" value:@"Calculator" table:@"Entities"],[[NSBundle mainBundle]localizedStringForKey:@"Share as PDF" value:@"Share as PDF" table:@"Entities"],nil];
    UIDevice* thisDevice = [UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
    else
    {
        [actionSheet showInView:self.view];
    }

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[[NSBundle mainBundle]localizedStringForKey:@"Graph Stats" value:@"Graph Stats" table:@"Entities"]]) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self performSegueWithIdentifier:@"Stats" sender:self];
        });
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[[NSBundle mainBundle]localizedStringForKey:@"Share as PDF" value:@"Share as PDF" table:@"Entities"]]) {
        DotPDFView *pdfView = [[DotPDFView alloc]initWithFrame:self.dotCardView.frame];
        pdfView.height = self.dotCardView.bounds.size.height;
        pdfView.graph = self.graph;
        pdfView.backgroundColor = [UIColor whiteColor];
        pdfView.dots = [NSMutableArray arrayWithArray:[self.graph.dots allObjects]];
        pdfView.lines = [NSMutableArray arrayWithArray:[self.graph.lines allObjects]];
        pdfView.texts = [NSMutableArray arrayWithArray:[self.graph.texts allObjects]];
        [pdfView setNeedsDisplay];
        self.filePath = [self createPDFfromUIView:pdfView saveToDocumentsWithFileName:[NSString stringWithFormat:@"PDF%f.pdf",self.graph.lastModified]];
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        if (url) {
            // Initialize Document Interaction Controller
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
            
            // Configure Document Interaction Controller
            [self.documentController setDelegate:self];
            
            // Preview PDF
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.documentController presentPreviewAnimated:YES];
            });
        }
        
        //[self performSegueWithIdentifier:@"PDF" sender:self];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[[NSBundle mainBundle]localizedStringForKey:@"Calculator" value:@"Calculator" table:@"Entities"]]) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self performSegueWithIdentifier:@"Calc" sender:self];
        });
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[[NSBundle mainBundle]localizedStringForKey:@"Delete Graph" value:@"Delete Graph" table:@"Entities"]]) {
        [self deleteGraph];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        self.adBanner.frame = CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, 50.0f);
        self.dotColorPickView.frame = CGRectMake(self.dotColorPickView.frame.origin.x, self.dotColorPickView.frame.origin.y+self.adBanner.frame.size.height*0.5, self.dotColorPickView.frame.size.width, self.dotColorPickView.frame.size.height-self.adBanner.frame.size.height);
        self.colorPickerHeightConstraint.constant+=self.adBanner.frame.size.height*0.5;
        self.colorPickerBottonConstraint.constant-=self.adBanner.frame.size.height;

        [UIView commitAnimations];
        [self.dotColorPickView setNeedsDisplay];
        
        self.bannerIsVisible = NO;
    }*/
    if ([segue.identifier isEqualToString:@"Stats"]) {
        [(DotStatsViewController *)[[segue.destinationViewController viewControllers] firstObject] setGraph:self.graph];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"com.bradgayman.graph.adfree"]) {
            [(DotStatsViewController *)[[segue.destinationViewController viewControllers] firstObject] setInterstitialPresentationPolicy:ADInterstitialPresentationPolicyAutomatic];
        }
    }
    if ([segue.identifier isEqualToString:@"PDF"]) {
        [(DotPDFViewController *)[[segue.destinationViewController viewControllers] firstObject] setFilePath:self.filePath];
        [(DotPDFViewController *)[[segue.destinationViewController viewControllers] firstObject] setPdfData:self.pdfData];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"com.bradgayman.graph.adfree"]) {
            [(DotPDFViewController *)[[segue.destinationViewController viewControllers] firstObject] setInterstitialPresentationPolicy:ADInterstitialPresentationPolicyAutomatic];
        }
    }
}

-(NSString *)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    self.pdfData = pdfData;
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    //NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return documentDirectoryFilename;
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

-(void)deleteGraph
{
    [self.managedObjectContext deleteObject:self.graph];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self.dotCardView.dots removeAllObjects];
        [self.dotCardView.lines removeAllObjects];
        for (UITextView *text in self.dotCardView.texts) {
            [text removeFromSuperview];
        }
        [self.dotCardView.texts removeAllObjects];
        [self.dotCardView setNeedsDisplay];
        [self.dotCardView.graph removeLines:self.graph.lines];
        [self.dotCardView.graph removeDots:self.graph.dots];
        [self.dotCardView.graph removeTexts:self.graph.texts];
    } 
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /*if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        self.dotColorPickView.frame = CGRectMake(self.dotColorPickView.frame.origin.x, self.dotColorPickView.frame.origin.y+self.adBanner.frame.size.height*0.5,
                                                 self.dotColorPickView.frame.size.width, self.dotColorPickView.frame.size.height-self.adBanner.frame.size.height);
        self.colorPickerBottonConstraint.constant-=self.adBanner.frame.size.height;
        [UIView commitAnimations];
        
        self.bannerIsVisible = NO;
    }*/
}

/*- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible && ![[NSUserDefaults standardUserDefaults] boolForKey:@"com.bradgayman.graph.adfree"])
    {
        // If banner isn't part of view hierarchy, add it
        if (self.adBanner.superview == nil)
        {
            [self.view addSubview:self.adBanner];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectMake(0.0, self.view.bounds.size.height - banner.bounds.size.height, self.view.bounds.size.width, banner.bounds.size.height);
        self.dotColorPickView.frame = CGRectMake(self.dotColorPickView.frame.origin.x, self.dotColorPickView.frame.origin.y-banner.frame.size.height*0.5,
                                                 self.dotColorPickView.frame.size.width, self.dotColorPickView.frame.size.height-banner.frame.size.height);
        //self.colorPickerHeightConstraint.constant-=banner.frame.size.height*0.5;
        self.colorPickerBottonConstraint.constant+=banner.frame.size.height;
        [UIView commitAnimations];
        [self.dotColorPickView setNeedsDisplay];
        
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectMake(0.0f, self.view.frame.size.height, self.view.bounds.size.width, 50.0f);
        self.dotColorPickView.frame = CGRectMake(self.dotColorPickView.frame.origin.x, self.dotColorPickView.frame.origin.y+banner.frame.size.height*0.5,
                                                 self.dotColorPickView.frame.size.width, self.dotColorPickView.frame.size.height-banner.frame.size.height);
        self.colorPickerBottonConstraint.constant-=banner.frame.size.height;

        [UIView commitAnimations];

        [self.dotColorPickView setNeedsDisplay];

        self.bannerIsVisible = NO;
    }
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectMake(0.0f, self.view.frame.size.height, self.view.bounds.size.width, 50.0f);
        self.dotColorPickView.frame = CGRectMake(self.dotColorPickView.frame.origin.x, self.dotColorPickView.frame.origin.y+banner.frame.size.height*0.5,
                                                 self.dotColorPickView.frame.size.width, self.dotColorPickView.frame.size.height-banner.frame.size.height);
        self.colorPickerHeightConstraint.constant+=banner.frame.size.height*0.5;
        self.colorPickerBottonConstraint.constant-=banner.frame.size.height;
        [UIView commitAnimations];
        [self.dotColorPickView setNeedsDisplay];
        self.bannerIsVisible = NO;
    }
}*/

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    /*if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        self.dotColorPickView.frame = CGRectMake(self.dotColorPickView.frame.origin.x, self.dotColorPickView.frame.origin.y+self.adBanner.frame.size.height*0.5,
                                                 self.dotColorPickView.frame.size.width, self.dotColorPickView.frame.size.height-self.adBanner.frame.size.height);
        self.colorPickerBottonConstraint.constant-=self.adBanner.frame.size.height;
        [UIView commitAnimations];
        
        self.dotCardView.changingSize = YES;
        [coordinator animateAlongsideTransition:nil completion:^(id context){
            self.dotCardView.changingSize = NO;
        }];
    }*/
}


@end
