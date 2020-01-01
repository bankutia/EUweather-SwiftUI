//
//  CitySelectingView.swift
//  EUweather-SwiftUI
//
//  Created by ALi on 2019. 12. 28..
//  Copyright © 2019. ALi. All rights reserved.
//

import SwiftUI

struct CitySelectingView: View {
    
    @ObservedObject
    var viewModel: CitySelectingViewModel
    
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List(viewModel.dataSource) { rowViewModel in
            CityRowView(viewModel: rowViewModel.with(action: { _ in
                rowViewModel.citySelectedAction?(rowViewModel)
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        .navigationBarTitle("citySelecting_title")
    }
    
    init(viewModel: CitySelectingViewModel) {
        self.viewModel = viewModel
    }
}

extension CityRowViewModel {
    func with(action: @escaping(CityRowViewModel) -> Void) -> CityRowViewModel {
        var viewModel = self
        viewModel.citySelectedAction = action
        return viewModel
    }
}

#if DEBUG
class CitySelectingView_Preview: PreviewProvider {
    static var previews: some View {
        CitySelectingView(viewModel: getPreviewViewModel())
    }
    
    static func getPreviewViewModel() -> CitySelectingViewModel {
        CitySelectingViewModel(disabledCityCodes: ["3054643", "2643743"]) { _ in }
    }
}
#endif
