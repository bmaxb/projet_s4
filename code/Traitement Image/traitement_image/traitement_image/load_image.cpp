#include <boost/shared_array.hpp>
#include <cstdlib>
#include <iostream>
#include <fstream>

using namespace std;

boost::shared_array<uint8_t> load_raw_image(char* filename, int width, int height, bool isOnlyRed)
{
	// Open image file
	ifstream image_file(filename, ios::binary);
	if(!image_file)
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

	// Votre code ici: l'image est un tableau lineaire de uint8.
	// Chaque pixel contient 3 uint8 soit les composantes: Red, Green, Blue (expliquant le "*3" dans IMAGE_SIZE)
	// Les pixels sont sotckes en mode: row-major order.
	// L'outil convert de imagemagick peut etre interessant pour convertir le format d'image si requis:
	// convert -depth 8 -size 480x480 test.rgb test.png

	return image;
}
