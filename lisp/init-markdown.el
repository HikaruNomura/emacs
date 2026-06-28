;;; init-markdown.el --- Markdown editing & nice display -*- lexical-binding: t; -*-

;;; Commentary:
;; Markdown is a daily format here (md-based ADRs, docs/, notes).  Goals:
;; a clean in-buffer reading experience that also works in a terminal over
;; SSH, plus an optional rendered preview in GUI frames.
;;
;; .md files open in `gfm-mode' (GitHub-Flavored Markdown) since the repos
;; live on GitHub.  Fenced code blocks are highlighted in their own language,
;; headings are scaled, prose soft-wraps, and line numbers are hidden for a
;; document-like look.
;;
;; Preview:
;;   C-c C-c l   live preview (built-in; uses `markdown-command' = pandoc)
;;   C-c C-c v   export to HTML and open
;;   C-c C-c g   toggle grip-mode (accurate GitHub rendering; needs `grip',
;;               e.g. `pipx install grip' / `uv tool install grip')
;; Code blocks:
;;   C-c '       edit the block at point in its own language buffer
;;               (via edit-indirect)

;;; Code:

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'"        . gfm-mode)
         ("\\.markdown\\'"  . markdown-mode))
  :custom
  (markdown-fontify-code-blocks-natively t) ; syntax-highlight fenced code
  (markdown-header-scaling t)               ; larger headings (GUI)
  (markdown-enable-math t)                  ; fontify $...$ math
  (markdown-asymmetric-header t)            ; only leading #'s on headings
  :hook ((markdown-mode . visual-line-mode) ; soft-wrap prose
         (markdown-mode . (lambda () (display-line-numbers-mode -1))))
  :config
  ;; Use pandoc (or multimarkdown) for live preview / HTML export when present.
  (setq markdown-command (or (executable-find "pandoc")
                             (executable-find "multimarkdown")
                             markdown-command)))

;; Edit fenced code blocks in a dedicated, correctly-moded buffer (C-c ').
(use-package edit-indirect
  :ensure t
  :after markdown-mode)

;; Accurate GitHub-style preview (renders the way GitHub does).  Optional:
;; activates only when the `grip' program is installed.  In GUI frames with
;; xwidgets it renders inside Emacs; otherwise it opens a browser.
(use-package grip-mode
  :ensure t
  :after markdown-mode                    ; so markdown-mode-command-map exists
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode))
  :custom
  (grip-preview-use-webkit t))            ; in-Emacs preview when xwidgets exist

;; Generate / refresh a table of contents
;; (M-x markdown-toc-generate-or-refresh-toc).
(use-package markdown-toc
  :ensure t
  :after markdown-mode)

(provide 'init-markdown)
;;; init-markdown.el ends here
