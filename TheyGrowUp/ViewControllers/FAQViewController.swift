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
    
    enum FAQError: Error {
        case FileUnavailable(fileName: String)
        case DataCorrupted(url: URL)
        case JustDoesNotWork(fileName:String)
    }

    override func viewDidLoad() {
        
        do {
            try parseQuestionSet(fileName: "faqs")
        } catch {
            print(FAQError.JustDoesNotWork(fileName: "faqs"))
        }
        
        let faqView = FAQView(frame: view.frame, items: items)
        faqView.titleLabel.text = "FAQs"
        faqView.titleLabelTextFont = UIFont(name: "HelveticaNeue-Light", size: 45)
        
        // Question text color
        faqView.questionTextColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        // Answer text color
        faqView.answerTextColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        // Question text font
        faqView.questionTextFont = UIFont(name: "HelveticaNeue-Light", size: 25)
        
        // Question text font
        faqView.answerTextFont = UIFont(name: "HelveticaNeue-Light", size: 25)
        
        // View background color
        faqView.viewBackgroundColor = UIColor.white
        
        // Set up data detectors for automatic detection of links, phone numbers, etc., contained within the answer text.
        faqView.dataDetectorTypes = [.link]
        
        // Set color for links and detected data
        faqView.tintColor = UIColor.blue
        self.view.addSubview(faqView)
        super.viewDidLoad()
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
            loadQuestions(customFAQs: self.FAQSet[0])
        } else {
            loadQuestions(customFAQs: self.FAQSet[1])
        }
    }
    
    func loadQuestions(customFAQs : FAQs) {
        items.removeAll()
        for i in 0..<customFAQs.answers.count {
            items.append(FAQItem(question: customFAQs.questions[i], answer: customFAQs.answers[i] ))
        }
    }
}
