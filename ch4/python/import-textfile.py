"""import-textfile.py"""

#### IMPORTS
from pyspark import SparkContext
from pyspark.sql import SQLContext

#### CONSTANTS
inputFile = "/Users/amcasari/repos/triumph-book/ch4/README.md"

####
sqlContext = SQLContext(sc)

textdf = sc.textFile(inputFile)

textdf.show()