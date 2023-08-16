//
//  DetailsViewModel.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 17.08.2023.
//

import Foundation

final class DetailsViewModel: ObservableObject {
    @Published private(set) var detailCharacter: Result?
    @Published private(set) var originCharacter: OriginModel?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    
    @Published private(set) var episodes = [EpisodeModel]()
    
    @Published private(set) var viewState: ViewState?
    
    private let networkingManager = NetworkingManager.shared
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    @MainActor
    func fetchDetails(for id: Int) async {
        viewState = .loading
        defer { viewState = .finished }
        
        do {
            let response = try await networkingManager.request(.detail(id: id), type: Result.self)

            detailCharacter = response
        } catch {
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
        
        do {
            if let origin = detailCharacter?.origin.url {
                await fetchOrigin(url: origin)
            }
        }
        
        do {
            for episode in detailCharacter?.episode ?? [] {
                await fetchEpisodes(url: episode)
            }
        }
    }
    
    @MainActor
    func fetchEpisodes(url: String) async {
        do {
            var response = try await networkingManager.request(url: url, type: EpisodeModel.self)
            
            let format = response.episode.split(separator: "S")[0].split(separator: "E")
            let season = String(Int(format[0])!)
            let episodeString = String(Int(format[1])!)
            
            response.episode = "Episode: \(episodeString), Season: \(season)"
            
            episodes.append(response)
            
        } catch {
            self.hasError = true
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetchOrigin(url: String) async {
        do {
            let response = try await networkingManager.request(url: url, type: OriginModel.self)
            
            originCharacter = response
        } catch {
            
            self.hasError = true
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}

extension DetailsViewModel {
    enum ViewState {
        case loading
        case finished
    }
}
