[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/wpK/reswift-loop/blob/master/LICENSE.md)
![Platform support](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20watchos-lightgrey.svg?style=flat-square)


A port of redux-loop to ReSwift. This is a proof of concept, still has a long way to go!

#Installation

##CocoaPods

You can install ReSwiftLoop via CocoaPods by adding it to your `Podfile`:

	use_frameworks!

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'

	pod 'ReSwift'
	pod 'ReSwiftLoop'
	
And run `pod install`.

##Carthage

You can install ReSwiftLoop via [Carthage]() by adding the following line to your Cartfile:

	github "wpK/ReSwiftLoop"

#Usage

`AppState` can be defined as usual:

````swift
struct AppState: StateType {
  	let firstRun: Bool = false
  	let secondRun: Bool = false
  	let thirdRun: Bool = false
  	let fourthRun: Bool = false
}
````

A few `actions`:

````swift
struct FirstAction: Action { }
struct SecondAction: Action { }
struct ThirdAction: Action { }
struct FourthAction: Action { }
````

The `LoopStore` will work with existing `reducers`. If you want to enable returning side `effects` in your `reducer`, you need to use the `LoopReducer` protocol. You use the `loop()` function when you want to add `Effects`.

````swift
struct AppReducer: LoopReducer {
	func handleAction(action: Action, state: AppState?) -> StateType {
		let state = state ?? AppState()
		
		switch (action) {
		case _ as FirstAction:
			return loop(
				AppState(firstRun: true, secondRun: state.secondRun, thirdRun: state.thirdRun, fourthRun: state.fourthRun),
				effect: BatchEffect([
					BatchEffect([
						ActionEffect(SecondAction())]),
					ActionCreatorEffect<AppState>({ _ in
						return { _ in
        					return ThirdAction()
    					}
					}),
					AsyncActionCreatorEffect<AppState>({ _ in
						return { _, _, callback in
					        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
					            callback { _, _ in
					                return FourthAction()
					            }
					        }
					    }
					})]))
		case _ as SecondAction:
			return AppState(firstRun: state.firstRun, secondRun: true, thirdRun: state.thirdRun, fourthRun: state.fourthRun)
		case _ as ThirdAction:
			return AppState(firstRun: state.firstRun, secondRun: state.secondRun, thirdRun: true, fourthRun: state.fourthRun)
		case _ as FourthAction:
			return AppState(firstRun: state.firstRun, secondRun: state.secondRun, thirdRun: state.thirdRun, fourthRun: true)
		default:
			return state
		}
	}
}
````

Your store needs to use `LoopStore` instead of `Store`:

````swift
let mainStore = LoopStore<AppState>(reducer: AppReducer(), state: nil)
````

##Effects

- `ActionEffect()`
- `BatchEffect()`
- `ActionCreatorEffect()`
- `AsyncActionCreatorEffect()`

#Credits

- [ReSwift](https://github.com/ReSwift/ReSwift)
- [Redux Loop](https://github.com/raisemarketplace/redux-loop)
- [Elm Effects](https://github.com/evancz/elm-effects)