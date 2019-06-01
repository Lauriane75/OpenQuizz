//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Lauriane Haydari on 27/03/2019.
//  Copyright © 2019 Lauriane Haydari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
        
        var game = Game()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
            
            startNewGame()
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
            questionView.addGestureRecognizer(panGestureRecognizer)
        }
        
        @IBAction func didTapNewGameButton() {
            startNewGame()
        }
    
        private func reward() {
            if game.score == 10 {
            activityIndicator.isHidden = true
            newGameButton.isHidden = false
            questionView.title = "Congratulations! You won the gold trophy!"
            questionView.medal = .gold10
            } else if game.score == 9 {
                activityIndicator.isHidden = true
                newGameButton.isHidden = false
                questionView.title = "Congratulations! You gold the silver medal!"
                questionView.medal = .silver9
            } else if game.score == 8 {
                activityIndicator.isHidden = true
                newGameButton.isHidden = false
                questionView.title = "Congratulations! You won the bronze medal"
                questionView.medal = .bronze8
            } else {
                activityIndicator.isHidden = true
                newGameButton.isHidden = false
                questionView.title = "You should try again"
                questionView.style = .standard
            }
    }
        
        private func startNewGame() {
            activityIndicator.isHidden = false
            newGameButton.isHidden = true
            
            questionView.title = "Wait..."
            questionView.style = .standard
            
            scoreLabel.text = "0 / 10"
            
            game.refresh()
        }
        
    @objc func questionsLoaded() {
            activityIndicator.isHidden = true
            newGameButton.isHidden = false
            questionView.title = game.currentQuestion.title
        }
        
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
            if game.state == .ongoing {
                switch sender.state {
                case .began, .changed:
                    transformQuestionViewWith(gesture: sender)
                case .ended, .cancelled:
                    answerQuestion()
                default:
                    break
                }
            }
        }
        
        private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: questionView)
            
            let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
            let translationPercent = translation.x/(UIScreen.main.bounds.width / 2)
            let rotationAngle = (CGFloat.pi / 3) * translationPercent
            let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
            
            let transform = translationTransform.concatenating(rotationTransform)
            questionView.transform = transform
            
            if translation.x > 0 {
                questionView.style = .correct
            } else {
                questionView.style = .incorrect
            }
        }
        
        private func answerQuestion() {
            switch questionView.style {
            case .correct:
                game.answerCurrentQuestion(with: true)
            case .incorrect:
                game.answerCurrentQuestion(with: false)
            case .standard:
                break
            }
            
            scoreLabel.text = "\(game.score) / 10"
            
            let screenWidth = UIScreen.main.bounds.width
            var translationTransform: CGAffineTransform
            if questionView.style == .correct {
                translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
            } else {
                translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.questionView.transform = translationTransform
            }, completion: { (success) in
                if success {
                    self.showQuestionView()
                }
            })
        }
        
        private func showQuestionView() {
            questionView.transform = .identity
            questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            questionView.style = .standard
            
            switch game.state {
            case .ongoing:
                questionView.title = game.currentQuestion.title
            case .over:
                reward()
            }
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.questionView.transform = .identity
            }, completion:nil)
        }
} // End of class ViewController

