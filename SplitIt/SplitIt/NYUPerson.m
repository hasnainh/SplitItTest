//
//  NYUPerson.m
//  SplitIt
//
//  Created by Shalin Shah on 4/22/14.
//  Copyright (c) 2014 Jaimin Doshi. All rights reserved.
//

#import "NYUPerson.h"

@implementation NYUPerson

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.foodItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
