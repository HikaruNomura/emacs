;;; init-python.el --- Python development -*- lexical-binding: t; -*-

;;; Commentary:
;; Tuned for the main workspace (nemophila-workspace): a uv monorepo with a
;; src layout and PEP 420 namespace packages, checked with ruff (line-length
;; 100, py312) + mypy --strict, tested with pytest.  No language server is
;; committed to the repo, so we add one locally for navigation only.
;;
;; `pet' does the heavy lifting: per buffer it finds the project's `.venv'
;; (uv-aware, Scripts/ on Windows or bin/ on Linux) and rewrites `exec-path'
;; and the relevant tool variables, so ruff/mypy/pytest/the LSP all resolve
;; to the project's own tools without hardcoding any path.  That keeps this
;; config correct whether Emacs runs on native Windows, WSL2, or the Spark.
;;
;; Stack:
;;   pet         -> detect .venv + tools per buffer
;;   eglot       -> basedpyright for completion / hover / go-to-definition
;;   apheleia    -> format on save with `ruff' (imports then format)
;;   flymake-ruff-> live ruff lint
;;   mypy        -> the authoritative strict type gate (C-c m, via compile)
;;   pytest      -> python-pytest (C-c y)
;;
;; basedpyright is NOT a project dependency; install it locally, e.g.
;;   uv tool install basedpyright    (see scripts/install-python-lsp.sh)
;; mypy stays the strict gate, so basedpyright is kept light to avoid
;; drowning in duplicate type diagnostics.

;;; Code:

;; Detect the project's virtualenv and point every Python tool at it.
;; Priority -10 so this runs before the other python hooks below.
(use-package pet
  :ensure t
  :config
  (add-hook 'python-base-mode-hook #'pet-mode -10)
  (pet-eglot-setup))                     ; make eglot use the venv's server

(use-package eglot
  :ensure nil                            ; built in
  :hook ((python-base-mode . eglot-ensure)
         ;; Inlay type hints clutter code we mostly read; keep them off.
         (eglot-managed-mode . (lambda () (eglot-inlay-hints-mode -1))))
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 "basedpyright-langserver" "--stdio"))
  ;; Navigation-focused: lighter than basedpyright's default, only diagnose
  ;; open files, and leave strict whole-project typing to mypy.
  (setq-default eglot-workspace-configuration
                '(:basedpyright
                  (:analysis (:typeCheckingMode "standard"
                              :diagnosticMode "openFilesOnly")))))

;; Format on save with ruff (sort imports, then format) -- pet has already
;; pointed the `ruff' formatter at the project's binary.
(use-package apheleia
  :ensure t
  :config
  (setf (alist-get 'python-mode apheleia-mode-alist) '(ruff-isort ruff)
        (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff))
  (apheleia-global-mode 1))

;; Live ruff linting in addition to basedpyright's diagnostics.
(use-package flymake-ruff
  :ensure t
  :hook (python-base-mode . flymake-ruff-load))

;; Run the project's strict mypy from the project root (uses pyproject's
;; `files'); pet has put the venv's mypy on `exec-path'.
(defun my/python-mypy ()
  "Run the project's mypy from the directory holding pyproject.toml."
  (interactive)
  (let ((default-directory (or (locate-dominating-file
                                default-directory "pyproject.toml")
                               default-directory)))
    (compile "mypy")))

(use-package python-pytest
  :ensure t
  :bind (:map python-base-mode-map
              ("C-c y" . python-pytest-dispatch)
              ("C-c m" . my/python-mypy)))

;; Prefer tree-sitter Python where the grammar is present; fall back to
;; python-mode otherwise (e.g. native Windows without a C compiler).
(when (and (fboundp 'treesit-available-p)
           (treesit-available-p)
           (treesit-language-available-p 'python))
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)))

(provide 'init-python)
;;; init-python.el ends here
