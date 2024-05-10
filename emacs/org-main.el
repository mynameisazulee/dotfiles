;; org todo keywords
;; ! = timestamp, @ = note with timestamp
(setq org-todo-keywords '((sequence "TODO(t)"
                                    "STARTED(s)"
                                    "WAITING(w)"
                                    "|"
                                    "DONE(d!)"
                                    "CANCELED(c@)"
                                    "DEFERRED(f@)")))

;; one separator empty line between org mode should fold as expected
(setq org-cycle-separator-lines 1)