from django.http import JsonResponse
from django.shortcuts import render
from django.views.decorators.http import require_GET, require_POST

from core.models import Pasta


def index(request):
    return render(request, 'pasta/index.html')


@require_POST
def save(request):
    content = request.POST.get('content')
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
