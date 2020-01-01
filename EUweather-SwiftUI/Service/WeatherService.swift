//
//  CurrentWeatherProviding.swift
//  EUerayher-SwiftUI
//
//  Created by ALi on 2019. 12. 26..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation
import Combine

enum WeatherServiceError: Error {
    case serviceError(String), invalidJson(String)
}

protocol WeatherService {
    func getCurrentWeather(by cityIds: [OpenWeatherCityCode]) -> AnyPublisher<CurrentWeatherDAO, WeatherServiceError>
    func getWeatherIconUrl(for iconFileName: String) -> URL?
}

final class WeatherServiceFactory {
    static var mockedInstance: WeatherService?
    class func getInstance() -> WeatherService {
        mockedInstance ?? CurrentWeatherServiceImpl()
    }
}

private final class CurrentWeatherServiceImpl: WeatherService {
    
    private lazy var session: URLSession = {
        URLSession.shared
    }()
    
    func getCurrentWeather(by cityIds: [OpenWeatherCityCode]) -> AnyPublisher<CurrentWeatherDAO, WeatherServiceError> {
        guard cityIds.isNotEmpty else {
            return Just(0)
                .tryMap { _ in CurrentWeatherDAO.empty }
                .mapError { _ in WeatherServiceError.serviceError("") }
                .eraseToAnyPublisher()
        }
        guard let url = getCurrentWeatherComponents(by: cityIds).url else {
            return Fail(error: WeatherServiceError.serviceError("Invalid URL!")).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: URLRequest(url: url))
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == HTTPStatusCode.ok.rawValue else {
                    throw WeatherServiceError.serviceError("HTTP error: \(HTTPStatusCode.internalServerError)")
                }
                return data
            }
            .decode(type: CurrentWeatherDAO.self, decoder: JSONDecoder())
            .mapError { WeatherServiceError.invalidJson($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
    
    func getWeatherIconUrl(for iconName: String) -> URL? {
        getWeatherIconComponents(for: iconName).url
    }

    private func getWeatherIconComponents(for iconFileName: String) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = Resource.ImageCloudStorage.Url.scheme
        urlComponents.host = Resource.ImageCloudStorage.Url.host
        urlComponents.path = Resource.ImageCloudStorage.Url.imagePath + "/\(iconFileName)"
        
        return urlComponents
    }
    
    private func getCurrentWeatherComponents(by cityCodes: [OpenWeatherCityCode]) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = Resource.Service.Url.scheme
        urlComponents.host = Resource.Service.Url.host
        urlComponents.path = Resource.Service.Url.path + "/group"
        urlComponents.queryItems = [
            URLQueryItem(name: Resource.Service.Arg.cityIds, value: cityCodes.joined(separator: ",")),
            URLQueryItem(name: Resource.Service.Arg.apiKey, value: Config.openWeatherApiKey),
            URLQueryItem(name: Resource.Service.Arg.unit, value: Resource.Service.Values.Units.metric),
            URLQueryItem(name: Resource.Service.Arg.mode, value: Resource.Service.Values.Modes.json)
        ]
        return urlComponents
    }
}
