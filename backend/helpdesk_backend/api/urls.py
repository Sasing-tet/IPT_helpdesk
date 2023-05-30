from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('reports/', views.ReportView.getReports),
    path('reports/create/', views.ReportView.createReport),
    path('reports/<str:pk>/update/', views.ReportView.updateReport),
    path('reports/<str:pk>/delete/', views.ReportView.deleteReport),
    path('reports/<str:pk>/', views.ReportView.getReport),
    path('categories/', views.getCategories),
    path('categories/create/', views.createCategory),
    path('comments/', views.CommentView.getComments),
    path('comments/create/', views.CommentView.createComment),
    path('replies/', views.ReplyView.getReplies),
    path('replies/create/', views.ReplyView.createReply),
    path('users/', views.UserView.getUsers),
    path('users/<str:pk>/', views.UserView.getUser),
    path('login/', views.UserView.getLogin),
    path('register/', views.UserView.register),
    
]