//
//  NYUJoinTableUserDetailViewController.m
//  SplitIt
//
//  Created by Shalin Shah on 5/9/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUJoinTableUserDetailViewController.h"
#import "NYUPerson.h"
#import "NYUfoodDetails.h"
#import <Firebase/Firebase.h>

@interface NYUJoinTableUserDetailViewController () {
    Firebase* firebase;
    Firebase* firebase2;
    FirebaseHandle* childAddedObserverHandle;
    FirebaseHandle* childAddedObserverHandle2;
    
}

@end

@implementation NYUJoinTableUserDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.person.name;
    [self.person.foodItems removeAllObjects];
    self.url = [[NSMutableString alloc]initWithString:@"https://splitbill.firebaseio.com/"];
    [self.url appendString:[NSString stringWithFormat:@"%@/%@/", self.person.tableNumber, self.person.name]];
    //[self.url appendString:[NSString stringWithFormat:@"96/%@/",self.person.name]];
    // Do any additional setup after loading the view.
    __block double total=0;
    
    //used to calculate total when adding items
    Firebase* FaddChild=[[Firebase alloc]initWithUrl:self.url];
    
    [FaddChild observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if (![snapshot.name isEqualToString:@"tax"] && ![snapshot.name isEqualToString:@"tip"] ){
            NSString* foodValue= snapshot.value;
            (total)+=[foodValue doubleValue];
            [self.userTotal setText:[NSString stringWithFormat:@"Total: $%.2f", total]];
        }
    }];
    //used to calculate total when removing items
    Firebase* FremoveChild=[[Firebase alloc]initWithUrl:self.url];
    
    [FremoveChild observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        
        NSString* foodValue= snapshot.value;
        (total)-=[foodValue doubleValue];
        [self.userTotal setText:[NSString stringWithFormat:@"Total: $%.2f", total]];
    }];
    firebase = [[Firebase alloc]initWithUrl:self.url];
    childAddedObserverHandle = [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot* snapshot){
        NYUfoodDetails* details = [[NYUfoodDetails alloc]init];
        [details setFoodName:[NSString stringWithFormat:@"%@",snapshot.name]];
        [details setFoodPrice:[NSString stringWithFormat:@"%@",snapshot.value]];
        
        [self.person.foodItems addObject:details];
        if ([details.foodName isEqualToString:@"tip"] || [details.foodName isEqualToString:@"tax"]) {
            [self.person.foodItems removeLastObject];
        }
        [self.tableView reloadData];
    }];
    
    firebase2 = [[Firebase alloc]initWithUrl:self.url];
    [firebase2 observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot* snapshot){
        //NSLog(self.person);
        NYUfoodDetails *foodToRemove = nil;
        for (int i=0; i<[self.person.foodItems count]; i++){
			NYUfoodDetails *currentFoodDetails = [self.person.foodItems objectAtIndex:i];
            if ([currentFoodDetails.foodName isEqualToString:snapshot.name]){
                foodToRemove = currentFoodDetails;
				break;
            }
        }
		if (foodToRemove) {
			[self.person.foodItems removeObject:foodToRemove];
			[self.tableView reloadData];
		}    }];


}

#pragma mark - UITableView Data Source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return ([self.person.foodItems count]-2);
    return [self.person.foodItems count];
    //return 5;
}

-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"joinTableItemCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    
    
    NYUfoodDetails * tempFoodName = [[NYUfoodDetails alloc]init];
    
    tempFoodName = self.person.foodItems[indexPath.row];
    NSString* name = tempFoodName.foodName;
    
    NSString* price = tempFoodName.foodPrice;
    
    
    [cell.textLabel setText:name];
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%@",price]];

    return cell;
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[firebase removeObserverWithHandle:childAddedObserverHandle];
}

- (IBAction)addFood:(id)sender {
    NSString* foodName = [self.foodNameField text];
    
    NSString* price = [self.foodPriceField text];
    if ([foodName length]>0 && [price length]>0){
        double priceInt= [price doubleValue];
        
        
        Firebase* f = [[Firebase alloc] initWithUrl:_url];
        
        // Write data to Firebase
        [[f childByAppendingPath:foodName] setValue:[NSNumber numberWithDouble:priceInt]];
        
        //        NYUfoodDetails* details = [[NYUfoodDetails alloc]init];
        //
        //        [details setFoodName:foodName];
        //        [details setFoodPrice:price];
        
        //[self.person.foodItems addObject:details]; //Adds the user to the array
        
        
        [self.foodNameField resignFirstResponder]; // if add button is pressed then it also hides the keyboard
        
        //you want to reload the tableview once you add a user
        [self.foodPriceField resignFirstResponder];
        self.foodNameField.text=nil;
        self.foodPriceField.text=nil;
        [self.tableView reloadData];
    }
}


-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath]; //retreives the cell to be removed
    NSString* foodToRemove = cell.textLabel.text;
    
    [self.person.foodItems removeObjectAtIndex:indexPath.row];
    
    
    Firebase* f=[[Firebase alloc]initWithUrl:_url];
    Firebase* ref=[f childByAppendingPath:foodToRemove];
    if(ref)
        [ref removeValue];
    
    [self.tableView reloadData];
    
    
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //IF they touch anywhere else it hides the keyboard
    [self.foodNameField resignFirstResponder];
    [self.foodPriceField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
