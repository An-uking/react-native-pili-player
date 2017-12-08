//
//  RCTLive.h
//  RCTPlayer
//
//  Created by uking on 2017/12/8.
//  Copyright © 2017年 uking. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RCTView.h"
#import "PLPlayer.h"

@class RCTEventDispatcher;

@interface RCTLive : UIView<PLPlayerDelegate>
@property (nonatomic, assign) int reconnectCount;

@property (nonatomic, copy) RCTBubblingEventBlock onLoading;
@property (nonatomic, copy) RCTBubblingEventBlock onReady;

@property (nonatomic, copy) RCTBubblingEventBlock onPlaying;
@property (nonatomic, copy) RCTBubblingEventBlock onPaused;
@property (nonatomic, copy) RCTBubblingEventBlock onStop;
//@property (nonatomic, copy) RCTBubblingEventBlock onError;
@property (nonatomic, copy) RCTBubblingEventBlock onAutoReconnecting;
@property (nonatomic, copy) RCTBubblingEventBlock onProg;

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;
@end
