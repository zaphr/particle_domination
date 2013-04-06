//
//  WobbleMove.h
//  ParticleTest
//
//  Created by gb on 6/04/13.
//  Copyright 2013 gb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// HelloWorldLayer
@interface WobbleMove : CCLayer
{
    CCSprite *_sun;
    CGPoint playerVelocity;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@property (strong)CCSprite *sun;

@end