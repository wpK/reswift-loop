//
//  LoopReducer.swift
//  ReSwiftLoop
//
//  Created by William Key on 6/2/16.
//  Copyright © 2016 William Key. All rights reserved.
//

import Foundation
import ReSwift

public protocol LoopReducer: AnyReducer {
    #if swift(>=2.2)
    associatedtype ReducerStateType: StateType
    #else
    typealias ReducerStateType: StateType
    #endif
    
    func loop(state: ReducerStateType, effect: Effect?) -> LoopStateType<ReducerStateType>
    
    func handleAction(action: Action, state: ReducerStateType?) -> StateType
}

extension LoopReducer {
    public func loop(state: ReducerStateType, effect: Effect?) -> LoopStateType<ReducerStateType> {
        return LoopStateType(model: state, effect: effect)
    }
    
    public func _handleAction(action: Action, state: StateType?) -> StateType {
        return withSpecificTypes(action, state: state, function: handleAction)
    }
}