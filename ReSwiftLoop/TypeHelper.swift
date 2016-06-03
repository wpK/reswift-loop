//
//  TypeHelper.swift
//  ReSwift
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import ReSwift

func withSpecificTypes<SpecificStateType: StateType, Action>(
        action: Action,
        state genericStateType: StateType?,
        @noescape function: (action: Action, state: SpecificStateType?) -> StateType
    ) -> StateType {
        guard let genericStateType = genericStateType else {
            return function(action: action, state: nil)
        }
        
        guard let specificStateType = genericStateType as? SpecificStateType else {
            return genericStateType
        }
        
        let newState = function(action: action, state: specificStateType)
        
        if let newLoopState = newState as? LoopStateType<SpecificStateType> {
            return newLoopState
        }
        
        if let newState = newState as? SpecificStateType {
            return LoopStateType(model: newState, effect: nil)
        }
        
        return genericStateType
}
