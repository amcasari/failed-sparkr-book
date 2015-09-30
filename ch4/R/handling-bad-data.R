# Ref: https://databricks.gitbooks.io/databricks-spark-knowledge-base/content/best_practices/dealing_with_bad_data.html

library(SparkR)
sc <- sparkR.init(master="local[2]",appName="handling-bad-data")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()