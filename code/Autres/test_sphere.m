function [] = test_sphere(s_path, img_path)

    s = imread(s_path);
    R_s = s(:,:,1);
    G_s = s(:,:,2);
    B_s = s(:,:,3);
    
    Sy = size(s, 1);
    Sx = size(s, 2);
    

    img = imread(img_path);
    R_img = img(:,:,1);
    G_img = img(:,:,2);
    B_img = img(:,:,3);
    
    
    figure;
    
    r_R = real(normxcorr2(R_s, R_img));
    r_G = real(normxcorr2(G_s, G_img));
    r_B = real(normxcorr2(B_s, B_img));
    
    [R_ypeak, R_xpeak] = find(r_R==max(r_R(:)));
    [G_ypeak, G_xpeak] = find(r_G==max(r_G(:)));
    [B_ypeak, B_xpeak] = find(r_B==max(r_B(:)));
      
    subplot(3,2,1);
    imshow(R_s);
    title('Sphere (R)');
    subplot(3,2,2);
    imshow(R_img);
    title('Image (R)');

    subplot(3,2,3);
    imshow(G_s);
    title('Sphere (G)');
    subplot(3,2,4);
    imshow(G_img);
    title('Image (G)');
    
    subplot(3,2,5);
    imshow(B_s);
    title('Sphere (B)');
    subplot(3,2,6);
    imshow(B_img);
    title('Image (B)');

    
    figure();
    surf(r_R);
    view(2);
    shading('flat');
    set(gca,'ydir','reverse')
    title(['Correlation (R)   -   Y: ' num2str(R_ypeak) ' ; X: ' num2str(R_xpeak) ' ; max: ' num2str(max(r_R(:)))]);
    
    figure();
    surf(r_G);
    view(2);
    shading('flat');
    set(gca,'ydir','reverse')
    title(['Correlation (G)   -   Y: ' num2str(G_ypeak) ' ; X: ' num2str(G_xpeak) ' ; max: ' num2str(max(r_G(:)))]);
    
    figure();
    surf(r_B);
    view(2);
    shading('flat');
    set(gca,'ydir','reverse')
    title(['Correlation (B)   -   Y: ' num2str(B_ypeak) ' ; X: ' num2str(B_xpeak) ' ; max: ' num2str(max(r_B(:)))]);
    
end
