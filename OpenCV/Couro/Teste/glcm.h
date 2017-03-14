#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv2/core.hpp>

using namespace cv;
using namespace std;


void GLCM(Mat Input_Image, int Class, char Output_File_Name[100])
{
	float energy = 0, contrast = 0, homogenity = 0;
	float IDM = 0, entropy = 0, dissimilarity = 0;
	float asm1 = 0, correlation = 0;
	float mean1 = 0, mean2 = 0, omegai = 0, omegaj = 0;
	float variance = 0, sumEntropy = 0, sumVariance = 0, sumAverage = 0;
	float diferenceEntropy = 0, diferenceVariance = 0;

	int row = Input_Image.rows, col = Input_Image.cols;
	Mat gl = Mat::zeros(256, 256, CV_32FC1);

	//creating glcm matrix with 256 levels,radius=1 and in the horizontal direction
	for (int i = 0; i<row; i++)
		for (int j = 0; j<col - 1; j++)
			gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) = gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) + 1;

	// normalizing glcm matrix for parameter determination
	gl = gl + gl.t();
	gl = gl / sum(gl)[0];


	for (int i = 0; i<256; i++)
	{
		for (int j = 0; j<256; j++)
		{
			contrast = contrast + (i - j)*(i - j)*gl.at<float>(i, j);
			homogenity = homogenity + gl.at<float>(i, j) / (1 + abs(i - j)); // No denominador È ( i - j ) ao quadrado //
			dissimilarity = dissimilarity + gl.at<float>(i, j)*(abs(i - j));
			asm1 = asm1 + (gl.at<float>(i, j)*gl.at<float>(i, j));
			energy = energy + sqrt(asm1);

			if (i != j)
			{
				IDM = IDM + gl.at<float>(i, j) / ((i - j)*(i - j)); //Taking k=2; // IDM no artigo o denominador È (1 + (i-j)^2)
			}
			if (gl.at<float>(i, j) != 0)
			{
				entropy = entropy - gl.at<float>(i, j)*log10(gl.at<float>(i, j));
			}
			mean1 = mean1 + i*gl.at<float>(i, j);
			mean2 = mean2 + j*gl.at<float>(i, j);
			omegai = omegai + sqrt(gl.at<float>(i, j)*(i - mean1)*(i - mean2));
			omegaj = omegaj + sqrt(gl.at<float>(i, j)*(j - mean2)*(j - mean2));
			if (omegai != 0 && omegaj != 0)
			{
				correlation = correlation + ((((i*j)*(gl.at<float>(i, j))) - (mean1*mean2)) / (omegai*omegaj));
			}
			variance += ((i - (mean1 + mean2) / 2)*(i - (mean1 + mean2) / 2))*gl.at<float>(i, j);
			for (int s = 2; s<513; s++)
			{
				if (i + j == s && gl.at<float>(s)>0)
				{
					sumEntropy += (-1)*(gl.at<float>(s))*log10((gl.at<float>(s)));
					sumVariance += (i - sumEntropy)*(i - sumEntropy)*(gl.at<float>(s));
					sumAverage += i*(gl.at<float>(s));
				}
			}
			for (int s = 0; s<256; s++)
			{
				if (i - j == s && gl.at<float>(s)>0)
				{
					diferenceEntropy += (-1)*(gl.at<float>(s))*log10(gl.at<float>(s));
					diferenceVariance += ((i - (mean1 + mean2) / 2)*(i - (mean1 + mean2) / 2))*gl.at<float>(s);
				}
			}
		}
	}

	//Para FILE
	FILE*GLCMBD = fopen(Output_File_Name, "a");
	fprintf(GLCMBD, "%f,", entropy);
	fprintf(GLCMBD, "%f,", energy);
	fprintf(GLCMBD, "%f,", homogenity);
	fprintf(GLCMBD, "%f,", contrast);
	fprintf(GLCMBD, "%f,", IDM);
	fprintf(GLCMBD, "%f,", dissimilarity);
	fprintf(GLCMBD, "%f,", asm1);
	fprintf(GLCMBD, "%f,", correlation);
	fprintf(GLCMBD, "%f,", variance);
	fprintf(GLCMBD, "%f,", sumEntropy);
	fprintf(GLCMBD, "%f,", sumVariance);
	fprintf(GLCMBD, "%f,", sumAverage);
	fprintf(GLCMBD, "%f,", diferenceEntropy);
	fprintf(GLCMBD, "%f,", diferenceVariance);
	fprintf(GLCMBD, "%d", Class);
	fprintf(GLCMBD, "\n");
	fclose(GLCMBD);
}