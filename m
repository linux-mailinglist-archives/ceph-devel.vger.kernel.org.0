Return-Path: <ceph-devel+bounces-1909-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8E999CBD1
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 15:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EA47B23131
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 13:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA121AB522;
	Mon, 14 Oct 2024 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="xHeT880M"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24411AA78D
	for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728913597; cv=none; b=L/C9u7FA96AFfJ/wHir8lL9mRwlKe5l1Mfyvbr9t4r2Sdgrv1o+C2L0AS6tWh1yJZtvJ6ZQjfPC31V42w3ZAo7I48qqFFxKXO0YfzEgDI8vYTtE7/CwAHwQYXYu1BaEzZwMrweWTbvw/D9zGuw0NLRJDcqT0IXfBK0Qx4366l/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728913597; c=relaxed/simple;
	bh=hXB/C5cfukY2a2WKHkPhfQHVJ+hWk/5yyFbXvCtVRjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/xRJjaT1hqQX3Z+v2zADawqBx4EG+7cJ2MCUV2iZF5hVFdlQ7Di6f8abb9UJHEPHUumpIghUi1infSaytEzNV6VK4ew6qNWHNbBjBM1asnXs0pdPorV2ziE7UeSG4OZwMyU48UwuJkq4JdrfS7E2+zynzhlkz/NsLayWn4wlWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=xHeT880M; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6cbceb321b3so35413366d6.3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2024 06:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728913594; x=1729518394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ko3jW5Cl6F4biBXzgYlOkyez2QUIpC8KdqLdRC76G2Y=;
        b=xHeT880MBBsaME/gWtr+dHzxQSon9R0Q4Sagpqd9+n46QcZ2fTpQI8e3t6OQYZUgMl
         /ENN753Wihv+im2VWMdYnDnoCm/OKMC37NKFPkIBlbaaKL+saTzXvKvVvQHj+Z45hHHd
         2gyHxzIFId7Ury/CiB4kmQHe3UNWOv70NUCSh4vJ9mPxXJqfIdT7lX0GgIpfclpI7HRD
         t3UEv0NEcPIooZ5Dhdf3GQRwY73fiPBCojMNAFJeyuRk5M6L1O0Bsqo1qmJPok3ppONl
         MMgBQHm4Zwbb4wvya8eha5OMzZXCYkvcKAYn+9eXjPQ+uYMegk5Cxa5KAvX0heZrl2MG
         S+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728913594; x=1729518394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ko3jW5Cl6F4biBXzgYlOkyez2QUIpC8KdqLdRC76G2Y=;
        b=S7i5Gjx7oT0sjmRgb1XKfut4xlUGGnl6W6AxeaBGJkJYaXdKAO3ECeZlv+tIXnMrQ+
         mWVtwvmy0aXi7FbSYDud2xCs1IjG9eK3qVkWEbUoJ6SUT+EaYuvRPcDLFIPXhEdrMY19
         zRHX1PWT8/atq2IPBC03rxtYSg/ZE6RjAcdRh7grHI7yb+/OPYH6vV6oLurzRaBYmHAQ
         SDF7aj8OBOlFhR6gyn+VzSFrTNdku+pZW3o+1mCffOXsKUP74xIU1jnxfWeV/gkG+U4S
         O7Rn+4fS3Sj9aOgr4DT59gU4+BoRhwyDgN42F6YQ2Qk1JrXMzalDnrrj2PP5pOfVafRf
         CnUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgPip6yH1SpntQJqLEzBtlfNm26H01+pFOaVc72frJM89HKR7KsvymoMZrCG6jgtQ3/bx6Io8l4cLQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwqfCj+6hQG28xvudoI+AYVgfZ4XjjnRN9J2VbZT8pKzGdJ1Kx2
	uMtxGWaDXOST41R5Q7bUA08tyPqmpVh1KRvdz5cel5j34MbiYyEZVB0eT6/3ov2+vQC4c4dUxSb
	c0A==
X-Google-Smtp-Source: AGHT+IECjyFa7lqpkKz9WnA88loVkpaciMaBusV2OtD0lFCtirhYVtvs6EezQ5JzX+waow9Y789YcQ==
X-Received: by 2002:a05:6214:4b04:b0:6cb:eea5:69e0 with SMTP id 6a1803df08f44-6cbeff63b34mr210563056d6.27.1728913593824;
        Mon, 14 Oct 2024 06:46:33 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cbe85a7700sm45584966d6.7.2024.10.14.06.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 06:46:33 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	stable@vger.kernel.org,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] ceph: extract entity name from device id
Date: Mon, 14 Oct 2024 09:46:24 -0400
Message-ID: <20241014134625.700634-3-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014134625.700634-1-batrick@batbytes.com>
References: <20241014134625.700634-1-batrick@batbytes.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrick Donnelly <pdonnell@redhat.com>

Previously, the "name" in the new device syntax "<name>@<fsid>.<fsname>" was
ignored because (presumably) tests were done using mount.ceph which also passed
the entity name using "-o name=foo". If mounting is done without the mount.ceph
helper, the new device id syntax fails to set the name properly.

Cc: stable@vger.kernel.org
Resolves: https://tracker.ceph.com/issues/68516
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 42bdbe5b7ef9..de03cd6eb86e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -285,7 +285,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	size_t len;
 	struct ceph_fsid fsid;
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_options *opts = pctx->copts;
 	struct ceph_mount_options *fsopt = pctx->opts;
+	const char *name_start = dev_name;
 	const char *fsid_start, *fs_name_start;
 
 	if (*dev_name_end != '=') {
@@ -296,8 +298,14 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	fsid_start = strchr(dev_name, '@');
 	if (!fsid_start)
 		return invalfc(fc, "missing cluster fsid");
-	++fsid_start; /* start of cluster fsid */
+	len = fsid_start - name_start;
+	kfree(opts->name);
+	opts->name = kstrndup(name_start, len, GFP_KERNEL);
+	if (!opts->name)
+		return -ENOMEM;
+	dout("using %s entity name", opts->name);
 
+	++fsid_start; /* start of cluster fsid */
 	fs_name_start = strchr(fsid_start, '.');
 	if (!fs_name_start)
 		return invalfc(fc, "missing file system name");
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


