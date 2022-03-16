% ��������Ӧ�˲����棨��Գ��ٶ�ģ�͵ĵ���״̬���ƣ����������μ�'�����ߵ��㷨����ϵ���ԭ��'����ϰ��35��.
%	AKF   - ��������Ӧ�������˲�
%	MCKF  - MCKF�������ؿ������˲�
%	RSTKF - RSTKF³��ѧ��t�������˲�
%	SSMKF - SSMKFͳ�����ƶ����������˲�
% Copyright(c) 2009-2022, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 16/03/2022
%% ��������
Ft = [0 -1; 0 0];  Gt = [0; 1];
q = 0.05;
Ts = 0.5;
Phi = eye(2)+Ft*Ts;  Gamma = Gt;  Qk = q*Ts;
Hk = [1 0];  Rk = 50^2;
%% �켣����
s0 = 100000; v0 = 300;
Xk = [s0; v0];
Xkk = zeros(fix(s0/300/Ts),2); Zkk = Xkk(:,1);
k = 1;
while Xk(1)>0
    Xk = Phi*Xk + Gamma*randn(1)*sqrt(Qk);
    Zk = Hk*Xk + htwn(0.1,100)*sqrt(Rk);  % ��β��������
    Xkk(k,:) = Xk';
    Zkk(k,:) = Zk; k = k+1;
end
Xkk(k-1:end,:) = [];  Zkk(k-1:end,:) = [];
figure
subplot(211), plot([Xkk(:,1),Zkk]); grid on; xlabel('k'); ylabel('����/m'); legend('��ʵ����sk', '�۲����Zk');
subplot(212), plot(Xkk(:,2)); grid on; xlabel('k'); ylabel('�ٶ�/m/s'); legend('��ʵ�ٶ�vk');
%% �����˲� KF/MCKF/RSTKF/SSMKF
akf.xk = [s0+100; v0+10];  akf.Pxk = diag([100, 10])^2;
akf.Phikk_1 = Phi;   akf.Gammak = Gamma;   akf.Qk = Qk;
akf.Rk = Rk;  akf.Hk = Hk;
ares = zeros(length(Zkk),5);
mkf = akf; rkf = akf; skf = akf;   mres = ares; rres = ares; sres = ares; 
for k=1:length(Zkk)
    akf = akfupdate(akf, Zkk(k), 'B', 'AKF');       ares(k,:) = [akf.xk; diag(akf.Pxk); akf.lambda];
    mkf = akfupdate(mkf, Zkk(k), 'B', 'MCKF');      mres(k,:) = [mkf.xk; diag(mkf.Pxk); mkf.lambda];
    rkf = akfupdate(rkf, Zkk(k), 'B', 'RSTKF');     rres(k,:) = [rkf.xk; diag(rkf.Pxk); rkf.lambda];
    skf = akfupdate(skf, Zkk(k), 'B', 'SSMKF');     sres(k,:) = [skf.xk; diag(skf.Pxk); skf.lambda];
end
figure
subplot(221), plot(Zkk-Xkk(:,1)); grid on; xlabel('k'); ylabel('����/m'); legend('��β����۲����Zk-sk');
subplot(223), plot([Xkk(:,2),ares(:,2),mres(:,2),rres(:,2),sres(:,2)]); grid on; xlabel('k'); ylabel('�ٶ�/m/s'); 
    legend('��ʵ�ٶ�vk', 'AKF����','MCKF����','RSTKF����','SSMKF����');
    perr = [ares(:,1)-Xkk(:,1),mres(:,1)-Xkk(:,1),rres(:,1)-Xkk(:,1),sres(:,1)-Xkk(:,1)];
subplot(222), plot(perr); hold on, grid on; xlabel('k'); plot(sqrt([ares(:,3),mres(:,3),rres(:,3),sres(:,3)])); ylabel('�������/m');
    perr=mean(abs(perr(100:end,:))); legend(sprintf('AKF����%.3f',perr(1)),sprintf('MCKF����%.3f',perr(2)),sprintf('RSTKF����%.3f',perr(3)),sprintf('SSMKF����%.3f',perr(4)));
    verr = [ares(:,2)-Xkk(:,2),mres(:,2)-Xkk(:,2),rres(:,2)-Xkk(:,2),sres(:,2)-Xkk(:,2)];
subplot(224), plot(verr); hold on, grid on; xlabel('k'); plot(sqrt([ares(:,4),mres(:,4),rres(:,4),sres(:,4)])); ylabel('�ٶ����/m/s');
    verr = mean(abs(verr(100:end,:))); legend(sprintf('AKF����%.3f',verr(1)),sprintf('MCKF����%.3f',verr(2)),sprintf('RSTKF����%.3f',verr(3)),sprintf('SSMKF����%.3f',verr(4)));
% figure, plot([ares(:,5),mres(:,5),rres(:,5),sres(:,5)]), grid on; xlabel('k'); ylabel('��������'); legend('AKF����','MCKF����','RSTKF����','SSMKF����');


