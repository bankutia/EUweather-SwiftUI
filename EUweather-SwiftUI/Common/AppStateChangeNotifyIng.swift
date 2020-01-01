//
//  AppStateChangeNotifyIng.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 22..
//  Copyright © 2019. ALi. All rights reserved.
//

import SwiftUI
import Combine
import Entwine
import os.log

enum AppState {
    case unknown
    case willResignActive
    case willEnterForeground
    case willTerminate
    case willFinishLaunching
    case didFinishLaunching
    case didBecomeActive
    case didEnterBackground
}

protocol AppStateChangeNotifying {
    var recentStates: ReplaySubject<AppState, Never> { get }
    func start(with state: AppState)
}

final class AppStateChangeNotifierFactory {
    static var mockedInstance: AppStateChangeNotifying?
    class func getInstance() -> AppStateChangeNotifying {
        mockedInstance ?? AppStateChangeNotifier.sharedNotifyer
    }
}

private final class AppStateChangeNotifier: AppStateChangeNotifying, ObservableObject, Identifiable {
    
    let id: UUID = .init()
    private (set) var recentStates: ReplaySubject<AppState, Never>
    
    static let sharedNotifyer = AppStateChangeNotifier()
    
    init() {
        recentStates = ReplaySubject(maxBufferSize: 3)
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { _ in self.changeState(to: .willResignActive) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in self.changeState(to: .didBecomeActive) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { _ in self.changeState(to: .willTerminate) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: nil) { _ in self.changeState(to: .didFinishLaunching) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in self.changeState(to: .didEnterBackground) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in self.changeState(to: .willEnterForeground) }
    }
    
    @inline(__always) private func changeState(to state: AppState) {
//        let previousState = self.state
//        self.state = state
        recentStates.send(state)
        os_log("State changed to: %@", "\(state)")
    }
    
    func start(with state: AppState = .willFinishLaunching) {
        recentStates.send(state)
    }
}
