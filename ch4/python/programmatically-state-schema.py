"""programmatically-state-schema.py"""

#### IMPORTS
from pyspark import SparkContext
from pyspark.sql import SQLContext

#### CONSTANTS
inputFile = "/Users/amcasari/repos/triumph-book/ch4/README.md"

####
sqlContext = SQLContext(sc)

textFile = sc.textFile(inputFile)

textFile.count()