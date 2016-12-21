#include "Segment2.h"
#include "haralick.h"
//#include "Cam.h"
#include <string>
#include <iostream>

int main(int argc, char** argv)
{
	String path_img = "C:\\Users\\fadell\\Google Drive\\Mestrado\\dataBases\\couro_images\\c6_20.jpg";// argv[1];
	String folderpath = "C:\\Users\\fadell\\Google Drive\\Mestrado\\dataBases\\couro_images\\";
	vector<String> filenames;
	glob(folderpath, filenames);

	////ROI
	Mat roi = ROI(path_img);
	//imshow("Segment", roi);

	//extract features GLCM
	Mat glH = glcmH(roi);
	//cout << "glH = " << endl << " " << glH << endl << endl;
	extractFeatures(glH, Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), 1, 6, "C:\\Users\\fadell\\Google Drive\\Mestrado\\results\\glcm.txt");
	
	//for (int i = 0; i<filenames.size(); i++)
	//{
	//	int Class = (int)filenames[i][22]-48;
	//	//ROI
	//	Mat roi = ROI(filenames[i]);
	//	//imshow(filenames[i], roi);

	//	//extract features GLCM
	//	Mat glH = glcmH(roi);
	//	//cout << "glH = " << endl << " " << glH << endl << endl;
	//	extractFeatures(glH, Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), 1, Class, "C:\\Users\fadell\\Google Drive\Mestrado\\dataBases\\glcm.txt");
	//}
	
	

	/// Wait until user finishes program
	while (true)
	{
		int c;
		c = waitKey(20);
		if ((char)c == 27)
		{
			break;
		}
	}
	
	
}