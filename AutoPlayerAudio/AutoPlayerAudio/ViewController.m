//
//  ViewController.m
//  AutoPlayerAudio
//
//  Created by ju on 2017/3/16.
//  Copyright © 2017年 hu. All rights reserved.
//

#import "ViewController.h"
#import "AutoPlayerManager.h"

@interface ViewController ()<AutoPlayerManagerProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[AutoPlayerManager sharedInstance] setDelegate:self];
    [[AutoPlayerManager sharedInstance] startRingTimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
