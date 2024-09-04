import Alamofire
import Foundation

protocol APIDataDelegate: AnyObject {
    func didUpdateData()
    func didFailWithError(_ error: Error)
}

class APIData {
    weak var delegate: APIDataDelegate?
    
    private var cities: [City] = []
    private(set) var filteredCities: [City] = []
    private(set) var groupedCities = [String: [City]]()
    
    // Fetch city data from the API using Alamofire
    func fetchCities() {
        let url = "https://countriesnow.space/api/v0.1/countries/population/cities"
        
        AF.request(url).responseDecodable(of: CityResponse.self) { response in
            switch response.result {
            case .success(let cityResponse):
                self.cities = cityResponse.data
                self.filterAndGroupCities(searchText: "") // Initialize with all data
                DispatchQueue.main.async {
                    self.delegate?.didUpdateData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    // Filter and group cities based on search text
    func filterAndGroupCities(searchText: String) {
        if searchText.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.filter {
                $0.city.lowercased().hasPrefix(searchText.lowercased()) ||
                $0.country.lowercased().hasPrefix(searchText.lowercased())
            }
        }
        
        // Group filtered cities by country
        groupedCities.removeAll()
        for city in filteredCities {
            groupedCities[city.country, default: []].append(city)
        }
        
        delegate?.didUpdateData() // Notify delegate after filtering
    }
    
    // Get the number of sections (countries) for the table view
    func numberOfSections() -> Int {
        return groupedCities.keys.count
    }
    
    // Get the number of rows (cities) in a specific section (country)
    func numberOfRows(inSection section: Int) -> Int {
        let countryName = Array(groupedCities.keys)[section]
        return groupedCities[countryName]?.count ?? 0
    }
    
    // Get the country name for a specific section
    func countryName(forSection section: Int) -> String {
        return Array(groupedCities.keys)[section]
    }
    
    // Get the city for a specific index path
    func city(for indexPath: IndexPath) -> City {
        let countryName = countryName(forSection: indexPath.section)
        return groupedCities[countryName]?[indexPath.row] ?? City(city: "", country: "")
    }
}
