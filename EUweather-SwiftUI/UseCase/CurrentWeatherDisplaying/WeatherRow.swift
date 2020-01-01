//
//  WeatherDisplayRow.swift
//  EUerayher-SwiftUI
//
//  Created by ALi on 2019. 12. 26..
//  Copyright © 2019. ALi. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct WeatherRow: View {
    
    let viewModel: WeatherRowViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: -12) {
                KFImage(viewModel.iconUrl)
                    .frame(width: 75, height: 75, alignment: .center)
                Text(viewModel.cityName).font(.title)
            }
            Spacer()
            Text(viewModel.degree).font(.largeTitle)
        }
    }
    
    init(viewModel: WeatherRowViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
class WeatherDisplayRow_Preview: PreviewProvider {
    static var previews: some View {
        WeatherRow(viewModel: getPreviewViewModel())
            .previewLayout(.fixed(width: 300, height: 90))
    }
    
    static func getPreviewViewModel() -> WeatherRowViewModel {
        WeatherRowViewModel(currentWeather: CurrentWeather(city: City(code: "1", name: "Budapest", countryCode: "HU"), degree: 12.8, iconName: "10d"))
    }
}
#endif
