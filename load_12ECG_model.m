function model = load_12ECG_model()
        % can be changed as desired
        filename='finalized_model.mat';
        A=load(filename);
        model=A.model;

end


