% using raw acc n gyro
clf;
i=0;
t='a';
k=1000;%number of samples
r=zeros(1,6);
p=zeros(1,6);
ax=zeros(1,k);
ay=zeros(1,k);
az=zeros(1,k);
gx=zeros(1,k);
gy=zeros(1,k);
gz=zeros(1,k);
tax=zeros(1,k);
tay=zeros(1,k);
taz=zeros(1,k);
tgx=zeros(1,k);
tgy=zeros(1,k);
tgz=zeros(1,k);
s1 = serial('COM3');             
s1.BaudRate=9600;                               
fopen(s1);
disp('Waiting for User input to record Primary Gesture')
while(t~='b')
    temp = fscanf(s1);
    [t, tempo] = strtok(temp);
end
disp('User input Received')
disp('Recording Primary Gesture')
while(i<k)
    data = fscanf(s1);
    [m, n] = strtok(data);
    if(m=='h')
        reading = real(str2num(n));
    else
        data = fscanf(s1);
        [m, n] = strtok(data);
        reading = real(str2num(n));
    end
    ax(i+1)=reading(1);
    ay(i+1)=reading(2);
    az(i+1)=reading(3);
    gx(i+1)=reading(4);
    gy(i+1)=reading(5);
    gz(i+1)=reading(6);
    i=i+1;
end
disp('Primary Gesture Recorded')
i=0;
disp('Waiting for User input to record Secondary Gesture')
while(t~='c')
    temp = fscanf(s1);
    [t, tempo] = strtok(temp);
end
disp('User input Received')
disp('Recording Secondary Gesture')
while(i<k)
    data = fscanf(s1);
    [m, n] = strtok(data);
    if(m=='h')
        reading = real(str2num(n));
    else
        data = fscanf(s1);
        [m, n] = strtok(data);
        reading = real(str2num(n));
    end
    tax(i+1)=reading(1);
    tay(i+1)=reading(2);
    taz(i+1)=reading(3);
    tgx(i+1)=reading(4);
    tgy(i+1)=reading(5);
    tgz(i+1)=reading(6);
    i=i+1;
end
disp('Secondary Gesture Recorded')
fclose(s1);
A=[ax ay az gx gy gz];
G=[tax tay taz tgx tgy tgz];
for j=0:5
    [R,P]=corrcoef(A((1+j*k):(k+j*k)),G((1+j*k):(k+j*k)));
    r(j+1)=R(1,2);
    p(j+1)=P(1,2);
    figure;
    plot((0:i-1),G((1+j*k):(k+j*k)),'b',(0:i-1),A((1+j*k):(k+j*k)),'r')
    legend('Secondary Gesture','Primary Gesture')
end
disp('p')
disp(p)
disp('r')
disp(r)
score=0;
for k=1:6
    if(p(k)<0.15)
        score=score+2;
    end
    if(r(k)>0.3)
        score=score+1;
    elseif(r(k)<0)
        score=score-2;
    end
end
if(score>=7)
    disp('Gesture Recognised')
else
    disp('Gesture Not Recognised')
end