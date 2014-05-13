//
//  NYUFinalReceiptViewController.h
//  SplitIt
//
//  Created by Jaimin Doshi on 5/11/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYUFinalReceiptViewController : UIViewController
@property (strong,nonatomic) NSMutableString * tableURL;
@property (strong,nonatomic) NSMutableArray * users;
@property (weak, nonatomic) IBOutlet UITextField *taxBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *showFinalTotal;
@property (weak, nonatomic) IBOutlet UITextField *tipBox;

@property (weak, nonatomic) IBOutlet UITextField *actualFinalTotal;


//@property (strong,nonatomic) NSInteger * finalWithTip1;
@property (nonatomic) double  finalTotal;

@end
