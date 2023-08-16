//
//  DetailScreenView.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 16.08.2023.
//

import SwiftUI

struct DetailScreenView: View {
    let characterId: Int
    @StateObject private var vm = DetailsViewModel()
    
    var body: some View {
        ScrollView {
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Group {
                    VStack(spacing: 8) {
                        if let imageAbsoluteString = vm.detailCharacter?.image,
                           let imageUrl = URL(string: imageAbsoluteString) {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.size.width / 2.5)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        
                        Text(vm.detailCharacter?.name ?? "Unknown")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.top, 16)
                        
                        Text(vm.detailCharacter?.status ?? "Unknown")
                            .foregroundColor(Theme.primary)
                    }
                    
                    infoBlock
                    
                    originBlock
                    
                    episodesBlock
                }
                .padding(24)
            }
        }
        .background(Theme.background)
        .task {
            await vm.fetchDetails(for: characterId)
        }
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button("Retry") { }
        }
    }
}

struct DetailScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailScreenView(characterId: 1)
        }
    }
}

private extension DetailScreenView {
    var infoBlock: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Info")
                .foregroundColor(.white)
                .font(.headline)
            
            VStack(spacing: 0) {
                Group {
                    HStack {
                        Text("Species:")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(Theme.grayNormal)
                        Spacer()
                        Text(vm.detailCharacter?.species ?? "Unknown")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Type: ")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(Theme.grayNormal)
                        Spacer()
                        Text(vm.detailCharacter?.type ?? "Unknown")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Gender: ")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(Theme.grayNormal)
                        Spacer()
                        Text(vm.detailCharacter?.gender ?? "Unknown")
                            .fontWeight(.medium)
                    }
                }
                .foregroundColor(.white)
                .padding(16)
            }
            .background(Theme.itemBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.bottom, 24)
    }
    
    var originBlock: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Origin")
                .foregroundColor(.white)
                .font(.headline)
            
            VStack {
                HStack(spacing: 8) {
                    Image("Planet")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .padding(20)
                        .background(Theme.blackElementPlanet, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(width: 72)
                        .padding(8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(vm.originCharacter?.name ?? "Unknown")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                        Text(vm.originCharacter?.type ?? "Unknown")
                            .font(.subheadline)
                            .foregroundColor(Theme.primary)
                    }
                    Spacer()
                }
                
            }
            .background(Theme.itemBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.bottom, 24)
    }
    
    var episodesBlock: some View {
        LazyVStack(alignment: .leading) {
            Text("Episodes")
                .foregroundColor(.white)
                .font(.headline)
            
            ForEach(vm.episodes, id: \.id) { episode in
                DetailEpisodesItemView(episode: episode)
            }
        }
    }
}
