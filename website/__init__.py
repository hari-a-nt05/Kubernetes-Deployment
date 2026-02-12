import os
import logging
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from dotenv import load_dotenv

db = SQLAlchemy()


def create_app():
    # Load .env ONLY for local development
    load_dotenv()

    app = Flask(__name__)

    # ---------------------------------------------------
    # 🔥 Production-Level Structured Logging
    # ---------------------------------------------------
    log_level = os.getenv("LOG_LEVEL", "INFO").upper()

    logging.basicConfig(
        level=getattr(logging, log_level, logging.INFO),
        format='{"time":"%(asctime)s","level":"%(levelname)s","message":"%(message)s"}'
    )

    app.logger.setLevel(getattr(logging, log_level, logging.INFO))
    app.logger.info("Flask application starting...")

    # ---------------------------------------------------
    # App configuration
    # ---------------------------------------------------
    app.config['SECRET_KEY'] = os.getenv("SECRET_KEY", "dev-secret")

    # ---------------------------------------------------
    # Database configuration
    # ---------------------------------------------------
    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD")
    db_host = os.getenv("DB_HOST")
    db_name = os.getenv("DB_NAME")
    db_port = os.getenv("DB_PORT", "3306")

    if not all([db_user, db_password, db_host, db_name]):
        app.logger.error("Database environment variables missing!")
    else:
        app.logger.info("Database configuration loaded successfully.")

    app.config['SQLALCHEMY_DATABASE_URI'] = (
        f"mysql+mysqlconnector://"
        f"{db_user}:{db_password}"
        f"@{db_host}:{db_port}/{db_name}"
    )

    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    # Initialize database
    db.init_app(app)

    # ---------------------------------------------------
    # Blueprints
    # ---------------------------------------------------
    from .views import views
    from .auth import auth

    app.register_blueprint(views, url_prefix='/')
    app.register_blueprint(auth, url_prefix='/')

    # ---------------------------------------------------
    # Models
    # ---------------------------------------------------
    from .models import User, Note

    # ---------------------------------------------------
    # Login manager
    # ---------------------------------------------------
    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))

    # ---------------------------------------------------
    # Controlled DB initialization
    # ---------------------------------------------------
    if os.getenv("RUN_DB_MIGRATIONS") == "true":
        app.logger.info("Running database migrations...")
        with app.app_context():
            db.create_all()
        app.logger.info("Database migration completed successfully.")

    app.logger.info("Flask application started successfully.")

    return app
