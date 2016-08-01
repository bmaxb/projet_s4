Decouplage

Kp=0.705;
Kv=0.57085;
Gdx=feedback(Gsy2,Kv);
Gdx=series(tf([1],[1 0]),Gdx)
Gx=feedback(Gdx,Kp);
Gx = minreal(Gx)*Kp;

figure,
rlocus(Gx)
figure,
step(Gx)

S=stepinfo(Gx)
t=[0:0.01:20];
u=ones(size(t));
y=lsim(Gx,u,t);
figure
plot(t,y)