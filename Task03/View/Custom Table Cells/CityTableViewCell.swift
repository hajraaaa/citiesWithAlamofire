import UIKit

class CityTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() // Called when the cell is loaded from the nib or storyboard
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Configure cell with city data
    func configure(with city: City) {
        cityLabel.text = city.city
//        countryLabel.text = city.country
    }
}

