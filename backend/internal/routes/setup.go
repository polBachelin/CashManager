package routes

import (
	"cash/backend/internal/controllers"
	"cash/backend/internal/middleware"

	"github.com/gin-gonic/gin"
)

func Output204(c *gin.Context) {
	c.JSON(200, "Output 204")
}

func Setup(r *gin.Engine) {

	auth := r.Group("/")
	auth.Use(middleware.AuthRequired())
	{
		auth.DELETE("/user", controllers.DeleteUser)
		auth.PUT("/user", controllers.PutUser)
		auth.GET("/user/balance", controllers.GetUserBalance)
		auth.GET("/user/cart", controllers.GetUserCart)
		auth.GET("/user/payment", controllers.UserPayment)
		auth.POST("/cart/articles/add", controllers.AddArticle)
		auth.POST("/cart/articles/remove", controllers.RemoveArticle)
	}
	r.GET("/", Output204)
	r.GET("/user", controllers.GetUser)
	r.POST("/user", controllers.CreateUser)
	r.POST("/auth", controllers.AuthenticateUser)
	r.GET("/articles", controllers.GetAllArticles)
}
