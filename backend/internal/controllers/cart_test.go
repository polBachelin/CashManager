package controllers

import (
	"bytes"
	"cash/backend/internal/middleware"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestAdd(t *testing.T) {
	r := setupRouter()

	r.POST("/cart/articles/add", middleware.AuthRequired(), AddArticle)

	token := createAndAuthUser(r, "pol.bachelin@gmail.com", "1234567890", 100.00)
	t.Run("Add article", func(t *testing.T) {
		body, _ := json.Marshal(ArticleJSON{Name: "nime free run", Price: 100.00, Image: "https://cdn.sportsshoes.com/product/N/NIK19385/NIK19385_1000_1.jpg"})
		req, _ := http.NewRequest("POST", "/cart/articles/add", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	})
	t.Run("Wrong user", func(t *testing.T) {
		req, _ := http.NewRequest("POST", "/cart/articles/add", nil)
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", WrongIDToken)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
	t.Run("Fail bind", func(t *testing.T) {
		body := "cool"
		j, _ := json.Marshal(body)
		req, _ := http.NewRequest("POST", "/cart/articles/add", bytes.NewBuffer(j))
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}

func TestRemove(t *testing.T) {
	r := setupRouter()

	var path = "/cart/articles/remove"

	r.POST(path, middleware.AuthRequired(), RemoveArticle)

	token := createAndAuthUser(r, "pol.bachelin@gmail.com", "1234567890", 100.00)
	t.Run("Remove article", func(t *testing.T) {
		body, _ := json.Marshal(ArticleJSON{Name: "nime free run", Price: 100.00, Image: "https://cdn.sportsshoes.com/product/N/NIK19385/NIK19385_1000_1.jpg"})
		req, _ := http.NewRequest("POST", "/cart/articles/add", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		req, _ = http.NewRequest("POST", path, bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "Bearer "+token)
		w = httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	})
	t.Run("Remove artilce not found", func(t *testing.T) {
		body, _ := json.Marshal(ArticleJSON{Name: "non existant shoe", Price: 100.00, Image: "https://cdn.sportsshoes.com/product/N/NIK19385/NIK19385_1000_1.jpg"})
		req, _ := http.NewRequest("POST", path, bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)

	})
	t.Run("Wrong user", func(t *testing.T) {
		req, _ := http.NewRequest("POST", path, nil)
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", WrongIDToken)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
	t.Run("Fail bind", func(t *testing.T) {
		body := "cool"
		j, _ := json.Marshal(body)
		req, _ := http.NewRequest("POST", path, bytes.NewBuffer(j))
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}
