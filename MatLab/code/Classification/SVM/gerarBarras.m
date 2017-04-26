function gerarGraficos(base,param)

numRodadas = param.numRodadas;
resoIni    = param.resoIni;
resoFim    = param.resoFim;
qtdClasses = param.qtdClasses;
melhores   = param.melhores;

fileAcc5 = sprintf('5_acc_Base%d_Rods%d.mat',base,numRodadas);
fileAcertos5 = sprintf('5_acertos_Base%d_Rods%d.mat',base,numRodadas);
fileErros5 = sprintf('5_erros_Base%d_Rods%d.mat',base,numRodadas);

a5 = load(fileAcc5);
b5 = load(fileAcertos5);
c5 = load(fileErros5);

matrixAccClasseRodReso5      = a5.matrixAccClasseRodReso;
somaEscoresAcertosResoGeral5 = b5.somaEscoresAcertosResoGeral;
somaEscoresErrosResoGeral5   = c5.somaEscoresErrosResoGeral;

fileAcc70 = sprintf('70_acc_Base%d_Rods%d.mat',base,numRodadas);
fileAcertos70 = sprintf('70_acertos_Base%d_Rods%d.mat',base,numRodadas);
fileErros70 = sprintf('70_erros_Base%d_Rods%d.mat',base,numRodadas);

a70 = load(fileAcc70);
b70 = load(fileAcertos70);
c70 = load(fileErros70);

matrixAccClasseRodReso70      = a70.matrixAccClasseRodReso;
somaEscoresAcertosResoGeral70 = b70.somaEscoresAcertosResoGeral;
somaEscoresErrosResoGeral70   = c70.somaEscoresErrosResoGeral;


%% exibir/salvar boxplot
fprintf('\nGerando gráfico\n');

% %BARRA TEMPO DE COMPUTAÇÃO
% %bar dos somatórios dos escores de acertos
% gcf = figure('visible','off');
% 
% 
% %x = 5*(resoIni:resoFim);
% x = [5 10 15 20 25 30 35 70 75 80 85 90 95 100];
% 
% %tempos
% %y1 = [22.3 8.85 6.64 5.52 5.11 5.05 4.81 4.51 4.64 4.49 4.65 4.48 4.47 4.56];%5-35 passos
% y1 = [18.82 7.72 5.934 4.96 4.616 4.594 4.377 4.123 4.256 4.106 4.267 4.098 4.092 4.182];
% % y8 = [4.51 4.64 4.49 4.65 4.48 4.47 4.56];%70-100 passos
% 
% bar(x,y1,'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0],'LineWidth',1);
% 
% hold on
% 
% legend({'Tempo (s)'},'FontSize',12);
% 
% 
% hold off
% strTitle = sprintf('Tempo de Computação - %d rodadas | Base %d',numRodadas,base);
% title(strTitle);
% xlabel('Passos');
% %ylabel('Média do Total de Acertos do Classificador');
% 
% nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Bar_Tempo_Rods%d.png',base,numRodadas);
% saveas(gcf,nameFileGraph);

%%
%BARRA VALOR E ACURÁCIA
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realização
%ou rodada
a5 = sum(somaEscoresAcertosResoGeral5(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
a5 = squeeze(a5);

a70 = sum(somaEscoresAcertosResoGeral70(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
a70 = squeeze(a70);

%armazena o valor total de erros do classificador em cada realização
%ou rodada
e5 = sum(somaEscoresErrosResoGeral5(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
e5 = squeeze(e5);

e70 = sum(somaEscoresErrosResoGeral70(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
e70 = squeeze(e70);

acertos = [a5,a70];
erros   = [e5,e70];

%pegando os valor do classificador
valor = acertos-erros;
y1 = mean(valor);

ac5  = 100*mean(squeeze(mean(matrixAccClasseRodReso5(:,:,resoIni:resoFim)))); %acurácia do classificador
ac70 = 100*mean(squeeze(mean(matrixAccClasseRodReso70(:,:,resoIni:resoFim)))); %acurácia do classificador

y2   = [ac5,ac70];

y = [y2;(y1-y2)];

%x = 5*(resoIni:resoFim);
x = [5 10 15 20 25 30 35 70 75 80 85 90 95 100];

bar(x,y','stacked');

hold on

legend({'Acurácia','Valor do Classificador'},'FontSize',12);


hold off
strTitle = sprintf('Valor do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Passos');
%ylabel('Média do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Bar_Valor_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%%
%BARRA VALOR E ACURÁCIA barras separadas
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realização
%ou rodada
a5 = sum(somaEscoresAcertosResoGeral5(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
a5 = squeeze(a5);

a70 = sum(somaEscoresAcertosResoGeral70(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
a70 = squeeze(a70);

%armazena o valor total de erros do classificador em cada realização
%ou rodada
e5 = sum(somaEscoresErrosResoGeral5(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
e5 = squeeze(e5);

e70 = sum(somaEscoresErrosResoGeral70(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
e70 = squeeze(e70);

acertos = [a5,a70];
erros   = [e5,e70];

%pegando os valor do classificador
valor = acertos-erros;
y1 = mean(valor);

ac5  = 100*mean(squeeze(mean(matrixAccClasseRodReso5(:,:,resoIni:resoFim)))); %acurácia do classificador
ac70 = 100*mean(squeeze(mean(matrixAccClasseRodReso70(:,:,resoIni:resoFim)))); %acurácia do classificador

y2   = [ac5,ac70];

y = [y2;y1];

%x = 5*(resoIni:resoFim);
x = [5 10 15 20 25 30 35 70 75 80 85 90 95 100];

bar(x,y');

hold on

legend({'Acurácia','Valor'},'FontSize',12);


hold off
strTitle = sprintf('Valor do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Passos');
%ylabel('Média do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Bar2_Valor_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

fprintf('\nFIM.\n');

end