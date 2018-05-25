% ��ȡRFM����
[RFMcoefficientBWD, regularizationBWD] = readrfm('ZY3_TLC_E85.9_N46.1_20140804_L1A0001804812-BWD.rpb'); % ��Ƭ
[RFMcoefficientFWD, regularizationFWD] = readrfm('ZY3_TLC_E85.9_N46.1_20140804_L1A0001804812-FWD.rpb'); % ��Ƭ

% ����ƽ������
avgHeight = 505984; 
deltaHeight = 10;
upHeight = avgHeight + deltaHeight;
downHeight = avgHeight - deltaHeight;

% Ӱ���ȡ
% imageBWD = imread('data/ZY3_TLC_E85.9_N46.1_20140804_L1A0001804812-BWD.tiff');
% imageFWD = imread('data/ZY3_TLC_E85.9_N46.1_20140804_L1A0001804812-FWD.tiff');


% littleImageBWD = ImageLinearFunction(imageBWD, 0.005);
% littleImageFWD = ImageLinearFunction(imageFWD, 0.005);

littleImageBWD = imread('littleImageBWD.tiff');
littleImageFWD = imread('littleImageFWD.tiff');


% Ӱ��ߴ�
[rowsBWD, colsBWD] = size(littleImageBWD);
[rowsFWD, colsFWD] = size(littleImageFWD);

imageEpi1 = uint8(zeros(1.5*rowsBWD, 1.5*colsBWD));
imageEpi2 = uint8(zeros(1.5*rowsBWD, 1.5*colsBWD));


%���Է���ϵ����
ParameterAB1 = zeros(rowsBWD + colsBWD - 1, 2);
ParameterAB2 = zeros(rowsFWD + colsFWD - 1, 2);


for m = 1:colsBWD
    
    % ----------����1����Ƭ��������1�͵�2�Ĵ������----------
    Sa = 1;
    La = m;
    
    % ��ɵ�1�͵�2��SLH�������ڵ���RFMreverse����
    SLH1 = [Sa, La, upHeight];
    SLH2 = [Sa, La, downHeight];

    % �����1�͵�2�Ĵ�����꣬������Ƭ����
    BL1 = RFMreverse(SLH1, RFMcoefficientBWD, regularizationBWD);
    BL2 = RFMreverse(SLH2, RFMcoefficientBWD, regularizationBWD);

    % ----------����2����Ƭ��������b�͵�c��Ӱ������----------

    % ��ɵ�1�͵�2��BLH�������ڵ���RFMforward����
    BLH1 = [BL1, upHeight];
    BLH2 = [BL2, downHeight];

    % �����b�͵�c��Ӱ�����꣬������Ƭ��
    SLb = RFMforward(BLH1, RFMcoefficientFWD, regularizationFWD);
    SLc = RFMforward(BLH2, RFMcoefficientFWD, regularizationFWD);
    
    Sb = SLb(1);
    Sc = SLc(1);
    Lb = SLb(2);
    Lc = SLc(2);

    % ----------����3����Ƭ��������3�Ĵ������----------

    SLH3 = [SLc, upHeight];

    BL3 = RFMreverse(SLH3, RFMcoefficientFWD, regularizationFWD);

    % ----------����4����Ƭ��������d��Ӱ������----------

    BLH3 = [BL3, upHeight];

    SLd = RFMforward(BLH3, RFMcoefficientBWD, regularizationBWD);

    Sd = SLd(1);
    Ld = SLd(2);

    % ----------����5������ֱ�߷���----------

    if (La -Ld ~= 0) 
        A1 = (Sa - Sd) / (La - Ld);
    end
    B1 = Sa - A1 * La;
    if (Lb -Lc ~= 0) 
        A2 = (Sb - Sc) / (Lb - Lc);
    end
    B2 = Sb - A2 * Lb;
    
    ParameterAB1(m, 1) = A1;
    ParameterAB1(m, 2) = B1;
    ParameterAB2(m, 1) = A2;
    ParameterAB2(m, 2) = B2;
 
    deltaBY = 1 / sqrt(1 + (A1 * A1));
    
    % ÿ��
    indexBWD = 1;
    for stepY = 1:deltaBY:rowsBWD - 1
        stepX = A1*stepY - B1;
        if (stepX > colsBWD - 1 || floor(stepY) <= 0 || floor(stepX) <=0)
           continue 
        end
        fuckX = stepX - floor(stepX);
        fuckY = stepY - floor(stepY);
        value = (1 - fuckX)*(1- fuckY)*littleImageBWD(floor(stepY), floor(stepX)) +...
        (1 - fuckX)*fuckY*littleImageBWD(floor(stepY), floor(stepX)+1) + ...
        fuckX*(1 - fuckY)*littleImageBWD(floor(stepY) + 1, floor(stepX)) + ...
        fuckX*fuckY*littleImageBWD(floor(stepY) + 1, floor(stepX) + 1);
        
        imageEpi1(m, indexBWD) = value;
        
        indexBWD = indexBWD + 1;     
    end
    
    
    deltaFY = 1 / sqrt(1 + (A2 * A2));
    
    indexFWD = 1;
    for stepY = 1:deltaFY:rowsFWD - 1
        stepX = A2 * stepY + B2;
        if (stepX > colsFWD - 1 || floor(stepY) <= 0 || floor(stepX) <=0)
           continue 
        end
        fuckX = stepX - floor(stepX);
        fuckY = stepY - floor(stepY);
        value = (1 - fuckX)*(1- fuckY)*littleImageFWD(floor(stepY), floor(stepX)) +...
        (1 - fuckX)*fuckY*littleImageFWD(floor(stepY), floor(stepX)+1) + ...
        fuckX*(1 - fuckY)*littleImageFWD(floor(stepY) + 1, floor(stepX)) + ...
        fuckX*fuckY*littleImageFWD(floor(stepY) + 1, floor(stepX) + 1);
        
        imageEpi2(m, indexFWD) = value;
        
        indexFWD = indexFWD + 1;
           
    end
    
end



