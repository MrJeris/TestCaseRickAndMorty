//
//  MainViewModel.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 17.08.2023.
//

import Foundation

final class MainViewModel: ObservableObject {
    @Published private(set) var characters = [Result]()
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    private let networkingManager = NetworkingManager.shared
    
    private(set) var page = 1
    private(set) var totalPages: Int?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var ifFetching: Bool {
        viewState == .fetching
    }
    
    @MainActor
    func fetchCharacters() async {
        
        resetData()
        
        viewState = .loading
        defer { viewState = .finished }
        
        do {
            let response = try await networkingManager.request(.main(page: page), type: CharactersModel.self)
            
            self.totalPages = response.info.pages
            self.characters = response.results
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
    func fetchNextSetOfCharacter() async {
        guard page != totalPages else { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        page += 1
        
        do {
            let response = try await networkingManager.request(.main(page: page), type: CharactersModel.self)
            
            self.totalPages = response.info.pages
            self.characters += response.results
        } catch {
            self.hasError = true
            
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachedEnd(of character: Result) -> Bool {
        characters.last?.id == character.id
    }
}

extension MainViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

extension MainViewModel {
    func resetData() {
        if viewState == .finished {
            characters.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}
