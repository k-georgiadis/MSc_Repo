%-------------------------------------------------------------------------- 
% Mo����������� ��� ������������ ��� �������� ��� ������� ������� Box-Jenkins.
% 6 �������: y(k-1), y(k-2), y(k-3), u(k), u(k-1), u(k-2)
%--------------------------------------------------------------------------
close all;      clear all;      clc;        format long;
%__________________________________________________________________________
%__________________________________________________________________________
% ���������� �������� - �����������
fuzzySets = 2;                      % ����� ������ ��� ������
epoch_number = 30;                 % ������� ����������� �����������
initial_learning_rate = 0.1;        % ������� ������ ���������
mfType = 'gauss2mf';                % ����� ���������� ���������� ('trimf', 'trapmf', 'gbellmf', 'gaussmf', 'gauss2mf', 'pimf' 'dsigmf', 'psigmf')
outType = 'linear';                 % ����� ������ ��� ������: ������� ('constant;) � �������� ('linear')
%__________________________________________________________________________
%__________________________________________________________________________
% ���������� ��� �����������
samples = 290;                      % ������� ��������� ����������� 
load BJ_data.dat
time = BJ_data(:,1);
x = BJ_data(:, 8);
figure(1)
plot(time,x)
title('Box-Jenkins time-series')
xlabel('Time')
%-------------------------------------------------------------------------- 
% �������� ��� ���������
for t = 1:samples 
    Data(t,:) = [BJ_data(t,2) BJ_data(t,3), BJ_data(t,4), BJ_data(t,5), BJ_data(t,6), BJ_data(t,7), BJ_data(t,8)]; 
end
trnData = Data(1:samples,:);
save('trnData.dat','trnData','-ASCII');

fismat = genfis1(trnData,[fuzzySets fuzzySets fuzzySets fuzzySets fuzzySets fuzzySets],char(mfType,mfType,mfType,mfType,mfType,mfType),char(outType));
%-------------------------------------------------------------------------- 
% �� ������� ����������� ���������� ��������� ���������� ��� ���� �������
figure(2)
for (i = 1:6)
    subplot(2,3,i)
    plotmf(fismat,'input',i)
end
%-------------------------------------------------------------------------- 
% ����������
[fismat2,training_error,learning_rate] = anfis(trnData,fismat,[epoch_number,0,initial_learning_rate,0.9,1.1],[0 0 0 0]);
training_error
%-------------------------------------------------------------------------- 
%���������� ��� ������� ����������� ����������
figure(3)
for (i = 1:6)
    subplot(2,3,i)
    plotmf(fismat2,'input',i)
end
%���������� ��� �������� ��� ��������� ���������
figure(4)
plot([training_error])
hold on
legend('training error')
xlabel('Epochs')
ylabel('RMSE (Root Mean Squared Error)')
title('Error Curves')
%���������� ��� �������� ��� ������ ���������
figure(5)
plot(learning_rate)
xlabel('Epochs')
ylabel('Learning rate')
title('Evolution of the learning rate')
%-------------------------------------------------------------------------- 
%�������� ��� ������ ��� ���������� �� ��� ����������
anfis_output = evalfis(trnData(:,1:6), fismat2);
index = 1:samples;

figure(6)
plot(time(index),[x(index) anfis_output])
plot(time(index),x(index),'b',time(index),anfis_output,'r')
xlabel('Time (sec)')
title('Box-Jenkins Time Series and ANFIS Prediction')

%������ ��� ���� ������ ��� ������� ���������
figure(7)
plot(time(index),x(index) - anfis_output)
xlabel('Time (sec)')
title('Prediction Error');