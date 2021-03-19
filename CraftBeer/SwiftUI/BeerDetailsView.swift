//
//  Created by Michele Restuccia on 17/3/21.
//

import SwiftUI

struct BeerDetailView: View {
    
    enum Constants {
        static let BigSpacing: CGFloat = 24
        static let ExtraSpacing: CGFloat = 24
    }
    
    struct VM {
        let title: String
        let nameVM: NameView.VM
        let imageVM: ImageView.VM
        let infoVM: InfoView.VM
    }
    var viewModel: VM
    
    @State private var showingAlert = false
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                NameView(viewModel: viewModel.nameVM)
                
                ImageView(viewModel: viewModel.imageVM)
                    .padding(.top, Constants.ExtraSpacing).padding(.bottom, Constants.ExtraSpacing)
                    .onTapGesture {
                        self.showingAlert = !self.showingAlert
                    }
                
                InfoView(viewModel: viewModel.infoVM)
            }
            .padding(.bottom, Constants.ExtraSpacing)
        }
        .navigationBarTitle(Text(viewModel.title))
//        .environment(\.colorScheme, UserDefaults.standard.isDarkModeActived ? .dark : .light)
        .padding(.leading, -Constants.BigSpacing)
        .alert(isPresented: $showingAlert, content: { () -> Alert in
            Alert(title: Text(viewModel.title))
        })
    }
}

