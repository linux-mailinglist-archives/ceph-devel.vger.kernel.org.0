Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA778505
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 08:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfG2GhE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 02:37:04 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:42283 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG2GhE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 02:37:04 -0400
Received: by mail-ed1-f44.google.com with SMTP id v15so58296222eds.9
        for <ceph-devel@vger.kernel.org>; Sun, 28 Jul 2019 23:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RaotGJbVQpI4u9QkJSpswzuJMFQGbcOLayRGbiyJo+k=;
        b=lch2dDaxAyCWYEsoy6z/qZ85zbldr6mfRJZzkTdE59o9B2JINV1ewDJ3xIar6uO7qP
         tFIXF5zttLDyWNqDlp6CeYq8E+SXkfjhzVRXfEUUL3aBNZ86MznmbmpQIzo6Jisr9Wh+
         uYQrE/R7TgblsotVqnoB9NFuMTnN0qBKnGjuUToG+v1HmU1GJCqZlybFcLdJI4FcU80i
         W2kxel1JuWVmksOdqUyahId3OBb87R6vLRif8ZCctEA2rTYrFdrdEuUhGtEUS+jfjSO8
         IFL1CF0n2Lhty8WSF2h2x06m1qkLurhw8FP/LCGP9WN+nTr4OSvCxI9wmMbkOF9aosyw
         j3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RaotGJbVQpI4u9QkJSpswzuJMFQGbcOLayRGbiyJo+k=;
        b=YRJdyMjNL7Uv344LbAJLPf9nkS/6X2/G0MHIAXLDowFel+T1w4nwz6JAkCCsK9cKit
         0yGdBAoC1sN0kGVB9EZ6PorL6ceiYEpcT8VlR3jNE6Fig2UuG3qm6oY09m4lOu+HVgxg
         wUZJV9+iNzRdFS6a3P7CmyVIFs1YntxTPDKXq+Q72NtnM2GGsf335tbrfj2Upe7hJYrF
         SJTthg9OEhflURDjmdZbOFPYfkzBf2TlD0wl8wGRp6ow1U17uWW350a10R8668weeqHZ
         LqlCS1Ry9woVubq5StOWaAIW62Is3LGv20Ni8bQeFspatv5Nn92CFDh0VY67N6JSO2Pq
         wWtw==
X-Gm-Message-State: APjAAAU2pSmzCi0siv7BByDdCLOH68yANOm7dx1UiviuE89bGSH3/jKW
        HtTzE73zsNnEHahRfdJ5hDcSV8/5A9Q//7XPTw9OuWty
X-Google-Smtp-Source: APXvYqyUKdc6Ef/DhFJge6mX/csJyRXXX6Syn9YiOSk3rdrxPOzQ7iJ0lu6B+F/eIJNGTD6iBysCXqZMVO7786S6heo=
X-Received: by 2002:a17:906:2599:: with SMTP id m25mr8705702ejb.177.1564382221428;
 Sun, 28 Jul 2019 23:37:01 -0700 (PDT)
MIME-Version: 1.0
From:   lin zhou <hnuzhoulin2@gmail.com>
Date:   Mon, 29 Jul 2019 14:32:22 +0800
Message-ID: <CAKO+7k0VmNuPDQF-QnLgg7YE0TzhE8ccgCFLRaX8dt9gBPk1qw@mail.gmail.com>
Subject: two radosgw instanse get two bucket id for the same bucket name
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

hi,cephers

a strange problem, we execute HEAD request for the same bucekt and
object return two result.
one is ok,the other is 404.

looks logs, the two radosgw tanslate the same bucket name to two bucekt id:

logs: HEAD gcp_test/1.py

first radosgw instanse,it translate gcp_test to
2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416
first radosgw instanse,it translate gcp_test to
2f58efaa-3fa2-48b2-b996-7f924ae1215c.4429.9

how radosgw instanse do this translating? maybe cache ?

2019-07-29 14:10:20.120146 7f7d0decb700 20 RGWEnv::set(): HTTP_HOST: 10.83.5.19
2019-07-29 14:10:20.120166 7f7d0decb700 20 RGWEnv::set(): REQUEST_METHOD: HEAD
2019-07-29 14:10:20.120168 7f7d0decb700 20 RGWEnv::set(): REQUEST_URI:
/gcp_test/1.py
2019-07-29 14:10:20.120169 7f7d0decb700 20 RGWEnv::set(): QUERY_STRING:
2019-07-29 14:10:20.120170 7f7d0decb700 20 RGWEnv::set(): REMOTE_USER:
2019-07-29 14:10:20.120172 7f7d0decb700 20 RGWEnv::set(): SCRIPT_URI:
/gcp_test/1.py
2019-07-29 14:10:20.120174 7f7d0decb700 20 RGWEnv::set(): SERVER_PORT: 80
2019-07-29 14:10:20.120175 7f7d0decb700 20 CONTENT_LENGTH=0
2019-07-29 14:10:20.120176 7f7d0decb700 20 HTTP_ACCEPT_ENCODING=identity
2019-07-29 14:10:20.120177 7f7d0decb700 20 HTTP_AUTHORIZATION=AWS
3XSGMGNV37CCDH715DFC:h8avCi24ykhY7AfkUz6CukRA+Lk=
2019-07-29 14:10:20.120181 7f7d0decb700 20 REQUEST_URI=/gcp_test/1.py
2019-07-29 14:10:20.120182 7f7d0decb700 20 SCRIPT_URI=/gcp_test/1.py
2019-07-29 14:10:20.120183 7f7d0decb700 20 SERVER_PORT=80
2019-07-29 14:10:20.120184 7f7d0decb700  1 ====== starting new request
req=0x7f7d0dec58a0 =====
2019-07-29 14:10:20.120201 7f7d0decb700  2 req 40221:0.000016::HEAD
/gcp_test/1.py::initializing for trans_id =
tx000000000000000009d1d-005d3e8dcc-14b9e4-ntes
2019-07-29 14:10:20.120219 7f7d0decb700 10 rgw api priority: s3=5 s3website=4
2019-07-29 14:10:20.120253 7f7d0decb700 10 handler=22RGWHandler_REST_Obj_S3
2019-07-29 14:10:20.120254 7f7d0decb700  2 req 40221:0.000069:s3:HEAD
/gcp_test/1.py::getting op 3
2019-07-29 14:10:20.120257 7f7d0decb700 10 op=21RGWGetObj_ObjStore_S3
2019-07-29 14:10:20.120258 7f7d0decb700  2 req 40221:0.000074:s3:HEAD
/gcp_test/1.py:get_obj:authorizing
2019-07-29 14:10:20.120286 7f7d0decb700 10 get_canon_resource():
dest=/gcp_test/1.py
20
x-amz-date:Mon, 29 Jul 2019 06:05:52 +0000
/gcp_test/1.py
2019-07-29 14:10:20.120331 7f7d0decb700 15 calculated
digest=h8avCi24ykhY7AfkUz6CukRA+Lk=
2019-07-29 14:10:20.120332 7f7d0decb700 15
auth_sign=h8avCi24ykhY7AfkUz6CukRA+Lk=
2019-07-29 14:10:20.120332 7f7d0decb700 15 compare=0
2019-07-29 14:10:20.120334 7f7d0decb700  2 req 40221:0.000150:s3:HEAD
/gcp_test/1.py:get_obj:normalizing buckets and tenants
2019-07-29 14:10:20.120336 7f7d0decb700 10 s->object=1.py s->bucket=gcp_test
2019-07-29 14:10:20.120338 7f7d0decb700  2 req 40221:0.000154:s3:HEAD
/gcp_test/1.py:get_obj:init permissions
2019-07-29 14:10:20.120366 7f7d0decb700 15 decode_policy Read
AccessControlPolicy<AccessControlPolicy
xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:type="CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList></AccessControlPolicy>
2019-07-29 14:10:20.120374 7f7d0decb700  2 req 40221:0.000189:s3:HEAD
/gcp_test/1.py:get_obj:recalculating target
2019-07-29 14:10:20.120376 7f7d0decb700  2 req 40221:0.000191:s3:HEAD
/gcp_test/1.py:get_obj:reading permissions
2019-07-29 14:10:20.120386 7f7d0decb700 20 get_obj_state:
rctx=0x7f7d0dec4ff0 obj=gcp_test:1.py state=0x7f7e00033f08
s->prefetch_data=0
2019-07-29 14:10:20.120428 7f7d0decb700  1 -- 10.83.5.19:0/1072914508
--> 10.83.5.14:6804/6451 -- osd_op(client.1358308.0:1265831
14.480334b7 2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416_1.py
[getxattrs,stat] snapc 0=[] ack+read+known_if_redirected e1563) v7 --
?+0 0x7f7e00034b50 con 0x7f7ec0038ed0
2019-07-29 14:10:20.121550 7f7e4c4dd700  1 -- 10.83.5.19:0/1072914508
<== osd.1 10.83.5.14:6804/6451 1 ==== osd_op_reply(1265831
2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416_1.py [getxattrs,stat]
v0'0 uv0 ack = -2 ((2) No such file or directory)) v7 ==== 214+0+0
(3637942346 0 0) 0x7f7dac01fd40 con 0x7f7ec0038ed0
2019-07-29 14:10:20.121633 7f7d0decb700 15 decode_policy Read
AccessControlPolicy<AccessControlPolicy
xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:type="CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList></AccessControlPolicy>
2019-07-29 14:10:20.121638 7f7d0decb700 10 read_permissions on
gcp_test(@{i=ntes.rgw.buckets.index,e=ntes.rgw.buckets.extra}ntes.rgw.buckets.data[2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.416]):1.py
only_bucket=0 ret=-2
2019-07-29 14:10:20.121642 7f7d0decb700 20 op->ERRORHANDLER: err_no=-2
new_err_no=-2
2019-07-29 14:10:20.121702 7f7d0decb700  2 req 40221:0.001517:s3:HEAD
/gcp_test/1.py:get_obj:op status=0
2019-07-29 14:10:20.121704 7f7d0decb700  2 req 40221:0.001520:s3:HEAD
/gcp_test/1.py:get_obj:http status=404
2019-07-29 14:10:20.121706 7f7d0decb700  1 ====== req done
req=0x7f7d0dec58a0 op status=0 http_status=404 ======
2019-07-29 14:10:20.121716 7f7d0decb700 20 process_request() returned -2
2019-07-29 14:10:20.121729 7f7d0decb700  1 civetweb: 0x7f7e0001a840:
10.120.170.102 - - [29/Jul/2019:14:10:20 +0800] "HEAD /gcp_test/1.py
HTTP/1.1" 404 0 - -

-----------------------------------------------

2019-07-29 14:12:46.196499 7fbf1decb700 20 RGWEnv::set(): HTTP_HOST: 10.83.5.18
2019-07-29 14:12:46.196546 7fbf1decb700 20 RGWEnv::set(): SCRIPT_URI:
/gcp_test/1.py
2019-07-29 14:12:46.196550 7fbf1decb700 20 RGWEnv::set(): SERVER_PORT: 80
2019-07-29 14:12:46.196552 7fbf1decb700 20 CONTENT_LENGTH=0
2019-07-29 14:12:46.196558 7fbf1decb700 20 HTTP_HOST=10.83.5.18
2019-07-29 14:12:46.196560 7fbf1decb700 20 HTTP_X_AMZ_DATE=Mon, 29 Jul
2019 06:08:18 +0000
2019-07-29 14:12:46.196571 7fbf1decb700 20 SERVER_PORT=80
2019-07-29 14:12:46.196574 7fbf1decb700  1 ====== starting new request
req=0x7fbf1dec58a0 =====
2019-07-29 14:12:46.196600 7fbf1decb700  2 req 9855575:0.000026::HEAD
/gcp_test/1.py::initializing for trans_id =
tx000000000000000966257-005d3e8e5e-19957-ntes
2019-07-29 14:12:46.196614 7fbf1decb700 10 rgw api priority: s3=5 s3website=4
2019-07-29 14:12:46.196618 7fbf1decb700 10 host=10.83.5.18
2019-07-29 14:12:46.196623 7fbf1decb700 20 subdomain= domain=
in_hosted_domain=0 in_hosted_domain_s3website=0
2019-07-29 14:12:46.196626 7fbf1decb700 20 final domain/bucket
subdomain= domain= in_hosted_domain=0 in_hosted_domain_s3website=0
s->info.domain= s->info.request_uri=/gcp_test/1.py
2019-07-29 14:12:46.196641 7fbf1decb700 10 meta>> HTTP_X_AMZ_DATE
2019-07-29 14:12:46.196649 7fbf1decb700 10 x>> x-amz-date:Mon, 29 Jul
2019 06:08:18 +0000
2019-07-29 14:12:46.196672 7fbf1decb700 20 get_handler
handler=22RGWHandler_REST_Obj_S3
2019-07-29 14:12:46.196678 7fbf1decb700 10 handler=22RGWHandler_REST_Obj_S3
2019-07-29 14:12:46.196682 7fbf1decb700  2 req
9855575:0.000107:s3:HEAD /gcp_test/1.py::getting op 3
2019-07-29 14:12:46.196688 7fbf1decb700 10 op=21RGWGetObj_ObjStore_S3
2019-07-29 14:12:46.196691 7fbf1decb700  2 req
9855575:0.000116:s3:HEAD /gcp_test/1.py:get_obj:authorizing
2019-07-29 14:12:46.196749 7fbf1decb700 10 get_canon_resource():
dest=/gcp_test/1.py
2019-07-29 14:12:46.196751 7fbf1decb700 10 auth_hdr:
HEAD

x-amz-date:Mon, 29 Jul 2019 06:08:18 +0000
/gcp_test/1.py
2019-07-29 14:12:46.196798 7fbf1decb700 15 calculated
digest=gei01bRLR0fJ+S66lArS8RKAff0=
2019-07-29 14:12:46.196799 7fbf1decb700 15
auth_sign=gei01bRLR0fJ+S66lArS8RKAff0=
2019-07-29 14:12:46.196800 7fbf1decb700 15 compare=0
2019-07-29 14:12:46.196801 7fbf1decb700  2 req
9855575:0.000228:s3:HEAD /gcp_test/1.py:get_obj:normalizing buckets
and tenants
2019-07-29 14:12:46.196803 7fbf1decb700 10 s->object=1.py s->bucket=gcp_test
2019-07-29 14:12:46.196806 7fbf1decb700  2 req
9855575:0.000232:s3:HEAD /gcp_test/1.py:get_obj:init permissions
2019-07-29 14:12:46.196834 7fbf1decb700 15 decode_policy Read
AccessControlPolicy<AccessControlPolicy
xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:type="CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList></AccessControlPolicy>
2019-07-29 14:12:46.196843 7fbf1decb700  2 req
9855575:0.000269:s3:HEAD /gcp_test/1.py:get_obj:recalculating target
2019-07-29 14:12:46.196844 7fbf1decb700  2 req
9855575:0.000271:s3:HEAD /gcp_test/1.py:get_obj:reading permissions
2019-07-29 14:12:46.196856 7fbf1decb700 20 get_obj_state:
rctx=0x7fbf1dec4ff0 obj=gcp_test:1.py state=0x7fc0b0037d28
s->prefetch_data=0
2019-07-29 14:12:46.196911 7fbf1decb700  1 -- 10.83.5.18:0/1956369637
--> 10.83.5.19:6800/6236 -- osd_op(client.104791.0:143027921
14.f46a1b62 2f58efaa-3fa2-48b2-b996-7f924ae1215c.4429.9_1.py
[getxattrs,stat] snapc 0=[] ack+read+known_if_redirected e1563) v7 --
?+0 0x7fc0b0031780 con 0x5589cdcacec0
2019-07-29 14:12:46.198715 7fc0d42d7700  1 -- 10.83.5.18:0/1956369637
<== osd.10 10.83.5.19:6800/6236 17038063 ==== osd_op_reply(143027921
2f58efaa-3fa2-48b2-b996-7f924ae1215c.4429.9_1.py [getxattrs,stat] v0'0
uv250908 ondisk = 0) v7 ==== 210+0+1316 (479645644 0 4119944048)
0x7fc0ac030110 con 0x5589cdcacec0
2019-07-29 14:12:46.198773 7fbf1decb700 10 manifest: total_size = 1993
2019-07-29 14:12:46.198777 7fbf1decb700 20 get_obj_state: setting
s->obj_tag to 2f58efaa-3fa2-48b2-b996-7f924ae1215c.104791.9855514
2019-07-29 14:12:46.198783 7fbf1decb700 15 decode_policy Read
AccessControlPolicy<AccessControlPolicy
xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Owner><AccessControlList><Grant><Grantee
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:type="CanonicalUser"><ID>p-acp</ID><DisplayName>p-acp</DisplayName></Grantee><Permission>FULL_CONTROL</Permission></Grant></AccessControlList></AccessControlPolicy>
2019-07-29 14:12:46.198787 7fbf1decb700  2 req
9855575:0.002213:s3:HEAD /gcp_test/1.py:get_obj:init op
2019-07-29 14:12:46.198790 7fbf1decb700  2 req
9855575:0.002216:s3:HEAD /gcp_test/1.py:get_obj:verifying op mask
2019-07-29 14:12:46.198791 7fbf1decb700 20 required_mask= 1 user.op_mask=7
2019-07-29 14:12:46.198792 7fbf1decb700  2 req
9855575:0.002219:s3:HEAD /gcp_test/1.py:get_obj:verifying op
permissions
2019-07-29 14:12:46.198797 7fbf1decb700  5 Searching permissions for
uid=p-acp mask=49
2019-07-29 14:12:46.198799 7fbf1decb700  5 Found permission: 15
2019-07-29 14:12:46.198800 7fbf1decb700  5 Searching permissions for
group=1 mask=49
2019-07-29 14:12:46.198801 7fbf1decb700  5 Permissions for group not found
2019-07-29 14:12:46.198802 7fbf1decb700  5 Searching permissions for
group=2 mask=49
2019-07-29 14:12:46.198803 7fbf1decb700  5 Permissions for group not found
2019-07-29 14:12:46.198803 7fbf1decb700  5 Getting permissions
id=p-acp owner=p-acp perm=1
2019-07-29 14:12:46.198804 7fbf1decb700 10  uid=p-acp requested perm
(type)=1, policy perm=1, user_perm_mask=15, acl perm=1
2019-07-29 14:12:46.198806 7fbf1decb700  2 req
9855575:0.002232:s3:HEAD /gcp_test/1.py:get_obj:verifying op params
2019-07-29 14:12:46.198807 7fbf1decb700  2 req
9855575:0.002234:s3:HEAD /gcp_test/1.py:get_obj:pre-executing
2019-07-29 14:12:46.198809 7fbf1decb700  2 req
9855575:0.002236:s3:HEAD /gcp_test/1.py:get_obj:executing
2019-07-29 14:12:46.198816 7fbf1decb700 20 get_obj_state:
rctx=0x7fbf1dec4ff0 obj=gcp_test:1.py state=0x7fc0b0037d28
s->prefetch_data=0
2019-07-29 14:12:46.198826 7fbf1decb700 20 Read xattr: user.rgw.acl
2019-07-29 14:12:46.198827 7fbf1decb700 20 Read xattr: user.rgw.content_type
2019-07-29 14:12:46.198827 7fbf1decb700 20 Read xattr: user.rgw.etag
2019-07-29 14:12:46.198828 7fbf1decb700 20 Read xattr: user.rgw.idtag
2019-07-29 14:12:46.198829 7fbf1decb700 20 Read xattr: user.rgw.manifest
2019-07-29 14:12:46.198830 7fbf1decb700 20 Read xattr: user.rgw.pg_ver
2019-07-29 14:12:46.198831 7fbf1decb700 20 Read xattr: user.rgw.source_zone
2019-07-29 14:12:46.198831 7fbf1decb700 20 Read xattr: user.rgw.x-amz-date
2019-07-29 14:12:46.198832 7fbf1decb700 20 Read xattr:
user.rgw.x-amz-meta-s3cmd-attrs
2019-07-29 14:12:46.198833 7fbf1decb700 20 Read xattr:
user.rgw.x-amz-meta-s3tools-gpgenc
2019-07-29 14:12:46.198834 7fbf1decb700 20 Read xattr:
user.rgw.x-amz-storage-class
2019-07-29 14:12:46.198892 7fbf1decb700  2 req
9855575:0.002318:s3:HEAD /gcp_test/1.py:get_obj:completing
2019-07-29 14:12:46.198895 7fbf1decb700  2 req
9855575:0.002321:s3:HEAD /gcp_test/1.py:get_obj:op status=0
2019-07-29 14:12:46.198896 7fbf1decb700  2 req
9855575:0.002323:s3:HEAD /gcp_test/1.py:get_obj:http status=200
2019-07-29 14:12:46.198899 7fbf1decb700  1 ====== req done
req=0x7fbf1dec58a0 op status=0 http_status=200 ======
2019-07-29 14:12:46.198923 7fbf1decb700  1 civetweb: 0x7fc0b0015660:
10.120.170.102 - - [29/Jul/2019:14:12:46 +0800] "HEAD /gcp_test/1.py
HTTP/1.1" 200 0 - -
