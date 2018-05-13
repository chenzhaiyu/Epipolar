function [RFMcoefficient, regularization] = readrfm( filepath )
%   readrfm ����·��, ��ȡrpb�ļ�
%   RFMcoefficientΪϵ�������������ζ�Ӧ
%   L���� L��ĸ S���� S��ĸ
%   L_Num L_Den S_Num S_Den
%   regularizationΪ���򻯲���
%   Ԫ������Ϊ
%   lineOffset = regularization(1);
%   sampOffset = regularization(2);
%   latOffset = regularization(3);
%   longOffset = regularization(4);
%   heightOffset = regularization(5);
%   lineScale = regularization(6);
%   sampScale = regularization(7);
%   latScale = regularization(8);
%   longScale = regularization(9);
%   heightScale = regularization(10);

    fid = fopen(filepath,'r');
    textscan(fid,'%*s',18);
    %���򻯲���
    temp = textscan(fid,'%*s%*s%f;',10);
    regularization = temp{1};
    %L����ϵ��
    textscan(fid,'%*s',3);
    L_Num = fscanf(fid,'%f,',[20,1]);
    %L��ĸϵ��
    textscan(fid,'%*s',4);
    L_Den = fscanf(fid,'%f,',[20,1]);
    %S����ϵ��
    textscan(fid,'%*s',4);
    S_Num = fscanf(fid,'%f,',[20,1]);
    %S��ĸϵ��
    textscan(fid,'%*s',4);
    S_Den = fscanf(fid,'%f,',[20,1]);
    fclose(fid);
    RFMcoefficient = [L_Num, L_Den, S_Num, S_Den];

end

