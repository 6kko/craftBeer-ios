//
//  Created by Michele Restuccia on 6/3/21.
//

import Foundation

enum MockJSON {
    case beers
    case beer
    
    var data: Data {
        let hardcodedJSON: String = {
            switch self {
            case .beers:
                return """
                [{"id":1,"name":"Buzz","tagline":"A Real Bitter Experience.","first_brewed":"09/2007","description":"A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.","image_url":"https://images.punkapi.com/v2/keg.png","abv":4.5,"ibu":60,"target_fg":1010,"target_og":1044,"ebc":20,"srm":10,"ph":4.4,"attenuation_level":75,"volume":{"value":20,"unit":"litres"},"boil_volume":{"value":25,"unit":"litres"},"method":{"mash_temp":[{"temp":{"value":64,"unit":"celsius"},"duration":75}],"fermentation":{"temp":{"value":19,"unit":"celsius"}},"twist":null},"ingredients":{"malt":[{"name":"Maris Otter Extra Pale","amount":{"value":3.3,"unit":"kilograms"}},{"name":"Caramalt","amount":{"value":0.2,"unit":"kilograms"}},{"name":"Munich","amount":{"value":0.4,"unit":"kilograms"}}],"hops":[{"name":"Fuggles","amount":{"value":25,"unit":"grams"},"add":"start","attribute":"bitter"},{"name":"First Gold","amount":{"value":25,"unit":"grams"},"add":"start","attribute":"bitter"},{"name":"Fuggles","amount":{"value":37.5,"unit":"grams"},"add":"middle","attribute":"flavour"},{"name":"First Gold","amount":{"value":37.5,"unit":"grams"},"add":"middle","attribute":"flavour"},{"name":"Cascade","amount":{"value":37.5,"unit":"grams"},"add":"end","attribute":"flavour"}],"yeast":"Wyeast 1056 - American Ale™"},"food_pairing":["Spicy chicken tikka masala","Grilled chicken quesadilla","Caramel toffee cake"],"brewers_tips":"The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus.","contributed_by":"Sam Mason <samjbmason>"}]
                """
                
            case .beer:
                return """
                [{"id":4,"name":"Pilsen Lager","tagline":"Unleash the Yeast Series.","first_brewed":"09/2013","description":"Our Unleash the Yeast series was an epic experiment into the differences in aroma and flavour provided by switching up your yeast. We brewed up a wort with a light caramel note and some toasty biscuit flavour, and hopped it with Amarillo and Centennial for a citrusy bitterness. Everything else is down to the yeast. Pilsner yeast ferments with no fruity esters or spicy phenols, although it can add a hint of butterscotch.","image_url":"https://images.punkapi.com/v2/4.png","abv":6.3,"ibu":55,"target_fg":1012,"target_og":1060,"ebc":30,"srm":15,"ph":4.4,"attenuation_level":80,"volume":{"value":20,"unit":"litres"},"boil_volume":{"value":25,"unit":"litres"},"method":{"mash_temp":[{"temp":{"value":65,"unit":"celsius"},"duration":null}],"fermentation":{"temp":{"value":9,"unit":"celsius"}},"twist":null},"ingredients":{"malt":[{"name":"Extra Pale","amount":{"value":4.58,"unit":"kilograms"}},{"name":"Caramalt","amount":{"value":0.25,"unit":"kilograms"}},{"name":"Dark Crystal","amount":{"value":0.06,"unit":"kilograms"}},{"name":"Munich","amount":{"value":0.25,"unit":"kilograms"}}],"hops":[{"name":"Centennial","amount":{"value":5,"unit":"grams"},"add":"start","attribute":"bitter"},{"name":"Amarillo","amount":{"value":5,"unit":"grams"},"add":"start","attribute":"bitter"},{"name":"Centennial","amount":{"value":10,"unit":"grams"},"add":"middle","attribute":"flavour"},{"name":"Amarillo","amount":{"value":10,"unit":"grams"},"add":"middle","attribute":"flavour"},{"name":"Centennial","amount":{"value":17.5,"unit":"grams"},"add":"end","attribute":"flavour"},{"name":"Amarillo","amount":{"value":17.5,"unit":"grams"},"add":"end","attribute":"flavour"}],"yeast":"Wyeast 2007 - Pilsen Lager™"},"food_pairing":["Spicy crab cakes","Spicy cucumber and carrot Thai salad","Sweet filled dumplings"],"brewers_tips":"Play around with the fermentation temperature to get the best flavour profile from the individual yeasts.","contributed_by":"Ali Skinner <AliSkinner>"}]
                """
            }
        }()
        
        let data = hardcodedJSON.data(using: .utf8)!
        return data
    }
}
