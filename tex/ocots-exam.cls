\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ocots-exam}[2026/09/03 v1.0 ocots -- classe examen]
%
%   \documentclass[11pt]{ocots-exam}
%   \usepackage[lang=fr, solutions=none, institution={insa,n7}]{ocots}

\def\ocots@carrier{exam}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ExecuteOptions{a4paper,11pt}
\ProcessOptions\relax

\LoadClass{article}

\endinput
