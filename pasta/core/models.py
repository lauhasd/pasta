import uuid
from django.db import models


class Pasta(models.Model):
    content = models.TextField()
    slug = models.CharField(max_length=16, null=True, unique=True)

    def save(self, *args, **kwargs):
        self.slug = str(uuid.uuid4())[:8]
        super(Pasta, self).save(*args, **kwargs)
