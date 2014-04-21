//
//  NYUViewController.h
//  SplitIt
//
//  Created by Jaimin Doshi on 4/5/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYUViewController : UIViewController{

    NSMutableArray* randomInt;
    
    NSMutableString* urlWithID;
    NSNumber *tableNumber;
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *tableID;
- (IBAction)joinTableButton:(id)sender;



@end
