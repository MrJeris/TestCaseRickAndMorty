//
//  MainItemView.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 17.08.2023.
//

import SwiftUI

struct MainItemView: View {
    let character: Result
    
    var body: some View {
        VStack(spacing: .zero) {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            .padding([.top, .horizontal], 8)

            VStack {
                Text(character.name)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .lineLimit(1)
            }
        }
        .background(Theme.itemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Theme.itemBackground, radius: 1)
        .padding(8)
    }
}

struct MainItemView_Previews: PreviewProvider {
    static var previews: some View {
        MainItemView(character: Result(
            id: 1,
            name: "Rick Sanchez",
            status: "",
            species: "",
            type: "",
            gender: "",
            origin: Origin(name: "", url: ""),
            location: Location(name: "", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: ""))
    }
}
