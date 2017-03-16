//
//  AudioPlayerManager.m
//  JusAuto
//
//  Created by ju on 2017/2/24.
//  Copyright © 2017年 ju. All rights reserved.
//

#import "AudioPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerManager()
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation AudioPlayerManager
+ (instancetype)sharedInstance
{
    static AudioPlayerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance)
        {
            instance = [[AudioPlayerManager alloc] init];
        }
    });
    return instance;
}

- (void)addNotification
{
    //注册中断通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    //注册线路改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}

- (void)micoroPermission
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            // 用户同意获取麦克风
            
        } else {
            
            // 用户不同意获取麦克风
            
        }
        
    }];
}

- (void)play:(NSString *)aName type:(NSString *)aType
{
    NSString *string = [[NSBundle mainBundle] pathForResource:aName ofType:aType];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    if(!self.player)
    {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    self.player.numberOfLoops = -1;
    self.player.enableRate = YES;//允许调整速率
    [self.player prepareToPlay];
    
    [self.player play];
    
    [self addNotification];
}

- (void)pause
{
    [self.player pause];
}

- (void)stop
{
    self.player.currentTime = 0;
    [self.player stop];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareToPlay
{
    [self.player prepareToPlay];
}

- (void)handleInterruption:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //中断开始
        [self.player stop];
    } else {
        //中断结束
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            [self.player playAtTime:self.player.deviceCurrentTime];
        }
        
    }
    
    /*
     开始中断的时候，userInfo的key
     AVAudioSessionInterruptionTypeKey = 1;
     
     //结束中断的时候
     AVAudioSessionInterruptionTypeKey = 0;
     
     
     AVAudioSessionInterruptionOptionKey = 1;
     
     */
    
    NSLog(@"%@",info);
}


- (void)handleRouteChange:(NSNotification *)notification
{
    /*
     {
     AVAudioSessionRouteChangePreviousRouteKey = "<AVAudioSessionRouteDescription: 0x13cd2fb40, \ninputs = (\n    \"<AVAudioSessionPortDescription: 0x13cd2fa80, type = MicrophoneBuiltIn; name = iPhone \\U9ea6\\U514b\\U98ce; UID = Built-In Microphone; selectedDataSource = \\U524d>\"\n); \noutputs = (\n    \"<AVAudioSessionPortDescription: 0x13cd53190, type = Speaker; name = \\U626c\\U58f0\\U5668; UID = Speaker; selectedDataSource = (null)>\"\n)>";
     AVAudioSessionRouteChangeReasonKey = 1;
     }
     */
    
    /*
     当耳机插入的时候，AVAudioSessionRouteChangeReason等于AVAudioSessionRouteChangeReasonNewDeviceAvailable
     代表一个新外接设备可用，但是插入耳机，我们不需要处理。所以不做判断。
     当耳机拔出的时候 AVAudioSessionRouteChangeReason等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable
     代表一个之前外的外接设备不可用了，此时我们需要处理，让他播放器静音 。
     AVAudioSessionRouteChangePreviousRouteKey：当之前的线路改变的时候，
     获取到线路的描述对象：AVAudioSessionRouteDescription，然后获取到输出设备，判断输出设备的类型是否是耳机,
     如果是就暂停播放
     */
    
    
    NSDictionary *info = notification.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self.player stop];
        }
        
    }
    NSLog(@"%@",info);
    
}

@end
