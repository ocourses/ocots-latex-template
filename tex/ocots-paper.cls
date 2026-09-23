\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ocots-paper}[2026/09/23 v1.0 ocots -- classe article de recherche]

\def\ocots@carrier{paper}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsart}}
\ExecuteOptions{a4paper,11pt}
\ProcessOptions\relax

\LoadClass{amsart}

\endinput
