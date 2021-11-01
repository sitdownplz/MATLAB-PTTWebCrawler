%% PTT 爬蟲練習
function Data = PTTCrawler(site,genFile)

% 此練習程式碼用於爬取PTT版上文章資訊，文本分析工具箱的需求單純用來移除html tag
% 若是使用這不具備文本分析工具箱，可用一般文字處理手法移除
% Requirement: Text Analytics Toolbox

tic; % 使用 tic-toc 計算程式運行爬取時間
narginchk(0,3) % 檢查使用者輸入的變數數量是否符合
switch nargin
    case 0
        % 使用者沒有任何輸入，預設查詢八卦版
        site  = 'Gossiping';
        genFile = false;
        Data = StartCrawl(site,genFile);
    case 1
        % 使用者輸入欲查詢的板
        if isa(site,'string')
            site = char(site);
        end
        genFile = false;
        chkClass(site,genFile)
        Data = StartCrawl(site,genFile);
    case 2
        % 使用者輸入欲查詢的板並決定是否輸出檔案
        if isa(site,'string')
            site = char(site);
        end
        chkClass(site,genFile);
        Data = StartCrawl(site,genFile);
end

elapsedTime = toc
end

%% Nested Function 架構
% PTT 頁面爬取主程式
function Data = StartCrawl(site,genFile)

opt = weboptions('KeyName','cookie','KeyValue','over18=1'); %八卦版需要年齡驗證
url = ['https://www.ptt.cc/bbs/',site,'/index.html'];

% 使用 try-catch 來抓去網路連線可能發生的錯誤，並提供使用者錯誤訊息
try
    Ptt_raw = webread(url,opt);
catch status
    if strcmp(status.identifier,'MATLAB:webservices:UnknownHost')
        error('請檢查網路連線')
    elseif strcmp(status.identifier,'MATLAB:webservices:Timeout')
        error('連線時間過長')
    else
        error('未知錯誤')
    end
end

Data = cleanData;    % Output

if genFile
    writetable(Data,'PTT爬取結果.csv')
end

% 將非結構性的爬蟲資料整理成 table 格式
    function Data = cleanData
        % 從 html 檔純文字中擷取資訊
        Title = regexp(Ptt_raw,'<?div class="title">.*?</div>?','match')';    % 文章標題
        Date = regexp(Ptt_raw,'<?div class="date">.*?</div>?','match')';    % 發表日期
        Author = regexp(Ptt_raw,'<?div class="author">.*?</div>?','match')';    % 發文者帳號
        Reply = regexp(Ptt_raw,'<?div class="nrec">.*?</div>?','match')';    % 回覆數量
        structTable = [Reply,Date,Author,Title];
        
        % ===== Text Analytics Toolbox Required ======
        cleanData = string(cellfun(@eraseTags,structTable,'UniformOutput',0)); % eraseTags: 刪除網頁標籤
        cleanData = regexprep(cleanData,'(\n|\t|\r| )','');
        
        Data = array2table(cleanData,'VariableNames',{'Reply','Date','Author','Title'});
        Data.Reply = str2double(Data.Reply);
        Data.Date = datetime(Data.Date,'InputFormat','MM/dd','Format','yyyy年MM月dd日');
        Data.Author = categorical(Data.Author);
    end
end

%% SubFunction 架構
% 檢查使用者輸入的變數型態是否正確
function chkClass(title,genFile)
chktitle = isa(title,'char');
chkgenFile = isa(genFile,'logical');
if ~chktitle|~chkgenFile
    error('輸入格式錯誤')
end
end



