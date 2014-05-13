//
//  NYUViewController.m
//  SplitIt
//
//  Created by Jaimin Doshi on 4/5/14.
//  Created by Shalin Shah on 4/5/14.
//  Created by Hasnain Hossain on 4/5/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUViewController.h"
#import "NYUJoinTableViewController.h"
#import "NYUUserDetailViewController.h"
#import "NYUAddUserViewController.h"
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
    //createTableSegue
    
    if([segue.identifier isEqualToString:@"createTableSegue"])
    {
        NYUAddUserViewController * bTable = (NYUAddUserViewController *) segue.destinationViewController;
        bTable.tableNumber = self.tableNumber;
    }
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
- (IBAction)join:(id)sender {
    if ([_tableID.text length]>0) {
        NSString * tableID= self.tableID.text;
        //        Firebase* f = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", _urlWithID, tableID]];
        //        [f observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //            if(!(snapshot.value == [NSNull null])) {
        //                //NSLog(@"Table does exist");
        //                //[_joinTableButton setEnabled:YES];
        //                [self.tableID resignFirstResponder];
        //                [self performSegueWithIdentifier:@"joinTableSegue" sender:tableID];
        //
        //            }
        //        }];
        [self.tableID resignFirstResponder];
        [self performSegueWithIdentifier:@"joinTableSegue" sender:tableID];
        
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //IF they touch anywhere else it hides the keyboard
    [self.tableID resignFirstResponder];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SplitIt!";
	// Do any additional setup after loading the view, typically from a nib.
    self.randomInt= [[NSMutableArray alloc]init];
    for(int i=0; i<100; i++){
        [self.randomInt addObject:[NSNumber numberWithInt:i]];
    }
    
    self.urlWithID= [[NSMutableString alloc]initWithString:@"https://cs394.firebaseio.com/"];
    
    
    
    

//
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)create:(id)sender {
    int randomIndex= arc4random() % [self.randomInt count];
    NSNumber* remove= [self.randomInt objectAtIndex:randomIndex];
    [self.randomInt removeObjectAtIndex:randomIndex];
    
    self.tableNumber=remove; //This is to set the const table number
    
    
    [self.urlWithID appendString:[NSString stringWithFormat:@"%@", remove]];
    //    self.urlWithID = [[NSMutableString alloc]initWithString:@"https://splitbill.firebaseio.com/"];
    //    [self.urlWithID appendString:[NSString stringWithFormat:@"%@/TaxTip/", self.tableNumber]];
    //    Firebase* f1=[[Firebase alloc]initWithUrl:_urlWithID];
    //    [[f1 childByAppendingPath:[NSString stringWithFormat:@"Tax"]] setValue:[NSNumber numberWithDouble:0]];
    //    [[f1 childByAppendingPath:[NSString stringWithFormat:@"Tip"]] setValue:[NSNumber numberWithDouble:0]];
    [self performSegueWithIdentifier:@"createTableSegue" sender:remove];
}

@end
