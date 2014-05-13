//
//  NYUJoinTableViewController.h
//  SplitIt
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYUJoinTableViewController : UIViewController <UITableViewDataSource>

@property (nonatomic,strong) NSString * tableID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableString * url;
@property (strong,nonatomic)  NSMutableArray * joinUsers;
@property (weak, nonatomic) IBOutlet UITextField *personField;


@end
