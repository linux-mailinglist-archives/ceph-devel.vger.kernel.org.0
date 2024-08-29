Return-Path: <ceph-devel+bounces-1781-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E1696426B
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Aug 2024 12:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28284286208
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Aug 2024 10:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A66918FDB9;
	Thu, 29 Aug 2024 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="PkwIU1PE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C0418FC8C
	for <ceph-devel@vger.kernel.org>; Thu, 29 Aug 2024 10:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724929060; cv=none; b=bWBT5vagc65rwxsdpSwUdxl6NFjMoPuueI8Sg6qHluWepUCkJhWcqIYbDtHj70jqcMSz/QKuWWygGUNNJf9DUuIoIjsw1UOwJj7AfkWGOOgIEHOW93//cz3RDzkBQkgeeVCwLlm3cKGRxKBOXBROKA45+b9C6jJyQuYUHnsw9nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724929060; c=relaxed/simple;
	bh=500LP0qX1Sxb5P/oDJaDqZYnHpB6IUucJWF0j3xgaiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=icOzP2Zvz9YF57JNcg/M195e50TZ1HngQwkZ80tT6gERUBpbY2WNIz9aLs453AqtQPrhI3K8c1n2jHXIzD4REztO+bMrv/8cPwTZWuZhh484U4HuX132quGcBTBPKB99JOGpIanOsgJAx4uokWKr1TPrUZN++9wiOA6oHlUyyIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=PkwIU1PE; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5bef295a429so541858a12.2
        for <ceph-devel@vger.kernel.org>; Thu, 29 Aug 2024 03:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1724929055; x=1725533855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eOayM7maWjGIKq5l/ubENwa1iRZX5CDdJ8r1AolwTwc=;
        b=PkwIU1PEOqNXrcI0blogFzl2VtpgbD+2z9pe8NGYPbEegaOoG2SK2/M/5LYJDvQ9kh
         rS5IphUQNfXjROb/HiWXHHRNfcMOCCRvGIr6bsGdgm+DCS+fCiCEg+LxpZMN+B0piq47
         sVowWmWmLSepxLMrQZNEabAytUP1cimVo8lS5rEdq0lmZZCIF8TYJDwDOzC+6aoVEo3r
         bgpkCMIOd4VtQVKNTpOSiO6Y9dS0+bIVJ6D7G8SjVIx5JL8VBOkEKQYNXqcACHl0ssnF
         fQQOvU8wgu1wwLS8cAS+ITuEDSatuwl6y3WZQ0teX58+fhShVL420BzriJnlgt35nIgY
         nKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724929055; x=1725533855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOayM7maWjGIKq5l/ubENwa1iRZX5CDdJ8r1AolwTwc=;
        b=Jxn/jbF5NT5dy1yqQSntL3yTiy7mnzfScnpuBYkjA8dY1i7rQQmGi4PicR1AyJwIl1
         v7uwBRk1XE90TLVN6h1KX3bIh884wIPmdOZnwfMSF5XBrihBPPvgUuEoq5EN8knz2GD8
         X16/M8pVnWI6fgtg1geFLNhjMMN4yVhx9g3SHdULccMBk99bHH4hTsRuT+IVoUaguURE
         PI7IJxnk91bTaVL5EsrqIB3EvvBEK9Cob+QQIaXz4FShQYvwW/uPKAmI0poP7Vu/plhU
         y4athCP36mAybaZJAIzE8CsLvv/Cn20i91k2PvbFwPhn16vBtYQdGP0Q1WpTl1mARmWk
         Ugdg==
X-Forwarded-Encrypted: i=1; AJvYcCX3zve+zwPMYlkN0uqhXVeCxhYkNKj3VTu+C5mjMMesIAaUAOG0ZmXYxsRVZFV2JP0/WXn4pGVflIb0@vger.kernel.org
X-Gm-Message-State: AOJu0YzVwQl9hanPRzsaLdcibHEiGCUudY2juEcLvxy/b1kLlwNw9puu
	+7O230RTwXFksdLA4TvDGX9sHgx6LbZAt54spsRigXeluJZ3erQy7jpjChQ4Ixg=
X-Google-Smtp-Source: AGHT+IEiZ/4/Lm7l+/N0PPQZZ3S9N+xlV2UqquwAjiCDrKqRI1NFP6Lr1WlXVP+v4DAsa0HeQ0181w==
X-Received: by 2002:a05:6402:4308:b0:5a2:5bd2:ca50 with SMTP id 4fb4d7f45d1cf-5c21ed85291mr1772134a12.25.1724929055077;
        Thu, 29 Aug 2024 03:57:35 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f0ebd00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f0e:bd00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226c7c32dsm568410a12.48.2024.08.29.03.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 03:57:34 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
Date: Thu, 29 Aug 2024 12:57:17 +0200
Message-ID: <20240829105717.1163483-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CAP_SYS_RESOURCE allows users to "override disk quota limits".  Most
filesystems have a CAP_SYS_RESOURCE check in all quota check code
paths, but Ceph currently does not.  This patch implements the
feature.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/quota.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 06ee397e0c3a..666315ec74d3 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -429,6 +429,9 @@ bool ceph_quota_is_max_files_exceeded(struct inode *inode)
 
 	WARN_ON(!S_ISDIR(inode->i_mode));
 
+	if (capable(CAP_SYS_RESOURCE))
+		return false;
+
 	return check_quota_exceeded(inode, QUOTA_CHECK_MAX_FILES_OP, 1);
 }
 
@@ -451,6 +454,9 @@ bool ceph_quota_is_max_bytes_exceeded(struct inode *inode, loff_t newsize)
 	if (newsize <= size)
 		return false;
 
+	if (capable(CAP_SYS_RESOURCE))
+		return false;
+
 	return check_quota_exceeded(inode, QUOTA_CHECK_MAX_BYTES_OP, (newsize - size));
 }
 
@@ -473,6 +479,9 @@ bool ceph_quota_is_max_bytes_approaching(struct inode *inode, loff_t newsize)
 	if (newsize <= size)
 		return false;
 
+	if (capable(CAP_SYS_RESOURCE))
+		return false;
+
 	return check_quota_exceeded(inode, QUOTA_CHECK_MAX_BYTES_APPROACHING_OP,
 				    (newsize - size));
 }
-- 
2.45.2


