function gerarGraficosComb2(base,param)

numRodadas = param.numRodadas;
resoIni    = param.resoIni;
resoFim    = param.resoFim;
qtdClasses = param.qtdClasses;
melhores   = param.melhores;

fileAcc = sprintf('acc_Base%d_Rods%d.mat',base,numRodadas);
fileAcertos = sprintf('acertos_Base%d_Rods%d.mat',base,numRodadas);
fileErros = sprintf('erros_Base%d_Rods%d.mat',base,numRodadas);

fileAcc2 = sprintf('2acc_Base%d_Rods%d.mat',base,numRodadas);
fileAcertos2 = sprintf('2acertos_Base%d_Rods%d.mat',base,numRodadas);
fileErros2 = sprintf('2erros_Base%d_Rods%d.mat',base,numRodadas);

a = load(fileAcc);
b = load(fileAcertos);
c = load(fileErros);

d = load(fileAcc2);
e = load(fileAcertos2);
f = load(fileErros2);

matrixAccClasseRodReso       = a.matrixAccClasseRodReso;
somaEscoresAcertosResoGeral  = b.somaEscoresAcertosResoGeral*10;
somaEscoresErrosResoGeral    = c.somaEscoresErrosResoGeral*10;

matrixAccClasseRodReso2      = d.matrixAccClasseRodReso2;
somaEscoresAcertosResoGeral2 = e.somaEscoresAcertosResoGeral2*10;
somaEscoresErrosResoGeral2   = f.somaEscoresErrosResoGeral2*10;

%% exibir/salvar boxplot
fprintf('\nGerando os gráficos\n');


%LINE PLOT DO CLASSIFICADOR
%lineplot dos somatórios dos escores de acertos
gcf = figure('visible','off');
ax1 = subplot(2,1,1);
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

x = resoIni:resoFim;
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

plot(ax1,x,y1,'b','LineWidth',2,'DisplayName','Acurácia');
hold on
plot(ax1,x,y2,'g','LineWidth',2,'DisplayName','Acertos');
hold on
plot(ax1,x,y3,'r','LineWidth',2,'DisplayName','Erros');
hold on
% plot(x,y4,'k','LineWidth',2,'DisplayName','Acurácia+');
% hold on
% plot(x,y5,'c','LineWidth',2,'DisplayName','Acertos+');
% hold on
% plot(x,y6,'m','LineWidth',2,'DisplayName','Erros+');
plot(ax1,x,y7,'k','LineWidth',2,'DisplayName','Valor Classificador');
hold on

% legend('show','Location','northeastoutside','Orientation','vertical');

strTitle = sprintf('Acurácia, Escores de Acertos e Erros do Classificador - %d rodadas | Base %d - Otimizado',numRodadas,base);
title(ax1,strTitle);
%xlabel('Redimensionamento %');
%ylabel(ax1,'Média do Total de Acertos do Classificador');


%#########################################################
%plot 2
%armazena o valor total de acertos do classificador em cada realização
%ou rodada
ax2 = subplot(2,1,2);

b2 = sum(somaEscoresAcertosResoGeral2(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
c2 = squeeze(b2);

%armazena o valor total de erros do classificador em cada realização
%ou rodada
b22 = sum(somaEscoresErrosResoGeral2(:,:,resoIni:resoFim));
%reduz a dimensão da matrix de 3D para 2D para ser plotada no box plot
c22 = squeeze(b22);

x2 = resoIni:resoFim;
y12 = 100*mean(squeeze(mean(matrixAccClasseRodReso2(:,:,resoIni:resoFim)))); %acurácia do classificador
y22 = mean(c2); %média do escores de acertos em todas as rodadas do classificador
y32 = mean(c22); %média do escores de acertos em todas as rodadas do classificador

%pegando as 5 melhores acurácia
mediaAccClasses = squeeze(mean(matrixAccClasseRodReso2(:,:,resoIni:resoFim)));%pega a média das acuracias das clases
mediaAccClassesOrder =  sort(mediaAccClasses,'descend');%ordena as colunas na forma decrescente
y42 = 100*mean(mediaAccClassesOrder(1:melhores,:));% pegar as n melhores melhores acurácias do classificador

%pegando os 5 melhores acertos
mediaAcertosOrder = sort(c,'descend');%ordena as colunas na forma decrescente
y52 = mean(mediaAcertosOrder(1:melhores,:));% pegar os n melhores acertos do classificador

%pegando os 5 menores erros
mediaErrosOrder = sort(c22);%ordena as colunas na forma crescente
y62 = mean(mediaErrosOrder(1:melhores,:));% pegar os n menores erros do classificador

%pegando os valor do classificador
valor_class = c2-c22;
y72 = mean(valor_class);

plot(ax2,x2,y12,'b','LineWidth',2,'DisplayName','Acurácia');
hold on
plot(ax2,x2,y22,'g','LineWidth',2,'DisplayName','Acertos');
hold on
plot(ax2,x2,y32,'r','LineWidth',2,'DisplayName','Erros');
hold on
% plot(x,y42,'k','LineWidth',2,'DisplayName','Acurácia+');
% hold on
% plot(x,y52,'c','LineWidth',2,'DisplayName','Acertos+');
% hold on
% plot(x,y62,'m','LineWidth',2,'DisplayName','Erros+');
plot(ax2,x2,y72,'k','LineWidth',2,'DisplayName','Valor Classificador');
hold on

legend(ax2,'show','Location','southeastoutside','Orientation','horizontal');
hold off
% strTitle = sprintf('Acurácia, Escores de Acertos e Erros do Classificador - %d rodadas | Base %d - Otimizado',numRodadas,base);
% title(strTitle);
xlabel(ax2,'Redimensionamento %');
% ylabel('Média do Total de Acertos do Classificador');

nameFileGraph = sprintf('graphics/escores_x_classificador/Comb2Base%d_Line_Acurácia_Acertos_Erros_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

fprintf('\nFIM.\n');

end