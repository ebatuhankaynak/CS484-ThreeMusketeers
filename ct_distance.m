function dct = ct_distance(i, j, colorHistsOfSuperpixels, textureHistsOfSuperpixels)
deltaColor = sum(abs(colorHistsOfSuperpixels{i} - colorHistsOfSuperpixels{j}));
deltaTexture = sum(abs(textureHistsOfSuperpixels{i} - textureHistsOfSuperpixels{j}));
dct = deltaColor + deltaTexture;
end