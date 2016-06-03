//
//  LoopState.swift
//  ReSwiftLoop
//
//  Created by William Key on 6/2/16.
//  Copyright © 2016 William Key. All rights reserved.
//

import Foundation
import ReSwift

public struct LoopStateType<State: StateType>: StateType {
    let model: State
    let effect: Effect?
}