//
//  ViewController.swift
//  Quiz
//
//  Created by cx on 2021/11/8.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var questionLabel:UILabel!
    @IBOutlet var answerLabel:UILabel!
    @IBOutlet var answerButton:UIButton!
    
    let questions: [String]=["what's your name?","how old are you?","how heavy are you?"]
    let answers:[String]=["zxl","26 years old","65 kilograms"]
    var currentQuestionIndex: Int=0
    
    @IBAction func showNextQuestion(sender: AnyObject){
        currentQuestionIndex+=1
        if(currentQuestionIndex==questions.count){
            currentQuestionIndex=0;
        }
        questionLabel.text=questions[currentQuestionIndex]
        answerLabel.text="???"
    }
    
    @IBAction func showAnswer(sender: AnyObject){
        answerLabel.text=answers[currentQuestionIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text=questions[currentQuestionIndex]
        // Do any additional setup after loading the view.
    }


}

