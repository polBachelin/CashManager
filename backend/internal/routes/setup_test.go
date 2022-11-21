package routes

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()
	Setup(r)
	return r
}

func TestHomepageHandler(t *testing.T) {
	mockResponse := "\"Output 204\""
	r := SetupRouter()

	req, _ := http.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	responseData, _ := ioutil.ReadAll(w.Body)
	assert.Equal(t, mockResponse, string(responseData))
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestAuthMiddlewareNoHeader(t *testing.T) {
	r := SetupRouter()

	req, _ := http.NewRequest("GET", "/user/balance", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusUnauthorized, w.Code)
}

func TestAuthMiddlewareToken(t *testing.T) {
	r := SetupRouter()

	req, _ := http.NewRequest("GET", "/user/balance", nil)
	req.Header.Set("Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzN2I0NGUyMmQ0OTZhMzIzNzAxNDZkZiIsImV4cCI6MTY2OTExMDIzMH0.Y_rJCURW0LEIkUaQvVyTWt29CGJ-fYhmQq6Hv8KGiiE")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestAuthMiddlewareTokenInvalid(t *testing.T) {
	r := SetupRouter()

	req, _ := http.NewRequest("GET", "/user/balance", nil)
	req.Header.Set("Authorization", "Bearer eyJhbGcJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzN2I0NGUyMmQ0OTZhMzIzNzAxNDZkZiIsImV4cCI6MTY2OTExMDIzMH0.Y_rJCURW0LEIkUaQvVyTWt29CGJ-fYhmQq6Hv8KGiiE")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestAuthMiddlewareNoToken(t *testing.T) {
	r := SetupRouter()

	req, _ := http.NewRequest("GET", "/user/balance", nil)
	req.Header.Set("Authorization", "Bearer")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}
