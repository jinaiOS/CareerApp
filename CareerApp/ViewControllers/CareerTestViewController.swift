//
//  CareerTestViewController.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/14.
//

import UIKit
import Alamofire

class CareerTestViewController: UIViewController {
    
    @IBOutlet var tvMain: UITableView!
    
    var questionData: [DataInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTest(testNumber: "진로흥미탐색")
        tvMain.delegate = self
        tvMain.dataSource = self
        tvMain.register(UINib(nibName: "CareerTestTableViewCell", bundle: nil), forCellReuseIdentifier: "CareerTestTableViewCell")
    }
    
    func getTest(testNumber: String) {
        let url = "https://www.career.go.kr/inspct/openapi/test/questions"
        let params = ["apikey":"7811821671dcaf7497a7a19b33d9f919","q":"17"] as Dictionary
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<600)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let list = try JSONDecoder().decode(TestQuestionModel.self, from: data)
                    self.questionData = list.result
                    self.tvMain.reloadData()
                    print(list.result)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CareerTestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareerTestTableViewCell", for: indexPath) as! CareerTestTableViewCell
        cell.lblTitle.text = questionData?[indexPath.row].question
        cell.lblAnswer1.text = questionData?[indexPath.row].answer01
        cell.lblAnswer2.text = questionData?[indexPath.row].answer02
        cell.lblAnswer3.text = questionData?[indexPath.row].answer03
        cell.lblAnswer4.text = questionData?[indexPath.row].answer04
        cell.lblAnswer5.text = questionData?[indexPath.row].answer05
        cell.lblAnswer6.text = questionData?[indexPath.row].answer06
        cell.lblAnswer7.text = questionData?[indexPath.row].answer07
        return cell
    }
}
