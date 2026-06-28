;;; init-typescript.el --- TypeScript / TSX development -*- lexical-binding: t; -*-

;;; Commentary:
;; For the workspace's web packages: a pnpm monorepo of React 19 + Vite SPAs,
;; TypeScript 5.7 strict, bundler module resolution.  The project ships NO
;; linter or formatter (no eslint/prettier/biome, no config) -- typing is
;; gated by `tsc --noEmit'.  So we deliberately add NO formatter here (never
;; reformat code the project doesn't format itself); we only add a language
;; server, which is non-destructive: completion, hover, go-to-definition,
;; and type diagnostics.
;;
;; Editing uses the built-in tree-sitter modes (`typescript-ts-mode' /
;; `tsx-ts-mode'), enabled only when their grammars are installed so nothing
;; breaks where a compiler isn't available (e.g. native Windows).  Install
;; the grammars once with `M-x my/ts-install-grammars' (needs git + a C
;; compiler); the main TS target is Linux/WSL where both are present.
;;
;; LSP: eglot's default `typescript-language-server' (install it with
;; scripts/install-ts-lsp.sh).  Inlay hints are turned off globally by the
;; eglot hook in init-python, so that applies here too.

;;; Code:

(require 'treesit)

;; Where to fetch the grammars from (used by `my/ts-install-grammars').
(dolist (src '((typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                           "master" "typescript/src")
               (tsx        "https://github.com/tree-sitter/tree-sitter-typescript"
                           "master" "tsx/src")))
  (add-to-list 'treesit-language-source-alist src))

(defun my/typescript--enable ()
  "Route .ts/.tsx to the tree-sitter modes and eglot, when grammars exist."
  (when (treesit-ready-p 'typescript t)
    (dolist (ext '("\\.ts\\'" "\\.mts\\'" "\\.cts\\'"))
      (add-to-list 'auto-mode-alist (cons ext 'typescript-ts-mode)))
    (add-hook 'typescript-ts-mode-hook #'eglot-ensure))
  (when (treesit-ready-p 'tsx t)
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
    (add-hook 'tsx-ts-mode-hook #'eglot-ensure)))

(defun my/ts-install-grammars ()
  "Install the TypeScript and TSX tree-sitter grammars, then enable the modes."
  (interactive)
  (dolist (lang '(typescript tsx))
    (treesit-install-language-grammar lang))
  (my/typescript--enable)
  (message "TypeScript grammars installed; reopen .ts/.tsx buffers."))

;; Enable now for environments where the grammars are already present.
(my/typescript--enable)

(provide 'init-typescript)
;;; init-typescript.el ends here
