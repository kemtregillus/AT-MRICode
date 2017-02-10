 function [s,k,k2,k3]=counter(g,points)
% Function counter.m
% Creates a counterbalanced sequence of 'g' different trial types
% and 'points' trials.
% usage:  counter(g,points) or [s,k,k2,k3]=counter(g,points)
%         e.g. a = counter(3,60)
%         This will generate a list of 60 items
%              (3 trial types, 20 items per trial type)
%
% s is the counterbalanced sequence of 'points' trials
% k is a vector of the number of each trial type
% k2 is a 2-dimensional matrix of the number of 2-trial combinations
% k3 is a 3-dimensional matrix of the number of 3-trial combinations
%
% different from counter4 in that g=2 sequences have added randomness


R=5;            % R: added randomness for g=2 sequences (R=1 Random, R>1 Less Random)

                % R can only take on positive integer values

f=1;            % a flag to do the while loop at least once

k=zeros(g);
k2=zeros(g,g);         % because they need to exist before we clear them.
k3=zeros(g,g,g);
k4=zeros(g,g,g,g);

% Loop until best possible counter-balanced sequence. Necessary because
% of the stochatic nature of the routine.

% while(((max(max(k2))-min(min(k2)))>1)|((max(k)-min(k))>1)|f==1);
%while(((max(max(k2))-min(min(k2)))>1)|((max(k)-min(k))>1)|((max(max(max(k3)))-min(min(min(k3))))>1)|f==1);

while(((max(max(k2))-min(min(k2)))>1)|((max(k)-min(k))>1)|((max(max(max(k3)))-min(min(min(k3))))>1)|(max(max(max(max(k4))))-min(min(min(min(k4)))))>1|f==1);


% Choose the first 'while' statement for quickest execution
   % Choose the second 'while' statement for a better counterbalanced
%     sequence but longer execution.
   % Chosse the third 'while' statement for the best, but be warned, it
%    might take a while, a long while.

   clear s k k2 k3 k4 j;
   f=0;


   k=zeros(1,g);
   k2=zeros(g,g);
   k3=zeros(g,g,g);
   k4=zeros(g,g,g,g);

   s(1)=rem(round(rand*10000),g)+1;     %Pick 1st 2 points at random
   s(2)=rem(round(rand*10000),g)+1;
   i=2;

   k(s(1))=k(s(1))+1;k(s(2))=k(s(2))+1;
   k2(s(i-1),s(i))=k2(s(i-1),s(i))+1;   %increment combo counter


   [min2,ind]=min(k2(s(i),:));          % Find the minimum 2-trial combo beginning with s(i)

   same2=find(k2(s(i),:)==min2);        % Check is that minimum is unique
   if length(same2)==1                  % If unique, pick it.
      s(i+1)=ind;                       % ind is the indice of the minimum.
   else
      s(i+1)=same2(rem(round(rand*10000),length(same2))+1);  % If not unique, pick it at random.

   end

   k(s(i+1))=k(s(i+1))+1;
   k2(s(i),s(i+1))=k2(s(i),s(i+1))+1;                   % increment combo counters

   k3(s(i),s(i+1),s(i-1))=k3(s(i),s(i+1),s(i-1))+1;


% The main Loop...

   for i=3:points-1
      [min2,ind]=min(k2(s(i),:));               % same set of statements as above 2-trial type sequences.

      same2=find(k2(s(i),:)==min2);
      if rem(i,R) == 0 & g==2                   % Added 'randomness' for

         s(i+1)=rem(round(rand*10000), g)+1;    % Sequences converge to a periodic signal w/o it.

      elseif length(same2)==1
         s(i+1)=ind;
      else                                              % If not unique, look at 3-trial combos

         [min3,ind]=min(k3(s(i),same2,s(i-1)));         % Find minimum 3-trial combo s(i-1),s(i),same2

         same3=find(k3(s(i),same2,s(i-1))==min3);       % Check if that minimum is unique

            if length(same3)==1                         % If unique, pick it
               s(i+1)=same2(ind);                       % confusing dereferencing...but correct

            else                                                % If not, look at 4-trial combos

               [min4,ind]=min(k4(s(i),same3,s(i-1),s(i-2)));    
%Min[s(i-2),s(i-1),s(i),same3]
               same4=find(k4(s(i),same3,s(i-1),s(i-2))==min4);  % Unique or not
               if length(same4)==1
                  s(i+1)=same2(same3(ind));                     % more dereferencing...

               else                                             % Pick at Random if not unique


s(i+1)=same2(same3(same4(rem(round(rand*10000),length(same4))+1)));

               end
            end
      end

      k(s(i+1))=k(s(i+1))+1;
      k2(s(i),s(i+1))=k2(s(i),s(i+1))+1;
      k3(s(i),s(i+1),s(i-1))=k3(s(i),s(i+1),s(i-1))+1;
      k4(s(i),s(i+1),s(i-1),s(i-2))=k4(s(i),s(i+1),s(i-1),s(i-2))+1;
   end;
   k2;
end;

Combo_Matrix=k2






