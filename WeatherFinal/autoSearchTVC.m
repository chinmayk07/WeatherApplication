//
//  autoSearchTVC.m
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 24/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import "autoSearchTVC.h"
#import "autoSearchtable.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface autoSearchTVC ()
{
    NSMutableArray *results, *results1;
    NSMutableDictionary *reslts, *outside, *result;
    NSInteger row;
    NSString *nameselected, *locationofselected, *loc_name, *loc_coordinates;
}
@property (nonatomic,strong) UISearchController *searchController;
@property (strong) NSMutableArray *data;

@end

@implementation autoSearchTVC

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"VIEW DID LOAD");
    
    [self.tableView reloadData];
    
    UINavigationController *search = [[self storyboard]instantiateViewControllerWithIdentifier:@"AutoSearchNavController"];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:search];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    loc_name = [[NSString alloc]init];
    loc_coordinates = [[NSString alloc]init];
    
    NSManagedObjectContext *managedobjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Locations"];
    self.data = [[managedobjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //[self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"VIEW DID APPEAR");
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updatedata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    row = indexPath.row;
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *dataLoc = [self.data objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[dataLoc valueForKey:@"loc_name"]]];
    
    //cell.detailTextLabel.text = [[results1 objectAtIndex:indexPath.row]objectForKey:@"l"];
    //}
    return cell;
}

- (void)updatedata {
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSManagedObject *dataLoc = [self.data objectAtIndex:indexPath.row];
    loc_name = [dataLoc valueForKey:@"loc_name"];
    loc_coordinates = [dataLoc valueForKey:@"loc_cordinates"];
    NSLog(@"DID select NAMW : %@",loc_name);
    NSLog(@"DID select LOCATION : %@",loc_coordinates);
    
    ViewController *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewC];
    viewC.selected_location = loc_name;
    viewC.selected_coordinates = loc_coordinates;
    
    [self presentViewController:navigationController animated:YES completion:nil];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *contex = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [contex deleteObject:[self.data objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        
        if(![contex save:&error]) {
            
            NSLog(@"CANNOT DELETE %@ %@",error,[error localizedDescription]);
            return;
        }
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if (self.searchController.searchResultsController) {
        
        UINavigationController *nav = (UINavigationController *)self.searchController.searchResultsController;
        
        autoSearchtable *ast = (autoSearchtable *)nav.topViewController;
        
        ast.searchAuto = results1;
        
        [ast.tableView reloadData];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *str = [self.searchController.searchBar.text stringByReplacingCharactersInRange:range withString:text];
    
    NSString *apiCallUrl = [NSString stringWithFormat:@"http://autocomplete.wunderground.com/aq?query=%@",str];
    
    NSLog(@"new api string is : %@",apiCallUrl);
    
    [self callAPI:apiCallUrl];
    
    NSLog(@"new string is : %@",str);
    
    return YES;
}

//Code for search button to toggle searchBar appearance
/*- (IBAction)searchBarButton:(id)sender {
    
    if(self.searchBtn.tag == 0) {
        
        self.searchController.searchBar.hidden = false;
        
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        
        self.tableView.tableHeaderView = self.searchController.searchBar;
        
        self.searchBtn.tag = 1;
    }
    else {
        
        self.searchController.searchBar.hidden = true;
        
        self.tableView.tableHeaderView = nil;
        
        self.searchBtn.tag = 0;
    }
}*/

- (void)callAPI:(NSString *)callURL {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:callURL]];
   
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil) {
            
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"DATA : %@",res);
            
            for(id key in res) {
                id value = [res objectForKey:key];
                NSString *keyAsString = (NSString *)key;
                NSString *valueAsString = (NSString *)value;
                NSLog(@"key: %@", keyAsString);
                NSLog(@"value: %@", valueAsString);
            }
            results = [res objectForKey:@"RESULTS"];
            for (result in results) {
                NSString *icon = [result objectForKey:@"l"];
                //NSString *icon1 = [result objectForKey:@"c"];
                NSString *icon2 = [result objectForKey:@"name"];
                NSLog(@"l: %@", icon);
                //NSLog(@"c: %@", icon1);
                NSLog(@"name : %@",icon2);
            }
            NSLog(@"RESULTS ARRAY : %@",results);
            results1 = results;
        }
    }];    
    [datatask resume];
}

- (IBAction)backBarButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
