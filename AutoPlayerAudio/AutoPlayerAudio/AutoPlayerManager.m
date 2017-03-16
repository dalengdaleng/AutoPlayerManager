//
//  AutoPlayerManager.m
//  JusAuto
//
//  Created by ju on 2017/3/1.
//  Copyright © 2017年 ju. All rights reserved.
//

#import "AutoPlayerManager.h"
#import "AudioPlayerManager.h"
#import "AudioPlayerTextMangager.h"
#import <AVFoundation/AVAudioSession.h>

static timerCount = 5;

@interface AutoPlayerManager()<AudioTextPlayerProtocol>
//自动接听定时器
@property (nonatomic, strong) NSTimer *autoRingTime;
@property (nonatomic, assign) NSInteger timerCount;

@property (nonatomic, strong) NSTimer *countTimer;
@end

@implementation AutoPlayerManager
+ (instancetype)sharedInstance
{
    static AutoPlayerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance)
        {
            instance = [[AutoPlayerManager alloc] init];
        }
    });
    return instance;
}

- (void)startSpeaker
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    //            [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
}

//自动播报定时器
- (void)startRingTimer
{
    self.isCallkitRing = YES;
            
        [self startSpeaker];
    
    [self stopRingTimer];
    
    if(!self.autoRingTime)
    {
        self.timerCount = 6;
        self.autoRingTime = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(ringAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.autoRingTime forMode:NSRunLoopCommonModes];
    }
}

- (void)ringAction:(NSTimer *)timer {
    self.timerCount -= 1;
    NSString *ringText = nil;
    if(self.timerCount == 5)//太难计算
    {
        ringText = [NSString stringWithFormat:@"test it"];
        [[AudioPlayerTextMangager sharedInstance] setIsStop:NO];
        [[AudioPlayerTextMangager sharedInstance] audioSession];
        [[AudioPlayerTextMangager sharedInstance] setDelegate:self];
        [[AudioPlayerTextMangager sharedInstance] audioPlayer:ringText];
        timerCount = 5;
    }
    else if(self.timerCount < 0)
    {
        [self stopRingTimer];
    }
}

- (void)stopRingTimer
{
    if(self.autoRingTime)
    {
        [self.autoRingTime invalidate];
        self.autoRingTime = nil;
    }
}

- (NSString *)playString:(NSInteger)aCount
{
    NSString *countPlay = nil;
    switch (aCount) {
        case 5:
            countPlay = @"5";
            break;
        case 4:
            countPlay = @"4";
            break;
        case 3:
            countPlay = @"3";
            break;
        case 2:
            countPlay = @"2";
            break;
        case 1:
            countPlay = @"1";
            break;
            
        default:
            break;
    }
    return countPlay;
}

- (void)textPlayerFinised
{
    if([[AudioPlayerTextMangager sharedInstance] isStop])
    {
        return;
    }
    [[AudioPlayerTextMangager sharedInstance] audioSession];
    [[AudioPlayerTextMangager sharedInstance] setDelegate:self];
    [[AudioPlayerTextMangager sharedInstance] audioPlayer:[self playString:timerCount]];
    
    timerCount--;
    if(timerCount < 0)
    {
        [[AudioPlayerTextMangager sharedInstance] setDelegate:nil];
        //
        [[AudioPlayerManager sharedInstance] stop];//停止播放语音
//        
//        if(self.delegate && [self.delegate respondsToSelector:@selector(autoAnswerCall:)])
//        {
//            [self.delegate autoAnswerCall:self.callKit];
//        }
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
}
@end
