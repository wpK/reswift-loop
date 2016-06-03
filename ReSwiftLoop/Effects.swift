//
//  Effects.swift
//  ReSwiftLoop
//
//  Created by William Key on 6/1/16.
//  Copyright © 2016 William Key. All rights reserved.
//

import Foundation
import ReSwift

public struct AsyncActionCreatorEffect<state: StateType>: Effect {
    let factory: () -> Store<state>.AsyncActionCreator
    
    init(_ factory: () -> Store<state>.AsyncActionCreator) {
        self.factory = factory
    }
}

public struct ActionCreatorEffect<state: StateType>: Effect {
    let factory: () -> Store<state>.ActionCreator
    
    init(_ factory: () -> Store<state>.ActionCreator) {
        self.factory = factory
    }
}

public struct BatchEffect: Effect {
    let effects: [Effect]
    
    init(_ effects: [Effect]) {
        self.effects = effects
    }
}

public struct ActionEffect: Effect {
    let action: Action
    
    init(_ action: Action) {
        self.action = action
    }
}

public protocol Effect { }