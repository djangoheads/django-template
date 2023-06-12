"""Default Dynaconf init"""
import dynaconf  # noqa


def sentry_validator(settings, validator):
    import sentry_sdk
    from sentry_sdk.integrations.django import DjangoIntegration

    if settings.SENTRY_DSN:
        return

    sentry_sdk.init(
        dsn=settings.SENTRY_DSN,
        integrations=[
            DjangoIntegration(),
        ],
        traces_sample_rate=0.05,  # TODO: Move to settings?
        send_default_pii=settings.DEBUG,
        release=getattr(settings, "SENTRY_RELEASE", "service-name@release-undefined")
    )

    return settings.SENTRY_DSN


settings = dynaconf.DjangoDynaconf(
    __name__,
    validators=[
        dynaconf.Validator("SENTRY_DSN", default=sentry_validator),
    ],
)  # noqa
