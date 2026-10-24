import os
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="", case_sensitive=False)

    wc_url: str = os.environ.get("WC_URL", "https://store.local")
    wc_consumer_key: str = os.environ.get("WC_CONSUMER_KEY", "")
    wc_consumer_secret: str = os.environ.get("WC_CONSUMER_SECRET", "")
    wc_verify_ssl: bool = os.environ.get("WC_VERIFY_SSL", "false").lower() in ("true", "1", "yes")
    wc_host_header: str = os.environ.get("WC_HOST_HEADER", "store.local")
    service_port: int = int(os.environ.get("PORT", "8002"))

settings = Settings()
