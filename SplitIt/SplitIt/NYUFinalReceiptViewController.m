//
//  NYUFinalReceiptViewController.m
//  SplitIt
//
//  Created by Jaimin Doshi on 5/11/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUFinalReceiptViewController.h"
#import <Firebase/Firebase.h>



@interface NYUFinalReceiptViewController ()
@end

@implementation NYUFinalReceiptViewController

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
    //[self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	//[firebase removeObserverWithHandle:(childAddedObserverHandle)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Final Receipt";
    // Do any additional setup after loading the view.
    //NSLog(_tableURL);
    _users=[[NSMutableArray alloc]init];
    __block double total=0;
    __block double tax=0;
    __block double tip=0;
    Firebase* firebase =[[Firebase alloc]initWithUrl:_tableURL];
    [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        //add name to the array
        [self.users addObject:snapshot.name];
        [self.tableView reloadData];
        
        Firebase* firebase2= [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"%@%@", _tableURL, snapshot.name]];
        [firebase2 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            if (![snapshot.name isEqualToString:@"tax"] && ![snapshot.name isEqualToString:@"tip"] ) {
                total+=[snapshot.value doubleValue];
                [self.showFinalTotal setText:[NSString stringWithFormat:@"$%0.2f", total]];
            }
            else if([snapshot.name isEqualToString:@"tax"]){
                tax=[snapshot.name doubleValue];
                [self.taxBox setText:[NSString stringWithFormat:@"%.2f%%", ([snapshot.value doubleValue]*100)]];

            }
            else if([snapshot.name isEqualToString:@"tip"]){
                tip=[snapshot.name doubleValue];
                [self.tipBox setText:[NSString stringWithFormat:@"$%0.2f", [snapshot.value doubleValue]]];
            }
            //[self.actualFinalTotalBox setText:[NSString stringWithFormat:@"%0.2f",((total)+(total*tax)+tip)]];
            

        }];
        
        Firebase* firebase3= [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"%@%@", _tableURL, snapshot.name]];
        [firebase3 observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
            if (![snapshot.name isEqualToString:@"tax"] && ![snapshot.name isEqualToString:@"tip"] ) {
                total-=[snapshot.value doubleValue];
                [self.showFinalTotal setText:[NSString stringWithFormat:@"$%0.2f", total]];
            }
            //[self.actualFinalTotalBox setText:[NSString stringWithFormat:@"%0.2f",((total)+(total*tax)+tip)]];
        }];
        NSLog(@"%f",total);
//        [self.actualFinalTotalBox setText:[NSString stringWithFormat:@"%0.2f",((total)+(total*tax)+tip)]];
//
        
        
    }];
    //[self.actualFinalTotalBox setText:[NSString stringWithFormat:@"$%0.2f", ([self.showFinalTotal.text doubleValue]+(([self.taxBox.text doubleValue]/100)*[self.showFinalTotal.text doubleValue])+[self.tipBox.text doubleValue])]];
    
    
    
    Firebase* firebase2= [[Firebase alloc]initWithUrl:_tableURL];
    [firebase2 observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        [self.users removeObject:snapshot.name];
        [self.tableView reloadData];
                 }];
    [self.actualFinalTotal setText:[NSString stringWithFormat:@"$%0.2f",_finalTotal]];
}

#pragma mark - UITableView Data Source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.users count];
}

-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"allUsers";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",self.users[indexPath.row]]];

    __block double total=0;
    NSString* tempURL=[NSString stringWithFormat:@"%@%@",_tableURL,self.users[indexPath.row]];

    // Calculates the total for each person and puts their total in the detail text label
    
    Firebase* f1=[[Firebase alloc]initWithUrl:tempURL];
    
    [f1 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if (![snapshot.name isEqualToString:@"tax"] && ![snapshot.name isEqualToString:@"tip"] ) {
            NSString* foodValue= snapshot.value;
            (total)+=[foodValue doubleValue];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%.2f", total]];
        }
        else{
            if ([snapshot.name isEqualToString:@"tax"]){
                double y= [snapshot.value doubleValue]*total;
                total+=y;
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%.2f", total]];

                
            }
            
            else if([snapshot.name isEqualToString:@"tip"]){
                double x= [snapshot.value doubleValue]/[self.users count];
                //NSLog(@"%0.2f",x);
                total+=x;
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%.2f", total]];

            }
            
        }
        
        
    }];
    

    
    return cell;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
