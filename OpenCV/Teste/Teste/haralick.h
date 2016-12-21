#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv2/core.hpp>

using namespace cv;
using namespace std;


//creating glcm matrix with 256 levels,radius=1 and in the horizontal direction
Mat glcmH(Mat Input_Image)
{

	int row = Input_Image.rows, col = Input_Image.cols;
	Mat gl = Mat::zeros(256, 256, CV_32FC1);

	//creating glcm matrix with 256 levels,radius=1 and in the horizontal direction
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col - 1; j++) {
			//Do not consider the white background
			if (Input_Image.at<uchar>(i, j) == 255 || Input_Image.at<uchar>(i, j + 1) == 255) {
				continue;
			}
			gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) = gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) + 1;
		}
	}
				

	// normalizing glcm matrix for parameter determination
	gl = gl + gl.t();
	gl = gl / sum(gl)[0];

	return gl;

}

//creating glcm matrix with 256 levels,radius=1 and in the  vertical direction
Mat glcmV(Mat Input_Image)
{
	int row = Input_Image.rows, col = Input_Image.cols;
	Mat gl = Mat::zeros(256, 256, CV_32FC1);

	//creating glcm matrix with 256 levels,radius=1 and in the horizontal direction
	for (int i = 0; i<row; i++)
		for (int j = 0; j<col - 1; j++)
			gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) = gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) + 1;

	// normalizing glcm matrix for parameter determination
	gl = gl + gl.t();
	gl = gl / sum(gl)[0];

	return gl;

}

//creating glcm matrix with 256 levels,radius=1 and in the diagonal direction
Mat glcmD(Mat Input_Image)
{

	int row = Input_Image.rows, col = Input_Image.cols;
	Mat gl = Mat::zeros(256, 256, CV_32FC1);

	//creating glcm matrix with 256 levels,radius=1 and in the horizontal direction
	for (int i = 0; i<row; i++)
		for (int j = 0; j<col - 1; j++)
			gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) = gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) + 1;

	// normalizing glcm matrix for parameter determination
	gl = gl + gl.t();
	gl = gl / sum(gl)[0];

	return gl;

}

//creating glcm matrix with 256 levels,radius=1 and in the antidiagonal direction
Mat glcmA(Mat Input_Image)
{

	int row = Input_Image.rows, col = Input_Image.cols;
	Mat gl = Mat::zeros(256, 256, CV_32FC1);

	//creating glcm matrix with 256 levels,radius=1 and in the horizontal direction
	for (int i = 0; i<row; i++)
		for (int j = 0; j<col - 1; j++)
			gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) = gl.at<float>(Input_Image.at<uchar>(i, j), Input_Image.at<uchar>(i, j + 1)) + 1;

	// normalizing glcm matrix for parameter determination
	gl = gl + gl.t();
	gl = gl / sum(gl)[0];

	return gl;

}

void extractFeatures(Mat glH, Mat glV, Mat glD, Mat glA,int avg, int Class, char Output_File_Name[100]) {
	float energy = 0, contrast = 0, homogenity = 0;
	float IDM = 0, entropy = 0, dissimilarity = 0, CT = 0, CS = 0, IMC1 = 0, IMC2 = 0, MCC = 0;
	float Px = 0, Py = 0, PyK = 0, HX = 0, HY = 0, HXY = 0, HXY1 = 0, HXY2 = 0;
	float asm1 = 0, correlation = 0;
	float mean = 0, mean1 = 0, mean2 = 0, omegai = 0, omegaj = 0;
	float variance = 0, sumEntropy = 0, sumVariance = 0, sumAverage = 0;
	float diferenceEntropy = 0, diferenceVariance = 0;

	//Extracting the features for Horizontal GLCM
	if (avg >= 1) {
		for (int i = 0; i<256; i++)
		{
			for (int j = 0; j < 256; j++)
			{
				contrast = contrast + (i - j)*(i - j)*glH.at<float>(i, j);
				homogenity = homogenity + glH.at<float>(i, j) / (1 + (abs(i - j)*abs(i - j)));
				energy = energy + (glH.at<float>(i, j)*glH.at<float>(i, j));
				dissimilarity = dissimilarity + glH.at<float>(i, j)*(abs(i - j));

				if (glH.at<float>(i, j) != 0)
				{
					entropy = entropy - glH.at<float>(i, j)*log10(glH.at<float>(i, j));
				}

				mean1 = mean1 + i*glH.at<float>(i, j);
				mean2 = mean2 + j*glH.at<float>(i, j);
				mean = mean + ((mean1 + mean2) / 2);
				omegai = omegai + sqrt(glH.at<float>(i, j)*(i - mean1)*(i - mean2));
				omegaj = omegaj + sqrt(glH.at<float>(i, j)*(j - mean2)*(j - mean2));
				if (omegai != 0 && omegaj != 0)
				{
					//rever aqui
					correlation = correlation + ((((i*j)*(glH.at<float>(i, j))) - (mean1*mean2)) / (omegai*omegaj));
				}

				CT += ((i + j + (-2 * ((mean1 + mean2) / 2)))*(i + j + (-2 * ((mean1 + mean2) / 2))))*glH.at<float>(i, j);

				CS += ((i + j - mean1 - mean2)*(i + j - mean1 - mean2)*(i + j - mean1 - mean2))*glH.at<float>(i, j);

				Px = Py = 0;
				//computation HX = entropy of Px
				for (int x = 0; x < 256; x++)
					if (glH.at<float>(i, x) != 0) {
						HX = HX - glH.at<float>(i, x)*log10(glH.at<float>(i, x));
						Px += glH.at<float>(i, x);
					}

				//computation HY = entropy of Py
				for (int y = 0; y < 256; y++)
					if (glH.at<float>(y, j) != 0) {
						HY = HY - glH.at<float>(y, j)*log10(glH.at<float>(y, j));
						Py += glH.at<float>(y, j);
					}

				if ((Px*Py) != 0) {
					HXY1 = HXY1 - glH.at<float>(i, j)*log10(Px*Py);
					HXY2 = HXY2 - Px*Py*log10(Px*Py);
				}

				//computation Second largest eigenvalue of Q
				/*for (int k = 0; k < 256; k++) {
					for (int y = 0; y < 256; y++)
						if (glH.at<float>(y, k) != 0) {
							PyK += glH.at<float>(y, k);
						}

					if (Px != 0) {
						MCC += sqrt((glH.at<float>(i, k) * glH.at<float>(j, k)) / (Px * PyK));
					}
				}*/
				

			}
		}

		HXY = entropy;

		IMC1 = (HXY - HXY1) / max(HX, HY);
		IMC2 = sqrt(1 - exp(-2.0*(HXY2 - HXY)));
	}
	

	//Para FILE
	FILE*GLCMBD = fopen(Output_File_Name, "a");
	fprintf(GLCMBD, "%f,", entropy);
	fprintf(GLCMBD, "%f,", energy);
	fprintf(GLCMBD, "%f,", homogenity);
	fprintf(GLCMBD, "%f,", contrast);
	fprintf(GLCMBD, "%f,", CT);
	fprintf(GLCMBD, "%f,", CS);
	fprintf(GLCMBD, "%f,", correlation);
	fprintf(GLCMBD, "%f,", IMC1);
	fprintf(GLCMBD, "%f,", IMC2);
	fprintf(GLCMBD, "%f,", dissimilarity);
	fprintf(GLCMBD, "%d", Class);
	fprintf(GLCMBD, "\n");
	fclose(GLCMBD);
}