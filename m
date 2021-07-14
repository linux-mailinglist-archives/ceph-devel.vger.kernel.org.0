Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DB83C8268
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 12:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbhGNKJG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 06:09:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238359AbhGNKJF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 06:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626257174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S4cU/xx0zjvXuWehqCcQBwCFvuxaw5ZEbgauSSASq8w=;
        b=WQUn442s45YZ/k94lpX9LzWdgGtL/b9C4MEJEnD/xyI5xbv+e3rvYVSUa3EBWlj+3tfn3s
        cbwWUX537vBCKU1/FWiIKDLhDeLrLSzdM03XlH0eFVxqzKC0UL/J9ebjX1hcMMyYuah6rC
        2uWSAb0sBkgw+2Xi4uvtgrjCq5Be6Zs=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-IZDCrIjjPvawQLKfTsQJhw-1; Wed, 14 Jul 2021 06:06:13 -0400
X-MC-Unique: IZDCrIjjPvawQLKfTsQJhw-1
Received: by mail-pg1-f200.google.com with SMTP id 29-20020a63105d0000b029022c245c3492so1170306pgq.17
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 03:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4cU/xx0zjvXuWehqCcQBwCFvuxaw5ZEbgauSSASq8w=;
        b=MTCdRWhURGfO+8bE9lFLEObKD8rYhbGnNQ44jH04MW7qbrM91XUAb+bcOcSoifrvz1
         Wu+Dr8GPf2XAGgltNpSjPCaDcjO3Imue1l541BHU5BF2jGO0ZLazt/COqRV/o89XoQdu
         GAOEkVYRMC6X500GTrUDP9Bpq5mmjbibTqgHM7munkGdk3DCaiuc6OkbZcm3P3GBQfM7
         n/ZinjQhW8HGSX5BVvZazavNFSbpXcarvvUeXYDWjYPWwBCJNMvErI8m8kEW8e6zbAAc
         okZcDioPxSwteA1VWfHWycHb8eTog82oWI2f8qIdmM5cqkX3HkQIJFVEqxZOyihRlaSF
         9zyQ==
X-Gm-Message-State: AOAM533WNorU+8VzQ/dBeVmWnu4M1gDS9YFBBo1C1Y5jQb2WwsYK3mnp
        TnjOru4ZQmZAzaf5FKraYMnJ8uzPXa3mhhqxAOez/d3DhaVT4Xy8+NBdE20aHfOul6cm6ICqUpd
        Nf17yPw9tLrdpkUgRqT3o6A==
X-Received: by 2002:a17:90a:9b13:: with SMTP id f19mr8976094pjp.229.1626257172006;
        Wed, 14 Jul 2021 03:06:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH9nkU6HkXTT3OJIbaYYx7hvd/4Da+KMD2r8eUNPvDYW0kHbcO3v/l+SdZjfl0UjTkcjxkpQ==
X-Received: by 2002:a17:90a:9b13:: with SMTP id f19mr8976079pjp.229.1626257171775;
        Wed, 14 Jul 2021 03:06:11 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.217.185])
        by smtp.gmail.com with ESMTPSA id 125sm2227030pfg.52.2021.07.14.03.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 03:06:11 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 2/5] ceph: rename parse_fsid() to ceph_parse_fsid() and export
Date:   Wed, 14 Jul 2021 15:35:51 +0530
Message-Id: <20210714100554.85978-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714100554.85978-1-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

... as it is too generic. also, use __func__ when logging
rather than hardcoding the function name.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 include/linux/ceph/libceph.h | 1 +
 net/ceph/ceph_common.c       | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index e50dba429819..37ab639b5012 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -298,6 +298,7 @@ extern bool libceph_compatible(void *data);
 extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
 extern void *ceph_kvmalloc(size_t size, gfp_t flags);
+extern int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid);
 
 struct fs_parameter;
 struct fc_log;
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 0f74ceeddf48..31cbe671121c 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -217,14 +217,14 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
 	return p;
 }
 
-static int parse_fsid(const char *str, struct ceph_fsid *fsid)
+int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
 {
 	int i = 0;
 	char tmp[3];
 	int err = -EINVAL;
 	int d;
 
-	dout("parse_fsid '%s'\n", str);
+	dout("%s '%s'\n", __func__, str);
 	tmp[2] = 0;
 	while (*str && i < 16) {
 		if (ispunct(*str)) {
@@ -244,9 +244,10 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 
 	if (i == 16)
 		err = 0;
-	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
+	dout("%s ret %d got fsid %pU\n", __func__, err, fsid);
 	return err;
 }
+EXPORT_SYMBOL(ceph_parse_fsid);
 
 /*
  * ceph options
@@ -465,7 +466,7 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		break;
 
 	case Opt_fsid:
-		err = parse_fsid(param->string, &opt->fsid);
+		err = ceph_parse_fsid(param->string, &opt->fsid);
 		if (err) {
 			error_plog(&log, "Failed to parse fsid: %d", err);
 			return err;
-- 
2.27.0

