//
//  LatexConfiguration.swift
//  protex
//
//  Created by Dániel Szabó on 21.8.2025.
//
//  Based on the structure of AgdaConfiguration.swift from LanguageSupport.
//

import Foundation
import LanguageSupport
import RegexBuilder

// A curated list of common LaTeX commands that should be highlighted as "keywords".
// This helps distinguish them from user-defined commands.
private let latexReservedIds = [
  // Preamble
  "documentclass", "usepackage", "author", "date", "title", "maketitle",
  
  // Document structure
  "part", "chapter", "section", "subsection", "subsubsection", "paragraph", "subparagraph",
  "tableofcontents", "listoftables", "listoffigures",
  
  // Environments
  "begin", "end",
  
  // Common commands
  "item", "label", "ref", "cite", "caption", "footnote", "emph",
  
  // Font styles
  "textbf", "textit", "texttt", "underline", "textrm", "textsf",
  
  // Graphics and layout
  "includegraphics", "include", "input", "newcommand", "renewcommand",
  "textwidth", "textheight",
  
  // Math
  "frac", "sqrt", "sum", "int", "lim", "sin", "cos", "log", "exp"
]

// Special characters in LaTeX that behave like operators.
private let latexReservedOperators = [
  "&", "_", "^", "$", "#", "%"
]

extension LanguageConfiguration {

  /// Language configuration for LaTeX.
  ///
  public static var latex: LanguageConfiguration {

    // --- Define the structure of a LaTeX command ---
    // A command is one of two things:
    // 1. A backslash `\` followed by one or more letters (e.g., `\section`).
    // 2. A backslash `\` followed by a single non-letter character (e.g., `\$`, `\%`).
    let letterCommand = Regex {
      One(.word)
      ZeroOrMore(.word)
    }
    let symbolCommand = One(.anyOf(!"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))
    
    let commandRegex = Regex {
      "\\"
      ChoiceOf {
        letterCommand
        symbolCommand
      }
    }

    return LanguageConfiguration(
      name: "LaTeX",
      
      // LaTeX uses both bracket types for arguments and options.
      supportsSquareBrackets: true,
      supportsCurlyBrackets: true,
      
      // Indentation is for human readability, not for the compiler.
      indentationSensitiveScoping: false,
      
      // LaTeX does not have a formal string or character literal syntax like a programming language.
      stringRegex: nil,
      characterRegex: nil,
      
      // LaTeX does not have a formal number syntax for the highlighter to detect.
      numberRegex: nil,
      
      // Single-line comments start with a percent sign.
      singleLineComment: "%",
      
      // LaTeX doesn't have a standard nested comment syntax (though packages can add it).
      nestedComment: nil,
      
      // The primary "identifier" in LaTeX is a command.
      identifierRegex: commandRegex,
      
      // We don't need a separate regex for operators as we list them explicitly below.
      operatorRegex: nil,
      
      // Pass in our curated list of known commands.
      reservedIdentifiers: latexReservedIds,
      
      // Pass in our list of special characters.
      reservedOperators: latexReservedOperators
    )
  }
}