// ==========================================
// Fiji Macro: Save ROI histograms to CSV
// For 8-bit single-channel images
// ==========================================

// Ask where to save CSV
defaultDir = getDirectory("Choose folder to save CSV");
defaultName = getString("Enter file name (with .csv):", "roi_histograms.csv");
savePath = defaultDir + defaultName;

// Get number of ROIs
nROIs = roiManager("count");
if (nROIs == 0) exit("No ROIs found in ROI Manager!");

// Remember active image
imgID = getImageID();
selectImage(imgID);

// Make sure image is 8-bit
if (bitDepth != 8) run("8-bit");

// Write CSV header
File.saveString("ROI,Bin,Count\n", savePath);

// Declare loop variables
i = 0;
j = 0;
roiName = "";

// Loop over each ROI
for (i = 0; i < nROIs; i++) {
    selectImage(imgID);
    roiManager("Select", i);

    roiName = "ROI_" + (i+1);

    // Get histogram directly
    bins = 256;
    counts = newArray(bins);
    getHistogram(values, counts, bins);  // gets histogram for current selection (ROI)

    for (j = 0; j < bins; j++) {
        line = roiName + "," + j + "," + counts[j] + "\n";
        File.append(line, savePath);
    }
}

print("Histograms saved to: " + savePath);
