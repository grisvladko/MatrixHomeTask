//
//  Cache.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Cache {
    
    public static let shared = Cache()
    
    private init() {}
    
    private class Entry<T: AnyObject> {
        let value : T
        let expirationDate : Date
        
        init(value: T, expirationDate: Date) {
            self.value = value
            self.expirationDate = expirationDate
        }
    }
    
    private lazy var storage: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        return cache
    }()
    
    private let lock = NSLock()
    
    public func get(_ key: AnyObject) -> AnyObject? {
        lock.lock(); defer { lock.unlock() }
        
        guard let object = storage.object(forKey: key) else { return nil }
        
        if let entry = object as? Entry<AnyObject> {
            if Date() > entry.expirationDate {
                storage.removeObject(forKey: key)
                return nil
            }
            return entry.value
        }
        
        return nil
    }
    
    public func save(_ object: AnyObject, for key: AnyObject,
                     lifetime: Int) {
        lock.lock(); defer { lock.unlock() }
        
        let date = Date().addingTimeInterval(TimeInterval(lifetime))
        let entry = Entry(value: object, expirationDate: date)
        
        storage.setObject(entry, forKey: key, cost: 1)
    }
    
    public func remove(for key: AnyObject) {
        lock.lock(); defer { lock.unlock() }
        storage.removeObject(forKey: key as AnyObject)
    }
    
    public func clear() {
        lock.lock(); defer { lock.unlock() }
        storage.removeAllObjects()
    }
}
