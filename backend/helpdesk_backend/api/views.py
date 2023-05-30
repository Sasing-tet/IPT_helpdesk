from django.http import JsonResponse
from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import CategorySerializer, ReportSerializer, CommentSerializer, ReplySerializer, UserSerializer
from .models import Category, Report, Comment, Reply, User
from rest_framework import viewsets
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from rest_framework.permissions import IsAuthenticated

# Create your views here.
#from helpdesk import models
#from .serializers import HelpdeskSerializer


@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint': '/reports/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of reports'
        },
        {
            'Endpoint': '/reports/repId/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single report object'
        },
        {
            'Endpoint': '/reports/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'creates a new report'
        },
        {
            'Endpoint': '/reports/repId/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'updates existing report'
        },
        {
            'Endpoint': '/reports/repId/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'deletes an existing report'
        },
    ]
    return Response(routes)

class ReportView(viewsets.ModelViewSet):
    @api_view(['GET'])
    def getReports(request):
        reports = Report.objects.all()
        serializer = ReportSerializer(reports, many=True)
        return Response(serializer.data)

    @api_view(['GET'])
    def getReport(request, pk):
        report = Report.objects.get(repId=pk)
        serializer = ReportSerializer(report, many=False)
        return Response(serializer.data)

    @api_view(['POST'])
    def createReport(request):
        data = request.data
        category_id = data['catId']
        user_id = data['userId']
        category = Category.objects.filter(pk=category_id).first()
        user = User.objects.get(pk=user_id)
        report = Report.objects.create(
            repId=data['repId'],
            title=data['title'],
            description=data['description'],
            created = data['created'],
            userId=user,
            catId=category
        )
        serializer = ReportSerializer(report, many=False)
        return Response(serializer.data)
    
    @api_view(['PUT'])
    def updateReport(request, pk):
        data = request.data

        report = Report.objects.get(repId=pk)
        serializer = ReportSerializer(report, data=request.POST)
        if serializer.is_valid():
            serializer.save()

        return Response(serializer.data)

    @api_view(['DELETE'])
    def deleteReport(request, pk):
        report = Report.objects.get(repId=pk)
        report.delete()
        return Response('Report was deleted!')




@api_view(['GET'])
def getCategories(request):
    categories = Category.objects.all()
    serializer = CategorySerializer(categories, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def createCategory(request):
    data = request.data
    user_id = data['userId']
    user = User.objects.get(pk=user_id)
    category = Category.objects.create(
        catId = data['catId'],
        categoryName=data['categoryName'],
        userId=user,
    )
    serializer = CategorySerializer(category, many=False)
    return Response(serializer.data)


class CommentView(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer

    @api_view(['GET'])
    def getComments(request):
        comments = Comment.objects.all()
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)

    @api_view(['POST'])
    def createComment(request):
        data = request.data
        repId = data['repId']
        user_id = data['userId']
        report = Report.objects.get(pk=repId)
        user = User.objects.get(pk=user_id)
        comment = Comment.objects.create(
            commentId=data['commentId'],
            content=data['content'],
            showReply=data['showReply'],
            created = data['created'],
            userId=user,
            repId=report
        )
        serializer = CommentSerializer(comment)
        return Response(serializer.data)
    
    @api_view(['PUT'])
    def updateComment(request, pk):
        data = request.data
        comment = Comment.objects.get(id=pk)
        serializer = CommentSerializer(comment, data=request.POST)
        if serializer.is_valid():
            serializer.save()

        return Response(serializer.data)

    @api_view(['DELETE'])
    def deleteComment(request, pk):
        comment = Comment.objects.get(id=pk)
        comment.delete()
        return Response('Report was deleted!')

"""    
    @api_view(['PUT'])
    def updateShowReply(request, pk):
        try:
            comment = Comment.objects.get(pk=pk)
        except Comment.DoesNotExist:
            return Response(status=404)

        comment_data = request.data
        reply_status = comment_data.get('showReply')
        if reply_status is not None:
            comment.showReply = reply_status

        serializer = CommentSerializer(comment, data=comment_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
"""    
    
class ReplyView(viewsets.ModelViewSet):
    queryset = Reply.objects.all()
    serializer_class = ReplySerializer

    @api_view(['GET'])
    def getReplies(request):
        replies = Reply.objects.all()
        serializer = ReplySerializer(replies, many=True)
        return Response(serializer.data)

    @api_view(['POST'])
    def createReply(request):
        data = request.data
        commentId = data['commentId']
        user_id = data['userId']
        comment = Comment.objects.get(pk=commentId)
        user = User.objects.get(pk=user_id)
        reply = Reply.objects.create(
            replyId=data['replyId'],
            replyContent=data['replyContent'],
            created = data['created'],
            userId=user,
            commentId=comment
        )
        serializer = ReplySerializer(reply)
        return Response(serializer.data)
    
    @api_view(['PUT'])
    def updateReply(request, pk):
        data = request.data
        comment = Reply.objects.get(id=pk)
        serializer = ReplySerializer(comment, data=request.POST)
        if serializer.is_valid():
            serializer.save()

        return Response(serializer.data)

    @api_view(['DELETE'])
    def deleteReply(request, pk):
        reply = Reply.objects.get(id=pk)
        reply.delete()
        return Response('Report was deleted!')
    

class UserView(viewsets.ModelViewSet):
    @api_view(['POST'])
    def register(request):
        user_data = request.data
        user = User.objects.create(
            userId=user_data['userId'],
            username=user_data['username'],
            password=user_data['password'],
            firstName=user_data['firstName'],
            lastName=user_data['lastName'],
        )
        serializer = UserSerializer(user)
        return Response(serializer.data, status=201)

    @api_view(['GET'])
    def getUsers(request):
        queryset = User.objects.all()
        serializer = UserSerializer(queryset, many=True)
        return Response(serializer.data)
    
    @api_view(['POST'])
    @csrf_exempt
    def getLogin(request):
        username = request.data.get('username')
        password = request.data.get('password')
    
        # validate username and password
        if not username or not password:
            return Response({'error': 'Invalid credentials'}, status=401)

        try:
            user = User.objects.get(username=username)
            passw = User.objects.get(password=password)
            if user and passw:
                user.last_login = timezone.now()
                user.save()
                user.is_active = True
                serializer = UserSerializer(user)
                return Response(serializer.data)
            else:
                return Response({'error': 'Invalid credentials'}, status=401)
        except User.DoesNotExist:
            return Response({'error': 'Invalid credentials'}, status=401)
    
    def getUser(request, pk):
     user = User.objects.get(userId =pk)
     serializer = UserSerializer(user)
     return JsonResponse(serializer.data, status=200 )
    
    @api_view(['POST'])
    def updateUser(request, userId):
        user = User.objects.get(pk = userId)
        user.username = request.POST.get('username', user.username)
        user.password = request.POST.get('password', user.password)
        user.firstName = request.POST.get('firstName', user.firstName)
        user.lastName =  request.POST.get('lastName', user.password)
        user.save()