//
//  CGFloat+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
    
    func toDegree() -> CGFloat {
        return self * 180 / CGFloat.pi
    }
}
