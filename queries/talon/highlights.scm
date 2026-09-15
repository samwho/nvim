; Context headers
(match
  left: (identifier) @keyword
  right: (implicit_string) @string)
(match_modifier) @keyword

; Spoken command rules
(word) @function
(list
  list_name: (identifier) @type)
(capture
  capture_name: (identifier) @variable.parameter)
(start_anchor) @operator
(end_anchor) @operator

; Special declarations and bindings
[
  "app("
  "face("
  "deck("
  "gamepad("
  "noise("
  "parrot("
  "key("
  "sleep("
] @function.builtin
(settings_binding) @function.builtin
(tag_binding) @function.builtin

(implicit_string) @string

(tag_import_declaration
  right: (identifier) @type)

; Statements and expressions
[
  "if"
  "for"
  "in"
] @keyword

(assignment_statement
  left: (identifier) @variable)
(for_statement
  name: (identifier) @variable)
(variable
  variable_name: (identifier) @variable)
(action
  action_name: (identifier) @function.call)

[
  (operator)
  "="
  "|"
  "*"
  "+"
] @operator

(integer) @number
(float) @number.float
(string) @string
(string_escape_sequence) @string.escape
(interpolation
  ["{" "}"] @punctuation.special)

(comment) @comment @spell

["(" ")" "[" "]" "{" "}" "<" ">"] @punctuation.bracket
[":" "," "-"] @punctuation.delimiter
