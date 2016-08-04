#define _CRT_SECURE_NO_DEPRECATE

#include <iostream>
#include <cmath>
#include <cstdio>
#include <ctime>
#include <chrono>
#include <boost/shared_array.hpp>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cstring>
#include <vector>
#include <math.h>

#include "image_processing_plugin.h"

using namespace std;

const static int HEADER_SIZE = 54;			// Le header est compose des 54 premiers bytes du fichier
const static int WIDTH_IN_HEADER = 18;		// Position de l'information sur la largeur de l'image dans le header
const static int HEIGHT_IN_HEADER = 22;		// Position de l'information sur la hauteur de l'image dans le header

char* TEMPL_PATH = "E:/MaximeBreton/OneDrive/Documents/universite/s4/projet/projet_s4/code/Traitement Image/traitement_image/traitement_image/rgb/templ.rgb";

boost::shared_array<uint8_t> load_img(char* filename, int width, int height, bool isOnlyRed)
{
	// Open image file
	ifstream image_file(filename, ios::binary);
	if (!image_file)
	{
		cerr << "Erreur: Chemin de l'image invalide" << endl;
	}

	int image_size = width * height;

	if (!isOnlyRed)
	{
		image_size *= 3;
	}

	// Check file size
	image_file.seekg(0, image_file.end);
	image_file.seekg(0, image_file.beg);

	// Read file
	boost::shared_array<uint8_t> image(new uint8_t[image_size]);
	image_file.read(reinterpret_cast<char *>(image.get()), image_size);

	if (!isOnlyRed)
	{
		boost::shared_array<uint8_t> imageR(new uint8_t[image_size / 3]);

		for (int i = 0; i < image_size; i+=3)
		{
			imageR[i / 3] = image[i];
		}

		return imageR;
	}

	return image;

	// Votre code ici: l'image est un tableau lineaire de uint8.
	// Chaque pixel contient 3 uint8 soit les composantes: Red, Green, Blue (expliquant le "*3" dans IMAGE_SIZE)
	// Les pixels sont sotckes en mode: row-major order.
	// L'outil convert de imagemagick peut etre interessant pour convertir le format d'image si requis:
	// convert -depth 8 -size 480x480 test.rgb test.png
}

extern "C"
{
	ImageProcessingPlugin * Load();
	void Unload(ImageProcessingPlugin * in_pPlugin);
}

int main(int args, char** argv)
{
	int N = 1;

	double* posx = new double[23];
	double* posy = new double[23];

	for (int i = 1; i < N+1; i++)
	{
		//char* IMAGE_PATH = "";

		/*std::string a = "rgb/image_";
		a += i;
		a += ".rgb";

		strcpy(IMAGE_PATH, a.c_str());*/

		char* IMAGE_PATH = "E:/MaximeBreton/OneDrive/Documents/universite/s4/projet/projet_s4/code/Traitement Image/traitement_image/traitement_image/rgb/image_001.rgb";

		std::clock_t startcputime = std::clock();

		int step = 6;

		int templWidth = 48, templHeight = 48;
		int imageWidth = 480, imageHeight = 480;

		int corr = 0;
		int max = 0;
		int iMax = 0;
		int jMax = 0;

		boost::shared_array<uint8_t> templ = load_img(TEMPL_PATH, templWidth, templHeight, true);
		boost::shared_array<uint8_t> image = load_img(IMAGE_PATH, imageWidth, imageHeight, false);

		int meanTempl = 0;
		for (int n = 0; n < templWidth * templHeight; n++)
		{
			meanTempl += templ[n];
		}
		meanTempl = meanTempl / (templWidth  *templHeight);

		boost::shared_array<long> templMeans(new long[templWidth * templHeight]);
		for (int n = 0; n < templWidth * templHeight; n++)
		{
			templMeans[n] = (long)(templ[n] - meanTempl);
		}

		for (int j = 0; j < imageHeight - templHeight; j += step)
		{
			for (int i = 0; i < imageWidth - templWidth; i += step)
			{
				corr = 0;
				for (int n = 0; n < templHeight; n++)
				{
					for (int m = 0; m < templWidth; m++)
					{
						corr += templMeans[n * templWidth + m] * image[(n + j) * imageWidth + (m + i)];
					}
				}

				if (max < corr)
				{
					max = corr;
					iMax = i;
					jMax = j;
				}
			}
		}
		if (max < 3050000)
		{
			iMax = -1;
			jMax = -1;
		}
		else
		{
			iMax += templWidth / 2;
			jMax += templHeight / 2;
		}

		posx[i] = iMax;
		posy[i] = jMax;

		std::cout << max << "   -  " << jMax << "   -   " << iMax << std::endl;

		double cpu_duration = (std::clock() - startcputime) / (double)CLOCKS_PER_SEC;
		std::cout << "Finished in " << cpu_duration << " seconds [CPU Clock] " << std::endl;
		system("pause");
	}

	return 0;
}
