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

-(void) pingHost: (NSString *)ipAddress : (NSInteger)threadIndex{
    NSLog(@"ITS WORKING");
    
     self.ping = [GBPing new];
        self.ping.host = ipAddress;
    //    self.ping.host = @"192.168.0.140";
    //    self.ping.host = @"192.168.0.255";
        self.ping.delegate = self;
        self.ping.timeout = 1;
        self.ping.pingPeriod = 0.9;
        
        // setup the ping object (this resolves addresses etc)
        [self.ping setupWithBlock:^(BOOL success, NSError *error) {
            if (success) {
                // start pinging
                [self.ping startPinging];
                double b = threadIndex;
                double a = 1 + b/10;
                NSLog(@"cia pasiekia %f", a);
                // stop it after 5 seconds
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((250 + threadIndex * 10) * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                    [self.ping stop];
                    self.ping = nil;
                    
                    NSString *ipToCall = [swiftPinger getIpAddressWithIdx:threadIndex];
                    NSLog(@"TOKS IP %@", ipToCall);
                    if ([ipToCall isEqualToString:@"-1"]){
                        return;
                    }
                    else{
                        [self pingHost: ipToCall :threadIndex];
                    }
                });
            } else {
                NSLog(@"failed to start");
            }
        }];
}

-(void)ping:(GBPing *)pinger didReceiveReplyWithSummary:(GBPingSummary *)summary {
    NSLog(@"cia pasiekia %@", summary.host);
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didReceiveUnexpectedReplyWithSummary:(GBPingSummary *)summary {
    NSLog(@"BREPLY> %@", summary);
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didSendPingWithSummary:(GBPingSummary *)summary {
    NSLog(@"SENT>   %@", summary);
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didTimeoutWithSummary:(GBPingSummary *)summary {
    NSLog(@"TIMOUT> %@", summary);
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}

-(void)ping:(GBPing *)pinger didFailWithError:(NSError *)error {
    NSLog(@"FAIL>   %@", error);

}

-(void)ping:(GBPing *)pinger didFailToSendPingWithSummary:(GBPingSummary *)summary error:(NSError *)error {
    NSLog(@"FSENT>  %@, %@", summary, error);
    [swiftPinger updateIpObjListWithIpAddress:summary.host status:summary.status];
}
@end
