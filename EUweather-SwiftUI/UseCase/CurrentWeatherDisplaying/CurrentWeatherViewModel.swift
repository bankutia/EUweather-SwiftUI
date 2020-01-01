//
//  WeatherDisplayViewModel.swift
//  EUerayher-SwiftUI
//
//  Created by ALi on 2019. 12. 26..
//  Copyright © 2019. ALi. All rights reserved.
//

import SwiftUI
import Combine

class CurrentWeatherViewModel: ObservableObject, Identifiable, CurrentWeatherProvidingInjecting, AppStateChangeNotifyingInjected {
    
    @Published
    var dataSource: [WeatherRowViewModel] = .init()
    
    @UserDefault(Resource.UserDefault.observingCitiesKey, defaultValue: [])
    private var observingCityCodes: [OpenWeatherCityCode]
    
    private lazy var provider: CurrentWeatherProviding = {
        inject()
    }()
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        refresh()
        _ = appStateChangeNotifier.recentStates
            .receive(on: RunLoop.main)
            .scan(Array<AppState>.init(), { acc, current -> [AppState] in (acc + [current]).suffix(3) })
            .sink(receiveValue: { [weak self] (appStates) in
                guard let currentState = appStates.last, currentState == .didBecomeActive, appStates.notContains(.didFinishLaunching) else { return }
                
                self?.refresh()
            })
            .store(in: &disposeBag)
    }
    
    private func refresh() {
        _ = provider.getCurrentWeather(by: observingCityCodes)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .finished:
                    break
                case .failure(_):
                    self.dataSource = .init()
                }
            }) { currentWeatherArray in
                self.dataSource = currentWeatherArray.map { WeatherRowViewModel(currentWeather: $0) }
        }
        .store(in: &disposeBag)
    }
    
    func getCitySelectingViewModel() -> CitySelectingViewModel {
        CitySelectingViewModel(disabledCityCodes: dataSource.map{ $0.cityCode }) { [weak self] selectedCityCode in
            guard let self = self else { return }
            self.observingCityCodes.insert(selectedCityCode, at: 0)
            self.refresh()
        }
    }
    
    func remove(atOffsets offsets: IndexSet) {
        observingCityCodes.remove(atOffsets: offsets)
        dataSource.remove(atOffsets: offsets)
    }
}
