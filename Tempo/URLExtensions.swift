//
//  URLExtensions.swift
//  SwiftDown
//
//  Created by Fabian Canas on 2/28/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

extension NSURL {
    var effectiveIcon :NSImage? {
        get {
            var icon :AnyObject? = nil
            do { try self.getResourceValue(&icon, forKey: NSURLEffectiveIconKey) }
            catch _ {
                return nil
            }
            return icon as? NSImage
        }
    }
    
    var isDirectory :Bool {
        get {
            var dir :AnyObject? = nil
            do { try self.getResourceValue(&dir, forKey: NSURLIsDirectoryKey) }
            catch _ {
                return false
            }
            return dir as? Bool ?? false
        }
    }
}
