import UIKit

class ViewController: UIViewController, APIDataDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var apiData = APIData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configTableview()
        fetchData()
    }
    
    func setupView() {
        title = "City Populations"
        apiData.delegate = self
        searchBar.delegate = self
    }
    
    func configTableview() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchData() {
        apiData.fetchCities()
    }
    
    // MARK: - APIDataDelegate Methods
    func didUpdateData() {
        tableView.reloadData()
    }

    func didFailWithError(_ error: Error) {
        print("Error fetching data: \(error)")
    }
    
    // MARK: - Search Bar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        apiData.filterAndGroupCities(searchText: searchText)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return apiData.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiData.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return apiData.countryName(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityTableViewCell
        let city = apiData.city(for: indexPath)
        cell.configure(with: city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = apiData.city(for: indexPath)
        print("Selected city: \(city.city), Country: \(city.country)")
    }
}
