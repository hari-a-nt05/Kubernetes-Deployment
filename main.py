import os
from website import create_app

app = create_app()

# --------------------------------------------
# Optional: Health Check Endpoint (Production)
# --------------------------------------------
@app.route("/health")
def health():
    return {"status": "healthy"}, 200


# --------------------------------------------
# Run only for local development
# --------------------------------------------
if __name__ == "__main__":
    debug_mode = os.getenv("FLASK_DEBUG", "false").lower() == "true"

    app.run(
        host="0.0.0.0",
        port=int(os.getenv("PORT", 5000)),
        debug=debug_mode
    )
