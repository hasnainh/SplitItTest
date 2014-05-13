//
//  NYUAddUserViewController.h
//  SplitIt
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NYUAddUserViewController : UIViewController

@property (strong,nonatomic) NSMutableString * url;
@property (strong,nonatomic) NSMutableArray * users;

@property (weak, nonatomic) IBOutlet UITextField *personName;
- (IBAction)addUserPerson:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSNumber * tableNumber;

@end
