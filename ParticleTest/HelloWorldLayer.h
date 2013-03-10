//
//  HelloWorldLayer.h
//  ParticleTest
//
//  Created by gb on 10/03/13.
//  Copyright gb 2013. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer 
{
    CCSprite *_sun;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@property (strong)CCSprite *sun;

@end
