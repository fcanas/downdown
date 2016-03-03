//
//  Tempo.swift
//  SwiftDown
//
//  Created by Fabian Canas on 2/28/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

enum FileNode {
    case Directory(url: NSURL, contents: [FileNode])
    case File(url: NSURL)
}

extension FileNode {
    
    init(directoryURL :NSURL) {
        
        let fileManager = NSFileManager.defaultManager()
        
        let fileKeys = [NSURLEffectiveIconKey, NSURLIsDirectoryKey]
        
        let contents = try! fileManager.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: fileKeys, options: NSDirectoryEnumerationOptions())
        
        self = .Directory(url: directoryURL, contents: contents.map { (url) -> FileNode in
            if url.isDirectory {
                return FileNode(directoryURL: url)
            } else {
                return .File(url: url)
            }
        })
    }
    
    init?(directoryPath :String) {
        guard let rootURL = NSURL(string: directoryPath) else {
            return nil
        }
        self = FileNode(directoryURL: rootURL)
    }
    
    
}