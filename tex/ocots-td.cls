\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ocots-td}[2026/09/03 v1.0 ocots -- classe TD]
%
%   \documentclass[11pt]{ocots-td}
%   \usepackage[lang=fr, solutions=none]{ocots}

\def\ocots@carrier{td}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ExecuteOptions{a4paper,11pt}
\ProcessOptions\relax

\LoadClass{article}

\endinput
