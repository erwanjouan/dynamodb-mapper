TABLE_NAME:=student
ENDPOINT_URL:=http://localhost:8000
JSON_ITEM:='{ "studentId": "1", "firstName": "Shan", "lastName": "Shanjeevan" }'

start:
	java -Djava.library.path=./db/DynamoDBLocal_lib -jar ./db/DynamoDBLocal.jar -sharedDb &

list-tables:
	aws dynamodb list-tables \
		--endpoint-url $(ENDPOINT_URL)

create-table:
	# Creates a table with composite primary key
	# 	Artist is the hash key, all items with the same Artist will be assigned to the same partition
	# 	SongTitle is the range key, items will be sorted on SongTitle after their creation
	# with Provisioned Capacity Mode with only 1 WriteCapacityUnits and 1 ReadCapacityUnits
	aws dynamodb create-table \
    	--table-name $(TABLE_NAME) \
    	--attribute-definitions \
			AttributeName=Artist,AttributeType=S \
			AttributeName=SongTitle,AttributeType=S \
    	--key-schema \
			AttributeName=Artist,KeyType=HASH \
			AttributeName=SongTitle,KeyType=RANGE \
    	--provisioned-throughput \
			ReadCapacityUnits=1,WriteCapacityUnits=1 \
	--endpoint-url $(ENDPOINT_URL)

create-table-json:
	aws dynamodb create-table --cli-input-json file://createTable.json \
		--endpoint-url $(ENDPOINT_URL)

put:
	read -p "Artist:" ARTIST_INPUT && \
	read -p "SongTitle:" SONG_TITLE && \
	read -p "AlbumTitle:" ALBUM_TITLE && \
	JSON_ENTRY=$$(printf $(JSON_ITEM) "$${ARTIST_INPUT}" "$${SONG_TITLE}" "$${ALBUM_TITLE}") && \
	aws dynamodb put-item \
		--table-name $(TABLE_NAME) \
		--item "$${JSON_ENTRY}" \
		--return-consumed-capacity TOTAL \
		--endpoint-url $(ENDPOINT_URL)

delete-table:
	aws dynamodb delete-table \
		--table-name $(TABLE_NAME) \
		--endpoint-url $(ENDPOINT_URL)

describe-table:
	aws dynamodb describe-table \
		--table-name $(TABLE_NAME) \
		--endpoint-url $(ENDPOINT_URL)

get-items:
	aws dynamodb scan \
    	--table-name $(TABLE_NAME) \
		--endpoint-url $(ENDPOINT_URL)

filter:
	aws dynamodb scan \
	    --table-name $(TABLE_NAME) \
    	--filter-expression "Artist = :name" \
    	--expression-attribute-values '{":name":{"S":"Acme Band"}}' \
		--endpoint-url $(ENDPOINT_URL)

get-item-to-be-refined:
	# Passes the keys the request, 
	# consistent-read is optional
	aws dynamodb get-item \
    	--table-name $(TABLE_NAME) \
    	--key '{ "Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Call Me Today"} }' \
    	--consistent-read \
		--endpoint-url $(ENDPOINT_URL)
