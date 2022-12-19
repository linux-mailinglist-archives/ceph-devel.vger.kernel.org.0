Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADF7650B0E
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Dec 2022 13:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiLSMAS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Dec 2022 07:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLSL7m (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Dec 2022 06:59:42 -0500
Received: from amailer.gwdg.de (amailer.gwdg.de [134.76.10.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D20FD01
        for <ceph-devel@vger.kernel.org>; Mon, 19 Dec 2022 03:59:38 -0800 (PST)
Received: from excmbx-25.um.gwdg.de ([134.76.9.235] helo=email.gwdg.de)
        by mailer.gwdg.de with esmtp (GWDG Mailer)
        (envelope-from <marco.roose@mpinat.mpg.de>)
        id 1p7Enw-0005qN-CC; Mon, 19 Dec 2022 12:59:36 +0100
Received: from EXCMBX-13.um.gwdg.de (134.76.9.222) by excmbx-25.um.gwdg.de
 (134.76.9.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.16; Mon, 19
 Dec 2022 12:59:36 +0100
Received: from EXCMBX-13.um.gwdg.de ([134.76.9.222]) by EXCMBX-13.um.gwdg.de
 ([134.76.9.222]) with mapi id 15.01.2507.016; Mon, 19 Dec 2022 12:59:35 +0100
From:   "Roose, Marco" <marco.roose@mpinat.mpg.de>
To:     "Menzel, Paul" <pmenzel@molgen.mpg.de>,
        Xiubo Li <xiubli@redhat.com>
CC:     Ilya Dryomov <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: RE: PROBLEM: CephFS write performance drops by 90%
Thread-Topic: PROBLEM: CephFS write performance drops by 90%
Thread-Index: AQHZEI/jaNUzK8v7qUq0BA8NpF//va5vAyEAgAC0/gCAAKFacIAD8tGAgADBBRD////FAIAAFB4w
Date:   Mon, 19 Dec 2022 11:59:35 +0000
Message-ID: <a212e2465caf4c7da3aa1fe0e094831f@mpinat.mpg.de>
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com>
 <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
 <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com>
 <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
 <a6091b92-c216-e525-0bc7-5515225f6dc8@molgen.mpg.de>
In-Reply-To: <a6091b92-c216-e525-0bc7-5515225f6dc8@molgen.mpg.de>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.250.9.205]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=SHA1; boundary="----=_NextPart_000_0204_01D913A9.BE82E370"
MIME-Version: 1.0
X-Virus-Scanned: (clean) by clamav
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

------=_NextPart_000_0204_01D913A9.BE82E370
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[...]
> Marco, if you have time, it=E2=80=99d be great if you tested Liunx =
5.6-rc7 and 5.6, where the commit entered Linus=E2=80=99 master branch.

already did it: as expected RC7 is fine 5.6 shows the exact problem

Kind regards,
Marco Roose

-----Original Message-----
From: Paul Menzel <pmenzel@molgen.mpg.de>=20
Sent: 19 December 2022 12:46
To: Xiubo Li <xiubli@redhat.com>; Roose, Marco =
<marco.roose@mpinat.mpg.de>
Cc: Ilya Dryomov <idryomov@gmail.com>; ceph-devel@vger.kernel.org
Subject: Re: PROBLEM: CephFS write performance drops by 90%

Dear Xiubo,


Am 19.12.22 um 11:48 schrieb Roose, Marco:

> my colleague Paul (in CC) tried to revert the commit, but it was'nt=20
> possible.

> -----Original Message-----
> From: Xiubo Li <xiubli@redhat.com>
> Sent: 19 December 2022 01:16
> To: Roose, Marco <marco.roose@mpinat.mpg.de>; Ilya Dryomov=20
> <idryomov@gmail.com>
> Cc: Ceph Development <ceph-devel@vger.kernel.org>
> Subject: Re: PROBLEM: CephFS write performance drops by 90%

[=E2=80=A6]

> Since you are here, could you try to revert this commit and have a try =
?
>=20
> Let's see whether is this commit causing it. I will take a look later=20
> this week.

Unfortunately, reverting the commit is not easily possible, as the code =
was changed afterward too. It=E2=80=99d be great if you provided a git =
branch with the commit reverted.

Marco, if you have time, it=E2=80=99d be great if you tested Liunx =
5.6-rc7 and 5.6, where the commit entered Linus=E2=80=99 master branch.


Kind regards,

Paul

------=_NextPart_000_0204_01D913A9.BE82E370
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIYeDCCBDIw
ggMaoAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwezELMAkGA1UEBhMCR0IxGzAZBgNVBAgMEkdyZWF0
ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBwwHU2FsZm9yZDEaMBgGA1UECgwRQ29tb2RvIENBIExpbWl0
ZWQxITAfBgNVBAMMGEFBQSBDZXJ0aWZpY2F0ZSBTZXJ2aWNlczAeFw0wNDAxMDEwMDAwMDBaFw0y
ODEyMzEyMzU5NTlaMHsxCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIx
EDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1pdGVkMSEwHwYDVQQDDBhB
QUEgQ2VydGlmaWNhdGUgU2VydmljZXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+
QJ30buHqdoccTUVEjr5GyIMGncEq/hgfjuQC+vOrXVCKFjELmgbQxXAizUktVGPMtm5oRgtT6stM
JMC8ck7q8RWu9FSaEgrDerIzYOLaiVXzIljz3tzP74OGooyUT59o8piQRoQnx3a/48w1LIteB2Rl
gsBIsKiR+WGfdiBQqJHHZrXreGIDVvCKGhPqMaMeoJn9OPb2JzJYbwf1a7j7FCuvt6rM1mNfc4za
BZmoOKjLF3g2UazpnvR4Oo3PD9lC4pgMqy+fDgHe75+ZSfEt36x0TRuYtUfF5SnR+ZAYx2KcvoPH
Jns+iiXHwN2d5jVoECCdj9je0sOEnA1e6C/JAgMBAAGjgcAwgb0wHQYDVR0OBBYEFKARCiM+lvEH
7OKvKe+CpX/QMKS0MA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MHsGA1UdHwR0MHIw
OKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3Js
MDagNKAyhjBodHRwOi8vY3JsLmNvbW9kby5uZXQvQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmww
DQYJKoZIhvcNAQEFBQADggEBAAhW/ALwm+j/pPrWe8ZEgM5PxMX2AFjMpra8FEloBHbo5u5d7AIP
YNaNUBhPJk4B4+awpe6/vHRUQb/9/BK4x09a9IlgBX9gtwVK8/bxwr/EuXSGti19a8zS80bdL8bg
asPDNAMsfZbdWsIOpwqZwQWLqwwv81w6z2w3VQmH3lNAbFjv/LarZW4E9hvcPOBaFcae2fFZSDAh
ZQNs7Okhc+ybA6HgN62gFRiP+roCzqcsqRATLNTlCCarIpdg+JBedNSimlO98qlo4KJuwtdssaMP
nr/raOdW8q7y4ys4OgmBtWuF174t7T8at7Jj4vViLILUagBBUPE5g5+V6TaWmG4wggWBMIIEaaAD
AgECAhA5ckQ6+SK3UdfTbBDdMTWVMA0GCSqGSIb3DQEBDAUAMHsxCzAJBgNVBAYTAkdCMRswGQYD
VQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9k
byBDQSBMaW1pdGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2VydmljZXMwHhcNMTkwMzEy
MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJz
ZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
LjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQCAEmUXNg7D2wiz0KxXDXbtzSfTTK1Qg2HiqiBNCS1kCdzO
iZ/MPans9s/B3PHTsdZ7NygRK0faOca8Ohm0X6a9fZ2jY0K2dvKpOyuR+OJv0OwWIJAJPuLodMkY
tJHUYmTbf6MG8YgYapAiPLz+E/CHFHv25B+O1ORRxhFnRghRy4YUVD+8M/5+bJz/Fp0YvVGONaan
ZshyZ9shZrHUm3gDwFA66Mzw3LyeTP6vBZY1H1dat//O+T23LLb2VN3I5xI6Ta5MirdcmrS3ID3K
fyI0rn47aGYBROcBTkZTmzNg95S+UzeQc0PzMsNT79uq/nROacdrjGCT3sTHDN/hMq7MkztReJVn
i+49Vv4M0GkPGw/zJSZrM233bkf6c0Plfg6lZrEpfDKEY1WJxA3Bk1QwGROs0303p+tdOmw1XNtB
1xLaqUkL39iAigmTYo61Zs8liM2EuLE/pDkP2QKe6xJMlXzzawWpXhaDzLhn4ugTncxbgtNMs+1b
/97lc6wjOy0AvzVVdAlJ2ElYGn+SNuZRkg7zJn0cTRe8yexDJtC/QV9AqURE9JnnV4eeUB9XVKg+
/XRjL7FQZQnmWEIuQxpMtPAlR1n6BB6T1CZGSlCBst6+eLf8ZxXhyVeEHg9j1uliutZfVS7qXMYo
CAQlObgOK6nyTJccBz8NUvXt7y+CDwIDAQABo4HyMIHvMB8GA1UdIwQYMBaAFKARCiM+lvEH7OKv
Ke+CpX/QMKS0MB0GA1UdDgQWBBRTeb9aqitKz1SA4dibwJ3ysgNmyzAOBgNVHQ8BAf8EBAMCAYYw
DwYDVR0TAQH/BAUwAwEB/zARBgNVHSAECjAIMAYGBFUdIAAwQwYDVR0fBDwwOjA4oDagNIYyaHR0
cDovL2NybC5jb21vZG9jYS5jb20vQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNAYIKwYBBQUH
AQEEKDAmMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEM
BQADggEBABiHUdx0IT2ciuAntzPQLszs8ObLXhHeIm+bdY6ecv7k1v6qH5yWLe8DSn6u9I1vcjxD
O8A/67jfXKqpxq7y/Njuo3tD9oY2fBTgzfT3P/7euLSK8JGW/v1DZH79zNIBoX19+BkZyUIrE79Y
i7qkomYEdoiRTgyJFM6iTckys7roFBq8cfFb8EELmAAKIgMQ5Qyx+c2SNxntO/HkOrb5RRMmda+7
qu8/e3c70sQCkT0ZANMXXDnbP3sYDUXNk4WWL13fWRZPP1G91UUYP+1KjugGYXQjFrUNUHMnREd/
EF2JKmuFMRTE6KlqTIC8anjPuH+OdnKZDJ3+15EIFqGjX5UwggbmMIIEzqADAgECAhAxAnDUNb6b
JJr4VtDh4oVJMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEpl
cnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29y
azEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0yMDAy
MTgwMDAwMDBaFw0zMzA1MDEyMzU5NTlaMEYxCzAJBgNVBAYTAk5MMRkwFwYDVQQKExBHRUFOVCBW
ZXJlbmlnaW5nMRwwGgYDVQQDExNHRUFOVCBQZXJzb25hbCBDQSA0MIICIjANBgkqhkiG9w0BAQEF
AAOCAg8AMIICCgKCAgEAs0riIl4nW+kEWxQENTIgFK600jFAxs1QwB6hRMqvnkphfy2Q3mKbM2ot
pELKlgE8/3AQPYBo7p7yeORuPMnAuA+oMGRb2wbeSaLcZbpwXgfCvnKxmq97/kQkOFX706F9O7/h
0yehHhDjUdyMyT0zMs4AMBDRrAFn/b2vR3j0BSYgoQs16oSqadM3p+d0vvH/YrRMtOhkvGpLuzL8
m+LTAQWvQJ92NwCyKiHspoP4mLPJvVpEpDMnpDbRUQdftSpZzVKTNORvPrGPRLnJ0EEVCHR82LL6
oz915WkrgeCY9ImuulBn4uVsd9ZpubCgM/EXvVBlViKqusChSsZEn7juIsGIiDyaIhhLsd3amm8B
S3bgK6AxdSMROND6hiHT182Lmf8C+gRHxQG9McvG35uUvRu8v7bPZiJRaT7ZC2f50P4lTlnbLvWp
Xv5yv7hheO8bMXltiyLweLB+VNvg+GnfL6TW3Aq1yF1yrZAZzR4MbpjTWdEdSLKvz8+0wCwscQ81
nbDOwDt9vyZ+0eJXbRkWZiqScnwAg5/B1NUD4TrYlrI4n6zFp2pyYUOiuzP+as/AZnz63GvjFK69
WODR2W/TK4D7VikEMhg18vhuRf4hxnWZOy0vhfDR/g3aJbdsGac+diahjEwzyB+UKJOCyzvecG8b
Z/u/U8PsEMZg07iIPi8CAwEAAaOCAYswggGHMB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKy
A2bLMB0GA1UdDgQWBBRpAKHHIVj44MUbILAK3adRvxPZ5DAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0T
AQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwOAYDVR0gBDEwLzAt
BgRVHSAAMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFAGA1UdHwRJMEcw
RaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDB2BggrBgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNl
cnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDov
L29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEACgVOew2PHxM5AP1v7GLGw+3t
F6rjAcx43D9Hl110Q+BABABglkrPkES/VyMZsfuds8fcDGvGE3o5UfjSno4sij0xdKut8zMazv8/
4VMKPCA3EUS0tDUoL01ugDdqwlyXuYizeXyH2ICAQfXMtS+raz7mf741CZvO50OxMUMxqljeRfVP
DJQJNHOYi2pxuxgjKDYx4hdZ9G2o+oLlHhu5+anMDkE8g0tffjRKn8I1D1BmrDdWR/IdbBOj6870
abYvqys1qYlPotv5N5dm+XxQ8vlrvY7+kfQaAYeO3rP1DM8BGdpEqyFVa+I0rpJPhaZkeWW7cImD
QFerHW9bKzBrCC815a3WrEhNpxh72ZJZNs1HYJ+29NTB6uu4NJjaMxpk+g2puNSm4b9uVjBbPO9V
6sFSG+IBqE9ckX/1XjzJtY8Grqoo4SiRb6zcHhp3mxj3oqWi8SKNohAOKnUc7RIP6ss1hqIFyv0x
XZor4N9tnzD0Fo0JDIURjDPEgo5WTdti/MdGTmKFQNqxyZuT9uSI2Xvhz8p+4pCYkiZqpahZlHqM
Fxdw9XRZQgrP+cgtOkWEaiNkRBbvtvLdp7MCL2OsQhQEdEbUvDM9slzZXdI7NjJokVBq3O4pls3V
D2z3L/bHVBe0rBERjyM2C/HSIh84rfmAqBgklzIOqXhd+4RzadUwggfPMIIFt6ADAgECAhEA5gmD
NATGbXJklUJJUze1YzANBgkqhkiG9w0BAQwFADBGMQswCQYDVQQGEwJOTDEZMBcGA1UEChMQR0VB
TlQgVmVyZW5pZ2luZzEcMBoGA1UEAxMTR0VBTlQgUGVyc29uYWwgQ0EgNDAeFw0yMTEyMTQwMDAw
MDBaFw0yNDEyMTMyMzU5NTlaMIIBHjEOMAwGA1UEERMFODA1MzkxSDBGBgNVBAsMP01heC1QbGFu
Y2stSW5zdGl0dXQgZsO8ciBNdWx0aWRpc3ppcGxpbsOkcmUgTmF0dXJ3aXNzZW5zY2hhZnRlbjFH
MEUGA1UEChM+TWF4LVBsYW5jay1HZXNlbGxzY2hhZnQgenVyIEZvZXJkZXJ1bmcgZGVyIFdpc3Nl
bnNjaGFmdGVuIGUuVi4xGzAZBgNVBAkMEkhvZmdhcnRlbnN0cmHDn2UgODEPMA0GA1UECBMGQmF5
ZXJuMQswCQYDVQQGEwJERTEUMBIGA1UEAxMLTWFyY28gUm9vc2UxKDAmBgkqhkiG9w0BCQEWGW1h
cmNvLnJvb3NlQG1waW5hdC5tcGcuZGUwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDA
HnbMvVBAokl5ekT4w+xrim4v+jwmoJGIEVg2KSkkYXz2Bo8G/lFrSaBkVD8gv1t+NGGfnvrC0fmL
zcusfXIwkbpo1iPGhxACvF6lZfcckd7KfTrccfxjaodiVK0Is9tUhN9I6lpH6Wib1+gRvzAjOSlT
rdSf6Ftqa1Ve/IS7jyWCKWz+iLsasPzG+NqNA6FCVPsKXXHmvPu9SRCi2w5vn7PzpZM1co94xfUH
rySgwH77GifaeKe1QrLoH4G7KRCD41v4KV7e4s4MbtLZUuS0DlRUPuq/p58qmid0l9FJf9B6Rk6D
1eCSl/8szGnochqll3cRb071+O1ISx+SObNZrNsiVkeVLVUc3cXMc9zp25qmA5NyKAw4ivoea7qp
Q+2kN+ZIcgF3b3sr6gWSGO1PTfgqblyIRczYEE+0RDtxxI8EzFysk65wzx0ZnIjaZ+RJpQT2PIfz
Oh4i2C+CJa7q+4JFrCnOIMsOjyEL8W0vRoD3AVHMd7ZKxnXs5Lri4fxla5wBOa4QMT4ltPUNeT8F
eOLxd6+GQZhM06bWd9kkPIm8amJu/876xwQqV3m5LDz1EiqjrwdWRsXwkxbeF5n5dPe5S7E8bL0u
C5H7rldUQNjC2JiSMVPWxOyv6CocYAfrR1PPs5KzJEqvQf51eCZpf9/CFdzdWA/YgStmv+e4BQID
AQABo4IB3DCCAdgwHwYDVR0jBBgwFoAUaQChxyFY+ODFGyCwCt2nUb8T2eQwHQYDVR0OBBYEFDeE
IMPOe/ODIhHpkS6i5xFEmA4tMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQW
MBQGCCsGAQUFBwMEBggrBgEFBQcDAjA/BgNVHSAEODA2MDQGCysGAQQBsjEBAgJPMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly9H
RUFOVC5jcmwuc2VjdGlnby5jb20vR0VBTlRQZXJzb25hbENBNC5jcmwweAYIKwYBBQUHAQEEbDBq
MD0GCCsGAQUFBzAChjFodHRwOi8vR0VBTlQuY3J0LnNlY3RpZ28uY29tL0dFQU5UUGVyc29uYWxD
QTQuY3J0MCkGCCsGAQUFBzABhh1odHRwOi8vR0VBTlQub2NzcC5zZWN0aWdvLmNvbTBaBgNVHREE
UzBRgRltYXJjby5yb29zZUBtcGluYXQubXBnLmRlgRltYXJjby5yb29zZUBtcGlicGMubXBnLmRl
gRltYXJjby5yb29zZUBtcGluYXQubXBnLmRlMA0GCSqGSIb3DQEBDAUAA4ICAQCxXPrgPp9llNx5
dFqR9icnFaFX35Sx7lQxUj/fkxT9bcVhueZJQ+hIErrSQJFHwfrlUAhbKzBKaVSIahaB2XmqOnLo
Gz8APUsp3Gj7W7ImYnmZOqVR/CG8thXrXdxbDK0/SVIAia/gOZwrGz2iMlSxjNlGNpGOLDBwB2NE
2QBwm+aqdZ9a0woRjBl+fggq+/SBI7XrAVWA5Ld7oQ+RM/LkLhgxdb5S22OhSiGKUQBERhS1KIyC
zQ044NieQ9L1FPxLGqL85WEixpbp4pdaOJODAqaHLeAIiJI0+81KHVpe9EK6400v3HerukO+OaM6
qswSuKZbrCr1z+kQvK9IVltEiE2STY6KD5BNpE/VB1mLSATHEA9Vb0sCpG+OxCNZ50KhJX7f5sEj
nPoNkK3PQMguk5rn68Sw2J30QPXFM/8v5sCW6X3KRbwE0Jvu354d7YRmFKGBg1QAiyVj6zwUWM4v
HJQjF9Ud2iQ23ldYeYVvafzj8x7X0leXhHS0kT9gLD0UY3VOsP9uRjxxgA/jNzq+ywv8npLzxW5s
J2AQaEZauTy1uLY20CmkeUx8HtisaanVRrtOLNCuWudDZhc18y5R1UJ8ReZwu3VFhIowaKTgkSd9
JjWftvp/zU7/GnNnNpCrQZ+lwwqIlTusWGSUvH9aurzXrP6IvBur22F70GavbTGCBFMwggRPAgEB
MFswRjELMAkGA1UEBhMCTkwxGTAXBgNVBAoTEEdFQU5UIFZlcmVuaWdpbmcxHDAaBgNVBAMTE0dF
QU5UIFBlcnNvbmFsIENBIDQCEQDmCYM0BMZtcmSVQklTN7VjMAkGBSsOAwIaBQCgggHNMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIxOTExNTkzNVowIwYJKoZI
hvcNAQkEMRYEFB4GweIgaA2jF8xFF+u8cwI6HY59MGoGCSsGAQQBgjcQBDFdMFswRjELMAkGA1UE
BhMCTkwxGTAXBgNVBAoTEEdFQU5UIFZlcmVuaWdpbmcxHDAaBgNVBAMTE0dFQU5UIFBlcnNvbmFs
IENBIDQCEQDmCYM0BMZtcmSVQklTN7VjMGwGCyqGSIb3DQEJEAILMV2gWzBGMQswCQYDVQQGEwJO
TDEZMBcGA1UEChMQR0VBTlQgVmVyZW5pZ2luZzEcMBoGA1UEAxMTR0VBTlQgUGVyc29uYWwgQ0Eg
NAIRAOYJgzQExm1yZJVCSVM3tWMwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgBZQMEASowCwYJ
YIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggIACfuYdu8UJ2lyBHkVKcRIa21XqJs7F5T8MXkYmXak+GatCmD0W+Hb
068tW7+70i/7Atn/CQNq8s00I73B+UipGBXSz2//XTroidkfplLEb+146pNZfcREVIe666Ot9MQp
Yv6vhjF+LlB5VWk7URFkQXvrl/NBhnkQ3WdpYBWKiyCsYoEuB8zJQ494yxHvp1GIdHaFYehNsHda
RCeC16Vwq82Br8OZqnqHklS9K2SqY4rgJLnYVUTCgQ4NG6eHGPu3vlHqWalEjMlHGbJ9OfdBvL1A
DVeHFX/ZG43+NnUyzB/M+o19arrgiUgoTJUpzyZS1JEFCzM/6iozFkLAyYF/d8WpuewkI4xXEDw4
nN1gi9bPTS6jOUlzYBJqvvX+V91fKk8gkKT8kEKYQDbJmtMPLQo3KX/SoLhvz4jhi9g6wb6ZyKej
3+RbyfPQw/uDB0QWu6t69/N0W3R/WM7VHa/gJNDUXQtXn2LFf7PONYEbf0JOFX2qa9Q1LIQxd8l+
QZAeOVIh6OcAZnexWpktw5CoAyDXyyrh8jEiohPsqm4LO8I8nI7oPzmhxAOnBt5y8b1RYNvjjmPs
lzF78DaD3Q2pce+TN7IhhFe6/DQUU5tISP/C25CWTgfuSsTMCHyheYGgpWHRpnLMCp91vjfBWWhh
Ve3vH67klBwCJx5qmjxUqqYAAAAAAAA=

------=_NextPart_000_0204_01D913A9.BE82E370--
