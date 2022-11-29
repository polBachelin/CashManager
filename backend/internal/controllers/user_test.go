package controllers

import (
	"bytes"
	"cash/backend/internal/database"
	"cash/backend/internal/middleware"
	service "cash/backend/internal/services"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func setupSuite(t testing.TB) func(tb testing.TB) {
	log.Println("Setup suite...")

	database.DropDatabase()

	return func(tb testing.TB) {
		database.DropDatabase()
	}
}

func setupRouter() *gin.Engine {
	r := gin.Default()
	r.POST("/", CreateUser)
	r.POST("/auth", AuthenticateUser)

	return r
}

type UserInfo struct {
	Email    string  `json:"email"`
	Password string  `json:"password"`
	Balance  float64 `json:"balance"`
}

var NoUserToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzN2I5NjQzM2NmOGRjZDg1NjBhY2M2YiJ9.8CeJEPbJGm4LPHl2WAc-zbYUpwySAqg2q5HSnjDQRDM"
var WrongIDToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNhY2EifQ.cr2CYwId5DxZtlcXpY6MIptJ7zzDiqnTwpKGciPlTH4"

func createAndAuthUser(r *gin.Engine, email string, password string, balance float64) string {
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

func TestCreate(t *testing.T) {
	teardownSuite := setupSuite(t)
	defer teardownSuite(t)

	r := setupRouter()

	bodies := []struct {
		name     string
		info     UserInfo
		expected int
	}{
		{"Create User", UserInfo{Email: "test@example.com", Password: "1234567890", Balance: 100.00}, http.StatusOK},
		{"Empty password", UserInfo{Email: "test@example.com", Password: "", Balance: 100.00}, http.StatusBadRequest},
		{"Fail email", UserInfo{Email: "tesom", Password: "12357890", Balance: 100.00}, http.StatusBadRequest},
		{"Same email", UserInfo{Email: "test@example.com", Password: "12357890", Balance: 100.00}, http.StatusBadRequest},
	}

	for _, tc := range bodies {
		t.Run(tc.name, func(t *testing.T) {
			j, _ := json.Marshal(tc.info)
			req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
			req.Header.Set("Content-Type", "application/json")
			w := httptest.NewRecorder()
			r.ServeHTTP(w, req)
			assert.Equal(t, tc.expected, w.Code)
		})
	}
	t.Run("Fail bind", func(t *testing.T) {
		body := "cool"
		j, _ := json.Marshal(body)
		req, _ := http.NewRequest("POST", "/", bytes.NewBuffer(j))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}

func TestDelete(t *testing.T) {
	teardownSuite := setupSuite(t)
	defer teardownSuite(t)

	r := setupRouter()
	r.DELETE("/delete", middleware.AuthRequired(), DeleteUser)

	t.Run("Delete user", func(t *testing.T) {
		token := createAndAuthUser(r, "delete@example.com", "1234567890", 100.00)
		req, _ := http.NewRequest("DELETE", "/delete", nil)
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	})
	t.Run("No bind", func(t *testing.T) {
		req, _ := http.NewRequest("DELETE", "/delete", nil)
		req.Header.Set("Authorization", NoUserToken)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}

func TestAuth(t *testing.T) {
	teardownSuite := setupSuite(t)
	defer teardownSuite(t)

	r := setupRouter()

	t.Run("Fail bind", func(t *testing.T) {
		body := "cool"
		j, _ := json.Marshal(body)
		req, _ := http.NewRequest("POST", "/auth", bytes.NewBuffer(j))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
	t.Run("Auth user", func(t *testing.T) {
		token := createAndAuthUser(r, "auth@example.com", "1234567890", 100.00)
		assert.NotEqual(t, token, "")
	})
	t.Run("No User", func(t *testing.T) {
		body, _ := json.Marshal(map[string]string{"email": "nousercool@gmail.com", "password": "1234567890"})
		req, _ := http.NewRequest("POST", "/auth", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)

		assert.Equal(t, http.StatusInternalServerError, w.Code)
	})
	t.Run("Wrong pass", func(t *testing.T) {
		createAndAuthUser(r, "pol.bachelin@gmail.com", "1234567890", 100.00)
		body, _ := json.Marshal(map[string]string{"email": "pol.bachelin@gmail.com", "password": "12"})
		req, _ := http.NewRequest("POST", "/auth", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}

type Token struct {
	Token string `json:"token"`
}

func TestBalance(t *testing.T) {
	teardownSuite := setupSuite(t)
	defer teardownSuite(t)

	r := setupRouter()
	r.Use(middleware.AuthRequired())
	r.GET("/balance", GetUserBalance)

	t.Run("Get balance", func(t *testing.T) {
		token := createAndAuthUser(r, "balance@example.com", "1234567890", 100.00)

		newReq, _ := http.NewRequest("GET", "/balance", nil)
		newReq.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, newReq)
		assert.Equal(t, http.StatusOK, w.Code)
	})
	t.Run("No User", func(t *testing.T) {
		newReq, _ := http.NewRequest("GET", "/balance", nil)
		newReq.Header.Set("Authorization", NoUserToken)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, newReq)

		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
	t.Run("Wrong id", func(t *testing.T) {
		newReq, _ := http.NewRequest("GET", "/balance", nil)
		newReq.Header.Set("Authorization", WrongIDToken)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, newReq)

		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}

func TestGet(t *testing.T) {
	teardownSuite := setupSuite(t)
	defer teardownSuite(t)

	r := setupRouter()
	r.Use(middleware.AuthRequired())
	r.GET("/user", GetUser)

	t.Run("Get user", func(t *testing.T) {
		token := createAndAuthUser(r, "get@example.com", "1234567890", 100.00)
		newReq, _ := http.NewRequest("GET", "/user", nil)
		newReq.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, newReq)
		assert.Equal(t, http.StatusOK, w.Code)
	})
	t.Run("No user", func(t *testing.T) {
		newReq, _ := http.NewRequest("GET", "/user", nil)
		newReq.Header.Set("Authorization", NoUserToken)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, newReq)

		assert.Equal(t, http.StatusOK, w.Code)
	})
}

func TestPut(t *testing.T) {
	teardownSuite := setupSuite(t)
	defer teardownSuite(t)

	r := setupRouter()
	r.PUT("/put", middleware.AuthRequired(), PutUser)

	t.Run("Put user", func(t *testing.T) {
		token := createAndAuthUser(r, "put@example.com", "1234567890", 100.00)
		body := UserInfo{Email: "new@example.com", Password: "1234567890", Balance: 100.00}
		j, _ := json.Marshal(body)
		req, _ := http.NewRequest("PUT", "/put", bytes.NewBuffer(j))
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	})
	t.Run("Fail bind", func(t *testing.T) {
		token := createAndAuthUser(r, "put1@example.com", "1234567890", 100.00)
		b := "cool"
		j, _ := json.Marshal(b)
		req, _ := http.NewRequest("PUT", "/put", bytes.NewBuffer(j))
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}

func TestCart(t *testing.T) {
	teardownSuite := setupSuite(t)
	defer teardownSuite(t)

	r := setupRouter()
	r.GET("/cart", middleware.AuthRequired(), GetUserCart)

	t.Run("Get cart", func(t *testing.T) {
		token := createAndAuthUser(r, "cart@example.com", "1234567890", 100.00)
		req, _ := http.NewRequest("GET", "/cart", nil)
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	})
	t.Run("Wrong id", func(t *testing.T) {
		req, _ := http.NewRequest("GET", "/cart", nil)
		req.Header.Set("Authorization", NoUserToken)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}
