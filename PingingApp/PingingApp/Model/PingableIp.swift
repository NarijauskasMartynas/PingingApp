//
//  PingableIp.swift
//  PingingApp
//
//  Created by Martynq on 19/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import Foundation

struct PingableIp{
    var ipAddress : String = ""
    var pinged : Bool = false
    
    init(ipAddress: String, pinged: Bool) {
        self.ipAddress = ipAddress
        self.pinged = pinged
    }
}
