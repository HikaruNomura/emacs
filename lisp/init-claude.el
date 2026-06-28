;;; init-claude.el --- Claude Code integration -*- lexical-binding: t; -*-

;;; Commentary:
;; Drive the Claude Code CLI from inside Emacs (the top-priority workflow:
;; most code here is written with Claude).  Uses stevemolitor's
;; `claude-code.el', which runs `claude' in a terminal buffer scoped to the
;; current project and can send the buffer/region to the session.
;;
;; Terminal backend is **eat** (pure Elisp, no native module to compile),
;; so this works the same on Windows/WSL2/DGX Spark/Pomera DM250, GUI or
;; -nw.  No API key is needed: it reuses the `claude' CLI's own auth.
;;
;; Note: the MELPA package literally named "claude-code" is a *different*,
;; vterm-only project (yuya373/claude-code-emacs); we deliberately install
;; stevemolitor's eat-capable one from Git via :vc instead.
;;
;; Entry points:
;;   C-c c          prefix map for all Claude Code commands
;;   C-c c c        start / open a Claude Code session for this project
;;   C-c c t        toggle the Claude window
;;   C-c c r        send the active region
;;   M-x claude-code-transient   menu of everything

;;; Code:

;; Pure-Elisp terminal backend; no libvterm/cmake build required.
(use-package eat
  :ensure t)

(use-package claude-code
  :vc (:url "https://github.com/stevemolitor/claude-code.el")
  ;; No `:after eat': we want the `C-c c' prefix installed at startup.
  ;; `claude-code' pulls in `eat' itself when a session is first started.
  :custom
  ;; Be explicit even though `eat' is the default.
  (claude-code-terminal-backend 'eat)
  ;; Path to the CLI; must be on `exec-path'.  Override per-host if needed.
  (claude-code-program "claude")
  :bind-keymap ("C-c c" . claude-code-command-map)
  :config
  (claude-code-mode 1))

(provide 'init-claude)
;;; init-claude.el ends here
