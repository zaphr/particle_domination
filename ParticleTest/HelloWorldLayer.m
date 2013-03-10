//
//  HelloWorldLayer.m
//  ParticleTest
//
//  Created by gb on 10/03/13.
//  Copyright gb 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "WinLayer.h"

#pragma mark - HelloWorldLayer

#define MAX_LEVEL_SCORE 1000

// HelloWorldLayer implementation
@implementation HelloWorldLayer{
    BOOL _userStart;
    BOOL _finished;
    CCSprite *_background;
    CCSprite *_pbExport;
    CCSprite *_eye;
    int _score;
    CCLabelTTF *_scoreDisplay;
    
}



-(void) update:(ccTime)delta
{

    if (_userStart && !_finished){
      [self updateScore];
      [self updateScoreDisplay];
    }
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
        
        self.touchEnabled = YES;
        _userStart = NO;
        _finished = NO;
        _score = 0;
        
//        _background = [CCSprite spriteWithFile:@"foo.jpg"];
//        _background.scale = 4.0;
//
//        [self addChild:_background z:-1];
		
        [self showPlayer];
        [self showBackgroundParticle];
        [self showParticle];
//        backgroundParticle
        
        
        [self showMessage];
//        [self zoomInPlayer];
        [self scheduleUpdate];

	}
	return self;
}

#pragma mark - handle touches
-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void)setPlayerPosition:(CGPoint)position {
	_sun.position = position;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_finished) return;
    
    _userStart = YES;
    CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
//    float duration = ccpDistance(_sun.position, touchLocation) / 400;
//    [self.sun stopAllActions];
    [self.sun runAction:[CCMoveTo actionWithDuration:0.5 position:touchLocation]];
}

- (CGPoint)randomLocation{
    CGSize size = [[CCDirector sharedDirector] winSize];
//    arc4random() % (int)screenWidth;
    return ccp(CCRANDOM_0_1() * size.width, CCRANDOM_0_1() * size.height);
//    return ccp(arc4random() % (int)size.width, arc4random() % (int)size.height);
}

- (void)showPlayer{
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.sun = (CCSprite*)[[CCParticleSun alloc] init];
    self.sun.position = ccp( size.width /2 , size.height/2 );
    [self addChild:self.sun];

        _eye = [CCSprite spriteWithFile:@"aurium_blue_iris.png"];
    
//    CCSprite *eye = [CCSprite spriteWithFile:@"Anonymous_Blue_Eye.png"];
    _eye.scale = 0.05;
    [self.sun addChild:_eye];
}

- (void)moveParticleToRandom
{
    CGPoint destination = [self randomLocation];
  [_pbExport runAction:[CCMoveTo actionWithDuration:2.0 position:destination]];
}

- (void)showParticle{

    CGSize size = [[CCDirector sharedDirector] winSize];
    _pbExport = (CCSprite*)[CCParticleSystemQuad particleWithFile:@"pd_export1.plist"];
    _pbExport.position = ccp( size.width /2 , size.height/2 );
    [self addChild:_pbExport];


    id delay = [CCDelayTime actionWithDuration:2.01];
    id moveToRandom = [CCCallBlock actionWithBlock:^{
        [self moveParticleToRandom];
    }];
    
    
    id sequence = [CCSequence actions:moveToRandom,delay,nil];
    
    CCAction *repeatForEver = [CCRepeatForever actionWithAction:sequence];
 
    [_pbExport runAction:repeatForEver];
    
}

- (CGPoint)screenCenter{
    CGSize size = [[CCDirector sharedDirector] winSize];
    return ccp(size.width / 2, size.height / 2);
}

- (void)showBackgroundParticle{
    CGSize size = [[CCDirector sharedDirector] winSize];
        CCParticleSystemQuad *bgParticle = [CCParticleSystemQuad particleWithFile:@"big_vortex.plist"];
//    CCParticleSystemQuad *bgParticle = [CCParticleSystemQuad particleWithFile:@"backgroundParticle2.plist"];
    
    bgParticle.position = ccp(size.width /2 , size.height/2 );
    [self addChild:bgParticle];
}

- (void)updateScore{
    float distanceApart = ccpDistance(_sun.position, _pbExport.position);
//    NSLog(@"%f", distanceApart);
    if (distanceApart < 50){
        _score = _score + 10;
    } else if (_score > 0) {
        _score--;
    }
    
    if (_score >= MAX_LEVEL_SCORE){
        _score = MAX_LEVEL_SCORE;
        _userStart = NO;
        _finished = YES;
        [self endDance];
        
    }
}

- (void)endDance{
    
//    [self.sun runAction:[CCMoveTo actionWithDuration:0.5 position:[self screenCenter]]];
    
    [self.sun stopAllActions];
    CCParticleSun *sunParticle = (CCParticleSun *) self.sun;
    [sunParticle stopSystem];
    [self removeChild:_pbExport];
    
    
    id dance = [CCSequence actions:
                   [CCMoveTo actionWithDuration:0.5 position:[self screenCenter]],
                   [CCScaleBy actionWithDuration:2.0f scale:30.0],
                   [CCCallBlock actionWithBlock:^{
//        [sunParticle scheduleUpdate];
        
    }],
//                [CCDelayTime actionWithDuration:2.0],
                [CCCallBlock actionWithBlock:^{
        [self nextScene];
        
    }]
                   , nil];
    
    
    [self.sun runAction:dance];
    
}

- (void)nextScene{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[WinLayer scene]]];
}

- (void)showMessage{		// create and initialize a Label
    CGSize size = [[CCDirector sharedDirector] winSize];
    _scoreDisplay = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:32];
    int margin = 50;
    _scoreDisplay.position =  ccp( _scoreDisplay.contentSize.width /2 + margin , size.height - _scoreDisplay.contentSize.height/2 - margin);
    _scoreDisplay.anchorPoint = ccp(0, 0.5);
    [self addChild: _scoreDisplay];
    [self updateScoreDisplay];
}

- (void)updateScoreDisplay{
    [_scoreDisplay setString:[NSString stringWithFormat:@"%d / %d", _score, MAX_LEVEL_SCORE]];
}


@end
