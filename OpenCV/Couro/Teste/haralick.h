
#include <opencv2/core.hpp>
#include <iostream>

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

	//normalize(gl, gl, 0, 1, NORM_MINMAX, -1, Mat());

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
	float mean1 = 0, mean2 = 0, omegai = 0, omegaj = 0;
	float variance = 0, sumEntropy = 0, sumVariance = 0, sumAverage = 0;
	float diferenceEntropy = 0, diferenceVariance = 0;
	float sumK = 0;

	Mat vPx, vPy;
	Mat mean, meanX, meanY;
	Mat omega, omegaX, omegaY;

	Mat Q = Mat::zeros(256, 256, CV_32FC1);

	reduce(glH, vPx, 1, CV_REDUCE_SUM);
	reduce(glH, vPy, 0, CV_REDUCE_SUM);

	meanStdDev(glH, mean, omega);


	//Extracting the features for Horizontal GLCM
	if (avg >= 1) {
		for (int i = 0; i<256; i++)
		{
			meanStdDev(glH.row(i),meanX,omegaX );

			//printf("%f - %f\n", meanX.at<double>(0,0), omegaX.at<double>(0,0));

			for (int j = 0; j < 256; j++)
			{
				meanStdDev(glH.col(j), meanY, omegaY);

				contrast = contrast + (i - j)*(i - j)*glH.at<float>(i, j);
				homogenity = homogenity + glH.at<float>(i, j) / (1 + (abs(i - j)*abs(i - j)));
				energy = energy + (glH.at<float>(i, j)*glH.at<float>(i, j));

				if (glH.at<float>(i, j) != 0)
				{
					entropy = entropy - glH.at<float>(i, j)*log10(glH.at<float>(i, j));
				}

				mean1 = meanX.at<double>(0,0);
				mean2 = meanY.at<double>(0,0);
				omegai = omegaX.at<double>(0,0);
				omegaj = omegaY.at<double>(0,0);
				float U = mean.at<double>(0,0);


				if (omegai != 0 && omegaj != 0)
				{
					//rever aqui
					correlation = correlation + ((((i*j)*(glH.at<float>(i, j))) - (mean1*mean2)) / (omegai*omegaj));
				}

				CT += ((i + j + (-2 * U))*(i + j + (-2 * U)))*glH.at<float>(i, j);

				CS += ((i + j - mean1 - mean2)*(i + j - mean1 - mean2)*(i + j - mean1 - mean2))*glH.at<float>(i, j);

				

				Px = vPx.at<float>(i);
				Py = vPy.at<float>(j);

				//computation HX = entropy of Px
				for (int x = 0; x < 256; x++)
					if (glH.at<float>(i, x) != 0) {
						HX = HX - glH.at<float>(i, x)*log10(glH.at<float>(i, x));
					}

				//computation HY = entropy of Py
				for (int y = 0; y < 256; y++)
					if (glH.at<float>(y, j) != 0) {
						HY = HY - glH.at<float>(y, j)*log10(glH.at<float>(y, j));
					}

				if ((Px*Py) != 0) {
					HXY1 = HXY1 - glH.at<float>(i, j)*log10(Px*Py);
					HXY2 = HXY2 - Px*Py*log10(Px*Py);
				}

				//computation Second largest eigenvalue of Q
				sumK = 0;
				for (int k = 0; k < 256; k++) {
					PyK = vPy.at<float>(k);

					if (Px != 0 && PyK != 0) {
						sumK += ((glH.at<float>(i, k) * glH.at<float>(j, k)) / (Px * PyK));
					}
				}

				Q.at<float>(i, j) = sumK;
				

			}
		}

		HXY = entropy;

		IMC1 = (HXY - HXY1) / max(HX, HY);
		IMC2 = sqrt(1 - exp(-2.0*(HXY2 - HXY)));

		
		Mat eigenvalues, eigenvectors;
		float secondEigenvalue;
		eigen(Q, eigenvalues, eigenvectors);
		secondEigenvalue = eigenvalues.at<float>(1);
		MCC = sqrt(secondEigenvalue);


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
	fprintf(GLCMBD, "%f,", MCC);
	fprintf(GLCMBD, "%d", Class);
	fprintf(GLCMBD, "\n");
	fclose(GLCMBD);

}