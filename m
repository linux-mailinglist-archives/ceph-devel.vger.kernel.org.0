Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99A578535
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 08:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfG2Gqu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 02:46:50 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:35003 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfG2Gqu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 02:46:50 -0400
Received: by mail-ed1-f50.google.com with SMTP id w20so58272029edd.2
        for <ceph-devel@vger.kernel.org>; Sun, 28 Jul 2019 23:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=svu+gdzq77gfbVqfq5DjG6SzPr/eerud+w2LnrjIQkw=;
        b=HPUrVqvNMfWzWuQfo658i+vAtWFZ6ds9pByh/dINWcq2yCLNKhtjCYWIRrVaiDCKcc
         2u2q5Y/QQ93FyffOmky9vGyDG+nXd1AybjrTFa4MsuusPFX2+TNxmKlyMC4EW/0DFuSC
         ACn/Ii08Pdgmue+Nxep6qjRqMgaHtQPA0pDgk6pYyCJbwP+x8Aoc6Y+YAllB/sY2jE6m
         1ow7piskFJGEr3lwwKWgc9rz7FU90CfhC2Rq++YmGxRv76Uzq18i6Dva7XyNDuqrZBpU
         IJw8qVkRKT+dHMqPG0izDNiK1GjBX0ObeKUKp/nTVR/6v6oc2D58QkGZJV51UTp00qgj
         imLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=svu+gdzq77gfbVqfq5DjG6SzPr/eerud+w2LnrjIQkw=;
        b=VHYN+U23bkGiC1mf57PSdwC9vmp+GXDg5Sq3e1P1nkTsJFMwxDtTM1w2UWfVmQVUXL
         W6cK9Ax7Qtz7CRZoIRPp9BzL8QDVwMyKtNZM/z7u3HScWhZQCsqNapUNwe4I2y8KnkwB
         4zHeekpCg3MCrfBOyfLgW5vWKSw+fYFFg7qPb1NK11wwDCCQpP1VxnZbatsnZrn27DD/
         sdqEM3qrLTE3a8ozWlnmlERG84hPxDzfamfm6vfo8ZHMPoqt//PVRlwRkAGiAyyEIsVS
         RuEi9Nbgq1QtjjNnKrFTQgGQDv/0q2RnBlKKryergcdaK6Eyww0usrb9bHX+RT0JRlcX
         /ZFw==
X-Gm-Message-State: APjAAAURR2oTZnFx+s0KPHXYt4Zv5sVDrSMXQ9TiUIJXuxken73+oSdn
        0X/6OCgyzw+ZbCqJYr6wx9NuUruVW7MRFcpM8LR3arKs
X-Google-Smtp-Source: APXvYqwkmD2jGvP7/7BHJo+/ajuI7DVDminJ5QdiHluOgnOU/WkyWhia4fkJma05RDOI9KFiUwJV2jT0+7AajnnHGgM=
X-Received: by 2002:a50:91ef:: with SMTP id h44mr94667628eda.276.1564382807379;
 Sun, 28 Jul 2019 23:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAKO+7k0VmNuPDQF-QnLgg7YE0TzhE8ccgCFLRaX8dt9gBPk1qw@mail.gmail.com>
In-Reply-To: <CAKO+7k0VmNuPDQF-QnLgg7YE0TzhE8ccgCFLRaX8dt9gBPk1qw@mail.gmail.com>
From:   lin zhou <hnuzhoulin2@gmail.com>
Date:   Mon, 29 Jul 2019 14:42:08 +0800
Message-ID: <CAKO+7k1_n+g=NaX5=U+ugNBd9-tRgk1XFa5nFZCR53XFZmBXEA@mail.gmail.com>
Subject: Re: two radosgw instanse get two bucket id for the same bucket name
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

sorry, my ceph version is 10.2.10-1~bpo80+1

my test is run much times: create bucekt, upload file, list file, post
delete file, delete bucekt.

lin zhou <hnuzhoulin2@gmail.com> =E4=BA=8E2019=E5=B9=B47=E6=9C=8829=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=882:32=E5=86=99=E9=81=93=EF=BC=9A
>
> hi,cephers
>
> a strange problem, we execute HEAD request for the same bucekt and
> object return two result.
> one is ok,the other is 404.
>
> looks logs, the two radosgw tanslate the same bucket name to two bucekt i=
d:
>
> logs: HEAD gcp_test/1.py
>
> first radosgw instanse,it translate gcp_test to
> 2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416
> first radosgw instanse,it translate gcp_test to
> 2f58efaa-3fa2-48b2-b996-7f924ae1215c.4429.9
>
> how radosgw instanse do this translating? maybe cache ?
>
> 2019-07-29 14:10:20.120146 7f7d0decb700 20 RGWEnv::set(): HTTP_HOST: 10.8=
3.5.19
> 2019-07-29 14:10:20.120166 7f7d0decb700 20 RGWEnv::set(): REQUEST_METHOD:=
 HEAD
> 2019-07-29 14:10:20.120168 7f7d0decb700 20 RGWEnv::set(): REQUEST_URI:
> /gcp_test/1.py
> 2019-07-29 14:10:20.120169 7f7d0decb700 20 RGWEnv::set(): QUERY_STRING:
> 2019-07-29 14:10:20.120170 7f7d0decb700 20 RGWEnv::set(): REMOTE_USER:
> 2019-07-29 14:10:20.120172 7f7d0decb700 20 RGWEnv::set(): SCRIPT_URI:
> /gcp_test/1.py
> 2019-07-29 14:10:20.120174 7f7d0decb700 20 RGWEnv::set(): SERVER_PORT: 80
> 2019-07-29 14:10:20.120175 7f7d0decb700 20 CONTENT_LENGTH=3D0
> 2019-07-29 14:10:20.120176 7f7d0decb700 20 HTTP_ACCEPT_ENCODING=3Didentit=
y
> 2019-07-29 14:10:20.120177 7f7d0decb700 20 HTTP_AUTHORIZATION=3DAWS
> 3XSGMGNV37CCDH715DFC:h8avCi24ykhY7AfkUz6CukRA+Lk=3D
> 2019-07-29 14:10:20.120181 7f7d0decb700 20 REQUEST_URI=3D/gcp_test/1.py
> 2019-07-29 14:10:20.120182 7f7d0decb700 20 SCRIPT_URI=3D/gcp_test/1.py
> 2019-07-29 14:10:20.120183 7f7d0decb700 20 SERVER_PORT=3D80
> 2019-07-29 14:10:20.120184 7f7d0decb700  1 =3D=3D=3D=3D=3D=3D starting ne=
w request
> req=3D0x7f7d0dec58a0 =3D=3D=3D=3D=3D
> 2019-07-29 14:10:20.120201 7f7d0decb700  2 req 40221:0.000016::HEAD
> /gcp_test/1.py::initializing for trans_id =3D
> tx000000000000000009d1d-005d3e8dcc-14b9e4-ntes
> 2019-07-29 14:10:20.120219 7f7d0decb700 10 rgw api priority: s3=3D5 s3web=
site=3D4
> 2019-07-29 14:10:20.120253 7f7d0decb700 10 handler=3D22RGWHandler_REST_Ob=
j_S3
> 2019-07-29 14:10:20.120254 7f7d0decb700  2 req 40221:0.000069:s3:HEAD
> /gcp_test/1.py::getting op 3
> 2019-07-29 14:10:20.120257 7f7d0decb700 10 op=3D21RGWGetObj_ObjStore_S3
> 2019-07-29 14:10:20.120258 7f7d0decb700  2 req 40221:0.000074:s3:HEAD
> /gcp_test/1.py:get_obj:authorizing
> 2019-07-29 14:10:20.120286 7f7d0decb700 10 get_canon_resource():
> dest=3D/gcp_test/1.py
> 20
> x-amz-date:Mon, 29 Jul 2019 06:05:52 +0000
> /gcp_test/1.py
> 2019-07-29 14:10:20.120331 7f7d0decb700 15 calculated
> digest=3Dh8avCi24ykhY7AfkUz6CukRA+Lk=3D
> 2019-07-29 14:10:20.120332 7f7d0decb700 15
> auth_sign=3Dh8avCi24ykhY7AfkUz6CukRA+Lk=3D
> 2019-07-29 14:10:20.120332 7f7d0decb700 15 compare=3D0
> 2019-07-29 14:10:20.120334 7f7d0decb700  2 req 40221:0.000150:s3:HEAD
> /gcp_test/1.py:get_obj:normalizing buckets and tenants
> 2019-07-29 14:10:20.120336 7f7d0decb700 10 s->object=3D1.py s->bucket=3Dg=
cp_test
> 2019-07-29 14:10:20.120338 7f7d0decb700  2 req 40221:0.000154:s3:HEAD
> /gcp_test/1.py:get_obj:init permissions
> 2019-07-29 14:10:20.120366 7f7d0decb700 15 decode_policy Read
> AccessControlPolicy<AccessControlPolicy
> xmlns=3D"http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><D=
isplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
> xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-instance"
> xsi:type=3D"CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName>=
</Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList>=
</AccessControlPolicy>
> 2019-07-29 14:10:20.120374 7f7d0decb700  2 req 40221:0.000189:s3:HEAD
> /gcp_test/1.py:get_obj:recalculating target
> 2019-07-29 14:10:20.120376 7f7d0decb700  2 req 40221:0.000191:s3:HEAD
> /gcp_test/1.py:get_obj:reading permissions
> 2019-07-29 14:10:20.120386 7f7d0decb700 20 get_obj_state:
> rctx=3D0x7f7d0dec4ff0 obj=3Dgcp_test:1.py state=3D0x7f7e00033f08
> s->prefetch_data=3D0
> 2019-07-29 14:10:20.120428 7f7d0decb700  1 -- 10.83.5.19:0/1072914508
> --> 10.83.5.14:6804/6451 -- osd_op(client.1358308.0:1265831
> 14.480334b7 2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416_1.py
> [getxattrs,stat] snapc 0=3D[] ack+read+known_if_redirected e1563) v7 --
> ?+0 0x7f7e00034b50 con 0x7f7ec0038ed0
> 2019-07-29 14:10:20.121550 7f7e4c4dd700  1 -- 10.83.5.19:0/1072914508
> <=3D=3D osd.1 10.83.5.14:6804/6451 1 =3D=3D=3D=3D osd_op_reply(1265831
> 2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416_1.py [getxattrs,stat]
> v0'0 uv0 ack =3D -2 ((2) No such file or directory)) v7 =3D=3D=3D=3D 214+=
0+0
> (3637942346 0 0) 0x7f7dac01fd40 con 0x7f7ec0038ed0
> 2019-07-29 14:10:20.121633 7f7d0decb700 15 decode_policy Read
> AccessControlPolicy<AccessControlPolicy
> xmlns=3D"http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><D=
isplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
> xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-instance"
> xsi:type=3D"CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName>=
</Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList>=
</AccessControlPolicy>
> 2019-07-29 14:10:20.121638 7f7d0decb700 10 read_permissions on
> gcp_test(@{i=3Dntes.rgw.buckets.index,e=3Dntes.rgw.buckets.extra}ntes.rgw=
.buckets.data[2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416]):1.py
> only_bucket=3D0 ret=3D-2
> 2019-07-29 14:10:20.121642 7f7d0decb700 20 op->ERRORHANDLER: err_no=3D-2
> new_err_no=3D-2
> 2019-07-29 14:10:20.121702 7f7d0decb700  2 req 40221:0.001517:s3:HEAD
> /gcp_test/1.py:get_obj:op status=3D0
> 2019-07-29 14:10:20.121704 7f7d0decb700  2 req 40221:0.001520:s3:HEAD
> /gcp_test/1.py:get_obj:http status=3D404
> 2019-07-29 14:10:20.121706 7f7d0decb700  1 =3D=3D=3D=3D=3D=3D req done
> req=3D0x7f7d0dec58a0 op status=3D0 http_status=3D404 =3D=3D=3D=3D=3D=3D
> 2019-07-29 14:10:20.121716 7f7d0decb700 20 process_request() returned -2
> 2019-07-29 14:10:20.121729 7f7d0decb700  1 civetweb: 0x7f7e0001a840:
> 10.120.170.102 - - [29/Jul/2019:14:10:20 +0800] "HEAD /gcp_test/1.py
> HTTP/1.1" 404 0 - -
>
> -----------------------------------------------
>
> 2019-07-29 14:12:46.196499 7fbf1decb700 20 RGWEnv::set(): HTTP_HOST: 10.8=
3.5.18
> 2019-07-29 14:12:46.196546 7fbf1decb700 20 RGWEnv::set(): SCRIPT_URI:
> /gcp_test/1.py
> 2019-07-29 14:12:46.196550 7fbf1decb700 20 RGWEnv::set(): SERVER_PORT: 80
> 2019-07-29 14:12:46.196552 7fbf1decb700 20 CONTENT_LENGTH=3D0
> 2019-07-29 14:12:46.196558 7fbf1decb700 20 HTTP_HOST=3D10.83.5.18
> 2019-07-29 14:12:46.196560 7fbf1decb700 20 HTTP_X_AMZ_DATE=3DMon, 29 Jul
> 2019 06:08:18 +0000
> 2019-07-29 14:12:46.196571 7fbf1decb700 20 SERVER_PORT=3D80
> 2019-07-29 14:12:46.196574 7fbf1decb700  1 =3D=3D=3D=3D=3D=3D starting ne=
w request
> req=3D0x7fbf1dec58a0 =3D=3D=3D=3D=3D
> 2019-07-29 14:12:46.196600 7fbf1decb700  2 req 9855575:0.000026::HEAD
> /gcp_test/1.py::initializing for trans_id =3D
> tx000000000000000966257-005d3e8e5e-19957-ntes
> 2019-07-29 14:12:46.196614 7fbf1decb700 10 rgw api priority: s3=3D5 s3web=
site=3D4
> 2019-07-29 14:12:46.196618 7fbf1decb700 10 host=3D10.83.5.18
> 2019-07-29 14:12:46.196623 7fbf1decb700 20 subdomain=3D domain=3D
> in_hosted_domain=3D0 in_hosted_domain_s3website=3D0
> 2019-07-29 14:12:46.196626 7fbf1decb700 20 final domain/bucket
> subdomain=3D domain=3D in_hosted_domain=3D0 in_hosted_domain_s3website=3D=
0
> s->info.domain=3D s->info.request_uri=3D/gcp_test/1.py
> 2019-07-29 14:12:46.196641 7fbf1decb700 10 meta>> HTTP_X_AMZ_DATE
> 2019-07-29 14:12:46.196649 7fbf1decb700 10 x>> x-amz-date:Mon, 29 Jul
> 2019 06:08:18 +0000
> 2019-07-29 14:12:46.196672 7fbf1decb700 20 get_handler
> handler=3D22RGWHandler_REST_Obj_S3
> 2019-07-29 14:12:46.196678 7fbf1decb700 10 handler=3D22RGWHandler_REST_Ob=
j_S3
> 2019-07-29 14:12:46.196682 7fbf1decb700  2 req
> 9855575:0.000107:s3:HEAD /gcp_test/1.py::getting op 3
> 2019-07-29 14:12:46.196688 7fbf1decb700 10 op=3D21RGWGetObj_ObjStore_S3
> 2019-07-29 14:12:46.196691 7fbf1decb700  2 req
> 9855575:0.000116:s3:HEAD /gcp_test/1.py:get_obj:authorizing
> 2019-07-29 14:12:46.196749 7fbf1decb700 10 get_canon_resource():
> dest=3D/gcp_test/1.py
> 2019-07-29 14:12:46.196751 7fbf1decb700 10 auth_hdr:
> HEAD
>
> x-amz-date:Mon, 29 Jul 2019 06:08:18 +0000
> /gcp_test/1.py
> 2019-07-29 14:12:46.196798 7fbf1decb700 15 calculated
> digest=3Dgei01bRLR0fJ+S66lArS8RKAff0=3D
> 2019-07-29 14:12:46.196799 7fbf1decb700 15
> auth_sign=3Dgei01bRLR0fJ+S66lArS8RKAff0=3D
> 2019-07-29 14:12:46.196800 7fbf1decb700 15 compare=3D0
> 2019-07-29 14:12:46.196801 7fbf1decb700  2 req
> 9855575:0.000228:s3:HEAD /gcp_test/1.py:get_obj:normalizing buckets
> and tenants
> 2019-07-29 14:12:46.196803 7fbf1decb700 10 s->object=3D1.py s->bucket=3Dg=
cp_test
> 2019-07-29 14:12:46.196806 7fbf1decb700  2 req
> 9855575:0.000232:s3:HEAD /gcp_test/1.py:get_obj:init permissions
> 2019-07-29 14:12:46.196834 7fbf1decb700 15 decode_policy Read
> AccessControlPolicy<AccessControlPolicy
> xmlns=3D"http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><D=
isplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
> xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-instance"
> xsi:type=3D"CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName>=
</Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList>=
</AccessControlPolicy>
> 2019-07-29 14:12:46.196843 7fbf1decb700  2 req
> 9855575:0.000269:s3:HEAD /gcp_test/1.py:get_obj:recalculating target
> 2019-07-29 14:12:46.196844 7fbf1decb700  2 req
> 9855575:0.000271:s3:HEAD /gcp_test/1.py:get_obj:reading permissions
> 2019-07-29 14:12:46.196856 7fbf1decb700 20 get_obj_state:
> rctx=3D0x7fbf1dec4ff0 obj=3Dgcp_test:1.py state=3D0x7fc0b0037d28
> s->prefetch_data=3D0
> 2019-07-29 14:12:46.196911 7fbf1decb700  1 -- 10.83.5.18:0/1956369637
> --> 10.83.5.19:6800/6236 -- osd_op(client.104791.0:143027921
> 14.f46a1b62 2f58efaa-3fa2-48b2-b996-7f924ae1215c.4429.9_1.py
> [getxattrs,stat] snapc 0=3D[] ack+read+known_if_redirected e1563) v7 --
> ?+0 0x7fc0b0031780 con 0x5589cdcacec0
> 2019-07-29 14:12:46.198715 7fc0d42d7700  1 -- 10.83.5.18:0/1956369637
> <=3D=3D osd.10 10.83.5.19:6800/6236 17038063 =3D=3D=3D=3D osd_op_reply(14=
3027921
> 2f58efaa-3fa2-48b2-b996-7f924ae1215c.4429.9_1.py [getxattrs,stat] v0'0
> uv250908 ondisk =3D 0) v7 =3D=3D=3D=3D 210+0+1316 (479645644 0 4119944048=
)
> 0x7fc0ac030110 con 0x5589cdcacec0
> 2019-07-29 14:12:46.198773 7fbf1decb700 10 manifest: total_size =3D 1993
> 2019-07-29 14:12:46.198777 7fbf1decb700 20 get_obj_state: setting
> s->obj_tag to 2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.9855514
> 2019-07-29 14:12:46.198783 7fbf1decb700 15 decode_policy Read
> AccessControlPolicy<AccessControlPolicy
> xmlns=3D"http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><D=
isplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
> xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-instance"
> xsi:type=3D"CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName>=
</Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList>=
</AccessControlPolicy>
> 2019-07-29 14:12:46.198787 7fbf1decb700  2 req
> 9855575:0.002213:s3:HEAD /gcp_test/1.py:get_obj:init op
> 2019-07-29 14:12:46.198790 7fbf1decb700  2 req
> 9855575:0.002216:s3:HEAD /gcp_test/1.py:get_obj:verifying op mask
> 2019-07-29 14:12:46.198791 7fbf1decb700 20 required_mask=3D 1 user.op_mas=
k=3D7
> 2019-07-29 14:12:46.198792 7fbf1decb700  2 req
> 9855575:0.002219:s3:HEAD /gcp_test/1.py:get_obj:verifying op
> permissions
> 2019-07-29 14:12:46.198797 7fbf1decb700  5 Searching permissions for
> uid=3Dp-acp mask=3D49
> 2019-07-29 14:12:46.198799 7fbf1decb700  5 Found permission: 15
> 2019-07-29 14:12:46.198800 7fbf1decb700  5 Searching permissions for
> group=3D1 mask=3D49
> 2019-07-29 14:12:46.198801 7fbf1decb700  5 Permissions for group not foun=
d
> 2019-07-29 14:12:46.198802 7fbf1decb700  5 Searching permissions for
> group=3D2 mask=3D49
> 2019-07-29 14:12:46.198803 7fbf1decb700  5 Permissions for group not foun=
d
> 2019-07-29 14:12:46.198803 7fbf1decb700  5 Getting permissions
> id=3Dp-acp owner=3Dp-acp perm=3D1
> 2019-07-29 14:12:46.198804 7fbf1decb700 10  uid=3Dp-acp requested perm
> (type)=3D1, policy perm=3D1, user_perm_mask=3D15, acl perm=3D1
> 2019-07-29 14:12:46.198806 7fbf1decb700  2 req
> 9855575:0.002232:s3:HEAD /gcp_test/1.py:get_obj:verifying op params
> 2019-07-29 14:12:46.198807 7fbf1decb700  2 req
> 9855575:0.002234:s3:HEAD /gcp_test/1.py:get_obj:pre-executing
> 2019-07-29 14:12:46.198809 7fbf1decb700  2 req
> 9855575:0.002236:s3:HEAD /gcp_test/1.py:get_obj:executing
> 2019-07-29 14:12:46.198816 7fbf1decb700 20 get_obj_state:
> rctx=3D0x7fbf1dec4ff0 obj=3Dgcp_test:1.py state=3D0x7fc0b0037d28
> s->prefetch_data=3D0
> 2019-07-29 14:12:46.198826 7fbf1decb700 20 Read xattr: user.rgw.acl
> 2019-07-29 14:12:46.198827 7fbf1decb700 20 Read xattr: user.rgw.content_t=
ype
> 2019-07-29 14:12:46.198827 7fbf1decb700 20 Read xattr: user.rgw.etag
> 2019-07-29 14:12:46.198828 7fbf1decb700 20 Read xattr: user.rgw.idtag
> 2019-07-29 14:12:46.198829 7fbf1decb700 20 Read xattr: user.rgw.manifest
> 2019-07-29 14:12:46.198830 7fbf1decb700 20 Read xattr: user.rgw.pg_ver
> 2019-07-29 14:12:46.198831 7fbf1decb700 20 Read xattr: user.rgw.source_zo=
ne
> 2019-07-29 14:12:46.198831 7fbf1decb700 20 Read xattr: user.rgw.x-amz-dat=
e
> 2019-07-29 14:12:46.198832 7fbf1decb700 20 Read xattr:
> user.rgw.x-amz-meta-s3cmd-attrs
> 2019-07-29 14:12:46.198833 7fbf1decb700 20 Read xattr:
> user.rgw.x-amz-meta-s3tools-gpgenc
> 2019-07-29 14:12:46.198834 7fbf1decb700 20 Read xattr:
> user.rgw.x-amz-storage-class
> 2019-07-29 14:12:46.198892 7fbf1decb700  2 req
> 9855575:0.002318:s3:HEAD /gcp_test/1.py:get_obj:completing
> 2019-07-29 14:12:46.198895 7fbf1decb700  2 req
> 9855575:0.002321:s3:HEAD /gcp_test/1.py:get_obj:op status=3D0
> 2019-07-29 14:12:46.198896 7fbf1decb700  2 req
> 9855575:0.002323:s3:HEAD /gcp_test/1.py:get_obj:http status=3D200
> 2019-07-29 14:12:46.198899 7fbf1decb700  1 =3D=3D=3D=3D=3D=3D req done
> req=3D0x7fbf1dec58a0 op status=3D0 http_status=3D200 =3D=3D=3D=3D=3D=3D
> 2019-07-29 14:12:46.198923 7fbf1decb700  1 civetweb: 0x7fc0b0015660:
> 10.120.170.102 - - [29/Jul/2019:14:12:46 +0800] "HEAD /gcp_test/1.py
> HTTP/1.1" 200 0 - -
