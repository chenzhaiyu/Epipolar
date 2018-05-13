function image_linear = ImageLinearFunction( image,k)
%�ԻҶ�ֵ������������
%image: �������Ӱ��
%k: ����ϵ�� һ��Ϊ0.005

[m,n] = size(image);

%ͳ�ƻҶ�ֱ��ͼ
bins = 0:intmax('uint16');
hist_count = histc(image(:),bins);

%�����ʱ����
clear bins;
%ֱ��ͼ�ü���������ֵ����ֵ
[l_val,r_val] = calcu_val(hist_count,m*n,k);
%������ֵ����ֵ�����ݽ���ת��
image_linear = (image-l_val).*(255/(r_val-l_val));
image_linear = uint8(round(image_linear));

end

function [l_val,r_val] = calcu_val(hist_count,image_size,k)
%������������ʱ��Ӧ����ֵ����ֵ

pix_cut = image_size*k;

%������ֵ
temp = 0;
for i = 1:length(hist_count)
    temp = temp + hist_count(i);
    if temp >= pix_cut
        l_val = i;
        break;
    end
end
%������ֵ
temp = 0;
for i = length(hist_count):-1:1
   temp = temp+ hist_count(i);
   if temp >= pix_cut
       r_val = i;
       break;
   end
end


end