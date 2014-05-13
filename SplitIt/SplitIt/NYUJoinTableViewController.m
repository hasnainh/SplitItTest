//
//  NYUJoinTableViewController.m
//  SplitIt
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUJoinTableViewController.h"
#import "NYUJoinTableUserDetailViewController.h"
#import <Firebase/Firebase.h>
#import "NYUPerson.h"
#import "NYUTaxnTipViewController.h"
@interface NYUJoinTableViewController () {
	Firebase *firebase;
    Firebase* firebase2;
}

@end


@implementation NYUJoinTableViewController

@synthesize tableID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UITableView Data Source


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    self.title =[NSString stringWithFormat:@"Table # %@",self.tableID];
    self.url = [[NSMutableString alloc]initWithString:@"https://splitbill.firebaseio.com/"];
    [self.url appendString:[NSString stringWithFormat:@"%@/", self.tableID]];
    self.joinUsers = [[NSMutableArray alloc]init]; // allocating the users array
    firebase =[[Firebase alloc]initWithUrl:_url];
    [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
       //add name to the array
        NYUPerson *person = [[NYUPerson alloc] initWithName:snapshot.name];
        [self.joinUsers addObject:person];
        [self.tableView reloadData];
    }];
    
    firebase2 = [[Firebase alloc]initWithUrl:self.url];
    [firebase2 observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot* snapshot){
        //NSLog(self.person);
        NYUPerson *personToRemove = nil;
        for (int i=0; i<[self.joinUsers count]; i++){
			NYUPerson *currentPersonDetails = [self.joinUsers objectAtIndex:i];
            if ([currentPersonDetails.name isEqualToString:snapshot.name]){
                personToRemove = currentPersonDetails;
				break;
            }
        }
		if (personToRemove) {
			[self.joinUsers removeObject:personToRemove];
			[self.tableView reloadData];
		}    }];
    
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //This function is for removing people
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath]; //retreives the cell to be removed
    NSString* personToRemove = cell.textLabel.text;
    
    
    [self.joinUsers removeObjectAtIndex:indexPath.row];
    
    // If you want to remove someone you also have to remove them from the database
    Firebase* f=[[Firebase alloc]initWithUrl:_url];
    Firebase* ref=[f childByAppendingPath:personToRemove];
    if(ref)
        [ref removeValue];
    
    [tableView reloadData];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //IF they touch anywhere else it hides the keyboard
    [self.personField resignFirstResponder];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.joinUsers count];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"joinUserCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NYUPerson * person = self.joinUsers[indexPath.row];
    person.tableNumber=[NSString stringWithFormat:@"%@", self.tableID];
    [cell.textLabel setText:person.name];
    
    __block double total=0;
    NSString* tempURL=[NSString stringWithFormat:@"%@/%@",_url,person.name];
    //NSLog(tempURL);
    
    // Calculates the total for each person and puts their total in the detail text label
    Firebase* f1=[[Firebase alloc]initWithUrl:tempURL];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"$0.00"]];
    [f1 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value!=[NSNull null] && ![snapshot.name isEqualToString:@"tax"] && ![snapshot.name isEqualToString:@"tip"] ) {
            NSString* foodValue= snapshot.value;
            (total)+=[foodValue doubleValue];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%.2f", total]];
        }
        
        
    }];
    
    Firebase* FremoveChild=[[Firebase alloc]initWithUrl:tempURL];
    
    [FremoveChild observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        
        NSString* foodValue= snapshot.value;
        (total)-=[foodValue doubleValue];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%.2f", total]];
    }];
    
    return cell;
    
    
}




- (IBAction)addUser:(id)sender {
    NSString* name = [self.personField text];
    
    
    if([name length]>0){
        
        
        NSString* temp = [NSString stringWithFormat:@"%@%@", self.url, name];
        
        Firebase* f = [[Firebase alloc] initWithUrl:temp];
        
        // Write data to Firebase
        [[f childByAppendingPath:@"tax"] setValue:[NSNumber numberWithDouble:0]];
        [[f childByAppendingPath:@"tip"] setValue:[NSNumber numberWithDouble:0]];
        
        [self.personField resignFirstResponder]; // if add button is pressed then it also hides the keyboard
        [self.tableView reloadData]; //you want to reload the tableview once you add a user
        self.personField.text=nil;
        
    }
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
    if ([segue.identifier isEqualToString:@"JoinUserDetail"]) {
        NYUJoinTableUserDetailViewController *userDetailVC = (NYUJoinTableUserDetailViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NYUPerson *person = self.joinUsers[indexPath.row];
        userDetailVC.person = person;
        
        userDetailVC.tableID=self.tableID;
    }
    
    if([segue.identifier isEqualToString:@"joinToTax"]) {
        NYUTaxnTipViewController *bTable = (NYUTaxnTipViewController *) segue.destinationViewController;
        bTable.tableURL = self.url;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if they presss return then it hides the keyboard
    if (textField == self.personField) {
        bool success = [self.personField resignFirstResponder];
        return success;
    }else {
        return NO;
    }
    
    
}



@end
