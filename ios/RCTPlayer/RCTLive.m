//
//  RCTLive.m
//  RCTPlayer
//
//  Created by uking on 2017/12/8.
//  Copyright © 2017年 uking. All rights reserved.
//

#import "RCTLive.h"
#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"
//#import "RCTEventEmitter.h"
#import "UIView+React.h"

@implementation RCTLive{
    RCTEventDispatcher *_eventDispatcher;
    PLPlayer *_plplayer;
    BOOL _started;
    BOOL _muted;
    BOOL _islive;
    BOOL _autoPlay;
    BOOL _loop;
    BOOL _first;
    BOOL _isSeeking;
    NSTimer *_timer;
    //CMTime _currentTime;
}
static NSString *status[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusCaching",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError",
    @"PLPlayerStatusCompleted"
};


- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
    if ((self = [super init])) {
        _eventDispatcher = eventDispatcher;
        _started = YES;
        _muted = NO;
        _timer = nil;
        _first = YES;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.reconnectCount = 0;
    }
    
    return self;
};
- (void) setSource:(NSDictionary *)source
{
    NSString *uri = source[@"uri"];
    bool backgroundPlay = source[@"backgroundPlay"] == nil ? false : source[@"backgroundPlay"];
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    
    if(_plplayer){
        [_plplayer stop]; //TODO View 被卸载时 也要调用
    }
    
    _plplayer = [PLPlayer playerLiveWithURL:[[NSURL alloc] initWithString:uri] option:option];
    
    _plplayer.delegate = self;
    _plplayer.delegateQueue = dispatch_get_main_queue();
    _plplayer.backgroundPlayEnable = backgroundPlay;
    
    
    if(backgroundPlay){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayer) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    //[_plplayer addObserver:self forKeyPath:@"currentTime" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    [self setupUI];
    [self startPlayer];
    
}

- (void)setupUI {
    if (_plplayer.status != PLPlayerStatusError) {
        // add player view
        UIView *playerView = _plplayer.playerView;
        [self addSubview:playerView];
        [playerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        
        NSArray *constraints = [NSArray arrayWithObjects:centerX, centerY,width,height, nil];
        [self addConstraints: constraints];
        
        
        
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) setMuted:(BOOL) muted {
    _muted = muted;
    [_plplayer setMute:muted];
    
}
- (void) setVolume:(float) volume{
    [_plplayer setVolume:volume];
}
- (void)startPlayer {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //NSLog(@"布尔值3:%i",_autoPlay);
    [_plplayer play];
    _started = true;
    //NSLog(@"布尔值:%i",_started);
    [self startProcess];
}
/** --------------- 播放进度的timer ----------------- */
- (void)startProcess {
    if (!_timer) {
        //NSLog(@"布尔值:%i",_started);
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerFunction:) userInfo:nil repeats:YES];
    }
}

- (void) endProcess {
    [_timer invalidate];
    _timer  = nil;
}
- (void)timerFunction:(NSTimer *) timer {
    //NSLog(@"布尔值2:%i",_started);
    if(_plplayer.playing && self.onProg){
        self.onProg(@{@"currentTime":[NSNumber numberWithDouble:CMTimeGetSeconds(_plplayer.currentTime)]});
    }
    //NSLog(@"TIME:%f",currentTime);
}

/** --------------- 播放进度的timer ----------------- */

#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    switch (state) {
        case PLPlayerStatusCaching:
            self.onLoading(@{@"target": self.reactTag});
            //[_eventDispatcher sendInputEventWithName:@"onLoading" body:@{@"target": self.reactTag}];
            break;
        case PLPlayerStatusReady:
            self.onReady(@{@"target": self.reactTag});
            //[_eventDispatcher sendInputEventWithName:@"onReady" body:@{@"target": self.reactTag}];
            break;
        case PLPlayerStatusPlaying:
            self.onPlaying(@{@"target": self.reactTag});
            //[_eventDispatcher sendInputEventWithName:@"onPlaying" body:@{@"target": self.reactTag}];
            break;
        case PLPlayerStatusPaused:
            self.onPaused(@{@"target": self.reactTag});
            //[_eventDispatcher sendInputEventWithName:@"onPaused" body:@{@"target": self.reactTag}];
            break;
        case PLPlayerStatusStopped:
            self.onStop(@{@"target": self.reactTag});
            //[_eventDispatcher sendInputEventWithName:@"onShutdown" body:@{@"target": self.reactTag}];
            break;
        case PLPlayerStatusError:
            //self.onError(@{@"target": self.reactTag,@"errorCode": [NSNumber numberWithUnsignedInt:0]});
            //[_eventDispatcher sendInputEventWithName:@"onError" body:@{@"target": self.reactTag , @"errorCode": [NSNumber numberWithUnsignedInt:0]}];
            break;
        case PLPlayerStateAutoReconnecting:
            self.onAutoReconnecting(@{@"target": self.reactTag});
            //[_eventDispatcher sendInputEventWithName:@"onAutoReconnecting" body:@{@"target": self.reactTag}];
            break;
        default:
            break;
    }
    NSLog(@"%@", status[state]);
}

- (void) setPaused:(BOOL) paused{
    NSLog(@"ssssssss:%i",paused);
    if(_first){
        paused=false;
        _first=false;
        return;
    }
    if(!paused){
        [_plplayer resume];
        _started = paused;
        [self startProcess];
    }else{
        [_plplayer pause];
        _started = paused;
        [self endProcess];
    }
    
    //    if(!_first && _autoPlay){
    //        [_plplayer pause];
    //        _started =  false;
    //        started =_started;
    //        _first =true;
    //        [self endProcess];
    //    }else{
    //        if(started){
    //            [_plplayer resume];
    //            _started = started;
    //            [self startProcess];
    //
    //        }else{
    //            [_plplayer pause];
    //            _started = started;
    //            [self endProcess];
    //        }
    //    }
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    [self tryReconnect:error];
}

- (void)tryReconnect:(nullable NSError *)error {
    if (self.reconnectCount < 3) {
        _reconnectCount ++;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"错误 %@，播放器将在%.1f秒后进行第 %d 次重连", error.localizedDescription,0.5 * pow(2, self.reconnectCount - 1), _reconnectCount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_plplayer play];
        });
    }else {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        NSLog(@"%@", error);
    }
}

@end


