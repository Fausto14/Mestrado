function gerarGraficos(base,param)

numRodadas = param.numRodadas;
resoIni    = param.resoIni;
resoFim    = param.resoFim;
qtdClasses = param.qtdClasses;
melhores   = param.melhores;

fileAcc = sprintf('2acc_Base%d_Rods%d.mat',base,numRodadas);
fileAcertos = sprintf('2acertos_Base%d_Rods%d.mat',base,numRodadas);
fileErros = sprintf('2erros_Base%d_Rods%d.mat',base,numRodadas);

a = load(fileAcc);
b = load(fileAcertos);
c = load(fileErros);

matrixAccClasseRodReso      = a.matrixAccClasseRodReso2;
somaEscoresAcertosResoGeral = b.somaEscoresAcertosResoGeral2*10;
somaEscoresErrosResoGeral   = c.somaEscoresErrosResoGeral2*10;

%% exibir/salvar boxplot
fprintf('\nGerando os gr�ficos\n');

%boxplot das classes por resolu��o
for k = 1 : qtdClasses
    
    gcf = figure('visible','off');
    
    boxplot(squeeze(matrixAccClasseRodReso(k,:,resoIni:resoFim)));
    % Overlay the mean as green circle
    hold on
    plot(mean(squeeze(matrixAccClasseRodReso(k,:,resoIni:resoFim))), 'og');
    hold off
    strTitle = sprintf('Acur�cia da Classe %d por Resolu��o - %d rodadas | Base %d',k,numRodadas, base);
    title(strTitle);
    xlabel('Redimensionamento %');
    ylabel('Acur�cia');
    
    nameFileGraph = sprintf('graphics/classes_x_resolucao/2Base%d_C%d_Rods%d.png',base,k,numRodadas);
    saveas(gcf,nameFileGraph);
    
end

%boxplot das resolu��o por classes
for k = (resoIni:1:resoFim)
    
    gcf = figure('visible','off');
    
    boxplot(matrixAccClasseRodReso(:,:,k)');
    % Overlay the mean as green circle
    hold on
    plot(mean(matrixAccClasseRodReso(:,:,k)'), 'og');
    hold off
    strTitle = sprintf('Acur�cia por Classe na resolu��o de %d%% - %d rodadas | Base %d',k,numRodadas,base);
    title(strTitle);
    xlabel('Classes');
    ylabel('Acur�cia');
    
    nameFileGraph = sprintf('graphics/resolucao_x_classes/2Base%d_Reso%d_Rods%d.png',base,k,numRodadas);
    saveas(gcf,nameFileGraph);
    
end

%BOX PLOT DO CLASSIFICADOR
%boxplot dos somat�rios dos escores de acertos
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realiza��o
%ou rodada
b = sum(somaEscoresAcertosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c = squeeze(b);

boxplot(c);
% Overlay the mean as green circle
hold on
plot(mean(c), 'og');
%line(resoIni:resoFim,mean(c));
hold off
strTitle = sprintf('Escores de Acertos do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Redimensionamento %');
ylabel('Valor Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/2Base%d_BoxPlot_Acertos_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%boxplot dos somat�rios dos escores de erros
gcf = figure('visible','off');

%armazena o valor total de erros do classificador em cada realiza��o
%ou rodada
b2 = sum(somaEscoresErrosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c2 = squeeze(b2);

boxplot(c2);
% Overlay the mean as green circle
hold on
plot(mean(c2), 'og');
hold off
strTitle = sprintf('Escores de Erros do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Redimensionamento %');
ylabel('Valor Total de Erros do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/2Base%d_BoxPlot_Erros_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%boxplot dos somat�rios dos valores do classificador
gcf = figure('visible','off');

d = c-c2;

boxplot(d);
% Overlay the mean as green circle
hold on
plot(mean(d), 'og');
hold off
strTitle = sprintf('Valor do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Redimensionamento %');
ylabel('Valor Total do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/2Base%d_BoxPlot_Valor_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%LINE PLOT DO CLASSIFICADOR
%lineplot dos somat�rios dos escores de acertos
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realiza��o
%ou rodada
b = sum(somaEscoresAcertosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c = squeeze(b);

%armazena o valor total de erros do classificador em cada realiza��o
%ou rodada
b2 = sum(somaEscoresErrosResoGeral(:,:,resoIni:resoFim));
%reduz a dimens�o da matrix de 3D para 2D para ser plotada no box plot
c2 = squeeze(b2);

x = resoIni:resoFim;
y1 = 100*mean(squeeze(mean(matrixAccClasseRodReso(:,:,resoIni:resoFim)))); %acur�cia do classificador
y2 = mean(c); %m�dia do escores de acertos em todas as rodadas do classificador
y3 = mean(c2); %m�dia do escores de acertos em todas as rodadas do classificador

%pegando as 5 melhores acur�cia
mediaAccClasses = squeeze(mean(matrixAccClasseRodReso(:,:,resoIni:resoFim)));%pega a m�dia das acuracias das clases
mediaAccClassesOrder =  sort(mediaAccClasses,'descend');%ordena as colunas na forma decrescente
y4 = 100*mean(mediaAccClassesOrder(1:melhores,:));% pegar as n melhores melhores acur�cias do classificador

%pegando os 5 melhores acertos
mediaAcertosOrder = sort(c,'descend');%ordena as colunas na forma decrescente
y5 = mean(mediaAcertosOrder(1:melhores,:));% pegar os n melhores acertos do classificador

%pegando os 5 menores erros
mediaErrosOrder = sort(c2);%ordena as colunas na forma crescente
y6 = mean(mediaErrosOrder(1:melhores,:));% pegar os n menores erros do classificador

%pegando os valor do classificador
valor_class = c-c2;
y7 = mean(valor_class);

plot(x,y1,'b','LineWidth',2,'DisplayName','Acur�cia');
hold on
plot(x,y2,'g','LineWidth',2,'DisplayName','Acertos');
hold on
plot(x,y3,'r','LineWidth',2,'DisplayName','Erros');
hold on
% plot(x,y4,'k','LineWidth',2,'DisplayName','Acur�cia+');
% hold on
% plot(x,y5,'c','LineWidth',2,'DisplayName','Acertos+');
% hold on
% plot(x,y6,'m','LineWidth',2,'DisplayName','Erros+');
plot(x,y7,'k','LineWidth',2,'DisplayName','Valor Classificador');
hold on

legend('show','Location','northeastoutside','Orientation','vertical');
hold off
strTitle = sprintf('Acur�cia, Escores de Acertos e Erros do Classificador - %d rodadas | Base %d - Otimizado',numRodadas,base);
title(strTitle);
xlabel('Redimensionamento %');
ylabel('M�dia do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/2Base%d_Line_Acur�cia_Acertos_Erros_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

fprintf('\nFIM.\n');

end