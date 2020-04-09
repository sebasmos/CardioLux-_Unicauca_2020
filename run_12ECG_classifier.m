function [score, label] = run_12ECG_classifier(data,header_data,classes, model,k)

    num_classes = length(classes);

    label = zeros([1,num_classes]);
    score = ones([1,num_classes]);
    features = get_12ECG_features_v2(data,header_data);
    score = mnrval(model,features);		
    [~,idx] = max (score);
    label(idx)=1;
end
