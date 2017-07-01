#!/usr/bin/env bash
echo "Test 0"
./example1.sh && {
	echo "should have failed"
}
echo "Test 1"
./example1.sh --module && {
	echo "should have failed"
}
echo "Test 2"
./example1.sh --module 'tttt' || {
	echo "should have passed"
}
echo "Test 3"
./example1.sh  --module 'tttt' -i 'tttt' && {
	echo "should have failed"
}

echo "Test 4"
./example1.sh  --module 'tttt' -t && {
	echo "should have failed"
}

echo "Test 5"
./example1.sh  --module 'tttt' -t -s || {
	echo "should have passed"
}

echo "Test 6"
./example2.sh  -i 'test' && {
	echo "should have failed"
}


