//
//  Created by Michele Restuccia on 17/3/21.
//

import SwiftUI
import EssentialKit

extension BeerDetailView {
    
    struct NameView: View {
        
        struct VM {
            let title: String
            let subtitle: String
        }
        var viewModel: VM
        
        var body: some View {
            Group {
                Text(viewModel.title)
                    .bold()
                    .font(.title)
                    .lineLimit(nil)
                    .foregroundColor(.primary)
                    .padding(.top, 16).padding(.leading, 32).padding(.trailing, 32)
                
                Text(viewModel.subtitle)
                    .font(.body)
                    .lineLimit(nil)
                    .padding(.leading, 32).padding(.trailing, 32)
                    .frame(height: 45)
            }
        }
    }
    
    struct ImageView: View {
        
        struct VM {
            let imageURL: URL?
        }
        var viewModel: VM
        
        var body: some View {
            let photo = Photo(url: viewModel.imageURL)
            
            HStack(alignment: .center) {
                Image(uiImage: photo.uiImage!)
                    .resizable()
                    .frame(width: 60, height: 200, alignment: .center)
                    .aspectRatio(180/600, contentMode: .fit)
            }
            .frame(width: UIScreen.main.bounds.size.width)
            .padding(.top, 16)
        }
    }
    
    struct InfoView: View {
        
        struct VM {
            let section1: (title: String, data: [String])
            let section2: (title: String, data: [String])
        }
        var viewModel: VM
        
        var body: some View {
            Group {
                Text(viewModel.section1.title)
                    .italic()
                    .padding(.top, 16).padding(.leading, 32).padding(.trailing, 32)
                
                Group {
                    ForEach(viewModel.section1.data, id: \.self) {
                        Text($0)
                            .lineLimit(nil)
                            .padding(.leading, 32).padding(.trailing, 32)
                    }
                }.frame(height: 45)
                
                Text(viewModel.section2.title)
                    .italic()
                    .padding(.leading, 32).padding(.trailing, 32)
                
                Group {
                    ForEach(viewModel.section2.data, id: \.self) {
                        Text("- \($0)")
                            .lineLimit(nil)
                            .padding(.leading, 32).padding(.trailing, 32)
                    }
                }
            }
        }
    }
}
