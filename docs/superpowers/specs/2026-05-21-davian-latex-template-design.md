# DAVIAN LaTeX Template — Design

Date: 2026-05-21
Owner: Kang Eun Jeon (DAVIAN Lab, KAIST AI)

## Goal

A reusable, lab-branded single-column LaTeX template for arXiv-style preprints
and technical reports, visually inspired by the reference paper in `ref/`
("Draft Less, Retrieve More", Qwen/Zhejiang Univ. arXiv report) but using
freely-available fonts and a cleaner, maintainable structure.

## Reference analysis

The reference PDF (`ref/2605.20104v1.pdf`) uses:
- Body: XCharter (Charter family)
- Title/headings: Futura-style geometric sans
- Math: tx-fonts + XCharterMath
- Mono: Latin Modern Mono
- Single-column layout, centered title, numbered-affiliation author block
  with `*` (equal contribution) and `†` (corresponding author) daggers.

## Decisions (locked)

- **Scope:** single-column report/preprint class only.
- **Fidelity:** "inspired-by / cleaner" — free fonts, our own polish.
- **Base:** fork `kourgeorge/arxiv-style` (`arxiv.sty`, permissive license),
  renamed into a self-contained `davian.cls`.
- **Branding:** DAVIAN Lab, KAIST AI baked in as default affiliation, with
  override macros.
- **Body font:** XCharter.
- **Heading/title font:** Montserrat (free geometric sans, Futura analog).
- **Math font:** `newtxmath` keyed to Charter.
- **Accent color:** KAIST deep blue (~#004191), used for section numbers,
  links, and rules.
- **Engine:** pdfLaTeX (all fonts pdfLaTeX-compatible).

## Components

- `davian.cls` — restyled class derived from `arxiv.sty`:
  - font setup (XCharter + Montserrat + newtxmath + LM mono)
  - `titlesec` heading styles in accent color
  - title/author block with numbered affiliations + `*`/`†` daggers
  - abstract styling, `hyperref`/`cleveref` colored links, `caption`,
    `booktabs`, `enumitem`, `microtype` defaults
  - author/affiliation macros with DAVIAN/KAIST defaults
- `main.tex` — worked example doubling as a feature showcase (title, authors,
  abstract, sections, figure, table, equation, citations, bibliography).
- `references.bib` — sample references.
- `figures/` — KAIST/DAVIAN logo placeholders.
- `latexmkrc` — one-command build (`latexmk -pdf`).
- `README.md` — usage and customization docs.

## Build/verify

- Compile `main.tex` with `latexmk -pdf` end-to-end with no errors.
- Confirm a PDF is produced and visually sanity-check the title block,
  headings, math, table, and references render correctly.

## Out of scope (YAGNI)

- Two-column / conference variant.
- Beamer slide theme.
- xelatex/lualatex font loading.
