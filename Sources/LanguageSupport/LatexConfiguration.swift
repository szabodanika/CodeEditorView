import Foundation
import LanguageSupport
import RegexBuilder

// Define keywords that should be highlighted as reserved identifiers.
// This includes common commands that don't define a section.
private let latexReservedIds =
  ["documentclass", "usepackage", "author", "date", "title", "maketitle",
   "tableofcontents", "listoftables", "listoffigures",
   "begin", "end", "item", "label", "ref", "cite", "caption",
   "textbf", "textit", "texttt", "underline",
   "includegraphics", "include", "input",
   "frac", "sqrt", "sum", "int"]

// We can define special characters as "operators" for different highlighting.
private let latexReservedOperators =
  ["&", "_", "^", "$"]

extension LanguageConfiguration {

  /// Language configuration for LaTeX.
  ///
  public static var tex: LanguageConfiguration {
    
    // A LaTeX command starts with a backslash followed by one or more letters,
    // or a backslash followed by a single non-letter character.
    let commandRegex = Regex {
      "\\"
      OneOrMore(.word)
    }

    return LanguageConfiguration(name: "LaTeX",
                                 // LaTeX uses both kinds of brackets extensively.
                                 supportsSquareBrackets: true,
                                 supportsCurlyBrackets: true,
                                 
                                 // Unlike Haskell or Python, indentation doesn't define scope in LaTeX.
                                 indentationSensitiveScoping: false,
                                 
                                 // A single-line comment in LaTeX starts with a '%'.
                                 singleLineComment: "%",
                                 
                                 // LaTeX doesn't have a standard block comment syntax like "/* ... */",
                                 // so we leave this nil.
                                 nestedComment: nil,
                                 
                                 // We'll define a "command" as the primary identifier.
                                 identifierRegex: commandRegex,
                                 
                                 // We will use the operator regex for special characters.
                                 operatorRegex: /[\&_\^\$]/,
                                 
                                 // Pass in the list of common commands.
                                 reservedIdentifiers: latexReservedIds,
                                 
                                 // Pass in the list of special characters.
                                 reservedOperators: latexReservedOperators)
  }
}