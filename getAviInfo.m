%
% on a déjà testé que le fichier existe
% et peut être ouvert avec fopen()
%
% Y800 = 808466521;
%
function v =getAviInfo(leFich)
  try
    fid =fopen(leFich, 'r');
    isAviFile(fid);
    % rendu ici, le fichier existe et est lisible.
    v.MainHeader =lirListHdrl(fid);
    v.VideoStreamHeader =lirListStrl(fid);
    v.VideoFrameHeader =lirListStrf(fid);
    fclose(fid);
  catch me
    fclose(fid);
    rethrow(me);
  end
end

function isAviFile(fid)
  RIFF =1179011410;
  AVI =541677121;
  fseek(fid, 0, 'bof');
  buf =fread(fid, 1, 'uint32');
  if fid == -1
    me =MException('GETAVIINFO:ISAVIFILE', '???SVP, revisez le nom du fichier, lecture impossible');
    throw(me);
  end
  if buf ~= RIFF
    me =MException('GETAVIINFO:ISAVIFILE', 'L''entête du fichier n''est pas de type AVI.');
    throw(me);
  end
  % le Size du RIFF
  buf =fread(fid, 1, 'uint32');
  buf =fread(fid, 1, 'uint32');
  if buf ~= AVI
    me =MException('GETAVIINFO:ISAVIFILE', 'L''entête du fichier n''est pas de type AVI.');
    throw(me);
  end
end

%
% Pour le champ Flags
% #define 	AVIF_HASINDEX   0x00000010
% #define 	AVIF_MUSTUSEINDEX   0x00000020
% #define 	AVIF_ISINTERLEAVED   0x00000100
% #define 	AVIF_TRUSTCKTYPE   0x00000800
% #define 	AVIF_WASCAPTUREFILE   0x00010000
% #define 	AVIF_COPYRIGHTED   0x00020000
% #define 	AVI_MAX_RIFF_SIZE   0x40000000LL
% #define 	AVI_MASTER_INDEX_SIZE   256
% #define 	AVI_MAX_STREAM_COUNT   100
% #define 	AVIIF_INDEX   0x10
% on pourra utiliser: if  bitand(a,b) == b ...
%_________________________
% retourne s.AviMainHeader
function s =lirListHdrl(fid)
  LIST =1414744396;
  hdrl =1819436136;
  avih =1751742049;
  buf =fread(fid, 1, 'uint32');
  while ~feof(fid) & (buf ~= LIST)
    buf =fread(fid, 1, 'uint32');
  end
  if buf ~= LIST
    me =MException('GETAVIINFO:LIRLISTHDRL', 'L''entête du fichier est incomplète.');
    throw(me);
  end
  % le Size du premier LIST
  leSize =fread(fid, 1, 'uint32');
  buf =fread(fid, 2, 'uint32');
  if ~prod(single(buf' == [hdrl avih]))
    me =MException('GETAVIINFO:LIRLISTHDRL', 'L''entête du fichier est incomplète..');
    throw(me);
  end
  s.fcc =buf(2);
  % le Size de avih
  s.cb =fread(fid, 1, 'uint32');
  rendu =ftell(fid)+s.cb;
  s.MicroSecPerFrame =fread(fid, 1, 'uint32');
  s.FramesPerSecond =1000000/s.MicroSecPerFrame;
  s.MaxBytesPerSec =fread(fid, 1, 'uint32');
  s.PaddingGranularity =fread(fid, 1, 'uint32');
  s.Flags =fread(fid, 1, 'uint32');
  s.TotalFrames =fread(fid, 1, 'uint32');
  s.InitialFrames =fread(fid, 1, 'uint32');
  s.Streams =fread(fid, 1, 'uint32');
  s.SuggestedBufferSize =fread(fid, 1, 'uint32');
  s.Width =fread(fid, 1, 'uint32');
  s.Height =fread(fid, 1, 'uint32');
  fseek(fid, rendu, 'bof');
end

%___________________________
% retourne s.AviStreamHeader
function s =lirListStrl(fid)
  LIST =1414744396;
  strl =1819440243;
  strh =1752331379;
  buf =fread(fid, 1, 'uint32');
  while ~feof(fid) & (buf ~= LIST)
    buf =fread(fid, 1, 'uint32');
  end
  if buf ~= LIST
    me =MException('GETAVIINFO:LIRLISTHDRL', 'L''entête du fichier est incomplète.');
    throw(me);
  end
  % le Size du deuxième LIST
  leSize =fread(fid, 1, 'uint32');
  buf =fread(fid, 2, 'uint32');
  if ~prod(single(buf' == [strl strh]))
    me =MException('GETAVIINFO:LIRLISTHDRL', 'L''entête du fichier est incomplète..');
    throw(me);
  end
  s.fcc =buf(2);
  % le Size de strh
  s.cb =fread(fid, 1, 'uint32');
  rendu =ftell(fid)+s.cb;
  s.fccType =fread(fid, 1, 'uint32');
  s.fccHandler =fread(fid, 1, 'uint32');
  s.CompressionHandler =s.fccHandler;
  s.Flags =fread(fid, 1, 'uint32');
  s.Priority =fread(fid, 1, 'uint16');
  s.Language =fread(fid, 1, 'uint16');
  s.InitialFrames =fread(fid, 1, 'uint32');
  s.Scale =fread(fid, 1, 'uint32');
  s.Rate =fread(fid, 1, 'uint32');
  s.Start =fread(fid, 1, 'uint32');
  s.Length =fread(fid, 1, 'uint32');
  s.SuggestedBufferSize =fread(fid, 1, 'uint32');
  s.Quality =fread(fid, 1, 'uint32');
  s.SampleSize =fread(fid, 1, 'uint32');
  fseek(fid, rendu, 'bof');
end

%____________________________
% retourne s.BitmapInfoHeader
function s =lirListStrf(fid)
  strf =1718776947;
  buf =fread(fid, 1, 'uint32');
  while ~feof(fid) & (buf ~= strf)
    buf =fread(fid, 1, 'uint32');
  end
  if buf ~= strf
    me =MException('GETAVIINFO:LIRBITMAPINFO', 'L''entête du fichier est incomplète.');
    throw(me);
  end
  % le Size de strf
  s.Size =fread(fid, 1, 'uint32');
  rendu =ftell(fid)+s.Size;
  s.Size =fread(fid, 1, 'uint32');
  s.Width =fread(fid, 1, 'uint32');
  s.Height =fread(fid, 1, 'uint32');
  s.Planes =fread(fid, 1, 'uint16');
  s.BitCount =fread(fid, 1, 'uint16');
  s.BitDepth =s.BitCount;
  s.Compression =fread(fid, 1, 'uint32');
  s.CompressionType =s.Compression;
  s.SizeImage =fread(fid, 1, 'uint32');
  s.XPelsPerMeter =fread(fid, 1, 'uint32');
  s.YPelsPerMeter =fread(fid, 1, 'uint32');
  s.ClrUsed =fread(fid, 1, 'uint32');
  s.ClrImportant =fread(fid, 1, 'uint32');
  fseek(fid, rendu, 'bof');
end
