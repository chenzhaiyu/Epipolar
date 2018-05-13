function BL = RFMreverse( SLH, RFMcoefficient, regularization )
%   RFMreverse ����RFMģ�ͷ���
%   ����Ӱ�����кŸ߳��Լ���������, RFMģ�Ͳ��������������
%   �ڲ��������򻯣�������S L H(����x y W)
%   ֱ�ӵõ��������(Lat, Lon)�������ⲿ�����������Լ�����
%   ���: Lat = BL(1) Lon = BL(2)
%   ����: S = SLH(1) L = SLH(2) Height = SLH(3)
%   RFMcoefficient��regularization��ֱֵ���亯��readrfm����ֵ����

    lineOffset = regularization(1);
    sampOffset = regularization(2);
    latOffset = regularization(3);
    longOffset = regularization(4);
    heightOffset = regularization(5);
    lineScale = regularization(6);
    sampScale = regularization(7);
    latScale = regularization(8);
    longScale = regularization(9);
    heightScale = regularization(10);

    if(length(regularization)==16)
        S1 = SLH(1);
        L1 = SLH(2);
        S = S1 - (regularization(14) + regularization(15)*S1 + regularization(16)*L1);
        L = L1 - (regularization(11) + regularization(12)*S1 + regularization(13)*L1);
    else
        S = SLH(1); 
        L = SLH(2); 
    end
    clear S1 L1;
   
    Height = SLH(3);
    
    L_Num = RFMcoefficient(:,1);
    L_Den = RFMcoefficient(:,2);
    S_Num = RFMcoefficient(:,3);
    S_Den = RFMcoefficient(:,4);
    
    %����SLH
    x = (S - sampOffset) / sampScale;
    y = (L - lineOffset) / lineScale;
    H = (Height - heightOffset) / heightScale;
    
    %��ֵ
    A = [(S_Num(3) - x*S_Den(3)), (S_Num(2) - x*S_Den(2));(L_Num(3) - y*L_Den(3)), (L_Num(2) - y*L_Den(2))];
    l = [(S_Num(1) + S_Num(4)*H - x*S_Den(1) - x*S_Den(4)*H);(L_Num(1) + L_Num(4)*H - y*L_Den(1) - y*L_Den(4)*H)];
    X0 = -A\l;%[P;L]
    %�������
    a = S_Num - x*S_Den;
    c = L_Num - y*L_Den;
    
    for i = 1:10
        P0 = X0(1);
        L0 = X0(2);
        
        %ϵ����
        ap = a(3) + a(5) + a(7)*H + 2*a(9)*P0 + a(11)*H*L0 + 2*a(13)*P0*L0 + a(15)*L0*L0 + 3*a(16)*P0*P0 + a(17)*H*H + 2*a(19)*H*P0;
        al = a(2) + a(5) + a(6)*H + 2*a(8)*L0 + a(11)*H*P0 + 3*a(12)*L0*L0 + a(13)*P0*P0 + a(14)*H*H + 2*a(15)*P0*L0 + 2*a(18)*H*L0;
        cp = c(3) + c(5) + c(7)*H + 2*c(9)*P0 + c(11)*H*L0 + 2*c(13)*P0*L0 + c(15)*L0*L0 + 3*c(16)*P0*P0 + c(17)*H*H + 2*c(19)*H*P0;
        cl = c(2) + c(5) + c(6)*H + 2*c(8)*L0 + c(11)*H*P0 + 3*c(12)*L0*L0 + c(13)*P0*P0 + c(14)*H*H + 2*c(15)*P0*L0 + 2*c(18)*H*L0;
        
        A = [ap, al; cp, cl];
        
        %����
        X = ones(1,20);
        X(2) = L0; X(3) = P0; X(4) = H;
        X(5) = L0 * P0; X(6) = L0 * H; X(7) = P0 * H;
        X(8) = L0 * L0; X(9) = P0 * P0; X(10) = H * H;
        X(11) = P0 * L0 * H; X(12) = L0 * L0 * L0; X(13) = L0 * P0 * P0;
        X(14) = L0 * H * H; X(15) = L0 * L0 * P0; X(16) = P0 * P0 * P0;
        X(17) = P0 * H * H; X(18) = L0 * L0 * H; X(19) = P0 * P0 * H;
        X(20) = H * H * H;
        
        l = [X*a; X*c];
        
        %���
        V = -A\l;
        X0 = X0 + V;
        
        if max(abs(V)) < 0.01
            break;
        end
        
    end
    
    P = X0(1);
    L = X0(2);
    %������
    BL(1) = P * latScale + latOffset;
    BL(2) = L * longScale + longOffset;


end

