//
//  ViewController.swift
//  SistemaDatapilar
//
//  Created by Giovanni Tjahyamulia on 04/09/23.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var meals: [Meal]!
    
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        fetchData()
    }
    
    // Setup and Register NIB
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.backgroundColor = .clear
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meals == nil {
            return 0
        }
        return meals.count
    }
    
    // Set table view cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as! ItemTableViewCell
        cell.nameLabel.text = meals[indexPath.row].strMeal
        
        // set image with Kingfisher
        let url = URL(string: meals[indexPath.row].strMealThumb ?? "")
        let processor = DownsamplingImageProcessor(size: cell.thumbnailImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.thumbnailImageView.kf.indicatorType = .activity
        cell.thumbnailImageView.kf.setImage(
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
        
        /*
        // set image manually
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = UIImage(data: data!)
            }
        }
        */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.meal = meals[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension MainViewController {
    // Fetch Data using Alamofire
    func fetchData() {
        apiService.fetchList { meals in
            // Set Local Data
            self.meals = meals
            
            DispatchQueue.main.async {
                // Update Table View Data
                self.tableView.reloadData()
            }
        }
    }
    
    /*
    // Retrieve Data Manually
    func retrieve(){
        apiService.retrieve(
            type: ResponseMeal.self,
            endpoint: .fetchList
        )
        { [weak self] result in
            switch result {
                case .success(let result):
                    self?.meals = result.meals
                
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let err):
                    let alert = UIAlertController(title: "We are sorry", message: "\(err)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    }))
                    self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    */
}
