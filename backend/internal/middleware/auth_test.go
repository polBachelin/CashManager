package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.Use(AuthRequired())
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusNoContent, "")
	})
	return r
}

func TestAuthMiddlewareNoHeader(t *testing.T) {
	r := setupRouter()

	req, _ := http.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusUnauthorized, w.Code)
}

func TestAuthMiddlewareToken(t *testing.T) {
	r := setupRouter()

	req, _ := http.NewRequest("GET", "/", nil)
	req.Header.Set("Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzN2I0NGUyMmQ0OTZhMzIzNzAxNDZkZiJ9.ysOX0H8RLtYV8eKCnfYt1SXGukE-DUoSnXqfDWKYdvU")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNoContent, w.Code)
}

func TestAuthMiddlewareTokenInvalid(t *testing.T) {
	r := setupRouter()

	req, _ := http.NewRequest("GET", "/", nil)
	req.Header.Set("Authorization", "Bearer eyJhbGciOiJIUzI1N.eyJpZCI6IjYzN2I0NGUyMmQ0OTZhMzIzNzAxNDZkZiJ9.jUraRdhccCXAMAKXgNY0U8HJ6y58Kww2TeULOn1PjrU")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusUnauthorized, w.Code)
}

func TestAuthMiddlewareNoToken(t *testing.T) {
	r := setupRouter()

	req, _ := http.NewRequest("GET", "/", nil)
	req.Header.Set("Authorization", "Bearer")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusUnauthorized, w.Code)
}
