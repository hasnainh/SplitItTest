//
//  NYUViewController.h
//  SplitIt
//
//  Created by Jaimin Doshi on 4/5/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYUViewController : UIViewController

@property (nonatomic,strong)NSMutableArray* randomInt;
@property (nonatomic,strong)NSMutableString* urlWithID;
@property (nonatomic,strong)NSNumber *tableNumber;


@property (weak, nonatomic) IBOutlet UITextField *tableID;




@end
