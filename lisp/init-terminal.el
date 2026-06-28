;;; init-terminal.el --- In-Emacs terminal for SSH/tmux -*- lexical-binding: t; -*-

;;; Commentary:
;; A real terminal *inside* Emacs, used to SSH out to a server and run
;; tmux + the Claude Code CLI there.  Typical workflow: Emacs runs locally
;; (e.g. on the Pomera DM250's terminal, with Japanese input), and from
;; inside Emacs we open a terminal, `ssh' to the DGX Spark, and work in a
;; remote tmux session.
;;
;; This is distinct from `init-claude' (which runs `claude' as a *local*
;; subprocess).  Here Emacs is just the terminal; Claude runs on the server.
;;
;; Backend is `eat' (pure Elisp, no native module) -- light enough for the
;; DM250 and a faithful terminal for TUI apps like tmux and the Claude TUI.
;;
;; IMPORTANT for remote tmux/claude: eat advertises its own TERM, so the
;; *server* needs eat's terminfo or full-screen apps render wrong.  Install
;; it once per server with scripts/sync-eat-terminfo.sh <host>.
;;
;; Keys (prefix C-c t):
;;   C-c t t  terminal here        C-c t o  terminal in other window
;;   C-c t p  terminal at project  C-c t s  SSH to a host (new terminal)

;;; Code:

(require 'init-platform)                  ; provides the `my' customize group

(defcustom my/ssh-hosts nil
  "SSH host names or ~/.ssh/config aliases offered by `my/ssh'."
  :type '(repeat string) :group 'my)

(defun my/ssh (host)
  "Open an eat terminal and SSH to HOST (always a fresh session)."
  (interactive (list (completing-read "SSH host: " my/ssh-hosts)))
  ;; PROGRAM may be a shell command; '(4) forces a new eat session so
  ;; multiple SSH terminals don't collide on one buffer.
  (eat (concat "ssh " host) '(4)))

(use-package eat
  :ensure t
  :commands (eat eat-other-window eat-project)
  :custom
  ;; Close the terminal buffer when the shell/ssh exits.
  (eat-kill-buffer-on-exit t)
  :bind (("C-c t t" . eat)
         ("C-c t o" . eat-other-window)
         ("C-c t p" . eat-project)
         ("C-c t s" . my/ssh)))

(provide 'init-terminal)
;;; init-terminal.el ends here
