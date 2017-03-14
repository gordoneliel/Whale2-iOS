//
//  AsyncOperation.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/9/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//
import Foundation

class AsyncOperation: Operation {
    override var isExecuting : Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _executing: Bool = false
    
    private var _finished: Bool = false
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func cancel() {
        self.isFinished = true
        self.isExecuting = false
    }
}
