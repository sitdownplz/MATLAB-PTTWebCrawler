%% PTT ���νm��
function Data = PTTCrawler(site,genFile)

% ���m�ߵ{���X�Ω󪦨�PTT���W�峹��T�A�奻���R�u��c���ݨD��¥ΨӲ���html tag
% �Y�O�ϥγo����Ƥ奻���R�u��c�A�i�Τ@���r�B�z��k����
% Requirement: Text Analytics Toolbox

tic; % �ϥ� tic-toc �p��{���B�檦���ɶ�
narginchk(0,3) % �ˬd�ϥΪ̿�J���ܼƼƶq�O�_�ŦX
switch nargin
    case 0
        % �ϥΪ̨S�������J�A�w�]�d�ߤK����
        site  = 'Gossiping';
        genFile = false;
        Data = StartCrawl(site,genFile);
    case 1
        % �ϥΪ̿�J���d�ߪ��O
        if isa(site,'string')
            site = char(site);
        end
        genFile = false;
        chkClass(site,genFile)
        Data = StartCrawl(site,genFile);
    case 2
        % �ϥΪ̿�J���d�ߪ��O�èM�w�O�_��X�ɮ�
        if isa(site,'string')
            site = char(site);
        end
        chkClass(site,genFile);
        Data = StartCrawl(site,genFile);
end

elapsedTime = toc
end

%% Nested Function �[�c
% PTT ���������D�{��
function Data = StartCrawl(site,genFile)

opt = weboptions('KeyName','cookie','KeyValue','over18=1'); %�K�����ݭn�~������
url = ['https://www.ptt.cc/bbs/',site,'/index.html'];

% �ϥ� try-catch �ӧ�h�����s�u�i��o�ͪ����~�A�ô��ѨϥΪ̿��~�T��
try
    Ptt_raw = webread(url,opt);
catch status
    if strcmp(status.identifier,'MATLAB:webservices:UnknownHost')
        error('���ˬd�����s�u')
    elseif strcmp(status.identifier,'MATLAB:webservices:Timeout')
        error('�s�u�ɶ��L��')
    else
        error('�������~')
    end
end

Data = cleanData;    % Output

if genFile
    writetable(Data,'PTT�������G.csv')
end

% �N�D���c�ʪ����θ�ƾ�z�� table �榡
    function Data = cleanData
        % �q html �ɯ¤�r���^����T
        Title = regexp(Ptt_raw,'<?div class="title">.*?</div>?','match')';    % �峹���D
        Date = regexp(Ptt_raw,'<?div class="date">.*?</div>?','match')';    % �o����
        Author = regexp(Ptt_raw,'<?div class="author">.*?</div>?','match')';    % �o��̱b��
        Reply = regexp(Ptt_raw,'<?div class="nrec">.*?</div>?','match')';    % �^�мƶq
        structTable = [Reply,Date,Author,Title];
        
        % ���� HTML Tags
        % ===== Text Analytics Toolbox Required ======
        cleanData = string(cellfun(@eraseTags,structTable,'UniformOutput',0)); % eraseTags: �R����������
        % ============================================
        
        % If Text Analytics Toolbox Not Installed, Use This Line instead 
        % ============================================
        %         cleanData = string(cellfun(@(x)regexprep(x,'(<.*?>)',''),structTable,'UniformOutput',0));
        % ============================================
        cleanData = regexprep(cleanData,'(\n|\t|\r| )','');
        
        Data = array2table(cleanData,'VariableNames',{'Reply','Date','Author','Title'});
        Data.Reply = str2double(Data.Reply);
        Data.Date = datetime(Data.Date,'InputFormat','MM/dd','Format','yyyy�~MM��dd��');
        Data.Author = categorical(Data.Author);
    end
end

%% SubFunction �[�c
% �ˬd�ϥΪ̿�J���ܼƫ��A�O�_���T
function chkClass(title,genFile)
chktitle = isa(title,'char');
chkgenFile = isa(genFile,'logical');
if ~chktitle|~chkgenFile
    error('��J�榡���~')
end
end



