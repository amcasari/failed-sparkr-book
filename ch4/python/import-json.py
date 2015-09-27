"""import-json.py"""

#### IMPORTS
from pyspark import SparkContext
from pyspark.sql import SQLContext

#### CONSTANTS
inputJSON = "/Users/amcasari/repos/triumph-book/ch4/README.md"

####
sqlContext = SQLContext(sc)

JSONdf = sqlContext.read.json(inputJSON)

JSONdf.show()