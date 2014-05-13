//
//  NYUTaxnTipViewController.m
//  SplitIt
//
//  Created by Jaimin Doshi on 4/27/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUTaxnTipViewController.h"
#import <Firebase/Firebase.h>
#import "NYUFinalReceiptViewController.h"

@interface NYUTaxnTipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *showTax;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *displayTipValue;
@property (weak, nonatomic) IBOutlet UILabel *tipPercentage;
@property (weak, nonatomic) IBOutlet UITextField *b;
@property (weak, nonatomic) IBOutlet UITextField *showTotal;


@end

@implementation NYUTaxnTipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)tipSliderValue:(id)sender {
    double total= [self.showTotal.text doubleValue];
    double valueOfTipSlider = roundf(self.tipSlider.value);
    NSString* convertValueOfTipSlider = [NSString stringWithFormat:@"%.2f%%", valueOfTipSlider];
    [self.tipPercentage setText:convertValueOfTipSlider];
    double tip  = valueOfTipSlider/100;
    double tipValue = (total*tip);
    NSString* convertValueOfSlider = [NSString stringWithFormat:@"$%0.2f", tipValue];
    [self.displayTipValue setText:convertValueOfSlider];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tipSlider.minimumValue = 0;
    _tipSlider.maximumValue = 100;
    [self.tipSlider setValue:5.0];
    _finalTotal = 0.0;
    // Do any additional setup after loading the view.
    //NSLog(_tableURL);
    //Firebase* f=
    //-------------- Look into a child of child to add all the values of the users! does it live!
    __block double total=0;
    __block double tax = 0;
    __block double tip = 0;
    Firebase* f1=[[Firebase alloc]initWithUrl:_tableURL];
    if (f1) {
        [f1 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            
            NSString* foodValue= [NSString stringWithFormat:@"%@/%@/",_tableURL, snapshot.name];
            //NSLog(foodValue);
            //--------
            
            Firebase* f2=[[Firebase alloc]initWithUrl:foodValue];
            [f2 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
                
                if(![snapshot.name isEqualToString:@"tax"] && ![snapshot.name isEqualToString:@"tip"]){
                    
                    NSString* foodValue= snapshot.value;
                    (total)+=[foodValue doubleValue];
                    //NSLog(@"%f",total);
                    [self.showTotal setText:[NSString stringWithFormat:@"%0.2f", total]];
                    
                }
                else if([snapshot.name isEqualToString:@"tax"]){
                    tax=[snapshot.name doubleValue];
                    [self.showTax setText:[NSString stringWithFormat:@"%.2f%%", ([snapshot.value doubleValue]*100)]];
                    
                }
                else if([snapshot.name isEqualToString:@"tip"]){
                    tip=[snapshot.name doubleValue];
                    [self.displayTipValue setText:[NSString stringWithFormat:@"$%0.2f", [snapshot.value doubleValue]]];
                    [_tipSlider setValue:[snapshot.value doubleValue] animated:YES];
                }

            }];
            
            Firebase* f3=[[Firebase alloc]initWithUrl:foodValue];
            [f3 observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
                
                if(![snapshot.name isEqualToString:@"tax"] && ![snapshot.name isEqualToString:@"tip"]){
                    
                    NSString* foodValue= snapshot.value;
                    (total)-=[foodValue doubleValue];
                    //NSLog(@"%f",total);
                    [self.showTotal setText:[NSString stringWithFormat:@"%0.2f", total]];
                }
            }];
            
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //IF they touch anywhere else it hides the keyboard
    [self.view endEditing:YES];
}



- (IBAction)updateTotal:(id)sender {
    double totalBox= [self.showTotal.text doubleValue];
    __block double taxBox= [self.showTax.text doubleValue]/100;
    //double finalWithTax= totalBox + (totalBox*taxBox);
    double valueOfTipSlider = roundf(self.tipSlider.value);
    double tipSlider  = valueOfTipSlider/100;
    double finalWithTip = totalBox +(totalBox*tipSlider) + (totalBox*taxBox);
    _finalTotal=finalWithTip;
    
    [self.b setText:[NSString stringWithFormat:@"$%0.2f",finalWithTip]];
    __block double tipValue = totalBox * tipSlider;
    Firebase* updateTax=[[Firebase alloc]initWithUrl:self.tableURL];
    [updateTax observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        
        NSString* temp= [NSString stringWithFormat:@"%@/%@/",_tableURL, snapshot.name];
        Firebase* updateTax2=[[Firebase alloc]initWithUrl:temp];
        //        [updateTax2 observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        //            //[updateTax2 updateChildValues:@{@"tax": @[@"%0.2f" ,taxBox]}];
        //
        //
        //        }];
        [updateTax2 updateChildValues:@{@"tax": [NSNumber numberWithDouble:taxBox]}];
        [updateTax2 updateChildValues:@{@"tip": [NSNumber numberWithDouble:tipValue]}];
    }];
    
    
}

// Seguing to NYUFinalRecipt...

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"finalView"])
    {
        NYUFinalReceiptViewController* bTable = (NYUFinalReceiptViewController *) segue.destinationViewController;
        bTable.tableURL = self.tableURL;
        bTable.finalTotal = self.finalTotal;
    }
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
