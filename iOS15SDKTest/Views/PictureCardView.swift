//
//  PictureCardView.swift
//  PictureCardView
//
//  Created by Руслан Кукса on 22.08.2021.
//

import SwiftUI

struct PictureCardView: View {
    
    let imageURL: URL
    let onDownload: Action
    
    var body: some View {
        ZStack {
            AsyncImage(url: imageURL) { image in
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                ProgressView()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: 400)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .trailing) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: onDownload) {
                        Image(systemName: "tray.and.arrow.down")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .frame(width: 44, height: 44)
                    .buttonStyle(.plain)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
    }
}

struct PictureCardView_Previews: PreviewProvider {
    static var previews: some View {
        PictureCardView(imageURL: URL(string: "https://google.com")!, onDownload: {})
    }
}
