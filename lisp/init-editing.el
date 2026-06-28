;;; init-editing.el --- Editing & UX niceties -*- lexical-binding: t; -*-

;;; Commentary:
;; Small, broadly-expected quality-of-life defaults and discoverability.
;; Most of these ship with Emacs 30; only ws-butler is external.

;;; Code:

;; Discover keybindings -- handy now that there are several prefixes
;; (C-c c Claude, C-c t terminal, C-c y pytest, C-c m mypy, ...).
(use-package which-key
  :ensure nil                            ; built in (Emacs 30)
  :custom
  (which-key-idle-delay 0.5)
  :init (which-key-mode 1))

;; Recent files, opened through consult's nicer UI.
(use-package recentf
  :ensure nil                            ; built in
  :bind ("C-x C-r" . consult-recent-file)
  :custom
  (recentf-max-saved-items 300)
  (recentf-exclude '("/tmp/" "/ssh:" "/elpa/" "/\\.git/"))
  :init (recentf-mode 1))

;; Reopen files at the cursor position you left them.
(use-package saveplace
  :ensure nil                            ; built in
  :init (save-place-mode 1))

;; Honour per-project .editorconfig (indent style/size, final newline).
(use-package editorconfig
  :ensure nil                            ; built in (Emacs 30)
  :init (editorconfig-mode 1))

;; Stay responsive in files with very long lines (minified JS, lockfiles).
(use-package so-long
  :ensure nil                            ; built in
  :init (global-so-long-mode 1))

;; Trim trailing whitespace only on lines actually edited -- keeps diffs
;; clean in shared repos, unlike a blanket `delete-trailing-whitespace'.
(use-package ws-butler
  :ensure t
  :hook ((prog-mode text-mode) . ws-butler-mode))

;; Widely-expected editing defaults.
(use-package emacs
  :ensure nil
  :custom
  (require-final-newline t)              ; files end with a newline
  :init
  (electric-pair-mode 1)                 ; auto-close brackets/quotes
  (delete-selection-mode 1))             ; typing replaces the active region

(provide 'init-editing)
;;; init-editing.el ends here
