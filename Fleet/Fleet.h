//
//  Fleet.h
//  Fleet
//
//  Created by Nicholas Beers on 2/20/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovableAndRotatable.h"

@class Ship;

@interface Fleet : NSObject <MovableAndRotatable>

+ (Fleet *) fleetWithLeadShip:(Ship *) ship;
- (void) spawnNewShip;

@end
