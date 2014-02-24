//
//  Ship.h
//  Fleet
//
//  Created by Nicholas Beers on 2/20/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import "SpriteObject.h"

@interface Ship : SpriteObject

+ (Ship *) shipAtPosition:(CGPoint) position;

@end
