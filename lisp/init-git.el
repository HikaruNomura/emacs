;;; init-git.el --- Git integration -*- lexical-binding: t; -*-

;;; Commentary:
;; Magit: the standard interface for Git inside Emacs.  `C-x g' opens the
;; status buffer for the current repository.

;;; Code:

(use-package magit
  :bind (("C-x g" . magit-status))
  :custom
  ;; Show fine-grained (word-level) diffs in the status/diff buffers.
  (magit-diff-refine-hunk t))

(provide 'init-git)
;;; init-git.el ends here
