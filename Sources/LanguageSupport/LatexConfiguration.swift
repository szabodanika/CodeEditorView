import Foundation
import LanguageSupport
import RegexBuilder

private let latexReservedIds = [
  "documentclass", "usepackage", "author", "date", "title", "maketitle",
  "part", "chapter", "section", "subsection", "subsubsection", "paragraph", "subparagraph",
  "tableofcontents", "listoftables", "listoffigures",
  "begin", "end",
  "item", "label", "ref", "cite", "caption", "footnote", "emph",
  "textbf", "textit", "texttt", "underline", "textrm", "textsf",
  "includegraphics", "include", "input", "newcommand", "renewcommand",
  "textwidth", "textheight",
  "frac", "sqrt", "sum", "int", "lim", "sin", "cos", "log", "exp"
]

private let latexReservedOperators = [
  "&", "_", "^", "$", "#", "%"
]

extension LanguageConfiguration {

  public static var latex: LanguageConfiguration {

    // --- Define the structure of a LaTeX command ---
    
    // 1. A command made of letters (e.g., \section)
    let letterCommand = Regex {
      OneOrMore(.word) // .word is equivalent to a-zA-Z0-9_
    }
    
    // 2. A command made of a single non-letter symbol (e.g., \$)
    //    This is the corrected syntax. We define a CharacterClass of all letters
    //    and then invert it.
    let nonLetterCharacter = CharacterClass.anyOf("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
    let symbolCommand = Regex {
        nonLetterCharacter
    }
    
    // The final regex for an identifier (a command)
    let commandRegex = Regex {
      "\\"
      ChoiceOf {
        letterCommand
        symbolCommand
      }
    }

    return LanguageConfiguration(
      name: "LaTeX",
      supportsSquareBrackets: true,
      supportsCurlyBrackets: true,
      indentationSensitiveScoping: false,
      stringRegex: nil,
      characterRegex: nil,
      numberRegex: nil,
      singleLineComment: "%",
      nestedComment: nil,
      identifierRegex: commandRegex,
      operatorRegex: nil,
      reservedIdentifiers: latexReservedIds,
      reservedOperators: latexReservedOperators
    )
  }
}