nw=$1
cores=6
factor=`echo "scale=0; $nw/$cores" | bc -l`
reminder=`echo "scale=0; $nw - $factor*$cores" | bc -l`
echo $factor $reminder
