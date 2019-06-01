//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Lauriane Haydari on 27/03/2019.
//  Copyright © 2019 Lauriane Haydari. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    // Relié au label (question Marsu dans le story board)
    var title = "" {
        didSet {
            label.text = title
        }
    }
        
    // énumère les différents style de vue des questions
    enum Style {
        case correct, incorrect, standard
    }
    
    var style : Style = .standard {
        didSet {
            setStyle(style)
        }
    }
        
    private func setStyle(_ style: Style){
        switch style {
        case .correct:
        backgroundColor = #colorLiteral(red: 0.7842472196, green: 0.9260502458, blue: 0.6268314719, alpha: 1)
        icon.image = UIImage(named: "icon-correct")
        icon.isHidden = false
        case .incorrect:
        backgroundColor = #colorLiteral(red: 0.9313799739, green: 0.5266035199, blue: 0.5792709589, alpha: 1)
        icon.image = UIImage(named: "icon-error")
        icon.isHidden = false
        case .standard:
        backgroundColor = #colorLiteral(red: 0.7487187982, green: 0.7688382268, blue: 0.7867640853, alpha: 1)
        icon.isHidden = true
        }
    }
    
    // énumère les différents style de récompenses
    enum Medal {
        case gold10, silver9, bronze8
    }
    
    var medal : Medal = .gold10 {
        didSet {
            rewardMedal(medal)
        }
    }
    
    private func rewardMedal(_ medal: Medal) {
        switch medal {
        case .gold10:
            backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        icon.image = UIImage(named: "icon-reward")
        icon.isHidden = false
        case .silver9:
            backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            icon.image = UIImage(named: "icon-reward-silver")
            icon.isHidden = false
        case .bronze8:
            backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            icon.image = UIImage(named: "icon-reward-bronze")
            icon.isHidden = false
        }
    }

} // End of class QuestionView
