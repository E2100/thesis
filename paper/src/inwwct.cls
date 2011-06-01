% Identification part
\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{inwwct}[2011/04/15 v2.0 INWWCT workshop document class]
% based on the v2.0 NAIS document class and using the IEEEtran class 

% Conference information
\def\inwwct@info{India-Norway Workshop on Web Concepts and Technologies, Trondheim, Norway, October 3rd, 2011}

% Package and classloading part:
\LoadClass[a4paper,10pt,conference]{IEEEtran}

% Main code part:
\newcommand{\AuthorName}[1]{\IEEEauthorblockN{#1}}
\newcommand{\AuthorAffiliation}[1]{\IEEEauthorblockA{#1}}
\newcommand{\Abstract}[1]{\IEEEcompsoctitleabstractindextext{#1}}

\renewcommand{\rmdefault}{ppl}

% enable Times/Palatino main text font
\normalfont\selectfont

\def\@maketitle{\newpage
  \leftmark{\small\inwwct@info}
  \begin{center}%
    \vskip 2.0em{\LARGE\@IEEEcompsoconly{\sffamily}
      \@title\par}\vskip 1.0em\par%
      {{{\@IEEEspecialpapernotice\mbox{}\vskip\@IEEEauthorblockconfadjspace%
          \mbox{}\hfill\begin{@IEEEauthorhalign}\@author\end{@IEEEauthorhalign}\hfill\mbox{}\par}\relax
            \vskip 1.5em\relax
            \vrule depth 0pt height 0.5pt width 0.915\textwidth\par
            \vskip 1em\relax
            \@IEEEcompsoctitleabstractindextextbox{\@IEEEcompsoctitleabstractindextext}
            \vskip 1em\relax
          \vrule depth 0pt height 0.5pt width 0.915\textwidth\par\hfill
       }}\relax
      \end{center}}

\bibliographystyle{abbrv}

% subsubsection is the lowest number of sectioning
\setcounter{secnumdepth}{3}

% section counters
\def\thesection{\arabic{section}}                
\def\thesubsection{\thesection.\arabic{subsection}}
\def\thesubsubsection{\thesubsection.\arabic{subsubsection}}

\def\thesectiondis{\thesection.}
\def\thesubsectiondis{\thesection.\arabic{subsection}.}
\def\thesubsubsectiondis{\thesubsection.\arabic{subsubsection}.}

% section headings
\def\section{\@startsection{section}{1}{\z@}{1\baselineskip plus 0.25\baselineskip minus 0.25\baselineskip}%
{1\baselineskip plus 0.25\baselineskip minus 0.25\baselineskip}{\normalfont\large\bfseries}}%
\def\subsection{\@startsection{subsection}{2}{\z@}{1\baselineskip plus 0.25\baselineskip minus 0.25\baselineskip}%
{1\baselineskip plus 0.25\baselineskip minus 0.25\baselineskip}{\normalfont\sublargesize\itshape}}%
\def\subsubsection{\@startsection{subsubsection}{3}{\z@}{-2.5ex plus -1ex minus -1ex}%
{0.5ex plus 0.5ex minus 0ex}{\normalfont\normalsize\itshape}}%



