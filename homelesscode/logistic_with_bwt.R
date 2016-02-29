#uses MASS:birthwt -- Risk Factors Associated with Low Infant Birth Weight
#low -- indicator of birth weight less than 2.5 kg.
#age -- mother's age in years.
#lwt -- mother's weight in pounds at last menstrual period.
#race -- mother's race (1 = white, 2 = black, 3 = other).
#smoke -- smoking status during pregnancy.
#ptl -- number of previous premature labours.
#ht -- history of hypertension.
#ui -- presence of uterine irritability.
#ftv -- number of physician visits during the first trimester.
#bwt -- birth weight in grams.

#all the columns are numeric
head(birthwt)

Sys.setenv(SPARK_HOME="/Users/deborahsiegel/software/spark-1.6.0-bin-hadoop2.4")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-example")
sqlContext <- sparkRSQL.init(sc)
library("MASS", pos = 100) #something in MASS was masking a sparkR function so we load the namespace at a higher position
??birthwt
bwt <- with(birthwt, {
  race <- factor(race, labels = c("white", "black", "other"))
  ptd <- factor(ptl > 0)
  ftv <- factor(ftv)
  levels(ftv)[-(1:2)] <- "2+"
  data.frame(low = factor(low), age, lwt, race, smoke = (smoke > 0),
             ptd, ht = (ht > 0), ui = (ui > 0), ftv)
})
head(bwt)


#options(contrasts = c("contr.treatment", "contr.poly"))
glm(low ~ ., binomial, bwt)

#########
dbwt<- createDataFrame(sqlContext, birthwt) 
printSchema(dbwt)
head(dbwt)

#newdata <- dbwt[,c("age","lwt")]
#head(newdata)
#newdf <- select(dbwt,dbwt[[1]])

explain(dbwt)

glm(smoke ~ bwt, binomial, birthwt)
#Coefficients:
#  (Intercept)          bwt  
#1.1664293   -0.0005513  

mylogisticmodel <- glm(smoke ~ bwt, data = dbwt, family = "binomial")
summary(mylogisticmodel)
#$coefficients
#Estimate
#(Intercept)  1.1664284800
#bwt         -0.0005512802

predictions <- predict(mylogisticmodel, newData = dbwt) #adds a features column and a predicted label column. 
#rename the label column and figure out the features column
head(predictions)
#########


#options(contrasts = c("contr.treatment", "contr.poly"))
glm(low ~ ., binomial, bwt)
#works but has the one-hot coded features


glm(low ~ ., binomial,birthwt) #algorithm glm.fit does not converge, fitted probs 0 or 1 occurred. 
#Coefficients:
#  (Intercept)          age          lwt         race        smoke          ptl           ht  
#1161.4913       0.3223      -0.1733       0.6494     -17.4594     126.7066      36.3620  
#ui          ftv          bwt  
#-61.8269      -8.9249      -0.4466  


model <- glm(low ~ ., data = dbwt, family = "binomial")
summary(model)

#works with spark 1.6.0 because features are added to model summary
#$coefficients
#Estimate
#(Intercept) 1482.8093325
#age           -5.7833683
#lwt            0.4534653
#race          29.0005248
#smoke         66.1652868
#ptl           45.3774288
#ht            87.3317482
#ui           -43.8416966
#ftv           25.3710217
#bwt           -0.6061093

#15/09/03 12:52:27 ERROR RBackendHandler: getModelFeatures on org.apache.spark.ml.api.r.SparkRWrappers failed
#Error in invokeJava(isStatic = TRUE, className, methodName, ...) : 
#  java.lang.UnsupportedOperationException: No features names available for LogisticRegressionModel


predictions <- predict(model, newData = dbwt)
#head(predictions)
#explain(predictions)
head(select(predictions, c("label","prediction")),1000)

### a guassian model###
model_gauss <- glm( bwt ~ smoke, data = dbwt, family = "gaussian")
predictions2 <- predict(model_gauss, newData = dbwt)
head(select(predictions2, c("label","prediction")),1000)
summary(model_gauss)
plot (birthwt$smoke, birthwt$birthwt, main="Birth Weight by Mother's Smoking Habit", ylab = "Birth Weight (g)", xlab="Mother Smokes")
