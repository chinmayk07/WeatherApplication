//
//  autoSearchtable.m
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 24/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import "autoSearchtable.h"
#import "AppDelegate.h"
#import "autoSearchTVC.h"

@interface autoSearchtable ()
{
    NSInteger row;
    NSString *nameselected, *locationofselected;
    NSMutableDictionary *selectedcity, *finalDict;    
}

@end

@implementation autoSearchtable

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchAuto count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoSearchCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.searchAuto objectAtIndex:indexPath.row]objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.searchAuto objectAtIndex:indexPath.row]objectForKey:@"l"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    nameselected = [[self.searchAuto objectAtIndex:indexPath.row]objectForKey:@"name"];
    locationofselected = [[self.searchAuto objectAtIndex:indexPath.row]objectForKey:@"l"];
    
    NSLog(@"DID SELECT 1 : %@",nameselected);
    NSLog(@"DID SELECT 1 : %@",locationofselected);
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newData = [NSEntityDescription insertNewObjectForEntityForName:@"Locations" inManagedObjectContext:context];
    [newData setValue:nameselected forKey:@"loc_name"];
    [newData setValue:locationofselected forKey:@"loc_cordinates"];
    
    NSError *error = nil;
    if(![context save:&error]) {
        
        NSLog(@"Cant Save %@ %@",error,[error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
