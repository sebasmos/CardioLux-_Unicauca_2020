function [recording,Total_time,num_leads,Fs,gain,age_data,sex_data,dx_value]=extract_data_from_header(header_data);

	tmp_hea = strsplit(header_data{1},' ');
	recording = tmp_hea{1};
	num_leads = str2num(tmp_hea{2});
    Fs = str2num(tmp_hea{3});
	Total_time = str2num(tmp_hea{4})/Fs;
        gain = zeros(1,num_leads);
	for ii=1:num_leads
	        tmp_hea = strsplit(header_data{ii+1},' ');
                tmp_gain=strsplit(tmp_hea{3},'/');
                gain(ii)=str2num(tmp_gain{1});
    end
        for tline = 1:length(header_data)
                if startsWith(header_data{tline},'#Age')
			tmp = strsplit(header_data{tline},': ');
			age_data = str2num(tmp{2});
                elseif startsWith(header_data{tline},'#Dx')
                    dx = strsplit(header_data{tline},': ');
                    if  strcmp(dx{2},'AF')
                        dx_value = 1;
                    elseif strcmp(dx{2},'I-AVB')
                        dx_value = 2;
                    elseif strcmp(dx{2},'LBBB')
                        dx_value = 3;
                    elseif strcmp(dx{2},'Normal')
                        dx_value = 4;
                    elseif strcmp(dx{2},'PAC')
                        dx_value = 5;
                    elseif strcmp(dx{2},'PVC')
                        dx_value = 6;
                    elseif strcmp(dx{2},'RBBB')
                        dx_value = 7;
                    elseif strcmp(dx{2},'STD')
                        dx_value = 8;
                    else
                        dx_value = 9;
                    end            
                elseif startsWith(header_data{tline},'#Sex')
			tmp = strsplit(header_data{tline},': ');
			if strcmp(tmp{2},'Female')
				sex_data = 1;
			else
				sex_data = 0;
			end
		end
	end


end
