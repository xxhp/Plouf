//
//  FishAnimated.m
//  ProtoMesh2
//
//  Created by Clément RUCHETON on 10/05/11.
//  Copyright 2011 Plouf. All rights reserved.
//

#import "FishAnimated.h"


@implementation FishAnimated
@synthesize eye,hit,body,wound,listen;

-(void)dealloc
{
    [self stopAllActions];
    [body release];
    [eye release];
    [hit release];
    [super dealloc];
}

+(id) fishWithName:(NSString*)name
{
    return [[[FishAnimated alloc] initWithFishName:name] autorelease];
}

-(id) initWithFishName:(NSString*)name
{
    self = [super init];
    
    if(self)
    {
        self.listen = YES;
        
        self.eye = [AnimationHelper animationWithName:name andOption:@"Eye" frameNumber:9];
        self.hit = [AnimationHelper animationWithName:name andOption:@"Aie" frameNumber:9];
        self.hit.visible = NO;
        
        self.body = [AnimationHelper animationWithName:name andOption:@"" frameNumber:9];
        self.body.listen = self.listen;
        
        self.body.delegate = self;
        self.eye.delegate = self;
        self.hit.delegate = self;
        
        [self addChild:self.body z:0 tag:0];
        [self addChild:self.eye z:1 tag:1];
        [self addChild:self.hit z:2 tag:2];
                
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationComplete) name:@"animationComplete" object:nil];
        
        [self.body runAction:self.body.action];
        [self.eye runAction:self.eye.action];
        [self.hit runAction:self.hit.action];
        [[CCActionManager sharedManager] pauseTarget:self.hit];
    }
    
    return self;
}

-(void)stopAllActions
{
    
    self.listen = NO;
    CCLOG(@"stopAllActions !!!!!!");
    [[CCActionManager sharedManager] pauseTarget:self];
    
    [[CCActionManager sharedManager] pauseTarget:self.body];
    [self.body setListen:self.listen];
    
    [[CCActionManager sharedManager] pauseTarget:self.hit];
    [self.hit setListen:self.listen];
    
    [[CCActionManager sharedManager] pauseTarget:self.eye];
    [self.eye setListen:self.listen];
    
    
    [super stopAllActions];
}

-(void)punch
{
    self.body.visible = NO;
    self.eye.visible = NO;
    
    [[CCActionManager sharedManager] pauseTarget:self.body];
    [[CCActionManager sharedManager] pauseTarget:self.eye];
    [[CCActionManager sharedManager] resumeTarget:self.hit];

    self.hit.visible = YES;
    
    
    [self.hit setListen:self.listen];
    
    self.wound = YES;
}

-(void)animationComplete
{
    if(!self.wound)
    {
        self.body.visible = YES;
        self.eye.visible = YES;
        self.hit.visible = NO;
        
        self.body.listen = self.listen;
        self.hit.listen = NO;
        
        [self changeEyes];
        
        [[CCActionManager sharedManager] resumeTarget:self.body];
        [[CCActionManager sharedManager] resumeTarget:self.eye];
        [[CCActionManager sharedManager] pauseTarget:self.hit];
    }
    
    self.wound = NO;
}

-(void)changeEyes
{
    int rd = rand() % 100 ;
    if(rd > 75)
    {
        self.eye.visible = NO;
    }
    else
    {
        self.eye.visible = YES;
    }
}

-(void) setFlipX:(BOOL)flip
{
    for (uint i = 0; i < [[self children] count]; i++) 
    {
        [[[self children] objectAtIndex:i] setFlipX:flip];
    }
}

@end
