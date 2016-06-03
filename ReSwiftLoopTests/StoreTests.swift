//
//  StoreTests.swift
//  ReSwiftLoop
//
//  Created by William Key on 6/2/16.
//  Copyright © 2016 William Key. All rights reserved.
//

import Quick
import Nimble
import ReSwift
@testable import ReSwiftLoop

class StoreSpecs: QuickSpec {
    
    override func spec() {
        
        let reducer = TestLoopReducer()
        let state = TestAppState(firstRun: false, secondRun: false, thirdRun: false, fourthRun: false)
        
        describe("#all") {
            
            it("Super basic test to get things started") {
                let firstAction = FirstAction()
                
                let store = LoopStore(reducer: reducer, state: state)
                
                store.dispatch(firstAction)
                
                expect(store.state.firstRun).to(beTrue())
                expect(store.state.secondRun).to(beTrue())
                expect(store.state.thirdRun).to(beTrue())
                expect(store.state.fourthRun).to(beTrue())
            }
        }
        
    }
    
}