//
//  ObjCPinger.m
//  PingingApp
//
//  Created by Martynq on 17/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

#import "ObjCPinger.h"
#import "PingingApp-Swift.h"

@implementation ObjCPinger

Pinger *swiftPinger;

-(void) prepareObject{
    swiftPinger = [[Pinger alloc] init];
}

-(void) pingHost: (NSString *)ipAddress : (NSInteger)threadIndex : (NSInteger)numberOfPings{
     self.ping = [GBPing new];
        self.ping.host = ipAddress;
        self.ping.delegate = self;
        self.ping.timeout = 1;
        self.ping.pingPeriod = 0.9;
        
        // setup the ping object (this resolves addresses etc)
        [self.ping setupWithBlock:^(BOOL success, NSError *error) {
            if (success) {
                // start pinging
                [self.ping startPinging];
                // stop it after 5 seconds
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(250 * numberOfPings * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                    [self.ping stop];
                    self.ping = nil;
                    
                    NSString *ipToCall = [swiftPinger getIpAddressWithIdx:threadIndex];
                    if ([ipToCall isEqualToString:@"stop"]){
                        return;
                    }
                    else{
                        [self pingHost: ipToCall :threadIndex : numberOfPings];
                    }
                });
            } else {
                NSLog(@"failed to start");
            }
        }];
}

-(void)ping:(GBPing *)pinger didReceiveReplyWithSummary:(GBPingSummary *)summary {
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didReceiveUnexpectedReplyWithSummary:(GBPingSummary *)summary {
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didSendPingWithSummary:(GBPingSummary *)summary {
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didTimeoutWithSummary:(GBPingSummary *)summary {
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didFailToSendPingWithSummary:(GBPingSummary *)summary error:(NSError *)error {
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}
@end
