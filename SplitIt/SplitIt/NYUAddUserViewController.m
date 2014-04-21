//
//  NYUAddUserViewController.m
//  SplitIt
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUAddUserViewController.h"

@interface NYUAddUserViewController () <UITableViewDelegate, UITableViewDelegate>

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString * name = self.users[indexPath.row];
    NSLog(@"%@",name);
    [cell.textLabel setText:name];
    
    return cell;
    
    
    
}


- (IBAction)addUserPerson:(id)sender {
    
    NSString* name = [self.personName text];
    
    [self.users addObject:name]; //Adds the user to the array
    
    
    NSLog(@"%@",name);
    [self.personName resignFirstResponder]; // if add button is pressed then it also hides the keyboard
    [self.tableView reloadData]; //you want to reload the tableview once you add a user
    self.personName.text=nil;
    
    
}
@end
