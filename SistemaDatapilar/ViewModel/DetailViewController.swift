//
//  DetailViewController.swift
//  SistemaDatapilar
//
//  Created by Giovanni Tjahyamulia on 04/09/23.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ingredientsLabel:UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var drinkAlternateLabel: UILabel!
    
    @IBOutlet weak var websiteSourceButton: UIButton!
    @IBOutlet weak var youtubeSourceButton: UIButton!
    
    var meal: Meal!
    
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        fetchData()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setupData(){
        // Set image with Kingfisher
        let url = URL(string: meal.strMealThumb ?? "")
        let processor = DownsamplingImageProcessor(size: thumbnailImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 8)
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        /*
        // check status set image
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        */
        
        // Set data
        nameLabel.text = getLabel(value: meal.strMeal ?? "")
        originLabel.text = getLabel(value: meal.strArea ?? "")
        categoryLabel.text = getLabel(value: meal.strCategory ?? "")
        ingredientsLabel.text = getIngredientsLabel()
        instructionsLabel.text = getLabel(value: meal.strInstructions ?? "")
        drinkAlternateLabel.text = getLabel(value: meal.strDrinkAlternate ?? "")
        tagLabel.text = getTagLabel(value: meal.strTags ?? "")
        
        if(meal.strSource == "") {
            websiteSourceButton.isHidden = true
        }
        
        if(meal.strYoutube == "") {
            youtubeSourceButton.isHidden = true
        }
    }
    
    func getIngredientsLabel() -> String {
        var result: String = ""
        
        let ingredientsName: [String] = [
            meal.strIngredient1 ?? "", meal.strIngredient2 ?? "", meal.strIngredient3 ?? "", meal.strIngredient4 ?? "", meal.strIngredient5 ?? "", meal.strIngredient6 ?? "", meal.strIngredient7 ?? "", meal.strIngredient8 ?? "", meal.strIngredient9 ?? "", meal.strIngredient10 ?? "", meal.strIngredient11 ?? "", meal.strIngredient12 ?? "", meal.strIngredient13 ?? "", meal.strIngredient14 ?? "", meal.strIngredient15 ?? "", meal.strIngredient16 ?? "", meal.strIngredient17 ?? "", meal.strIngredient18 ?? "", meal.strIngredient19 ?? "", meal.strIngredient20 ?? ""
        ]
        
        let ingredientsMeasurement: [String] = [
            meal.strMeasure1 ?? "", meal.strMeasure2 ?? "", meal.strMeasure3 ?? "", meal.strMeasure4 ?? "", meal.strMeasure5 ?? "", meal.strMeasure6 ?? "", meal.strMeasure7 ?? "", meal.strMeasure8 ?? "", meal.strMeasure9 ?? "", meal.strMeasure10 ?? "", meal.strMeasure11 ?? "", meal.strMeasure12 ?? "", meal.strMeasure13 ?? "", meal.strMeasure14 ?? "", meal.strMeasure15 ?? "", meal.strMeasure16 ?? "", meal.strMeasure17 ?? "", meal.strMeasure18 ?? "", meal.strMeasure19 ?? "", meal.strMeasure20 ?? ""
        ]
        
        for i in 0...19 {
            if (ingredientsName[i] != "" && ingredientsMeasurement[i] != "") {
                if (result != "") {
                    result += "\n - \(ingredientsName[i]) (\(ingredientsMeasurement[i].lowercased()))"
                }
                else {
                    result += " - \(ingredientsName[i]) (\(ingredientsMeasurement[i].lowercased()))"
                }
            }
        }
        return result.replacingOccurrences(of: "  ", with: " ", options: .literal, range: nil)
    }
    
    /*
    func getInstructionLabel() -> String {
        var temp: String = meal.strInstructions ?? ""
        if (temp == "") {
            return "-"
        }
        return " - \(temp.replacingOccurrences(of: "\n", with: ".\n - ", options: .literal, range: nil).replacingOccurrences(of: ". ", with: ".\n - ", options: .literal, range: nil))"
    }
    */
    
    func getLabel(value: String) -> String {
        if (value == "") {
            return "-"
        }
        return value
    }
    
    func getTagLabel(value: String) -> String {
        if (value == "") {
            return "-"
        }
        return value.replacingOccurrences(of: ",", with: ", ", options: .literal, range: nil)
    }
    
    func openWebsite(url: String) {
        guard let url = URL(string: url) else {
          return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openWebsiteSource(_ sender: Any) {
        openWebsite(url: meal.strSource ?? "")
    }
    
    @IBAction func openYoutubeSource(_ sender: Any) {
        openWebsite(url: meal.strYoutube ?? "")
    }
}

extension DetailViewController {
    // Fetch Data with Alamofire
    func fetchData() {
        apiService.fetchDetail(idMeal: meal.idMeal ?? "", completion: { meal in
            self.meal = meal
            self.setupData()
        })
    }
}
