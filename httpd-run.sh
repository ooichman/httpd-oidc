#!/bin/bash

# checking the variable and replacing them

cat > /home/apache/oidc-main.conf << EOF
<VirtualHost *:*>
	ServerAdmin webmaster@infra.local
	DocumentRoot /var/www/html
	ErrorLog /dev/stderr
        TransferLog /dev/stdout

    # OpenID Connect metadata for dataporten.
    OIDCProviderMetadataURL $OPENIDPROVIDERMETADATAURL
    OIDCSSLValidateServer Off

    # These are Client ID and Client Secret from the OAuth details page on dashboard.dataporten.no
    OIDCClientID $OIDCCLIENTID
    OIDCClientSecret $OIDCCLIENTSECRET

    # Scopes to request. These must be activated in dashboard.dataporten.no first
    OIDCScope "openid email"

    # Session cookie encryption key
    OIDCCryptoPassphrase GenerateNewPassword

    # Try uncommenting this if you get errors like these "OpenID Connect Provider error: Error in handling response type."
    # OIDCProviderTokenEndpointAuth client_secret_post

    # Needs to match exactly redirect URI registered in dashboard.dataporten.no
    OIDCRedirectURI ${PUBLICROUTE}redirect_uri
    <Location "/">
        AuthType openid-connect
        Require valid-user
    </Location>
</VirtualHost>
EOF

# starting the HTTPD
/usr/sbin/httpd -DFOREGROUND
