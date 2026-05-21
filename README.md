# DAVIAN LaTeX Template

A clean, single-column LaTeX template for arXiv-style preprints and technical
reports, branded for **DAVIAN Lab, KAIST AI**. Styled after modern AI tech
reports (XCharter body, Montserrat headings, Charter-matched math, KAIST-blue
accent).

## Quick start

```bash
latexmk -pdf          # builds build/main.pdf
latexmk -C            # clean all generated files
```

Requires a full TeX Live (2025 tested) with `xcharter`, `newtx`, `montserrat`,
`inconsolata`, `titlesec`, `natbib`, `cleveref`, `microtype`. Compiles with
**pdfLaTeX**.

## Files

| File | Purpose |
|------|---------|
| `davian.cls`     | The document class (fonts, colors, headings, title block). |
| `main.tex`       | Worked example / feature showcase. Start here. |
| `references.bib` | Bibliography (BibTeX, used with `plainnat`). |
| `latexmkrc`      | Build config — output goes to `build/`. |

## Writing your paper

Edit the title-block metadata at the top of `main.tex`:

```latex
\runningtitle{Short title for the page header}
\title{Your Paper Title}

\authors{%
  First Author\affmark{1,*}\quad
  Second Author\affmark{1,\dag}%
}
\affiliations{%
  \affmark{1}DAVIAN Lab, KAIST AI \qquad
  \affmark{2}Other Institution%
}
\contributions{%
  \affmark{*}Equal contribution.\quad
  \affmark{\dag}Corresponding author.%
}
\correspondence{\texttt{you@kaist.ac.kr}}   % optional
```

- `\affmark{...}` renders a superscript marker — use it both on author names
  and in the affiliation list to link them.
- `\contributions` and `\correspondence` are optional; omit them if unused.
- Defaults point to DAVIAN Lab, KAIST AI, so the template is usable as-is.

Then write normally: `\section`, `\subsection`, `\paragraph`, `figure`,
`table` (with `booktabs`), `equation`, and `\cite{...}`. Cross-reference with
`cleveref`'s `\Cref{...}`.

## Header logo

The first page shows a logo in the header (with a rule beneath it, matching the
footer rule). To use the official KAIST AI logo, drop an image file at:

```
figures/kaist-ai-logo.pdf      # preferred (vector)
figures/kaist-ai-logo.png      # fallback
```

It is picked up automatically. With no file present, a typeset "KAIST AI"
wordmark is shown as a placeholder. To use a different logo or position, override
in your preamble:

```latex
\renewcommand{\headerlogo}{\includegraphics[height=0.4in]{figures/mylogo.pdf}}
```

## Customization

All styling lives in `davian.cls`:

- **Accent color** — edit the `kaistblue` / `kaistbluedark` definitions.
- **Abstract box shade** — edit the `abstractbg` color.
- **Heading font** — swap the `montserrat` package line for `FiraSans`.
- **Margins / header height** — adjust the `geometry` options.
- **Header/footer rules** — edit the `davianmain` / `davianfirst` page styles.

## License

`davian.cls` is derived from [`kourgeorge/arxiv-style`](https://github.com/kourgeorge/arxiv-style)
and is free to use and modify within the lab.
