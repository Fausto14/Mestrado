function gerarGraficos(base,param)

numRodadas = param.numRodadas;
resoIni    = param.resoIni;
resoFim    = param.resoFim;
qtdClasses = param.qtdClasses;
melhores   = param.melhores;

fileAcc = sprintf('acc_Base%d_Rods%d.mat',base,numRodadas);
fileAcertos = sprintf('acertos_Base%d_Rods%d.mat',base,numRodadas);
fileErros = sprintf('erros_Base%d_Rods%d.mat',base,numRodadas);

a = load(fileAcc);
b = load(fileAcertos);
c = load(fileErros);

matrixAccClasseRodReso      = a.matrixAccClasseRodReso;
somaEscoresAcertosResoGeral = b.somaEscoresAcertosResoGeral;
somaEscoresErrosResoGeral   = c.somaEscoresErrosResoGeral;

%% exibir/salvar boxplot
fprintf('\nGerando os gráficos\n');

%boxplot das classes por resolução
for k = 1 : qtdClasses
    
    gcf = figure('visible','off');
    
    boxplot(squeeze(matrixAccClasseRodReso(k,:,resoIni:resoFim)));
    % Overlay the mean as green circle
    hold on
    plot(mean(squeeze(matrixAccClasseRodReso(k,:,resoIni:resoFim))), 'og');
    hold off
    strTitle = sprintf('Acurácia da Classe %d por Resolução - %d rodadas | Base %d',k,numRodadas, base);
    title(strTitle);
    xlabel('Redimensionamento %');
    ylabel('Acurácia');
    
    nameFileGraph = sprintf('graphics/classes_x_resolucao/Base%d_C%d_Rods%d.png',base,k,numRodadas);
    saveas(gcf,nameFileGraph);
    
end

%boxplot das resolução por classes
for k = (resoIni:1:resoFim)
    
    gcf = figure('visible','off');
    
    boxplot(matrixAccClasseRodReso(:,:,k)');
    % Overlay the mean as green circle
    hold on
    plot(mean(matrixAccClasseRodReso(:,:,k)'), 'og');
    hold off
    strTitle = sprintf('Acurácia por Classe na resolução de %d%% - %d rodadas | Base %d',k,numRodadas,base);
    title(strTitle);
    xlabel('Classes');
    ylabel('Acurácia');
    
    nameFileGraph = sprintf('graphics/resolucao_x_classes/Base%d_Reso%d_Rods%d.png',base,k,numRodadas);
    saveas(gcf,nameFileGraph);
    
end

%BOX PLOT DO CLASSIFICADOR
%boxplot dos somatórios dos escores de acertos
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realização
%ou rodada
b = sum(somaEscoresAcertosResoGeral(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
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

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_BoxPlot_Acertos_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%boxplot dos somatórios dos escores de erros
gcf = figure('visible','off');

%armazena o valor total de erros do classificador em cada realização
%ou rodada
b2 = sum(somaEscoresErrosResoGeral(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
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

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_BoxPlot_Erros_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%boxplot dos somatórios dos valores do classificador
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

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_BoxPlot_Valor_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%%
%LINE TODOS
%lineplot dos somatórios dos escores de acertos
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realização
%ou rodada
b = sum(somaEscoresAcertosResoGeral(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
c = squeeze(b);

%armazena o valor total de erros do classificador em cada realização
%ou rodada
b2 = sum(somaEscoresErrosResoGeral(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
c2 = squeeze(b2);

%x = 5*(resoIni:resoFim);
x = [70 75 80 85 90 95 100];
y1 = 100*mean(squeeze(mean(matrixAccClasseRodReso(:,:,resoIni:resoFim)))); %acurácia do classificador
y2 = mean(c); %média do escores de acertos em todas as rodadas do classificador
y3 = mean(c2); %média do escores de acertos em todas as rodadas do classificador

%pegando as 5 melhores acurácia
mediaAccClasses = squeeze(mean(matrixAccClasseRodReso(:,:,resoIni:resoFim)));%pega a média das acuracias das clases
mediaAccClassesOrder =  sort(mediaAccClasses,'descend');%ordena as colunas na forma decrescente
y4 = 100*mean(mediaAccClassesOrder(1:melhores,:));% pegar as n melhores melhores acurácias do classificador

%pegando os 5 melhores acertos
mediaAcertosOrder = sort(c,'descend');%ordena as colunas na forma decrescente
y5 = mean(mediaAcertosOrder(1:melhores,:));% pegar os n melhores acertos do classificador

%pegando os 5 menores erros
mediaErrosOrder = sort(c2);%ordena as colunas na forma crescente
y6 = mean(mediaErrosOrder(1:melhores,:));% pegar os n menores erros do classificador

%pegando os valor do classificador
valor_class = c-c2;
y7 = mean(valor_class);

%tempos
%y8 = [22.3 8.85 6.64 5.52 5.11 5.05 4.81];%5-35 passos
%y8 = [4.51 4.64 4.49 4.65 4.48 4.47 4.56];%70-100 passos

plot(x,y1,'-b','LineWidth',2,'DisplayName','Acurácia');
hold on
plot(x,y2,'--g>','LineWidth',2,'DisplayName','Acertos');
hold on
plot(x,y3,'--r<','LineWidth',2,'DisplayName','Erros');
hold on
% plot(x,y4,'k','LineWidth',2,'DisplayName','Acurácia+');
% hold on
% plot(x,y5,'c','LineWidth',2,'DisplayName','Acertos+');
% hold on
% plot(x,y6,'m','LineWidth',2,'DisplayName','Erros+');
plot(x,y7,':ko','LineWidth',2,'DisplayName','Valor Classificador');
hold on
% plot(x,y8,':mx','LineWidth',2,'DisplayName','Tempo (s)');
% hold on

legend('show','Location','northeastoutside','Orientation','vertical');
hold off
strTitle = sprintf('Acurácia, Escores de Acertos e Erros do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Passos');
%ylabel('Média do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Line_Acurácia_Acertos_Erros_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%%
%LINE VALOR CLASSIFICADOR
gcf = figure('visible','off');

%armazena o valor total de acertos do classificador em cada realização
%ou rodada
b = sum(somaEscoresAcertosResoGeral(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
c = squeeze(b);

%armazena o valor total de erros do classificador em cada realização
%ou rodada
b2 = sum(somaEscoresErrosResoGeral(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
c2 = squeeze(b2);

%x = 5*(resoIni:resoFim);
x = [70 75 80 85 90 95 100];


%pegando os valor do classificador
valor_class = c-c2;
y7 = mean(valor_class);

plot(x,y7,':ko','LineWidth',2,'DisplayName','Valor Classificador');
hold on

legend('show','Location','northeast','Orientation','horizontal');
hold off
strTitle = sprintf('Valor do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Passos');

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Line_Valor_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

%%
%LINE ACURÁCIA
gcf = figure('visible','off');

%x = 5*(resoIni:resoFim);
x = [70 75 80 85 90 95 100];
y1 = 100*mean(squeeze(mean(matrixAccClasseRodReso(:,:,resoIni:resoFim)))); %acurácia do classificador


plot(x,y1,'-b','LineWidth',2,'DisplayName','Acurácia');
hold on

legend('show','Location','northeast','Orientation','horizontal');
hold off
strTitle = sprintf('Acurácia do Classificador - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Passos');

nameFileGraph = sprintf('graphics/escores_x_classificador/Base%d_Line_Acurácia_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);



fprintf('\nFIM.\n');

end