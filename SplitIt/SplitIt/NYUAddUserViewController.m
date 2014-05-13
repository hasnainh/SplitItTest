//
//  NYUAddUserViewController.m
//  SplitIt
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUAddUserViewController.h"
#import "NYUUserDetailViewController.h"
#import "NYUTaxnTipViewController.h"
#import <Firebase/Firebase.h>
#import "NYUPerson.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface NYUAddUserViewController () <UITableViewDelegate, UITableViewDelegate> {
    Firebase *firebase;
    Firebase *firebase2;

}
@property (weak, nonatomic) IBOutlet UITextField *showTableNumber;

@end

@implementation NYUAddUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.users = [[NSMutableArray alloc]init]; // allocating the users array
    
    self.navigationItem.hidesBackButton = YES;
    NSLog(@"%d",self.tableNumber.intValue);
    //[self.showTableNumber setText:[NSString stringWithFormat:@"Table number: %@", _tableNumber]];
    self.title = [NSString stringWithFormat:@"Table #%@",self.tableNumber];
    self.url = [[NSMutableString alloc]initWithString:@"https://splitbill.firebaseio.com/"];
    [self.url appendString:[NSString stringWithFormat:@"%@/", self.tableNumber]];
    firebase =[[Firebase alloc]initWithUrl:_url];
    [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        //add name to the array
        NYUPerson *person = [[NYUPerson alloc] initWithName:snapshot.name];
        [self.users addObject:person];

        [self.tableView reloadData];
    }];
    //Remove child from database then also need to remove it from the array
    firebase2 = [[Firebase alloc]initWithUrl:self.url];
    [firebase2 observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot* snapshot){
        //NSLog(self.person);
        NYUPerson *personToRemove = nil;
        for (int i=0; i<[self.users count]; i++){
			NYUPerson *currentPersonDetails = [self.users objectAtIndex:i];
            if ([currentPersonDetails.name isEqualToString:snapshot.name]){
                personToRemove = currentPersonDetails;
				break;
            }
        }
		if (personToRemove) {
			[self.users removeObject:personToRemove];
			[self.tableView reloadData];
		}    }];
    
    
}


-(BOOL)textFieldDidBeginEditing:(UITextField*) textField {
    textField.layer.borderColor = [[UIColor blueColor]CGColor];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //This function is for removing people
    
      UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath]; //retreives the cell to be removed
      NSString* personToRemove = cell.textLabel.text;
    

      [self.users removeObjectAtIndex:indexPath.row];
    
    // If you want to remove someone you also have to remove them from the database
    Firebase* f=[[Firebase alloc]initWithUrl:_url];
    Firebase* ref=[f childByAppendingPath:personToRemove];
    if(ref)
        [ref removeValue];
    
    [tableView reloadData];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if they presss return then it hides the keyboard
    if (textField == self.personName) {
        bool success = [self.personName resignFirstResponder];
        return success;
    }else {
        return NO;
    }
    
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //IF they touch anywhere else it hides the keyboard
    [self.personName resignFirstResponder];
}

#pragma mark - UITableView Data Source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"personCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NYUPerson * person = self.users[indexPath.row];
    person.tableNumber = [NSString stringWithFormat:@"%@",self.tableNumber]; // need to convert int tableNumebr to NSString
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowUserDetail"]) {
        NYUUserDetailViewController *userDetailVC = (NYUUserDetailViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NYUPerson *person = self.users[indexPath.row];
        userDetailVC.person = person;
    }
    //------------Send url through segue
    if([segue.identifier isEqualToString:@"sendToTotal"])
    {
        NYUTaxnTipViewController *controller = (NYUTaxnTipViewController *)segue.destinationViewController;
        controller.tableURL= _url;
    }
    //------------

}
- (IBAction)addUserPerson:(id)sender {
    NSString* name = [self.personName text];
    
    
    if([name length]>0){
        
        
        NSString* temp = [NSString stringWithFormat:@"%@%@", self.url, name];
        
        Firebase* f = [[Firebase alloc] initWithUrl:temp];
        
        // Write data to Firebase
        [[f childByAppendingPath:@"tax"] setValue:[NSNumber numberWithDouble:0]];
        [[f childByAppendingPath:@"tip"] setValue:[NSNumber numberWithDouble:0]];
        
        [self.personName resignFirstResponder]; // if add button is pressed then it also hides the keyboard
        [self.tableView reloadData]; //you want to reload the tableview once you add a user
        self.personName.text=nil;
        
    }
}



//------------






@end
