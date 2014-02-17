//
//  MenuScene.m
//  Fleet
//
//  Created by Nicholas Beers on 2/15/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import "MenuScene.h"
#import "MyScene.h"

@implementation MenuScene

- (id) initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]){
        self.backgroundColor = [SKColor grayColor];
        SKLabelNode *tempText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        tempText.text = @"Welcome to Fleet";
        tempText.position = CGPointMake(self.size.width/2, self.size.height/2);
        tempText.fontColor = [SKColor orangeColor];
        tempText.fontSize = 24;
        
        [self addChild:tempText];
        
    }
    return self;
    
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKScene *myScene = [[MyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5f];
    [self.view presentScene:myScene transition:transition];
}

@end
