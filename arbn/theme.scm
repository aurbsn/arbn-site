(define-module (arbn theme)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt builder blog)
  #:use-module (srfi srfi-19)
  #:use-module (ice-9 match)
  #:export (arbn-theme))

(define (date->iso date)
  (date->string date "~Y-~m-~d"))

(define (post-href site post)
  (string-append "/" (site-post-slug site post) ".html"))

(define top-links
  '(("social" "https://functional.cafe/@arbn" ((rel "me")))
    ("code" "https://github.com/aurbsn" ((rel "me")))
    ("feed" "/feed.xml" ())))

(define (layout site title body)
  `((doctype "html")
    (html (@ (lang "en"))
          (head
           (meta (@ (charset "utf-8")))
           (meta (@ (name "viewport")
                    (content "width=device-width, initial-scale=1")))
           (meta (@ (name "color-scheme") (content "light dark")))
           (title ,(string-append title " — " (site-title site)))
           (link (@ (rel "stylesheet") (href "/css/style.css")))
           (link (@ (rel "alternate") (type "application/atom+xml")
                    (title ,(site-title site)) (href "/feed.xml"))))
          (body
           (header (@ (class "site-header"))
                   (a (@ (class "site-title") (href "/")) ,(site-title site))
                   (nav (ul ,@(map (match-lambda ((name link attrs) `(li (a (@ (href ,link) ,@attrs) ,name)))) top-links))))
           (main ,body)
           (footer (@ (class "site-footer"))
                   "© " ,(date->string (current-date) "~Y") " Austin Robinson. Content licensed "
                   (a (@ (rel "license")
                         (href "https://creativecommons.org/licenses/by-sa/4.0/"))
                      "CC BY-SA 4.0")
                   ".")))))

(define (post-template post)
  `(article
    (h1 ,(post-ref post 'title))
    (p (@ (class "meta"))
     (time (@ (datetime ,(date->iso (post-date post))))
           ,(date->string (post-date post) "~B ~e, ~Y")))
    ,(post-sxml post)))

(define (collection-template site title posts prefix)
  `((h2 ,title)
    (ul (@ (class "post-list"))
     ,@(map (lambda (post)
              `(li (a (@ (href ,(post-href site post)))
                      ,(post-ref post 'title))
                   (time (@ (datetime ,(date->iso (post-date post))))
                         ,(date->iso (post-date post)))))
            (posts/reverse-chronological posts)))))

(define arbn-theme
  (theme #:name "arbn"
         #:layout layout
         #:post-template post-template
         #:collection-template collection-template))
