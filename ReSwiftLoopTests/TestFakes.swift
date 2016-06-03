//
//  TestFakes.swift
//  ReSwiftLoop
//
//  Created by William Key on 6/2/16.
//  Copyright © 2016 William Key. All rights reserved.
//

import Foundation
import ReSwift
@testable import ReSwiftLoop

struct TestAppState: StateType {
    let firstRun: Bool
    let secondRun: Bool
    let thirdRun: Bool
    let fourthRun: Bool
}

struct TestLoopReducer: LoopReducer {
    func handleAction(action: Action, state: TestAppState?) -> StateType {
        let state = state ?? TestAppState(firstRun: false, secondRun: false, thirdRun: false, fourthRun: false)
        
        switch (action) {
        case _ as FirstAction:
            return loop(
                TestAppState(firstRun: true, secondRun: state.secondRun, thirdRun: state.thirdRun, fourthRun: state.fourthRun),
                effect: BatchEffect([
                    BatchEffect([
                        ActionEffect(SecondAction())
                        ]),
                    ActionCreatorEffect<TestAppState>({ _ in
                        return { _ in
                            return ThirdAction()
                        }
                    }),
                    AsyncActionCreatorEffect<TestAppState>({ _ in
                        return { _, _, callback in
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                callback { _, _ in
                                    return FourthAction()
                                }
                            }
                        }
                    })
                    ]))
        case _ as SecondAction:
            return TestAppState(firstRun: state.firstRun, secondRun: true, thirdRun: state.thirdRun, fourthRun: state.fourthRun)
        case _ as ThirdAction:
            return TestAppState(firstRun: state.firstRun, secondRun: state.secondRun, thirdRun: true, fourthRun: state.fourthRun)
        case _ as FourthAction:
            return TestAppState(firstRun: state.firstRun, secondRun: state.secondRun, thirdRun: state.thirdRun, fourthRun: true)
        default:
            return state
        }
        
    }
}

struct FirstAction: Action { }
struct SecondAction: Action { }
struct ThirdAction: Action { }
struct FourthAction: Action { }

class TestStoreSubscriber<T>: StoreSubscriber {
    var receivedStates: [T] = []
    
    func newState(state: T) {
        receivedStates.append(state)
    }
}