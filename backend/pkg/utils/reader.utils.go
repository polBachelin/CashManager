package utils

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"strings"
)

func BodyToString(body io.ReadCloser) string {
	r, err := ioutil.ReadAll(body)
	if err != nil {
		log.Println("Could not read body: ", err)
	}
	sb := string(r)
	return sb
}

func PrintBody(body io.ReadCloser) {
	log.Println(BodyToString(body))
}

func BodyToJson(body io.ReadCloser, v interface{}) {
	dec := json.NewDecoder(strings.NewReader(BodyToString(body)))
	_, err := dec.Token()
	if err != nil {
		log.Println("Error getting json token: ", err)
	}
	for dec.More() {
		err := dec.Decode(&v)
		if err != nil {
			log.Fatal(err)
		}
	}
}

func StringToJson[T any](body string) ([]T, error) {
	var jsonRes []T
	var v T
	dec := json.NewDecoder(strings.NewReader(body))
	_, err := dec.Token()
	if err != nil {
		log.Println("Error getting json token: ", err)
	}
	for dec.More() {
		newV := v
		err := dec.Decode(&newV)
		if err != nil {
			log.Println(err)
			return nil, fmt.Errorf("Error decoding json")
		}
		jsonRes = append(jsonRes, newV)
	}
	return jsonRes, nil
}
