package database

import (
	"cash/backend/pkg/utils"
	"context"
	"log"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var dbHost = utils.GetEnvVar("DB_HOST", "0.0.0.0")
var dbPort = utils.GetEnvVar("DB_PORT", "27017")
var dbUsername = utils.GetEnvVar("DB_USERNAME", "root")
var dbPass = utils.GetEnvVar("DB_PASSWORD", "pass12345")
var uri = "mongodb://" + dbUsername + ":" + dbPass + "@" + dbHost + ":" + dbPort
var client *mongo.Client = nil

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
