design.tree<-function(y,X,seq=c(1,2,3),alpha.left,alpha.right,min.num=5, R = 100){
	p<-ncol(X);n<-nrow(X);
	X<-cbind(X,marker=rep(0,n),class=rep(NA,n),ID=1:n);
	node<-1;
	cutoff<-matrix(nrow=length(seq),ncol=7);
	XX<-X;n.j<-nrow(XX);
	yy<-y[X$marker==0]
	ii=1;l<-length(seq);
	go.deep<-1;
	Effective = TRUE
	
	while(ii<=l & ((n.j>0)&(go.deep))){
		j=seq[ii];	
		if(j==1 | j == 4){
			order1<-XX[,j][order(XX[,j])];
			order2<-yy[order(XX[,j])];
			ID<-XX$ID[order(XX[,j])];
			order.left<-NULL;order.right<-NULL;
			for(i in 1:n.j){
				order.right[i]<-sum(order2[i:n.j])/(n.j-i+1);
				order.left[i]<-1-sum(order2[1:i])/i;
			}
			if(sum(order.left>=alpha.left, na.rm = TRUE)!=0){				
				left=0;
				for(k in 1:n.j){
					if(order.left[k]>=alpha.left){left=k;}
				}
				if((left != n.j)&(left != 1)){
					while(order1[left + 1] == order1[left]){
						left = left - 1
					}
				}
				node<-node+1;
				a<-1:left;
				if(length(a) >= min.num){
					X$marker[ID[1:left]]<-node;
					X$class[ID[1:left]]<-0;
					#cutoff[ii,3]<-0.01;	
					cutoff[ii,2]<-order1[left];
					cutoff[ii,4]<-length(a);
				}
			}else{node<-node+1;}			
			if(sum(order.right>=alpha.right, na.rm = TRUE)!=0){
				right=0;
				for(k in n.j:1){
					if(order.right[k]>=alpha.right){right=k;}
				}
				if((right != 1)&(right != n.j)){
					while(order1[right - 1] == order1[right]){
						right = right + 1
					}
				}
				node<-node+1;
				b<-(right:n.j);
				if(length(b) >= min.num){
					X$marker[ID[right:n.j]]<-node;
					X$class[ID[right:n.j]]<-1;
					#cutoff[ii,6]<-0.01;
					cutoff[ii,5]<-order1[right];
					cutoff[ii,7]<-length(b);
				}
			}else{node<-node+1;}
			
			# Check if two tails overlap
			if( length(intersect(ID[1:left], ID[right:n.j]))>0){
				Effective = FALSE
			}
			
		}else{
			order1<-XX[,j][order(XX[,j])];
			order2<-yy[order(XX[,j])];
			ID<-XX$ID[order(XX[,j])];
			order.left<-NULL;order.right<-NULL;
			for(i in 1:n.j){
				order.right[i]<-1-sum(order2[i:n.j])/(n.j-i+1);
				order.left[i]<-sum(order2[1:i])/i;
			}
			if(sum(order.right>=alpha.right, na.rm = TRUE)!=0){				
				right=0;
				for(k in n.j:1){
					if(order.right[k]>=alpha.right){right=k;}
				}
				if((right != 1)&(right != n.j)){
					while(order1[right - 1] == order1[right]){
						right = right + 1
					}
				}
				node<-node+1;
				a<-right:n.j;
				if(length(a) >= min.num){
					X$marker[ID[right:n.j]]<-node;
					X$class[ID[right:n.j]]<-0;
					#cutoff[ii,3]<-0.01;
					cutoff[ii,2]<-order1[right];
					cutoff[ii,4]<-length(a);
				}				
			}else{node<-node+1;}				
			if(sum(order.left>=alpha.left, na.rm = TRUE)!=0){
				left=0;
				for(k in 1:n.j){
					if(order.left[k]>=alpha.left){left=k;}
				}
				if((left != n.j)&(left != 1)){
					while(order1[left + 1] == order1[left]){
						left = left - 1
					}
				}
				node<-node+1;			
				b<-1:left;
				if(length(b) >= min.num){
					X$marker[ID[1:left]]<-node;
					X$class[ID[1:left]]<-1;
					#cutoff[ii,6]<-0.01;
					cutoff[ii,5]<- order1[left];	
					cutoff[ii,7]<-length(b);
				}
			}else{node<-node+1;}

			# Check if two tails overlap
			if((sum(order.left>=alpha.left, na.rm = TRUE)!=0)&(sum(order.right>=alpha.right, na.rm = TRUE)!=0)){
				if( length(intersect(ID[1:left], ID[right:n.j]))>0){
					Effective = FALSE
				}
			}
		}
		XX<-subset(X,marker==0);n.j<-nrow(XX);
		yy<-y[X$marker==0]
		ii<-ii+1;
		if(length(yy) == 0){
			go.deep = 0
		}
		cat(j, "\n")
	}
	result<-subset(X,marker==0);count<-nrow(result);
	cutoff[,1]<-seq;
	colnames(cutoff)<-c("label","l.cutoff","l.P-value","l.count","r.cutoff","r.P-value","r.count");
	fit<-NULL;
	fit$count<-count;
	fit$cutoff<-cutoff;
	fit$Effective = Effective
	return(fit);
}


predict.tree<-function(final.tree,y.new,X.new){
	tree<-as.matrix(final.tree);
	n<-nrow(X.new);	
	class<-rep(100,n);
		l<-nrow(tree);
		for(i in 1:n){
			flag<-0;t=1;
			while(t<=l & flag==0){
				if(tree[t,1]==1){
					if((!is.na(tree[t,2]))){if(X.new[i,1]<=tree[t,2]){class[i]=0;flag=1;}};
					if((!is.na(tree[t,5]))){if(X.new[i,1]>=tree[t,5]){class[i]=1;flag=1;}};
				}
				if(tree[t,1]==2){
					if((!is.na(tree[t,2]))){if(X.new[i,2]>=tree[t,2]){class[i]=0;flag=1;}};
					if((!is.na(tree[t,5]))){if(X.new[i,2]<=tree[t,5]){class[i]=1;flag=1;}};
				}
				if(tree[t,1]==3){
					if((!is.na(tree[t,2]))){if(X.new[i,3]>=tree[t,2]){class[i]=0;flag=1;}};
					if((!is.na(tree[t,5]))){if(X.new[i,3]<=tree[t,5]){class[i]=1;flag=1;}};
				}
				if(tree[t,1]==4){
					if((!is.na(tree[t,2]))){if(X.new[i,4]<=tree[t,2]){class[i]=0;flag=1;}};
					if((!is.na(tree[t,5]))){if(X.new[i,4]>=tree[t,5]){class[i]=1;flag=1;}};
				}
				t<-t+1;
			}   
		}
	result<-cbind(y.new,class);
	return(result);
}

CV.one.prune.tree<-function(y,X,seq,alpha.left,alpha.right){
	n<-length(y);
	data<-data.frame(y,X,ID=1:n);
	result<-NULL;
	Effective = TRUE;
	for(k in 1:n){
		data.train<-as.data.frame(data[-k,]);data.test<-data[k,];
		y<-data.train$y;
		X<-data.frame(p_tau=data.train$p_tau,FDG_PET=data.train$FDG_PET,Hippo=data.train$Hippo,ADAScog=data.train$ADAScog);
		y.test<-data.test$y;
		X.test<-data.frame(p_tau=data.test$p_tau,FDG_PET=data.test$FDG_PET,Hippo=data.test$Hippo,ADAScog=data.test$ADAScog);
		model<-design.tree(y, X, seq, alpha.left=alpha.left, alpha.right=alpha.right);
		if(!(model$Effective)){
			Effective = FALSE;
		}
		#print(model)
		result<-rbind(result,as.matrix(predict.tree(model$cutoff,y.test,X.test)));
		cat("CV ",k, "with low risk", alpha.left, " Finished","\n");
	}
	fit<-NULL;
	fit$result<-result;
	fit$accuracy<-sum(result[,1]==result[,2])/(n-sum(result[,2]==100));	
	fit$Effective = Effective
	return(fit)
}







