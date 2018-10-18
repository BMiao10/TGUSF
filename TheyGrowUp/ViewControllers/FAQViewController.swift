//
//  FAQViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 10/10/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {

    var items = [FAQItem]()
    var FAQSet = [FAQs]()
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    enum FAQError: Error {
        case FileUnavailable(fileName: String)
        case DataCorrupted(url: URL)
        case JustDoesNotWork(fileName:String)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try parseQuestionSet(fileName: "faqs")
        } catch {
            print(FAQError.JustDoesNotWork(fileName: "faqs"))
        }
        
        let faqView = FAQView(frame: view.frame, items: items)
        faqView.titleLabel.text = "Frequently Asked Questions"
        faqView.titleLabelTextFont = UIFont.systemFont(ofSize: 36, weight: .medium)
        faqView.titleLabelTextColor = #colorLiteral(red: 0.231372549, green: 0.3137254902, blue: 0.3921568627, alpha: 1)
        
        // Question text color
        faqView.questionTextColor = #colorLiteral(red: 0.1294117647, green: 0.4039215686, blue: 0.4, alpha: 1)
        
        // Answer text color
        faqView.answerTextColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        // Question text font
        faqView.questionTextFont = UIFont.systemFont(ofSize: 22, weight: .medium)
        
        // Question text font
        faqView.answerTextFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // View background color
        faqView.cellBackgroundColor = #colorLiteral(red: 0.9861111111, green: 1, blue: 1, alpha: 1)
        faqView.separatorColor = #colorLiteral(red: 0.5887696382, green: 0.7268461196, blue: 0.8431563377, alpha: 1)
        faqView.viewBackgroundColor = UIColor.clear
        
        // Set up data detectors for automatic detection of links, phone numbers, etc., contained within the answer text.
        faqView.dataDetectorTypes = [.link]
        
        // Set color for links and detected data
        faqView.tintColor = UIColor.blue
        
        self.view.insertSubview(faqView, belowSubview: emailButton)
    }
    
    func parseQuestionSet(fileName: String) throws {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw FAQError.FileUnavailable(fileName: fileName)
        }
        
        guard let data = try? Data(contentsOf: url),
            let jsonData = try? JSONDecoder().decode([FAQs].self, from: data)
            else {
                throw FAQError.DataCorrupted(url: url)
        }
        
        self.FAQSet = jsonData
        
        //for demo purposes
        //TODO: extend for additional metrics
        if (Parent.shared.journeys.last?.intent)! > 0 {
            loadQuestions(customFAQs: self.FAQSet[1])
        } else {
            loadQuestions(customFAQs: self.FAQSet[0])
        }
    }
    
    func loadQuestions(customFAQs : FAQs) {
        items.removeAll()
        for i in 0..<customFAQs.answers.count {
            items.append(FAQItem(question: customFAQs.questions[i], answer: customFAQs.answers[i] ))
        }
    }
    
    @IBAction func restartGame(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func emailFAQs(_ sender: Any) {
        let cdc = "https://www.cdc.gov/vaccines/parents/parent-questions.html"
        if let url = URL(string: "mailto:?subject=Vaccination%20FAQs&body=\(cdc)") {
            UIApplication.shared.open(url)
        }
    }
}
