//
//  Ip.swift
//  PingingApp
//
//  Created by Martynq on 09/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import Foundation

class Ip{
    var ipAddress : String = ""
    var reachable : Bool = false
    var ipNumber : Int {
        get{
            return Int(ipAddress.components(separatedBy: ".")[3]) ?? 0
        }
    }
}
