function [DS, dsInfo] = fun_readDose(ffn)

hWB = waitbar(0, 'Loading Dose...');

DS = dicomread(ffn);
dcmInfo = dicominfo(ffn);
dsInfo.dcmInfo = dcmInfo;

waitbar(50, hWB);


ipp = dcmInfo.ImagePositionPatient;
nRows = double(dcmInfo.Rows);
nColumns = double(dcmInfo.Columns);
dx = dcmInfo.PixelSpacing(1);
dy = dcmInfo.PixelSpacing(2);
x0 = ipp(1);
y0 = ipp(2);
z0 = ipp(3);
xx = x0:dx:x0+dx*(nColumns-1);
yy = y0:dy:y0+dy*(nRows-1);
zz = z0+dcmInfo.GridFrameOffsetVector;

dsInfo.ipp = ipp;
dsInfo.xx = xx;
dsInfo.yy = yy;
dsInfo.zz = zz;

dsInfo.dx = dx;
dsInfo.dy = dy;
dsInfo.dz = zz(2)-zz(1);
dsInfo.zOS = dcmInfo.GridFrameOffsetVector;

close(hWB)