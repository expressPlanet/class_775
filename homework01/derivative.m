function [ imgderx , imgdery ] = derivative( im , sigma )
%takes image im and a sigma.
%returns the x-derivative of image in imgderx, and
%returns the y-derivative of image in imgdery

[N,~,~]=size(im);
hp=1+(N/2); %index of halfway point. For 128 it is 65.

[mag, ph] = ampPhaseDFT(im);
tt=2*(pi^2)*sigma^2;
gf=zeros(hp,N);
gfderx=gf;
gfdery=gf;

for ii=1:hp
    for jj=1:N
        if(jj<=hp)
            nux=jj-1;
        else
            nux=jj-N-1;
        end
        nuy=ii-1;
        nux=nux/N;
        nuy=nuy/N;
        nu2=nux^2+nuy^2;
        gf(ii,jj)=exp(-nu2*tt);
        gfderx(ii,jj)=2*pi*nux*gf(ii,jj);
        gfdery(ii,jj)=2*pi*nuy*gf(ii,jj);
    end
end

magderx=mag.*gfderx;
magdery=mag.*gfdery;
phder=ph+pi/2;

phder(1,1)=ph(1,1);
phder(1,hp)=ph(1,hp);
phder(hp,1)=ph(hp,1);
phder(hp,hp)=ph(hp,hp);

magderx(1,1)=0;
magderx(1,hp)=0;
magderx(hp,1)=0;
magderx(hp,hp)=0;

magdery(1,1)=0;
magdery(1,hp)=0;
magdery(hp,1)=0;
magdery(hp,hp)=0;


thrshold=1e-7;
imgderx=reconfromAmpPhase(magderx,phder);
imgdery=reconfromAmpPhase(magdery,phder);
imgderx(abs(imgderx)<thrshold)=0;
imgdery(abs(imgdery)<thrshold)=0;

