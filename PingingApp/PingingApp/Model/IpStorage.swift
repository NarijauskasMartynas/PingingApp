//
//  IpStorage.swift
//  PingingApp
//
//  Created by Martynq on 19/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import Foundation

protocol UpdateIpListDelegate{
    func updateUI()
}

class IpStorage{
        
    static public var initialIpArray : [PingableIp] = []

    static var delegate : UpdateIpListDelegate?
    
    static var ipObjArray : [Ip] = [] {
        didSet{
            delegate?.updateUI()
        }
    }

}
