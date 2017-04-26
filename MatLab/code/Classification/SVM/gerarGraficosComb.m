function gerarGraficosComb(base,param)

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

x = resoIni:resoFim;
y1 = 100*mean(squeeze(mean(matrixAccClasseRodReso(:,:,resoIni:resoFim)))); %acurácia do classificador
y2 = 100*mean(squeeze(mean(matrixAccClasseRodReso2(:,:,resoIni:resoFim)))); %acurácia do classificador


plot(x,y1,'b','LineWidth',2,'DisplayName','Acurácia');
hold on
plot(x,y2,'g','LineWidth',2,'DisplayName','Acurácia Otimizada');
hold on

legend('show','Location','northeastoutside','Orientation','vertical');
hold off
strTitle = sprintf('Comparando as Acurácias - %d rodadas | Base %d',numRodadas,base);
title(strTitle);
xlabel('Redimensionamento %');
ylabel('Acurácia');

nameFileGraph = sprintf('graphics/escores_x_classificador/combBase%d_Line_Acurácia_Acertos_Erros_Rods%d.png',base,numRodadas);
saveas(gcf,nameFileGraph);

fprintf('\nFIM.\n');

end