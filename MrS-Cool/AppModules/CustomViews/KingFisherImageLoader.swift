//
//  KingFisherImageLoader.swift
//  MrS-Cool
//
//  Created by wecancity on 03/03/2024.
//

import Kingfisher
import SwiftUI

struct KFImageLoader: View {
    let url: URL?
    let placeholder: Image
    
    init(url: URL?, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        KFImage(url)
            .placeholder {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(8)
    }
}

