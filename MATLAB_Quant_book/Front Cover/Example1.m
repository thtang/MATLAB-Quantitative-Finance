%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Copyright (c) 2009, Rodolphe Sitter  %
%  Copyright (c) 2009, Yi Cao           %
%  All rights reserved.                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   EXAMPLE 1
%   Downloaded from http://www.cboe.com/delayedquote/QuoteTableDownload.aspx
%   SPX -> download 
%   a table of N points (Maturity,Strike,CallPrice), this is N times 3
%   numbers. 
%   The risk-free rate is 0.66% per annum
%   and S0=770.05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
close all

SPX=xlsread('SPX.xls');
S0=770.05;
r=0.66/100;

Maturity=SPX(3:end,2);          % maturity
Strike=SPX(3:end,3);            % moneyness
CallPrice=SPX(3:end,4);         % option prices

tic
surface=VolSurface(S0, r, Maturity, Strike, CallPrice);
toc
