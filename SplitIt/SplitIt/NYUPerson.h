//
//  NYUPerson.h
//  SplitIt
//
//  Created by Shalin Shah on 4/22/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYUPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *foodItems;
@property (nonatomic, strong) NSString* tableNumber;

- (id)initWithName:(NSString *)name;

@end
