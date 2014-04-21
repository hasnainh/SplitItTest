//
//  NYUViewController.m
//  SplitIt
//
//  Created by Jaimin Doshi on 4/5/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUViewController.h"
#import "NYUJoinTableViewController.h"

#import <limits.h>
#import <Firebase/Firebase.h>

@interface NYUViewController ()



@end

@implementation NYUViewController

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"joinTableSegue"])
    {
        NYUJoinTableViewController * aTable = (NYUJoinTableViewController *) segue.destinationViewController;
        aTable.tableID = self.tableID.text;
    }
}

-(IBAction)generateRandomInt:(id)sender {
    int randomIndex= arc4random() % [randomInt count];
    NSNumber* remove= [randomInt objectAtIndex:randomIndex];
    [randomInt removeObjectAtIndex:randomIndex];
    
    tableNumber=remove; //This is to set the const table number
    
    
    [urlWithID appendString:[NSString stringWithFormat:@"%@", remove]];
    //NSLog(urlWithID);

    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if they presss return then it hides the keyboard
    if (textField == self.tableID) {
        bool success = [self.tableID resignFirstResponder];
        return success;
    }else {
        return NO;
    }
    
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //IF they touch anywhere else it hides the keyboard
    [self.tableID resignFirstResponder];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    randomInt= [[NSMutableArray alloc]init];
    for(int i=0; i<100; i++){
        [randomInt addObject:[NSNumber numberWithInt:i]];
    }
    
    urlWithID= [[NSMutableString alloc]initWithString:@"https://cs394.firebaseio.com/"];
    
    
    
//    // Create a reference to a Firebase location
//    Firebase* f = [[Firebase alloc] initWithUrl:@"https://cs394.firebaseio.com/"];
//
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)joinTableButton:(id)sender {
    
    NSString * tableID= self.tableID.text;
    [self.tableID resignFirstResponder];
    [self performSegueWithIdentifier:@"joinTableSegue" sender:tableID];
}
@end
