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
\RequirePackage[letterpaper,margin=1.05in,headheight=15pt]{geometry}
\widowpenalty=10000
\clubpenalty=10000

%% ---- accent color (KAIST deep blue) ----
\RequirePackage{xcolor}
\definecolor{kaistblue}{HTML}{004191}
\definecolor{kaistbluedark}{HTML}{002B5F}

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
  {\sffamily\large\bfseries\color{kaistblue}}{\thesection}{0.6em}{}
\titleformat{\subsection}
  {\sffamily\normalsize\bfseries\color{kaistbluedark}}{\thesubsection}{0.5em}{}
\titleformat{\subsubsection}
  {\sffamily\normalsize\bfseries}{\thesubsubsection}{0.5em}{}
\titleformat{\paragraph}[runin]
  {\sffamily\bfseries}{}{0em}{}[.]
\titlespacing*{\section}{0pt}{2.4ex plus .6ex minus .2ex}{1.2ex plus .2ex}
\titlespacing*{\subsection}{0pt}{2.0ex plus .5ex minus .2ex}{0.8ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{1.6ex plus .4ex minus .2ex}{0.6ex plus .2ex}
\titlespacing*{\paragraph}{0pt}{1.2ex plus .3ex}{0.8em}

%% ---- running header / footer ----
\RequirePackage{fancyhdr}
\newcommand{\@runningtitle}{}
\newcommand{\runningtitle}[1]{\renewcommand{\@runningtitle}{#1}}
\fancyhf{}
\fancyhead[R]{\sffamily\footnotesize\color{kaistbluedark}\@runningtitle}
\fancyfoot[C]{\sffamily\footnotesize\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\pagestyle{fancy}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[C]{\sffamily\footnotesize\thepage}%
  \renewcommand{\headrulewidth}{0pt}}

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

%% ---- title rendering ----
\renewcommand{\maketitle}{%
  \thispagestyle{plain}%
  \begin{center}
    {\sffamily\bfseries\fontsize{19}{23}\selectfont\color{kaistbluedark}\@title\par}
    \vskip 1.0em
    {\normalsize\@authors\par}
    \vskip 0.5em
    {\small\itshape\@affiliations\par}
    \ifx\@correspondence\empty\else
      \vskip 0.35em{\footnotesize\@correspondence\par}\fi
    \ifx\@contributions\empty\else
      \vskip 0.35em{\footnotesize\color{black!70}\@contributions\par}\fi
  \end{center}
  \vskip 0.4em
  {\color{kaistblue}\hrule height 0.8pt}%
  \vskip 1.2em
}

%% ---- abstract: centered sans heading + narrowed body ----
\renewenvironment{abstract}{%
  \begin{center}{\sffamily\bfseries\color{kaistblue}\abstractname}\end{center}
  \vskip -0.2em
  \par\begingroup\leftskip=0.28in\rightskip=0.28in\small\noindent\ignorespaces
}{%
  \par\endgroup
  \vskip 0.6em
  {\color{kaistblue!40!white}\hrule height 0.4pt}%
  \vskip 1.0em
}

%% ---- keywords (optional) ----
\providecommand{\keywords}[1]{%
  \vskip 0.3em\noindent
  {\sffamily\bfseries\footnotesize\color{kaistbluedark}Keywords\, }%
  \begingroup\def\and{\,\textperiodcentered\, }{\footnotesize #1}\par\endgroup}

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
