//
//  TriviaService.swift
//  Trivia
//
//  Created by Khanh Do on 10/15/23.
//

import Foundation

class TriviaService {
    static func fetchquestion(completion: (([TriviaQuestion]) -> Void)? = nil){
//        let parameters = "amount=\(amount)"
        let url = URL(string: "https://opentdb.com/api.php?amount=10")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            let decoder = JSONDecoder()
            let response = try! decoder.decode(TriviaAPIResponse.self, from: data)
            DispatchQueue.main.async {
                completion?(response.results)
            }
        }
        task.resume()
    }
    private static func parse(data: Data) -> TriviaQuestion {
        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let currentTriviaQuestion = jsonDictionary["results"] as! [String: Any]
        let category = currentTriviaQuestion["category"] as! String
        let question = currentTriviaQuestion["question"] as! String
        let type = currentTriviaQuestion["type"] as! String
        let correctAnswer = currentTriviaQuestion["correct_answer"] as! String
        let incorrectAnswers = currentTriviaQuestion["incorrect_answers"] as! [String]
        return TriviaQuestion(category: category, question: question, type: type, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
    }
}

