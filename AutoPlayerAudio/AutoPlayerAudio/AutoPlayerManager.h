//
//  AutoPlayerManager.h
//  JusAuto
//
//  Created by ju on 2017/3/1.
//  Copyright © 2017年 ju. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CallKitManager.h"

@protocol AutoPlayerManagerProtocol <NSObject>



@end

@interface AutoPlayerManager : NSObject
@property (nonatomic, weak) id<AutoPlayerManagerProtocol>delegate;
@property (nonatomic, assign) BOOL isCallkitRing;

+ (instancetype)sharedInstance;

- (void)startRingTimer;
- (void)stopRingTimer;

- (void)startSpeaker;

@end
