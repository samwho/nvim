; extends
; Lit tagged templates

; css`...`
(call_expression
  function: (identifier) @_lit_css_tag
  (template_string) @injection.content
  (#eq? @_lit_css_tag "css")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "css"))

; html`...`
(call_expression
  function: (identifier) @_lit_html_tag
  (template_string) @injection.content
  (#eq? @_lit_html_tag "html")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "html"))
