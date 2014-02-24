//
//  Ship.m
//  Fleet
//
//  Created by Nicholas Beers on 2/20/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import "Ship.h"

@implementation Ship

+ (Ship *) shipAtPosition: (CGPoint) position {
    Ship *ship = [[Ship alloc] initWithImageNamed:@"Spaceship"];
    ship.name = @"spaceship";
    ship.anchorPoint = CGPointMake(0.5, 0.5);
    ship.position = position;
    ship.zPosition = 90;
    [ship setScale:0.2];
    
    return ship;
}

- (id) initWithImageNamed:(NSString *)name {
    if(self = [super initWithImageNamed:name]){
        
    }
    return self;
}
@end
