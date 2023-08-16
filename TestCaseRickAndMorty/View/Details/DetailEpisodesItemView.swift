//
//  DetailEpisodesItemView.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 16.08.2023.
//

import SwiftUI

struct DetailEpisodesItemView: View {
    let episode: EpisodeModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(episode.name)
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    
                    HStack {
                        Text(episode.episode)
                            .foregroundColor(Theme.primary)
                        
                        Spacer()
                        
                        Text(episode.air_date)
                            .foregroundColor(Theme.textSecond)
                    }
                    .font(.subheadline)
                }
                Spacer()
            }
            .padding(16)
        }
        .background(Theme.itemBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct DetailEpisodesItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEpisodesItemView(episode: EpisodeModel(
            id: 1,
            name: "Pilot",
            air_date: "December 2, 2013",
            episode: "S01E01"))
    }
}
