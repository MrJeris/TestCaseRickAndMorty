//
//  MainView.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 17.08.2023.
//

import SwiftUI

struct MainView: View {
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @StateObject private var vm = MainViewModel()
    
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    LazyVGrid(columns: columns) {
                        ForEach(vm.characters, id: \.id) { character in
                            NavigationLink {
                                DetailScreenView(characterId: character.id)
                            } label: {
                                MainItemView(character: character)
                                    .onAppear {
                                        if vm.hasReachedEnd(of: character) && !vm.ifFetching {
                                            Task {
                                                await vm.fetchNextSetOfCharacter()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .refreshable {
                await vm.fetchCharacters()
            }
            .task {
                if !hasAppeared {
                    await vm.fetchCharacters()
                    hasAppeared = true
                }
            }
            .background(Theme.background)
            .navigationTitle("Characters")
        }
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button("Retry") {
                Task {
                    await vm.fetchCharacters()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
