//
//  CityRowView.swift
//  EUweather-SwiftUI
//
//  Created by ALi on 2019. 12. 28..
//  Copyright © 2019. ALi. All rights reserved.
//

import SwiftUI

struct CityRowView: View {
    
    private let viewModel: CityRowViewModel
    
    var body: some View {
        HStack {
            if viewModel.isSelectable {
                Button(action: { self.viewModel.citySelectedAction?(self.viewModel) }) { rowView }
                    .foregroundColor(Color(.label))
            } else {
                rowView
                    .opacity(viewModel.isSelectable ? 1.0 : 0.5)
            }
        }
    }
    
    private var rowView: some View {
        HStack(spacing: 12) {
            Text(viewModel.flag)
                .font(Font.system(size: 36))
                .frame(width: 41, height: 43, alignment: .center)
            Text(viewModel.cityName)
                .font(.title)
        }
    }
    
    init(viewModel: CityRowViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
class CityRowView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            CityRowView(viewModel: CityRowViewModel(city: City(code: "1", name: "London", countryCode: "GB"), isSelectable: true, citySelectedAction: nil))
            CityRowView(viewModel: CityRowViewModel(city: City(code: "2", name: "Budapest", countryCode: "HU"), isSelectable: false, citySelectedAction: nil))
        }
        .previewLayout(.fixed(width: 300, height: 60))
    }
}
#endif
