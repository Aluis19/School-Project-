clc
clear
close all
warning off

load fisheriris                                                            % We use  a default iris dataset from matlab

                                                                           % accuracy_matrix its our final matrix that contain the final results
accuracy_matrix = zeros(100,8);

for k=1:8                                                                  % a set of k = [1 2 3 4 5 6 7 8] its put it in this for loop
    for n=1:100                                                            % for loop of 100 iterations for each k

        [random_data_x_y, labels] = datasample(meas(:,1:2),150);           % datasample its a function from matlab that gives you a random ordered values from a dataset, 
                                                                           % we choose the first and the second column to randomize our data
                                                                           % the new two random columns are in random_data_x_y and 
                                                                           % labels are the changing value position from the new random data corresponding to original data
                                                                           
        index_labels = labels;                                             % we correlate the new random labels using 'labels' the new labels corresponding to the original data
        index_labels(index_labels<51) = 1;
        index_labels(index_labels<101 & index_labels>50) = 2;
        index_labels(index_labels>100) = 3;
       
        training_data_x = random_data_x_y(1:105,1);                        % we choose the first 105 values of column 1 corresponding to the 70% of the data to training the algorithm
        training_data_y = random_data_x_y(1:105,2);                        % we choose the first 105 values of column 2 corresponding to the 70% of the data to training the algorithm
        training_labels = index_labels(1,1:105);                           % we choose the first 105 values of index_values corresponding to the 70% of the data to training the algorithm
        test_data_x = random_data_x_y(106:150,1);                          % we choose the last 45 values of column 1 corresponding to the 30% of the data to test the algorithm
        test_data_y = random_data_x_y(106:150,2);                          % we choose the last 45 values of column 2 corresponding to the 30% of the data to test the algorithm
        test_labels = index_labels(1,106:150);                             % we choose the last 45 values of index_labels corresponding to the 30% of the data to test the algorithm
       
        order_predict_labels = zeros(105,45);                              % a matrix 105x45 its created to almacenate the predict labels
        distance = zeros(105,45);                                          % a matrix 105x45 its created to almacenate the distance values
       
                                                                           %this is the algorithm for the distance, each distance between test and training data its almacenated in distance matrix
        for i=1:45
            for j=1:105
                 distance(j,i) = sqrt( (training_data_x(j)-test_data_x(i) )^2 + (training_data_y(j)-test_data_y(i) )^2 );
            end
        end
       
        [order_distance, dis_label] = sort(distance);                         % sort function give us the matrix distance ordered to min to max value and also give us a dis_label matrix which its the position of new values corresponding to before ordered 
       
        for i=1:45                                                            % as we order our distances, the labels corresponding to each point have changed, this pair of loops correlate the new labels corresponding to the labels position before ordered 
            for j=1:105
                order_predict_labels(j,i) = training_labels(:,dis_label(j,i));
            end
        end
       
        k_labels = order_predict_labels(1:k,:);                               % we select the closer distances coresponding to k
       
        [predicted_label] = mode(k_labels);                                   % with mode function we take the most repetitive label of each iteration
                                                                              % accuracy formula
        accuracy_matrix(n,k) = sum(test_labels == predicted_label)/length(test_labels);
        accuracy_matrix(n,k) = accuracy_matrix(n,k) * 100;                    % 
        avg_acc = mean(accuracy_matrix);
        S = std(accuracy_matrix);
        
    end
end                                                                           %ploting accuracy for each K value

errorbar(avg_acc, S, 's', 'MarkerSize', 10, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red');
 title('Average Accuracy vs Standard Deviation for all K');
 xlabel('K Values');
 ylabel('Average Accuracy (%)');
 
