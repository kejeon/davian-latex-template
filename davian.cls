%% davian.cls — DAVIAN Lab (KAIST AI) single-column preprint / tech-report class
%% Inspired-by restyle of kourgeorge/arxiv-style: XCharter body, Montserrat
%% headings, Charter-keyed math, KAIST-blue accent.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{davian}[2026/05/21 v1.0 DAVIAN Lab preprint class]

%% ---- options pass through to article ----
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[10pt]{article}

%% ---- page geometry ----
\RequirePackage[letterpaper,margin=1.05in,headheight=40pt,headsep=12pt,
                footskip=26pt]{geometry}
\widowpenalty=10000
\clubpenalty=10000

%% ---- accent color (KAIST deep blue) + abstract grey ----
\RequirePackage{xcolor}
\definecolor{kaistblue}{HTML}{004191}
\definecolor{kaistbluedark}{HTML}{002B5F}
\definecolor{abstractbg}{HTML}{EFF1F4}

%% ---- math packages (must precede newtxmath; amssymb before newtxmath
%%      avoids the \Bbbk "already defined" clash) ----
\RequirePackage{amsmath}
\RequirePackage{amssymb}

%% ---- fonts: XCharter body + Charter math + Montserrat sans + Inconsolata mono ----
\RequirePackage[T1]{fontenc}
\RequirePackage{XCharter}
\RequirePackage[charter,scaled=1.04,vvarbb]{newtxmath}
\RequirePackage[scaled=0.92]{montserrat}   % sets \sfdefault to Montserrat
\RequirePackage[scaled=0.90,varqu]{zi4}     % Inconsolata for \ttfamily
\RequirePackage{microtype}

%% ---- other math / graphics utilities ----
\RequirePackage{mathtools}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{array}
\RequirePackage[most]{tcolorbox}

%% ---- lists & captions ----
\RequirePackage[shortlabels]{enumitem}
\setlist{itemsep=2pt,topsep=4pt,parsep=0pt}
\RequirePackage[font=small,labelfont={bf,color=kaistbluedark},labelsep=period]{caption}

%% ---- paragraph style: no indent, modest skip ----
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.6em}

%% ---- section headings: Montserrat, accent color, numbered ----
\RequirePackage{titlesec}
\titleformat{\section}
  {\sffamily\large\bfseries\color{kaistbluedark}}{\thesection.}{0.6em}{}
\titleformat{\subsection}
  {\sffamily\normalsize\bfseries\color{kaistbluedark}}{\thesubsection.}{0.5em}{}
\titleformat{\subsubsection}
  {\sffamily\normalsize\bfseries}{\thesubsubsection.}{0.5em}{}
\titleformat{\paragraph}[runin]
  {\sffamily\bfseries}{}{0em}{}[.]
\titlespacing*{\section}{0pt}{2.4ex plus .6ex minus .2ex}{1.2ex plus .2ex}
\titlespacing*{\subsection}{0pt}{2.0ex plus .5ex minus .2ex}{0.8ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{1.6ex plus .4ex minus .2ex}{0.6ex plus .2ex}
\titlespacing*{\paragraph}{0pt}{1.2ex plus .3ex}{0.8em}

%% ---- header logos ----
%% Drop official assets at figures/kaist-ai-logo.{pdf,png} and
%% figures/davian-logo.{pdf,png} to use real images; otherwise a typeset
%% fallback is shown. Override with \renewcommand{\kaistailogo}{...} etc.
\newcommand{\kaistailogo}{%
  \IfFileExists{figures/kaist-ai-logo.pdf}
    {\includegraphics[height=0.36in]{figures/kaist-ai-logo.pdf}}%
    {\IfFileExists{figures/kaist-ai-logo.png}
      {\includegraphics[height=0.36in]{figures/kaist-ai-logo.png}}%
      {\sffamily\bfseries\large\color{kaistblue}KAIST\,\color{kaistbluedark}AI}}%
}
\newcommand{\davianlogo}{%
  \IfFileExists{figures/davian-logo.pdf}
    {\includegraphics[height=0.35in]{figures/davian-logo.pdf}}%
    {\IfFileExists{figures/davian-logo.png}
      {\includegraphics[height=0.35in]{figures/davian-logo.png}}%
      {\sffamily\bfseries\large\color{kaistbluedark}DAVIAN}}%
}
%% kept for backward compat
\newcommand{\headerlogo}{\kaistailogo}

%% ---- running header / footer (thin KAIST-blue rules) ----
\RequirePackage{fancyhdr}
\newcommand{\@runningtitle}{}
\newcommand{\runningtitle}[1]{\renewcommand{\@runningtitle}{#1}}
\newcommand{\@shortauthor}{}
\newcommand{\shortauthor}[1]{\renewcommand{\@shortauthor}{#1}}

% running pages: "First Author et al. · Short Title" in header
\fancypagestyle{davianmain}{%
  \fancyhf{}%
  \fancyhead[L]{\sffamily\footnotesize\color{kaistbluedark}%
    \@shortauthor\ifx\@shortauthor\empty\else\enspace·\enspace\fi\@runningtitle}%
  \fancyfoot[C]{\sffamily\footnotesize\thepage}%
  \renewcommand{\headrule}{\color{black}\hrule height 0.6pt}%
  \renewcommand{\footrule}{\color{black}\hrule height 0.6pt}%
  \renewcommand{\headrulewidth}{0.6pt}%
  \renewcommand{\footrulewidth}{0.6pt}%
}
% first page: DAVIAN logo left, KAIST AI logo right
\fancypagestyle{davianfirst}{%
  \fancyhf{}%
  \fancyhead[L]{\kaistailogo}%
  \fancyhead[R]{\davianlogo}%
  \fancyfoot[C]{\sffamily\footnotesize\thepage}%
  \renewcommand{\headrule}{\color{black}\hrule height 0.6pt}%
  \renewcommand{\footrule}{\color{black}\hrule height 0.6pt}%
  \renewcommand{\headrulewidth}{0.6pt}%
  \renewcommand{\footrulewidth}{0.6pt}%
}
\pagestyle{davianmain}
\let\ps@plain\ps@davianmain

%% ---- title-block metadata macros (with DAVIAN / KAIST AI defaults) ----
\newcommand{\@authors}{Author Name\affmark{1}}
\newcommand{\authors}[1]{\renewcommand{\@authors}{#1}}
\newcommand{\@affiliations}{\affmark{1}DAVIAN Lab, KAIST AI}
\newcommand{\affiliations}[1]{\renewcommand{\@affiliations}{#1}}
\newcommand{\@contributions}{}
\newcommand{\contributions}[1]{\renewcommand{\@contributions}{#1}}
\newcommand{\@correspondence}{}
\newcommand{\correspondence}[1]{\renewcommand{\@correspondence}{#1}}

%% superscript affiliation marker
\newcommand{\affmark}[1]{\textsuperscript{#1}}

%% email helper: Inconsolata via \fontfamily (not \texttt) + mailto hyperlink.
%% zi4 is scaled=0.90, so fontsize{10} renders at 9pt visual = \small serif.
\AtBeginDocument{%
  \newcommand{\email}[1]{%
    E-mail: \href{mailto:#1}{{\fontfamily{zi4}\fontsize{10}{12}\selectfont #1}}%
  }%
}

%% ---- title rendering (left aligned) ----
\renewcommand{\maketitle}{%
  \thispagestyle{davianfirst}%
  \begin{flushleft}
    \setlength{\parskip}{0pt}% don't let the body parskip inflate the \vskip gaps below
    {\sffamily\bfseries\fontsize{19}{23}\selectfont\color{kaistbluedark}\@title\par}
    \vskip 1em
    {\normalsize\bfseries\raggedright\@authors\par}
    \vskip 0.25em
    {\small\raggedright\@affiliations\par}
    \ifx\@correspondence\empty\else
      \vskip 0.25em{\small\@correspondence\par}\fi
    \ifx\@contributions\empty\else
      \vskip 0.25em{\footnotesize\color{black!70}\@contributions\par}\fi
  \end{flushleft}
  \vskip 0.8em
}

%% ---- keywords (call inside abstract environment) ----
\newcommand{\keywords}[1]{%
  \par\vskip 5pt
  {\sffamily\bfseries\small\color{kaistbluedark}Keywords:\enspace}{\small #1}%
}

%% ---- abstract: light grey box with sans heading (matches reference) ----
\renewenvironment{abstract}{%
  \begin{tcolorbox}[
    breakable, enhanced, colback=abstractbg, colframe=abstractbg,
    boxrule=0pt, arc=2pt, left=14pt, right=14pt, top=11pt, bottom=11pt,
    width=\textwidth, before skip=4pt, after skip=16pt]%
  {\sffamily\bfseries\color{kaistbluedark}\abstractname}\par
  \vskip 4pt
  \small\noindent\ignorespaces
}{%
  \end{tcolorbox}%
}

%% ---- bibliography (natbib, numeric & compressed) ----
\RequirePackage[numbers,sort&compress]{natbib}

%% ---- hyperref + cleveref (load late) ----
\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=kaistbluedark,
  citecolor=kaistblue,
  urlcolor=kaistblue,
  breaklinks=true,
}
\RequirePackage[capitalise,noabbrev]{cleveref}

\endinput
