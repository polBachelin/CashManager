package controllers

import (
	"bytes"
	"cash/backend/internal/middleware"
	service "cash/backend/internal/services"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func setupRouter() *gin.Engine {
	r := gin.Default()

	return r
}

type UserInfo struct {
	Email    string  `json:"email"`
	Password string  `json:"password"`
	Balance  float64 `json:"balance"`
}

var NoUserToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzN2I5NjQzM2NmOGRjZDg1NjBhY2M2YiIsImV4cCI6MTY2OTEzMDE4M30.WldZw8GP9xDwgZ6KeK9YyjsAgld62_K9yUtPhVvjrfo"

func createAndAuthUser(r *gin.Engine, email string, password string, balance float64) string {
	r.POST("/auth", AuthenticateUser)
	r.POST("/", CreateUser)

	body := UserInfo{Email: email, Password: password, Balance: balance}
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	req, _ = http.NewRequest("POST", "/auth", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w = httptest.NewRecorder()
	r.ServeHTTP(w, req)

	token := &Token{}
	err := json.NewDecoder(w.Body).Decode(token)
	if err != nil {
		fmt.Println("Error decoding token:", err)
		return ""
	}
	return token.Token
}

func deleteCreatedUserFromID(body *bytes.Buffer) {
	id := &ID{}
	_ = json.NewDecoder(body).Decode(id)
	svc := service.NewUserService()
	prim, _ := primitive.ObjectIDFromHex(id.InsertedID)
	svc.DeleteUser(prim)
}

type ID struct {
	InsertedID string `json:"InsertedID"`
}

func TestCreateUser(t *testing.T) {
	r := setupRouter()

	r.POST("/", CreateUser)
	body := UserInfo{Email: "test@example.com", Password: "1234567890", Balance: 100.00}
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	t.Cleanup(func() {
		deleteCreatedUserFromID(w.Body)
	})
	assert.Equal(t, http.StatusOK, w.Code)
}
func TestCreateFailBind(t *testing.T) {
	r := setupRouter()

	r.POST("/", CreateUser)
	body := "cool"
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestCreateFailUserPassword(t *testing.T) {
	r := setupRouter()

	r.POST("/", CreateUser)
	body := UserInfo{Email: "test@example.com", Password: "", Balance: 100.00}
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	t.Cleanup(func() {
		deleteCreatedUserFromID(w.Body)
	})
	assert.Equal(t, http.StatusBadRequest, w.Code)
}
func TestCreateFailUserEmail(t *testing.T) {
	r := setupRouter()

	r.POST("/", CreateUser)
	body := UserInfo{Email: "tesom", Password: "12357890", Balance: 100.00}
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestCreateFailSameEmail(t *testing.T) {
	r := setupRouter()

	r.POST("/", CreateUser)
	body := UserInfo{Email: "same@gmail.com", Password: "12357890", Balance: 100.00}
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	t.Cleanup(func() {
		deleteCreatedUserFromID(w.Body)
	})
	body = UserInfo{Email: "same@gmail.com", Password: "12357890", Balance: 100.00}
	j, _ = json.Marshal(body)
	req, _ = http.NewRequest("POST", "/", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	newW := httptest.NewRecorder()

	assert.Equal(t, http.StatusBadRequest, newW.Code)
}

func TestDeleteUser(t *testing.T) {
	r := setupRouter()

	r.DELETE("/delete", middleware.AuthRequired(), DeleteUser)

	token := createAndAuthUser(r, "delete@example.com", "1234567890", 100.00)
	req, _ := http.NewRequest("DELETE", "/delete", nil)
	req.Header.Set("Authorization", "Bearer "+token)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestDeleteUserNoBind(t *testing.T) {
	r := setupRouter()

	r.DELETE("/delete", DeleteUser)
	req, _ := http.NewRequest("DELETE", "/delete", nil)
	req.Header.Set("Authorization", NoUserToken)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestAuthUserFailBind(t *testing.T) {
	r := setupRouter()

	r.POST("/auth", AuthenticateUser)
	body := "cool"
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("POST", "/auth", bytes.NewBuffer(j))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestAuthUser(t *testing.T) {
	r := setupRouter()

	token := createAndAuthUser(r, "auth@example.com", "1234567890", 100.00)
	assert.NotEqual(t, token, "")
}

func TestAuthUserNoUser(t *testing.T) {
	r := setupRouter()

	r.POST("/auth", AuthenticateUser)
	body, _ := json.Marshal(map[string]string{"email": "nousercool@gmail.com", "password": "1234567890"})
	req, _ := http.NewRequest("POST", "/auth", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
}

func TestAuthUserWrongPass(t *testing.T) {
	r := setupRouter()

	r.POST("/auth", AuthenticateUser)
	body, _ := json.Marshal(map[string]string{"email": "pol.bachelin@gmail.com", "password": "wrong"})
	req, _ := http.NewRequest("POST", "/auth", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

type Token struct {
	Token string `json:"token"`
}

func TestGetUserBalance(t *testing.T) {
	r := setupRouter()

	r.Use(middleware.AuthRequired())
	r.GET("/balance", GetUserBalance)

	token := createAndAuthUser(r, "balance@example.com", "1234567890", 100.00)

	newReq, _ := http.NewRequest("GET", "/balance", nil)
	newReq.Header.Set("Authorization", "Bearer "+token)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, newReq)

	responseData, _ := ioutil.ReadAll(w.Body)
	fmt.Println("Body ", responseData)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestGetUserBalanceNoUser(t *testing.T) {
	r := setupRouter()

	r.Use(middleware.AuthRequired())
	r.GET("/balance", GetUserBalance)

	newReq, _ := http.NewRequest("GET", "/balance", nil)
	newReq.Header.Set("Authorization", NoUserToken)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, newReq)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

// func TestGetUserBalanceUserWrongID(t *testing.T) {
// 	r := setupRouter()

// 	r.Use(middleware.AuthRequired())
// 	r.GET("/balance", GetUserBalance)

// 	newReq, _ := http.NewRequest("GET", "/balance", nil)
// 	newReq.Header.Set("Authorization", NoUserToken)
// 	w := httptest.NewRecorder()
// 	r.ServeHTTP(w, newReq)

// 	assert.Equal(t, http.StatusBadRequest, w.Code)
// }

func TestGetUser(t *testing.T) {
	r := setupRouter()

	r.Use(middleware.AuthRequired())
	r.GET("/user", GetUser)

	token := createAndAuthUser(r, "get@example.com", "1234567890", 100.00)
	newReq, _ := http.NewRequest("GET", "/user", nil)
	newReq.Header.Set("Authorization", "Bearer "+token)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, newReq)

	resData, _ := ioutil.ReadAll(w.Body)
	fmt.Println("Body get: ", resData)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestGetUserNoUser(t *testing.T) {
	r := setupRouter()

	r.Use(middleware.AuthRequired())
	r.GET("/user", GetUser)

	newReq, _ := http.NewRequest("GET", "/user", nil)
	newReq.Header.Set("Authorization", NoUserToken)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, newReq)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestPutUser(t *testing.T) {
	r := setupRouter()

	r.PUT("/put", middleware.AuthRequired(), PutUser)

	token := createAndAuthUser(r, "put@example.com", "1234567890", 100.00)
	body := UserInfo{Email: "new@example.com", Password: "1234567890", Balance: 100.00}
	j, _ := json.Marshal(body)
	req, _ := http.NewRequest("PUT", "/put", bytes.NewBuffer(j))
	req.Header.Set("Authorization", "Bearer "+token)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestPutUserFailBind(t *testing.T) {
	r := setupRouter()

	r.PUT("/put", middleware.AuthRequired(), PutUser)

	token := createAndAuthUser(r, "put1@example.com", "1234567890", 100.00)
	b := "cool"
	j, _ := json.Marshal(b)
	req, _ := http.NewRequest("PUT", "/put", bytes.NewBuffer(j))
	req.Header.Set("Authorization", "Bearer "+token)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestGetUserCart(t *testing.T) {
	r := setupRouter()

	r.GET("/cart", middleware.AuthRequired(), GetUserCart)

	token := createAndAuthUser(r, "cart@example.com", "1234567890", 100.00)
	req, _ := http.NewRequest("GET", "/cart", nil)
	req.Header.Set("Authorization", "Bearer "+token)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}
