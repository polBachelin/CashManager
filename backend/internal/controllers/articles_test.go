package controllers

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGetArticles(t *testing.T) {
	r := setupRouter()

	r.GET("/articles", GetAllArticles)
	req, _ := http.NewRequest("GET", "/articles", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)
}
