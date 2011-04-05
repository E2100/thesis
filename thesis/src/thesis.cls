% -----------------
% NTNU Thesis Class
% -----------------

% Provide
\ProvidesClass{thesis}
\NeedsTeXFormat{LaTeX2e}

% Base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions
\LoadClass{memoir}

% Fixes
\RequirePackage{memhfixc}
\RequirePackage{etex}


% -----------------
% Colors
% -----------------

\RequirePackage{xcolor}

% Color
\definecolor{red}{HTML}{990000}
\definecolor{green}{HTML}{990000}

% Black and white
\definecolor{black}{HTML}{000000}
\definecolor{lightgray}{HTML}{CCCCCC}
\definecolor{gray}{HTML}{999999}
\definecolor{darkgray}{HTML}{666666}


% -----------------
% Text
% -----------------

% Encoding
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8x]{inputenc}

% Standard fonts
\renewcommand{\rmdefault}{ppl} % font: palatino

% Commands
\newcommand{\lowercaps}[1]{\textsc{\MakeLowercase{#1}}}
\newcommand{\uppercaps}[1]{\textsc{\MakeUppercase{#1}}}

% Hyphenation, kerning
\RequirePackage{microtype}

% Leading (for b5/10pt)
\setSpacing{1.2}

% Paragraphs
\clubpenalty = 500
\widowpenalty = 1000
\setlength{\parindent}{0em}
\setlength{\parskip}{1em}

% Compact lists
\RequirePackage{mdwlist}


% -----------------
% Math
% -----------------

\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}


% -----------------
% Graphics
% -----------------

\RequirePackage{graphicx}
\RequirePackage{pdfpages}


% -----------------
% References
% -----------------

\RequirePackage{natbib}


% -----------------
% Links
% -----------------

\RequirePackage{caption}
\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true, 
  urlcolor=red, 
  linkcolor=black,
  citecolor=red
}
\urlstyle{same}


% -----------------
% Page layout
% -----------------

% Page margins
\settypeblocksize{46pc}{32pc}{*} % (height,width,ratio)
\setlrmargins{*}{*}{1}
\setulmargins{6pc}{*}{*}
\checkandfixthelayout

% Standard text pages
\makepagestyle{thesis} 
  %\nouppercaseheads
  \createmark{chapter}{right}{nonumber}{}{}
  \makeevenhead{thesis}{\centering\color{gray}\rightmark}{}{}
  \makeoddhead{thesis}{\centering\color{gray}\rightmark}{}{}
  \makeevenfoot{thesis}{}{\color{gray}\thepage}{}
  \makeoddfoot{thesis}{}{\color{gray}\thepage}{}
\pagestyle{thesis}

% Pages with chapter headings
\makepagestyle{plain}
  \makeevenhead{plain}{}{}{}
  \makeoddhead{plain}{}{}{}
  \makeevenfoot{plain}{}{\color{gray}\thepage}{}
  \makeoddfoot{plain}{}{\color{gray}\thepage}{}


% -----------------
% Divisors
% -----------------

% Chapters (based on memoir/dash)
\makechapterstyle{thesis}{%
  \chapterstyle{default}
  \setlength{\beforechapskip}{-4em}
  \renewcommand*{\printchaptername}{}
  \renewcommand*{\chapternamenum}{}
  \renewcommand*{\chapnumfont}{\normalfont\Large}
  \settoheight{\midchapskip}{\chapnumfont 1}
  \renewcommand*{\printchapternum}{
    \centering \chapnumfont
    \rule[0.5\midchapskip]{1em}{0.4pt} \thechapter\
    \rule[0.5\midchapskip]{1em}{0.4pt}
    %\includegraphics[width=2em]{{\thechapter}}
  }
  \renewcommand*{\afterchapternum}{\par\nobreak
    \vskip -1 % change on indent
    \onelineskip
  }
  \renewcommand*{\printchapternonum}{\centering
                 \vphantom{\chapnumfont 1}\afterchapternum}
  \renewcommand*{\chaptitlefont}{\normalfont\LARGE}
  \renewcommand*{\printchaptertitle}[1]{\centering \chaptitlefont ##1}
  \setlength{\afterchapskip}{2.5\onelineskip}
}
\chapterstyle{thesis}

% Sections
\setsecheadstyle{\vspace{1em}\large\itshape}

% Subsections
\setsubsecheadstyle{\large\itshape}

% Subsubsections
\setsubsubsecheadstyle{\itshape}


% -----------------
% References
% -----------------

\RequirePackage{multicol}
\renewcommand*{\bibname}{References}
\renewenvironment{thebibliography}[1]{%
  \setlength{\bibitemsep}{-\parsep + 0.5em}
  \setSpacing{1}
  \setlength{\parindent}{1em}
  \bibsection
  \begin{bibitemlist}{#1}}{\end{bibitemlist}\postbibhook}

% -----------------
% Sourcecode
% -----------------

% Settings
\RequirePackage{listings}
\RequirePackage{courier}
\lstset{
  basicstyle=\footnotesize\ttfamily,
  numbers=right,
  numberstyle=\tiny\color{gray},
  %stepnumber=2,
  numbersep=-5pt,
  tabsize=2,
  extendedchars=true,
  breaklines=true,
  keywordstyle=\color{black},
  frame=lines,         
  stringstyle=\color{red}\ttfamily,
  showspaces=false,
  showtabs=false,
  xleftmargin=0pt,
  framexleftmargin=0pt,
  framexrightmargin=0pt,
  framextopmargin=3pt,
  framexbottommargin=3pt,
  rulecolor=\color{gray},
  backgroundcolor=\color{white},
  showstringspaces=false,
  abovecaptionskip=5pt,
  belowcaptionskip=0pt,
  captionpos=b,
  aboveskip=20pt,
  belowskip=5pt
}
\lstloadlanguages{XML}

% Captions
\RequirePackage{caption}
\DeclareCaptionFormat{listing}{\colorbox[cmyk]{0,0,0,0}{\parbox{0.8\textwidth}{\hspace{0pt}#1#2#3}}}
\captionsetup[lstlisting]{
  format=listing, font={it}, labelfont={it}, textfont={it}, 
  singlelinecheck=false, margin=0pt, font={footnotesize}}

% Sourcecode environment
\lstnewenvironment{sourcecode}[3][]{
  \setSpacing{1}
  \lstset{language={#1},label={#2},caption={#3}}
}{}


% -----------------
% Environments
% -----------------

% Footnotes
\footmarkstyle{({#1}) \ } 
\setlength{\footmarkwidth}{1.5em} 
\setlength{\footmarksep}{0em} 
\setlength{\footparindent}{0em} 
\renewcommand*{\foottextfont}{\footnotesize}
\renewcommand*{\footnoterule}{%
  \color{lightgray}
  \hrule width \columnwidth 
  \kern 5pt
  \color{darkgray}
}

% Quotes with citations
% \begin{citequote}[page]{ref}{text}..
\newenvironment{citequote}[3][]{%
  \citet[#1]{#2} #3:
  \begin{quote}
  \itshape
}{%
  \end{quote}
}











