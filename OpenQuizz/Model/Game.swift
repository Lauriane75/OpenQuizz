//
//  Game.swift
//  OpenQuizz
//
//  Created by Lauriane Haydari on 27/03/2019.
//  Copyright © 2019 Lauriane Haydari. All rights reserved.
//

import Foundation

class Game {
    var score = 0
    
    private var questions = [Question]()
    private var currentIndex = 0
    
    var state: State = .ongoing
    
    enum State {
        case ongoing, over
    }
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    
    
    
    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
    }
    
    
    func refresh() {
        // elle redémarre la partie en mettant le score à 0
        score = 0
        currentIndex = 0
        state = .over
        // Elle charge de nouvelle question sur internet
        // Fermeture avec la fonction get pour charger les question
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            // elle envoie une notification pour dire que les questions sont chargées
            // Notification.Name = structure
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            // je crée ma notif que je vais envoyer
            let notification = Notification(name: name)
            // poste principal = default
            NotificationCenter.default.post(notification)
            // mon modèle emmet une notif pour QuestionsLoaded
        }
    }
    

    
    
} // End of class Game
