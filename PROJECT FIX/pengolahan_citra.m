clc; clear; close all; warning off all;

%memanggil menu "browse file"
[nama_file,nama_folder] = uigetfile('*.jpg');

%jika ada nama file yang dipilih maka akan mengeksekusi perintah di bawah
%ini
if ~isequal(nama_file,0)
     %membaca file RGB
    Img = im2double(imread(fullfile(nama_folder,nama_file)));
    %figure, imshow(Img)
    
    %konfersi RGB ke grayscale
    Img_gray = rgb2gray(Img);
    %figure, imshow(rgb2gray)
    
    %konfersi grayscale ke biner
    bw = imbinarize(Img_gray);
    %figure, imshow(bw)
    
    %melakukan operasi komplemen
    bw = imcomplement(bw);
    %figure, imshow(bw)
    
    %melakukan operasi morfologi dari hasil segmentasi
    %filling holes
    bw = imfill(bw,'holes');
    %figure, imshow(bw)
    
    %area opening
    bw = bwareaopen(bw, 1000);
    %figure, imshow (bw)
    
    %ekstraksi ciri RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,2);
    R(~bw) = 0;
    G(~bw) = 0;
    B(~bw) = 0;
    %RGB = cat(3,R,G,B);
    %figure, imshow(RGB)
    
    Red = sum(sum(R))/sum(sum(bw));
    Green = sum(sum(G))/sum(sum(bw));
    Blue = sum(sum(B))/sum(sum(bw));
    
    %ekstraksi ciri HSV
    HSV = rgb2hsv(Img);
    %figure, imshow(HSV)
    
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    H(~bw) = 0;
    S(~bw) = 0;
    V(~bw) = 0;
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    
    %menyusun variabel ciri_uji
    ciri_uji = [Hue,Saturation,Value];
    
    %memanggil model knn hasil pelatihan
    load Mdl
    
    %membaca kelas keluaran hasil pengujian
    hasil_uji = predict(Mdl,ciri_uji);
    
    %menampilkan citra asli dan keluaran hasil pengujian
    figure, imshow(Img)
    title({['Nama File: ',nama_file],['Kelas Keluaran: ',hasil_uji{1}]})
else
    %jika tidak ada nama file yang dipilih maka akan kembali
    return
end