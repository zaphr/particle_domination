//
//  WinLayer.m
//  ParticleTest
//
//  Created by gb on 10/03/13.
//  Copyright 2013 gb. All rights reserved.
//

#import "WinLayer.h"
#import "HelloWorldLayer.h"


@implementation WinLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    
	
	// 'layer' is an autorelease object.
	WinLayer *layer = [WinLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        [self showBackgroundParticle];
        [self showMessage];

        [self performSelector:@selector(nextScene) withObject:nil afterDelay:5.0];
        
        
	}
	return self;
}

- (void)nextScene{
 	  [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:0.5 scene:[HelloWorldLayer scene] ]];
}

- (void)showBackgroundParticle{
    CCParticleSystemQuad *bgParticle = [CCParticleSystemQuad particleWithFile:@"backgroundParticle3.plist"];
        CGSize size = [[CCDirector sharedDirector] winSize];
        bgParticle.position = ccp(size.width /2 , size.height/2 );
    [self addChild:bgParticle];
}

- (void)showMessage{
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Win!!!" fontName:@"Marker Felt" fontSize:64];

    CGSize size = [[CCDirector sharedDirector] winSize];
    label.position =  ccp( size.width /2 , size.height/2 );

    // add the label as a child to this Layer
    [self addChild: label];    

}


@end
