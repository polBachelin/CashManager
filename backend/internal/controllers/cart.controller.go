package controllers

import (
	"cash/backend/internal/models"
	service "cash/backend/internal/services"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type ArticleJSON struct {
	Name  string  `json:"name"`
	Price float64 `json:"price"`
	Image string  `json:"image"`
}

func AddArticle(c *gin.Context) {
	userID := getUserPrimitiveFromContext(c)
	userSvc := service.NewUserService()
	user, err := userSvc.GetUser(userID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "User not found")
	}
	var article ArticleJSON
	errorBind := c.BindJSON(&article)
	if errorBind != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "Bad request")
	}
	svc := service.NewCartService()
	cart, _ := svc.GetCart(user.Cart)
	var articleObj models.Article
	articleID := primitive.NewObjectID()
	articleObj.ID = articleID
	articleObj.Name = article.Name
	articleObj.Price = article.Price
	cart.Articles = append(cart.Articles, articleObj)
	cart.Total = cart.Total + article.Price
	res, erro := svc.UpdateCart(cart)
	if erro != nil {
		log.Println(erro)
		c.AbortWithStatusJSON(http.StatusInternalServerError, "Could not update cart")
	}
	c.JSON(http.StatusOK, res)
}

func RemoveArticle(c *gin.Context) {
	userID := getUserPrimitiveFromContext(c)
	userSvc := service.NewUserService()
	user, err := userSvc.GetUser(userID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "User not found")
	}
	var article ArticleJSON
	errorBind := c.BindJSON(&article)
	if errorBind != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "Bad request")
	}
	svc := service.NewCartService()
	cart, _ := svc.GetCart(user.Cart)
	for i, art := range cart.Articles {
		if article.Name == art.Name {
			cart.Articles[i] = cart.Articles[len(cart.Articles)-1]
			cart.Articles = cart.Articles[:len(cart.Articles)-1]
			res, erro := svc.UpdateCart(cart)
			if erro != nil {
				log.Println(erro)
				c.AbortWithStatusJSON(http.StatusInternalServerError, "Could not update cart")
			}
			c.JSON(http.StatusOK, res)
			return
		}
	}
	c.JSON(http.StatusBadRequest, "Could not find article in cart")
}
