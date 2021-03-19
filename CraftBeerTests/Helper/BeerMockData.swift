//
//  Created by Michele Restuccia on 18/3/21.
//

@testable import CraftBeer

enum BeerMockData {
    
    static var bannerVM: [BeerListViewController.CollectionView.BannerCell.VM] {
        [.emptyPhoto()]
    }
    
    static var featureVM: [BeerListViewController.CollectionView.FeatureCell.VM] {
        [.init(title: "home-feature-title-1".localized, photo: .emptyPhoto())]
    }
    
    static var blocksVM: BeerListViewController.VM.BlocksVM {
        .init(
            title: "home-block-title".localized,
            contents: [
                .init(ID: 12345, title: "Pilsen Lager", photo: .emptyPhoto()),
                .init(ID: 12345, title: "Avery Brown Dredge", photo: .emptyPhoto())
            ])
    }
    
    static var inlineVM: BeerListViewController.VM.InlineVM {
        .init(
            title: "home-inline-title".localized,
            contents: [
                .init(ID: 12345, title: "Libertine Porter", photo: .emptyPhoto()),
                .init(ID: 12345, title: "Arcade Nation", photo: .emptyPhoto()),
                .init(ID: 12345, title: "Movember", photo: .emptyPhoto()),
                .init(ID: 12345, title: "Misspent Youth", photo: .emptyPhoto()),
            ])
    }
    
    static var basicInfoVM: BeerDetailsViewController.ContentViewController.BasicInfoView.VM {
        .init(title: "Pilsen Lager",
              subtitle: "Unleash the Yeast Series.",
              description: "Our Unleash the Yeast series was an epic experiment into the differences in aroma and flavour provided by switching up your yeast. We brewed up a wort with a light caramel note and some toasty biscuit flavour, and hopped it with Amarillo and Centennial for a citrusy bitterness. Everything else is down to the yeast. Pilsner yeast ferments with no fruity esters or spicy phenols, although it can add a hint of butterscotch.",
              alcohol: 6.2,
              bitter: 55,
              color: 15,
              photos: [.emptyPhoto()]
        )
    }
}
