//
//  ContentView.swift
//  EUerayher-SwiftUI
//
//  Created by ALi on 2019. 12. 25..
//  Copyright © 2019. ALi. All rights reserved.
//

import SwiftUI
import Combine

struct CurrentWeatherView: View {
    
    @ObservedObject
    var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dataSource) {
                    WeatherRow(viewModel: $0)
                }
                .onDelete(perform: { self.viewModel.remove(atOffsets: $0) })
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("weatherDisplay_title")
            .navigationBarItems(trailing:
                NavigationLink(destination: CitySelectingView(viewModel: viewModel.getCitySelectingViewModel()),
                               label: { Text("+").font(.largeTitle) }
                )
            )
        }
    }
    
    init(viewModel: CurrentWeatherViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct WeatherDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(viewModel: getPreviewViewModel())
    }
    
    static func getPreviewViewModel() -> CurrentWeatherViewModel {
        let viewModel = CurrentWeatherViewModel()
        viewModel.dataSource = [
            WeatherRowViewModel(currentWeather: CurrentWeather(city: City(code: "3054643", name: "Budapest", countryCode: "HU"), degree: 12.9, iconName: "10d")),
            WeatherRowViewModel(currentWeather: CurrentWeather(city: City(code: "2643743", name: "London", countryCode: "GB"), degree: 7.2, iconName: "02d"))
        ]
        return viewModel
    }
}
#endif
