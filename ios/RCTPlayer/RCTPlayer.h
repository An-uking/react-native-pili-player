//
//  RCTPlayer.h
//  RCTPlayer
//
//  Created by uking on 2017/12/4.
//  Copyright © 2017年 uking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTView.h"
#import "PLPlayer.h"

@class RCTEventDispatcher;

@interface RCTPlayer : UIView<PLPlayerDelegate>

@property (nonatomic, assign) int reconnectCount;
//@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) bool loop;
//@property(nonatomic,assign) bool autoPlay;



@property (nonatomic, copy) RCTBubblingEventBlock onLoading;
@property (nonatomic, copy) RCTBubblingEventBlock onReady;

@property (nonatomic, copy) RCTBubblingEventBlock onPlaying;
@property (nonatomic, copy) RCTBubblingEventBlock onPaused;
@property (nonatomic, copy) RCTBubblingEventBlock onShutdown;
//@property (nonatomic, copy) RCTBubblingEventBlock onError;
@property (nonatomic, copy) RCTBubblingEventBlock onAutoReconnecting;

@property (nonatomic, copy) RCTBubblingEventBlock onCompleted;

@property (nonatomic, copy) RCTBubblingEventBlock onProg;

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;


@end


