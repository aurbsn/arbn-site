(add-to-load-path (dirname (current-filename)))

(use-modules (haunt asset)
             (haunt site)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt reader skribe)
             (arbn theme))

(site #:title "arbn.nyc"
      #:domain "arbn.nyc"
      #:default-metadata
      '((author . "Austin Robinson")
        (email  . "arbn@arbn.nyc"))
      #:readers (list skribe-reader)
      #:builders (list (blog #:theme arbn-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (static-directory "css")))
