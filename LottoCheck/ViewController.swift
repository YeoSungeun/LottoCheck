//
//  ViewController.swift
//  LottoCheck
//
//  Created by 여성은 on 6/5/24.
//

import UIKit
import Alamofire
import SnapKit

/*
 {"totSellamnt":116187023000,"returnValue":"success","drwNoDate":"2023-12-30","firstWinamnt":2207575472,"drwtNo6":43,"drwtNo4":30,"firstPrzwnerCo":13,"drwtNo5":31,"bnusNo":12,"firstAccumamnt":28698481136,"drwNo":1100,"drwtNo2":26,"drwtNo3":29,"drwtNo1":17}
 */

struct Lotto: Decodable {
    let drwNoDate: String
    let drwNo: Int
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
}

class ViewController: UIViewController {
    
    let numberTextField = UITextField()
    
    let infoLabel = UILabel()
    let dateLabel = UILabel()
    let divideView = UIView()
    
    let roundLabel = UILabel()
    
    let numsStatickView = UIStackView()
    
    let num1Label = UILabel()
    let num2Label = UILabel()
    let num3Label = UILabel()
    let num4Label = UILabel()
    let num5Label = UILabel()
    let num6Label = UILabel()
    let plusLabel = UILabel()
    let bonusLabel = UILabel()
    
    lazy var numArray: [UILabel] = [num1Label, num2Label, num3Label, num4Label, num5Label, num6Label, plusLabel, bonusLabel]
    
    let picker = UIPickerView()
    
    let roundArray = [Int](1000...1100)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest(number: 1100)
        configureHierarchy()
        configureLayout()
        configureUI()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        numsStatickView.layoutIfNeeded()    // 스택뷰를 기준으로 먼저 레이아웃 확정⭐️
        let radius = numsStatickView.frame.height / 2
        for item in numArray {
            item.layer.cornerRadius = radius
        }
    }
    func configureHierarchy() {
        view.addSubview(numberTextField)
        view.addSubview(infoLabel)
        view.addSubview(dateLabel)
        view.addSubview(divideView)
        view.addSubview(roundLabel)
        view.addSubview(numsStatickView)
        
        for item in numArray {
            numsStatickView.addArrangedSubview(item)
        }
        
        numberTextField.inputView = picker
    }
    func configureLayout() {
        numberTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(40)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.height.equalTo(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.bottom.equalTo(infoLabel.snp.bottom)
            make.height.equalTo(16)
        }
        divideView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        roundLabel.snp.makeConstraints { make in
            make.top.equalTo(divideView.snp.bottom).offset(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        numsStatickView.snp.makeConstraints { make in
            make.top.equalTo(roundLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(num1Label.snp.height)
        }
        for item in numArray {
            item.snp.makeConstraints { make in
                make.height.equalTo(num1Label.snp.width)
            }
        }
        
    }
    func configureUI() {
        view.backgroundColor = .white
        configurePickerView()
        configureStackView(stackView: numsStatickView)
        
        infoLabel.text = "당첨번호 안내"
        infoLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        dateLabel.font = .systemFont(ofSize: 11)
        dateLabel.textColor = .lightGray
        dateLabel.textAlignment = .right
        
        divideView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        numberTextField.borderStyle = .roundedRect
        numberTextField.layer.borderColor = UIColor.lightGray.cgColor
        numberTextField.layer.cornerRadius = 5
        numberTextField.textAlignment = .center
        numberTextField.font = .boldSystemFont(ofSize: 17)
        
        
        roundLabel.textAlignment = .center
        roundLabel.font = .boldSystemFont(ofSize: 20)
        for item in numArray {
            item.textAlignment = .center
            item.textColor = .white
            item.font = .boldSystemFont(ofSize: 13)
        }
        plusLabel.text = "+"
        plusLabel.textColor = .black

    }

    func configureStackView(stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
    }
    func setNumColor(label: UILabel) -> UIColor {
        print(#function)
        guard let text = label.text, let num = Int(text) else { return .clear}
        switch num {
        case 1...10:
            return UIColor(hexCode: "FFCF6C", alpha: 1)
        case 11...20:
            return UIColor(hexCode: "639BFC", alpha: 1)
        case 21...30:
            return UIColor(hexCode: "66DC42", alpha: 1)
        case 31...40:
            return UIColor(hexCode: "FA5D5D", alpha: 1)
        case 41...45:
            return UIColor(hexCode: "C6BEBE", alpha: 1)
        default:
            return .clear
        }
        
    }
    
    func callRequest(number: Int) {
        let url = "\(APIURL.lottoURL)\(number)"
        
        AF.request(url).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let value):
                self.num1Label.text = String(value.drwtNo1)
                self.num2Label.text = String(value.drwtNo2)
                self.num3Label.text = String(value.drwtNo3)
                self.num4Label.text = String(value.drwtNo4)
                self.num5Label.text = String(value.drwtNo5)
                self.num6Label.text = String(value.drwtNo6)
                self.bonusLabel.text = String(value.bnusNo)
                
                self.dateLabel.text = value.drwNoDate
                self.roundLabel.text = "\(value.drwNo)회 당첨 결과"

                self.numberTextField.text = "\(number)"
                for item in self.numArray {
                    item.backgroundColor = self.setNumColor(label: item)
                    item.clipsToBounds = true
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func configurePickerView() {
        picker.delegate = self
        picker.dataSource = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roundArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(roundArray[(roundArray.count - 1) - row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(#function)
        let roundNum = roundArray[(roundArray.count - 1) - row]
        numberTextField.text = "\(roundNum)"
        callRequest(number: roundNum)
    }
    
    
}


