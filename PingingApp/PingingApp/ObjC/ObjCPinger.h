//
//  ObjCPinger.h
//  PingingApp
//
//  Created by Martynq on 17/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GBPing.h"

@interface ObjCPinger : UIResponder <UIApplicationDelegate, GBPingDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GBPing *ping;


- (void) pingHost:(NSString *)ipAddress : (NSInteger)threadIndex : (NSInteger)numberOfPings;

- (void) prepareObject;

@end
