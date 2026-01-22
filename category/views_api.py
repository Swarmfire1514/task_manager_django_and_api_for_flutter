from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from category.models import Category
from rest_framework import status
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .serializers import CategorySerializer
from rest_framework.pagination import PageNumberPagination

def isAdmin(user):
    return hasattr(user, "profile") and user.profile.role == "admin"

def getCategorybyID(user, id):
    if isAdmin(user):
        return get_object_or_404(Category, id=id)
    else:
        return get_object_or_404(Category, id=id, user=user) 

class CategoryListCreateAPI(APIView):
    permisssion_class = [IsAuthenticated]
    
    def get(self,request):
        if isAdmin(request.user):
            categories = Category.objects.all()
        else:
            categories = Category.objects.filter(user=request.user)
            
        paginator = PageNumberPagination()
        paginator.page_size=10
        result_page = paginator.paginate_queryset(categories, request)
        
        serializer = CategorySerializer(result_page, many = True)
        return paginator.get_paginated_response(serializer.data)
    
    def post(self,request):
        serializer = CategorySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class CategoryDetailAPI(APIView):
    permission_classes = [IsAuthenticated]
    
    def put(self,request,id):
        category = getCategorybyID(request.user, id)
        serializer = CategorySerializer(category, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self,request,id):
        category = getCategorybyID(request.user, id)
        category.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)