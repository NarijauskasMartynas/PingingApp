//
//  ObjCPinger.m
//  PingingApp
//
//  Created by Martynq on 17/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

#import "ObjCPinger.h"

@implementation ObjCPinger

-(void) pingHost: (NSString *)ipAddress{
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
                
                // stop it after 5 seconds
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSLog(@"stop it");
                    [self.ping stop];
                    self.ping = nil;
                });
            } else {
                NSLog(@"failed to start");
            }
        }];
}

-(void)ping:(GBPing *)pinger didReceiveReplyWithSummary:(GBPingSummary *)summary {
    NSLog(@"REPLY>  %@", summary.host);
    NSLog(@"REPLY>  %u", summary.status);

}

-(void)ping:(GBPing *)pinger didReceiveUnexpectedReplyWithSummary:(GBPingSummary *)summary {
    NSLog(@"BREPLY> %@", summary);
}

-(void)ping:(GBPing *)pinger didSendPingWithSummary:(GBPingSummary *)summary {
    NSLog(@"SENT>   %@", summary);
}

-(void)ping:(GBPing *)pinger didTimeoutWithSummary:(GBPingSummary *)summary {
    NSLog(@"TIMOUT> %@", summary);
}

-(void)ping:(GBPing *)pinger didFailWithError:(NSError *)error {
    NSLog(@"FAIL>   %@", error);
}

-(void)ping:(GBPing *)pinger didFailToSendPingWithSummary:(GBPingSummary *)summary error:(NSError *)error {
    NSLog(@"FSENT>  %@, %@", summary, error);
}
@end
