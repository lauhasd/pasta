from django.http import JsonResponse
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_POST
import json

from core.models import Pasta


def index(request, _):
    return render(request, 'pasta/index.html')


@csrf_exempt
@require_POST
def save(request):
    content = json.loads(request.body).get('content')
    if content:
        pasta = Pasta(content=content)
        pasta.save()

        return JsonResponse({
            'content': pasta.content,
            'slug': pasta.slug
        }, status=200)
    return JsonResponse({
        'error': 'Something went wrong :('
    }, status=500)


@require_GET
def get(request, slug):
    try:
        pasta = Pasta.objects.get(slug=slug)
    except:
        return JsonResponse({
            'error': 'Not found'
        }, status=404)

    return JsonResponse({
        'content': pasta.content,
        'slug': pasta.slug
    }, status=200)
