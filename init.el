;;; init.el --- Main configuration entry point -*- lexical-binding: t; -*-

;;; Commentary:
;; Sets up package archives and use-package, then loads the modular
;; configuration from the lisp/ directory.  Add a new module by creating
;; lisp/init-FOO.el and adding a (require 'init-FOO) line below.

;;; Code:

;; Make our lisp/ modules visible to `require'.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Package archives.
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; use-package ships with Emacs 29+.  Install missing packages by default.
(require 'use-package)
(setq use-package-always-ensure t)

;; --- Configuration modules ------------------------------------------------
(require 'init-platform)                 ; environment detection (load first)
(require 'init-ui)
(require 'init-japanese)                  ; comfortable Japanese input (top priority)
(require 'init-completion)
(require 'init-git)
(require 'init-claude)                    ; Claude Code integration (local claude)
(require 'init-terminal)                  ; in-Emacs terminal for SSH/tmux (remote claude)
(require 'init-dired)
(require 'init-python)
(require 'init-typescript)
(require 'init-markdown)
(require 'init-latex)
(require 'init-theme)
(require 'init-fonts)

;; Keep Customize's generated output out of version control.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file 'noerror))

;;; init.el ends here
