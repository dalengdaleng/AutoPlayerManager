//
//  AudioPlayerManager.h
//  JusAuto
//
//  Created by ju on 2017/2/24.
//  Copyright © 2017年 ju. All rights reserved.
//  自动管理的语音播报

#import <Foundation/Foundation.h>

@interface AudioPlayerManager : NSObject
+ (instancetype)sharedInstance;

//麦克风
- (void)micoroPermission;

//传入mp3的文件名字
- (void)play:(NSString *)aName type:(NSString *)aType;

//暂停
- (void)pause;

//停止
- (void)stop;

- (void)prepareToPlay;
@end
