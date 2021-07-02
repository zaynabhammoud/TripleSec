#' design tree
#'
#'design tree is a function used to calculate the cutoff values for low-risk and high risk groups.
#'The values correspond to the risk-threshold values given by the user, pHigh and pLow.
#'
#'
#' @param inputData input data given from the user ;used to be y
#' @param inputParam input parameters, given by user,
#' amount of (min. 2)/names should remain open, to allow user to define them themselves, dependent on availability
#' and need; used to be X (f.ex. support for MS instead of AD etc.)
#' @param seq sequence
#' @param pHigh risk-threshold p_high, user defined, needed to calculate the cutoff value; used to be alpha.left
#' @param pLow risk-threshold p_low, user defined, needed to calculate the cutoff value; used to be alpha.right
#' @param minNum minimum number of parameters and therefore runs?
#' @param repeats amount of repeats, how often the algorithm runs through ??
#'
#' @return fit, table with the prediction for the patients
#' @export
#'
#' @examples
design.tree <-
  function(inputData,
           inputParam,
           seq = c(1, 2, 3),
           pHigh,
           pLow,
           minNum = 5,
           repeats = 100) {
    paramCount <- ncol(inputParam) #count of features
    caseCount <- nrow(inputData) #count of cases

    inputParam <- cbind( #creats a table with  column for each input parameter, an ID, class, marker and rows for each patient
      inputParam,
      marker = rep(0, caseCount),
      class = rep(NA, caseCount),
      ID = 1:caseCount
    )

    #start heare after going through designTree_loop_test

    node <- 1 #create variable node with value 1

    cutoff <- matrix(nrow = length(seq), ncol = 7) #create matrix cutoff
    amountCaseCount <- caseCount #just extra, to save the time of switching variable names

    ii = 1
    l <- length(seq)

    reduce <- 1

    effective = TRUE

    right = NA
    left = NA

    while (ii <= l & ((amountCaseCount > 0) & (reduce))) { #while ii < length(seq) and Case amount > 0 and reduce = 1
      j = seq[ii]
      print(j)
#columns p_tau or adasCog
      if (j == 1 | j == 4) {
        order1 <- inputParam[, j]
        order1 <- order1[order(inputParam[, j])] #standart min -> max

        order2 <- order(inputData0[,2])
        ID <- inputParam$ID[order(inputParam[, j])]

        order.left <- NULL #cutoff high
        order.right <- NULL #cutoff low

        for (i in 1:amountCaseCount) {
          order.right[i] <- sum(order2[i:amountCaseCount]) / (amountCaseCount - i + 1) # cutLow

          order.left[i] <- 1 - sum(order2[1:i]) / i #cutHigh

        }

        print(as.data.frame(order.left))

        print(sum(order.left >= pHigh, na.rm = TRUE))

        if (sum(order.left >= pHigh, na.rm = TRUE) != 0) { #logical list, choosing the ones which are true
          print("in order.left >= pHigh")
          left = 0

          for (k in 1:amountCaseCount) {
            if (order.left[k] >= pHigh) {
              left = k
            }
          }
          if ((left != amountCaseCount) & (left != 1)) {
            while (order1[left + 1] == order1[left]) {
              left = left - 1
            }
          }
          node <- node + 1

          a <- 1:left

          if (length(a) >= minNum) {
            inputParam$marker[ID[1:left]] <- node

            inputParam$class[ID[1:left]] <- 0

            #cutoff[ii,3]<-0.01;
            cutoff[ii, 2] <- order1[left]

            cutoff[ii, 4] <- length(a)

          }
        } else{
          node <- node + 1
        }

        print(sum(order.right >= pLow, na.rm = TRUE))
        if (sum(order.right >= pLow, na.rm = TRUE) != 0) {
          print("in order.right >= pLow")
          right = 0

          for (k in amountCaseCount:1) {
            if (order.right[k] >= pLow) {
              right = k
            }
          }
          if ((right != 1) & (right != amountCaseCount)) {
            while (order1[right - 1] == order1[right]) {
              right = right + 1
            }
          }
          node <- node + 1

          b <- (right:amountCaseCount)

          if (length(b) >= minNum) {
            inputParam$marker[ID[right:amountCaseCount]] <- node

            inputParam$class[ID[right:amountCaseCount]] <- 1

            #cutoff[ii,6]<-0.01;
            cutoff[ii, 5] <- order1[right]

            cutoff[ii, 7] <- length(b)

          }
        } else{
          node <- node + 1
        }

        # Check if two tails overlap
        if (length(intersect(ID[1:left], ID[right:amountCaseCount])) > 0) {
          #cross join, zwei Variablen werden zsm geführt, basierend darauf, ob die Spalten ähnlich sind
          effective = FALSE
        }

      } else{
        order1 <- inputParamCopy[, j][order(inputParamCopy[, j])]

        order2 <- inputData0[order(inputParamCopy[, j])]

        ID <- inputParamCopy$ID[order(inputParamCopy[, j])]

        order.left <- NULL
        order.right <- NULL

        for (i in 1:amountCaseCount) {
          order.right[i] <-
            1 - sum(order2[i:amountCaseCount]) / (amountCaseCount - i + 1)

          order.left[i] <- sum(order2[1:i]) / i

        }
        if (sum(order.right >= pLow, na.rm = TRUE) != 0) {
          right = 0

          for (k in amountCaseCount:1) {
            if (order.right[k] >= pLow) {
              right = k
            }
          }
          if ((right != 1) & (right != amountCaseCount)) {
            while (order1[right - 1] == order1[right]) {
              right = right + 1
            }
          }
          node <- node + 1

          a <- right:amountCaseCount

          if (length(a) >= minNum) {
            inputParam$marker[ID[right:amountCaseCount]] <- node

            inputParam$class[ID[right:amountCaseCount]] <- 0

            #cutoff[ii,3]<-0.01;
            cutoff[ii, 2] <- order1[right]

            cutoff[ii, 4] <- length(a)

          }
        } else{
          node <- node + 1
        }
        if (sum(order.left >= pHigh, na.rm = TRUE) != 0) {
          left = 0

          for (k in 1:amountCaseCount) {
            if (order.left[k] >= pHigh) {
              left = k
            }
          }
          if ((left != amountCaseCount) & (left != 1)) {
            while (order1[left + 1] == order1[left]) {
              left = left - 1
            }
          }
          node <- node + 1

          b <- 1:left

          if (length(b) >= minNum) {
            inputParam$marker[ID[1:left]] <- node

            inputParam$class[ID[1:left]] <- 1

            #cutoff[ii,6]<-0.01;
            cutoff[ii, 5] <- order1[left]

            cutoff[ii, 7] <- length(b)

          }
        } else{
          node <- node + 1
        }

        # Check if two tails overlap, cut off overlap
        if ((sum(order.left >= pHigh, na.rm = TRUE) != 0) &
            (sum(order.right >= pLow, na.rm = TRUE) != 0)) {
          if (length(intersect(ID[1:left], ID[right:amountCaseCount])) > 0) {
            effective = FALSE
          }
        }
      }
      inputParamCopy <- subset(inputParam, marker == 0)
      amountCaseCount <- nrow(inputParamCopy)

      inputData0 <- inputData[inputParam$marker == 0]
      ii <- ii + 1

      if (length(inputData0) == 0) {
        reduce = 0
      }
      cat(j, "\n")
    } # end of the while
    result <- subset(inputParam, marker == 0)
    count <- nrow(result)

    cutoff[, 1] <- seq

    colnames(cutoff) <-
      c("label",
        "l.cutoff",
        "l.P-value",
        "l.count",
        "r.cutoff",
        "r.P-value",
        "r.count")

    fit <- NULL

    fit$count <- count

    fit$cutoff <- cutoff

    fit$effective = effective
    return(fit)

  }
