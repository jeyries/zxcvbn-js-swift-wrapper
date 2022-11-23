import JavaScriptCore

public final class ZxcvbnJS {
    
    /*
    result.score      # Integer from 0-4 (useful for implementing a strength bar)

      0 # too guessable: risky password. (guesses < 10^3)

      1 # very guessable: protection from throttled online attacks. (guesses < 10^6)

      2 # somewhat guessable: protection from unthrottled online attacks. (guesses < 10^8)

      3 # safely unguessable: moderate protection from offline slow-hash scenario. (guesses < 10^10)

      4 # very unguessable: strong protection from offline slow-hash scenario. (guesses >= 10^10)

    result.feedback   # verbal feedback to help choose better passwords. set when score <= 2.

      result.feedback.warning     # explains what's wrong, eg. 'this is a top-10 common password'.
                                  # not always set -- sometimes an empty string

      result.feedback.suggestions # a possibly-empty list of suggestions to help choose a less
                                  # guessable password. eg. 'Add another word or two'
     */
    
    public struct Result {
        public let score: Int
        public let warning: String
        public let suggestions: String
    }
    
    public init() {
        // nothing here
    }
        
    private lazy var context: JSContext = {
        let scriptURL = Bundle.module.url(forResource: "zxcvbn", withExtension: "js")!
        let script = try! String(contentsOf: scriptURL)
        let context = JSContext()!
        context.evaluateScript(script)
        return context
    }()
    
    public func evaluate(password: String) -> Result {
        let zxcvbn = context.objectForKeyedSubscript("zxcvbn")!
        let result = zxcvbn.call(withArguments: [password])!
        let score = result.objectForKeyedSubscript("score")
        var warning: JSValue?
        var suggestions: JSValue?
        if let object = result.objectForKeyedSubscript("feedback") {
            warning = object.objectForKeyedSubscript("warning")
            suggestions = object.objectForKeyedSubscript("suggestions")
        }
        return Result(score: Int(score!.toInt32()),
                      warning: warning!.toString(),
                      suggestions: suggestions!.toString())
    }
}
