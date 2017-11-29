//
//  DotCollectionViewController.m
//  Graph
//
//  Created by iMac on 9/25/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotCollectionViewController.h"
#import "Graph.h"
#import "DotCollectionViewCell.h"
#import "DotViewController.h"
#import "Dot.h"

@interface DotCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *graphs;
@property (nonatomic, strong) Graph *segueGraph;
@property (nonatomic) BOOL bannerIsVisible;
@property (nonatomic, weak) ADBannerView *adBanner;
@property (nonatomic) CGRect originalAdRect;
@end

@implementation DotCollectionViewController

static NSString * const reuseIdentifier = @"Card";

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNextCondensed-Bold" size:23.0],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
    self.title = [[NSBundle mainBundle]localizedStringForKey:@"Graphs" value:@"Graphs" table:@"Entities"];
    NSLog(@"%@",self.navigationController);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newGraph)];
    UIBarButtonItem *gear = [[UIBarButtonItem alloc]initWithTitle:@" ⚙ "style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
    self.navigationItem.leftBarButtonItem = gear;
    
    UIFont * font = [UIFont fontWithName:@"GillSans" size:25.0f];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    if (!self.managedObjectContext) {
        [self useGraphDocument];
    }

    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)useGraphDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Graph Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    document.persistentStoreOptions = @{
                                        NSMigratePersistentStoresAutomaticallyOption : @YES,
                                        NSInferMappingModelAutomaticallyOption : @YES
                                        };
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  NSLog(@"New Doc");
                  self.managedObjectContext = document.managedObjectContext;
                  self.graphs = [NSMutableArray array];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Open Doc");
                self.managedObjectContext = document.managedObjectContext;
                [self fetch];
            }
        }];
    } else {
        NSLog(@"Use Doc");
        self.managedObjectContext = document.managedObjectContext;
        [self fetch];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.managedObjectContext) {
        [self fetch];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
        }
        if ([self.graphs count]) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
        
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"com.bradgayman.graph.adfree"]) {
        self.canDisplayBannerAds = YES;
    }else{
        self.canDisplayBannerAds = NO;
    }
    /*if (![[NSUserDefaults standardUserDefaults] boolForKey:@"com.bradgayman.graph.adfree"]) {
        ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        self.originalAdRect = adView.frame;
        self.adBanner = adView;
        [self.view addSubview:adView];
        self.adBanner.delegate = self;
    }*/
    
}

-(void)fetch
{
    NSLog(@"HERE2");
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Graph"];
    NSError *error;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastModified" ascending:NO]];
    NSArray *fetchedGraphs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%@",fetchedGraphs);
    //NSLog(@"%@",[fetchedGraphs[0] dots]);
    self.graphs = [[NSMutableArray alloc]initWithArray:fetchedGraphs];
    NSLog(@"HERE3");
    [self.collectionView reloadData];
    NSLog(@"HERE5");
}

-(void)settings
{
    [self performSegueWithIdentifier:@"Settings" sender:self];
}

-(void)newGraph
{
    Graph *graph = [NSEntityDescription insertNewObjectForEntityForName:@"Graph" inManagedObjectContext:self.managedObjectContext];
    graph.lastModified = [NSDate timeIntervalSinceReferenceDate];
    self.segueGraph = graph;
    [self performSegueWithIdentifier:@"Card" sender:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Card"]) {
        [(DotViewController *)segue.destinationViewController setManagedObjectContext: self.managedObjectContext];
        [[(DotViewController *)segue.destinationViewController dotCardView] setManagedObjectContext: self.managedObjectContext];

        [(DotViewController *)segue.destinationViewController setGraph:self.segueGraph];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.graphs count];
}

-(CGSize) collectionView:(UICollectionView *) collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        return CGSizeMake(275, 367);
    }
    return CGSizeMake(240, 271);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DotCollectionViewCell *cell = (DotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //cell.dotCardView.dots = [NSMutableArray arrayWithArray:[[[self.graphs objectAtIndex:indexPath.item] dots]allObjects]];
    //cell.dotCardView.lines = [NSMutableArray arrayWithArray:[[[self.graphs objectAtIndex:indexPath.item] lines]allObjects]];
    //cell.dotCardView.texts = [NSMutableArray arrayWithArray:[[[self.graphs objectAtIndex:indexPath.item] texts]allObjects]];
    //NSLog(@"%@",cell.dotCardView.dots);
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    cell.layer.masksToBounds = YES;
    DotCardView *cardView = [[DotCardView alloc]init];
    UIDevice* thisDevice = [UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        cardView.frame = CGRectMake(0.0, 0.0, 761.0, 889.0);
    }
    else
    {
        cardView.frame = CGRectMake(0.0, 0.0, 313.0, 433.0);
    }

    cardView.managedObjectContext = self.managedObjectContext;
    cardView.backgroundColor = [UIColor clearColor];
    cardView.opaque = NO;
    cardView.showBack = NO;
    cardView.edgeString = nil;
    cardView.vertexString = nil;
    cardView.spanningString = nil;
    cardView.graph = [self.graphs objectAtIndex:indexPath.item];
    cardView.dots = [NSMutableArray arrayWithArray:[[[self.graphs objectAtIndex:indexPath.item] dots]allObjects]];
    cardView.lines = [NSMutableArray arrayWithArray:[[[self.graphs objectAtIndex:indexPath.item] lines]allObjects]];
    cardView.texts = [NSMutableArray arrayWithArray:[[[self.graphs objectAtIndex:indexPath.item] texts]allObjects]];
    cardView.currentColor = [UIColor blackColor];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        cardView.transform = CGAffineTransformMakeScale(cell.bounds.size.width/761.0, cell.bounds.size.height/889.0);
    }
    else
    {
        cardView.transform = CGAffineTransformMakeScale(cell.bounds.size.width/313.0, cell.bounds.size.height/433.0);
    }

    cardView.frame = CGRectMake(0.0, 0.0, cardView.frame.size.width, cardView.frame.size.height);
    [cell addSubview:cardView];
    return cell;
}

- (IBAction)tapCollectionView:(UITapGestureRecognizer *)sender {
    CGPoint tapLocation = [sender locationInView:self.collectionView ];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        self.segueGraph = [self.graphs objectAtIndex:indexPath.item];
        self.segueGraph.lastModified = [NSDate timeIntervalSinceReferenceDate];
        [self performSegueWithIdentifier:@"Card" sender:self];
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


@end
