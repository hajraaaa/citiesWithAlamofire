import Foundation

// A model representing a city, conforms to Decodable for JSON decoding
struct City :Decodable{
    let city: String
    let country: String
}

struct CityResponse :Decodable{
    let data: [City] // An array of cities returned from the API
}

