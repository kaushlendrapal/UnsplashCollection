//
//  AsynchronousOperation.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

/******************************************************************************
* AsynchronousOperation: is a base class for all operation object. This will handle
* the lifecycle for a operation.
******************************************************************************/

class AsynchronousOperation: Operation {
    
    var operationName: String = "NetworkOperation"
    
    override var isAsynchronous: Bool { return true }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    func handleRootNodeParsing(for JSON:String) -> (String) {
        
        return ""
    }
    
}
