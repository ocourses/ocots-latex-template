\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ocots-book}[2026/09/03 v1.0 ocots -- classe polycopie]
%
% Classe des polycopies.
%
%   \documentclass[11pt,twoside]{ocots-book}
%   \usepackage[lang=fr, theme=ocots, math=analysis]{ocots}
%
% La v0 embarquait un book.cls recopie et patche : 788 lignes pour une
% cinquantaine de lignes utiles, en trois exemplaires (book.cls, polycopie.cls,
% polycopie_old.cls), impossibles a suivre (defaut D6). Ici on charge la classe
% standard et le support fait le reste.

% Le support est lu par ocots.sty, charge juste apres par le document.
\def\ocots@carrier{book}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ExecuteOptions{a4paper,11pt,twoside,onecolumn,final,openright}
\ProcessOptions\relax

\LoadClass{book}

\endinput
