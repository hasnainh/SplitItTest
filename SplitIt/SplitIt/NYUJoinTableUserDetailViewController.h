//
//  NYUJoinTableUserDetailViewController.h
//  SplitIt
//
//  Created by Shalin Shah on 5/9/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NYUPerson;
@interface NYUJoinTableUserDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *foodNameField;
@property (weak, nonatomic) IBOutlet UITextField *foodPriceField;
@property (weak, nonatomic) IBOutlet UITextField *userTotal;
@property (nonatomic,strong) NSString * tableID;
@property (strong, nonatomic) IBOutlet NSMutableString *url;
@property (nonatomic, weak) NYUPerson *person;
@end

