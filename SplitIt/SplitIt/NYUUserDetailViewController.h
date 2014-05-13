//
//  NYUUserDetailViewController.h
//  SplitIt
//
//  Created by Shalin Shah on 4/22/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYUfoodDetails.h"

@class NYUPerson;

@interface NYUUserDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *foodNameField;
@property (weak, nonatomic) IBOutlet UITextField *foodPriceField;
@property (strong, nonatomic) IBOutlet NSMutableString *url;
@property (nonatomic, weak) NYUPerson *person;

- (IBAction)addFoodButton:(id)sender;



@end
