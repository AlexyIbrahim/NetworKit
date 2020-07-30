//
//  File.swift
//  
//
//  Created by Alexy Ibrahim on 7/30/20.
//

import Foundation
import UIKit

internal class NetworKitUtils {
    internal final class func topMostWindowController()->UIViewController? {
        
        var topController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController // UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
}
