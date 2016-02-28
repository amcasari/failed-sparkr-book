Sys.setenv(SPARK_HOME="/Users/deborahsiegel/software/spark-1.6.0-bin-hadoop2.4")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-example")
sqlContext <- sparkRSQL.init(sc)
hiveContext <- sparkRHive.init(sc)

#library(help="SparkR")
head(iris)
#local glm
glm(Species ~ Sepal.Width, binomial, iris)


diris <- createDataFrame(sqlContext, iris) 
model <- glm(Species ~ Sepal_Width, data = diris, family = "binomial") #same error with gaussian
#Error in invokeJava(isStatic = TRUE, className, methodName, ...) : 
#  java.lang.IllegalArgumentException: Unsupported type for label: StringType
#at org.apache.spark.ml.feature.RFormulaModel.transformLabel(RFormula.scala:185)
#turns out yea the label cant be a string, doesn't matter if its binomial or gaussian
#apparently labels have to be numeric or boolean not a string
#.. although I thought mllib transformed them to 0/1... not if they are strings?
printSchema(diris)

#this works bc response var is numeric
model <- glm(Sepal_Length ~ Sepal_Width + Species, data = diris, family = "gaussian")
summary(model)
#######

###find a way to convert the strings to numeric labels for species
registerTempTable(diris, 'dt')
head(sql(sqlContext, "SHOW tables"))
sql(sqlContext, "SELECT Species, Sepal_Length FROM diristable WHERE Species similar to 'setosa' FROM dt")
sql(sqlContext, "SELECT Species, Sepal_Length IF(Species LIKE 'setosa', 0, 1) AS numlabel FROM diristable")  

sql(sqlContext, "SELECT *, IF (Species LIKE 'setosa', 0, 1) AS numlabel FROM dt")  %>% showDF()

newiris <- sql(sqlContext, "SELECT *, IF (Species LIKE 'setosa', 0,1) AS numlabel FROM dt")
showDF(newiris)

sql(hiveContext, "SELECT *, IF (Species LIKE 'setosa' THEN 0) ELSE IF (Species LIKE 'virginica' THEN 1) ELSE 2 END IF AS numlabel FROM dt")

val df4 = sql(""" select *, case when color = 'green' then 1 else 0 end as Green_ind from data """)
sql(hiveContext, "SELECT *, case when Species = 'setosa' then 0 else if (Species = 'virginica') else 2 end AS numlabel FROM dt") %>% showDF()

sql(sqlContext, "SELECT *, case when Species = 'setosa' then 0 else if Species = 'virginica' then 1 else 2 end as numlabel FROM dt") %>% showDF()
sql(sqlContext, "SELECT *, case when Species = 'setosa' then 0 else 2 end as numlabel FROM dt") %>% showDF()

#nothing works for 3 cases yet.. only 2. 
#we need udfs for this
#val deptUdf = udf[String,String]( dept =>
##                                    dept match {
#                                      case "EDept1" => "IT"
#                                      case "EDept2" => "ComSc"
#                                      case _ => "Other"})
