close all; clear all; clc; addpath('..');
addpath('code\Classification\multisvm\');

%% Configurações gerais
param.ptrn = 0.74;
param.numRodadas = 50;
param.numFolds = 5;
param.qtdClasses = 7;


param.vIni = 5;
param.vInc = 1;
param.vFin = 35;
param.resolucoes = (param.vIni:param.vInc:param.vFin);

param.matrizErrosClasse(1,:) = [0 15 25 45 60 80 85];
param.matrizErrosClasse(2,:) = [0  0 15 25 45 60 80];
param.matrizErrosClasse(3,:) = [0  0  0 15 25 45 60];
param.matrizErrosClasse(4,:) = [0  0  0  0 15 25 45];
param.matrizErrosClasse(5,:) = [0  0  0  0  0 15 25];
param.matrizErrosClasse(6,:) = [0  0  0  0  0  0 15];
param.matrizErrosClasse(7,:) = [0  0  0  0  0  0  0];

param.frac = 10;

%vetor dos escores por acertos das classes
param.vetorEscoresClasses = [100 85 75 55 40 20 15];

%total máximo de escores de acertos do classificador
param.maxEscoresAcertos = (1-param.ptrn)*50*(sum(param.vetorEscoresClasses'));



%conhfigurações do SVM
% paraC = ceil(0.1 * ptrn * size(dados.y, 1))+80;
conf.paraC = 8;
conf.sigma = 2;
conf.fkernel = 'rbf';
conf.metodo = 'SMO';
conf.options.MaxIter = 150000;

%path do dados
aux = 4;

if (aux == 1)
    param.pathGLCM = '../DB_FEATURES/DB_GLCM_%d.txt';
end
if (aux == 2)
    param.pathGLCM = '../PASSO_DECIMACAO/GLCM_%d.txt';
end
if (aux == 3)
    param.pathGLCM = '../PASSO_ROI/GLCM_%d.txt';
end
if (aux == 4)
    param.pathGLCM = '../PASSO_ROI_PRETO/GLCM_%d.txt';
end

param.base = aux;

%% CHAMAR FUNÇÕES

%gerarDados5(param,conf);
%gerarDados70(param,conf);
%gerarDados(param,conf);
%gerarDados2(param,conf);

%% parametros para plotar os gráfico
paramG.resoIni = 1;
paramG.resoFim = 31;
paramG.numRodadas = param.numRodadas;
paramG.qtdClasses = param.qtdClasses;
paramG.frac = param.frac;
paramG.melhores = 5;


%gerarGraficos(param.base,paramG);
%gerarGraficos2(param.base,paramG);
%gerarGraficosComb(param.base,paramG);
%gerarBarTempo(param.base,paramG);
%gerarBarras(param.base,paramG);
gerarGraficos5(param.base,paramG);
%gerarGraficos70(param.base,paramG);
fprintf('Pronto ...\n');
