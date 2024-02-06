#!/bin/bash

export $(grep -v '^#' .env | xargs -d '\n')

cd ../models
diesel setup --database-url $DATABASE_URL
diesel migration run --database-url $DATABASE_URL