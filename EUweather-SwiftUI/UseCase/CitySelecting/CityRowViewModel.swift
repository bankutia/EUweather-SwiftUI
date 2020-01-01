//
//  CitySelectingCell.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

struct CityRowViewModel: Identifiable {
    
    typealias CityRowSelectedAction = (CityRowViewModel) -> Void

    var id: String {
        cityName
    }
    var flag: String {
        city.countryCode.flagUnicodeCharacter()
    }
    var cityName: String {
        city.name
    }
    var isSelectable: Bool
    var cityCode: OpenWeatherCityCode {
        city.code
    }
    var citySelectedAction: CityRowSelectedAction?
    
    private let city: City
    
    init(city: City, isSelectable: Bool, citySelectedAction: CityRowSelectedAction?) {
        self.city = city
        self.isSelectable = isSelectable
        self.citySelectedAction = citySelectedAction
    }
}

private extension String {
    func flagUnicodeCharacter() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(String(s).first ?? "?")
    }
}


//final class CitySelectingCell: UITableViewCell {
//    
//    @IBOutlet weak var labelFlag: UILabel!
//    @IBOutlet weak var labelName: UILabel!
//    
//    struct ViewModel {
//        var flag: String
//        var cityName: String
//        var cityCode: String
//        var isSelectable: Bool
//    }
//    
//    private let unselectableRowAlpha: CGFloat = 0.35
//    private let selectableRowAlpha: CGFloat = 1.0
//    func set(viewModel: ViewModel) {
//        labelFlag.text = viewModel.flag
//        labelName.text = viewModel.cityName
//        
//        if viewModel.isSelectable {
//            contentView.alpha = selectableRowAlpha
//            selectionStyle = .default
//        } else {
//            contentView.alpha = unselectableRowAlpha
//            selectionStyle = .none
//        }
//    }
//}
