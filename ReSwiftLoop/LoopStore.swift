//
//  LoopStore.swift
//  ReSwiftLoop
//
//  Created by William Key on 6/1/16.
//  Copyright © 2016 William Key. All rights reserved.
//

import Foundation
import ReSwift

public class LoopStore<State: StateType>: Store<State> {
    
    private var currentEffect: Effect?
    
    private var reducer: AnyReducer
    
    private var isDispatching = false
    
    public required init(reducer: AnyReducer, state: State?, middleware: [Middleware]) {
        self.reducer = reducer
        super.init(reducer: reducer, state: state, middleware: middleware)
    }
    
    public override func _defaultDispatch(action: Action) -> Any {
        if isDispatching {
            // Use Obj-C exception since throwing of exceptions can be verified through tests
            NSException.raise("SwiftFlow:IllegalDispatchFromReducer", format: "Reducers may not " +
                "dispatch actions.", arguments: getVaList(["nil"]))
        }
        
        isDispatching = true
        let newState = liftState(reducer._handleAction(action, state: state))
        currentEffect = newState.effect
        isDispatching = false
        
        state = newState.model
        
        return action
    }
    
    public override func dispatch(action: Action) -> Any {
        super.dispatch(action)
        let effectToRun = currentEffect
        currentEffect = nil
        if let effectToRun = effectToRun {
            runEffect(effectToRun)
        }
        return action
    }
    
    private func runEffect(effect: Effect) {
        switch (effect) {
        case let effect as ActionEffect:
            dispatch(effect.action)
            break
        case let effect as BatchEffect:
            effect.effects.forEach(runEffect)
            break
        case let effect as ActionCreatorEffect<State>:
            dispatch(effect.factory())
            break
        case let effect as AsyncActionCreatorEffect<State>:
            dispatch(effect.factory())
            break
        default:
            break
        }
    }
    
    private func liftState(state: StateType) -> LoopStateType<State> {
        if let state = state as? LoopStateType<State> {
            return state
        }
        
        return LoopStateType(model: state as! State, effect: nil)
    }
}