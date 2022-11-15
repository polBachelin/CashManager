package database

import (
	"context"
	"log"
	"os"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var dbHost = getSpecify("DB_HOST", "0.0.0.0")
var dbPort = getSpecify("DB_PORT", "27017")
var dbUsername = getSpecify("DB_USERNAME", "root")
var dbPass = getSpecify("DB_PASSWORD", "pass12345")
var uri = "mongodb://" + dbUsername + ":" + dbPass + "@" + dbHost + ":" + dbPort
var client *mongo.Client = nil

func getSpecify(vars string, defaultVal string) string {
	tmp := os.Getenv(vars)

	if len(tmp) == 0 {
		return defaultVal
	}
	return tmp
}

func GetDatabaseConnection() *mongo.Client {
	if client != nil {
		return client
	}
	clientOptions := options.Client().ApplyURI(uri)

	client, err := mongo.Connect(context.TODO(), clientOptions)

	if err != nil {
		log.Fatal(err)
	}

	err = client.Ping(context.TODO(), nil)

	if err != nil {
		log.Fatal(err)
	}

	return client
}

type ErrDatabase string

func (e ErrDatabase) Error() string {
	return "Invalid Database output -> " + string(e)
}
