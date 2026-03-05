from django.db import migrations
from django.utils import timezone


def create_basic_poll(apps, schema_editor):
    Question = apps.get_model("polls", "Question")
    Choice = apps.get_model("polls", "Choice")

    question_text = "What is your favorite programming language?"
    if not Question.objects.filter(question_text=question_text).exists():
        q = Question.objects.create(
            question_text=question_text, pub_date=timezone.now()
        )
        Choice.objects.create(question=q, choice_text="Python")
        Choice.objects.create(question=q, choice_text="JavaScript")
        Choice.objects.create(question=q, choice_text="C++")
        Choice.objects.create(question=q, choice_text="Rust")


def delete_basic_poll(apps, schema_editor):
    Question = apps.get_model("polls", "Question")
    Question.objects.filter(
        question_text="What is your favorite programming language?"
    ).delete()


class Migration(migrations.Migration):

    dependencies = [
        ("polls", "0001_initial"),
    ]

    operations = [
        migrations.RunPython(create_basic_poll, delete_basic_poll),
    ]
