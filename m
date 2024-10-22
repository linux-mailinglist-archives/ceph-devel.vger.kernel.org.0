Return-Path: <ceph-devel+bounces-1915-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 104659AB155
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Oct 2024 16:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3DD1B23D80
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Oct 2024 14:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83531A00C9;
	Tue, 22 Oct 2024 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="euFVfnXv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1411A19E836
	for <ceph-devel@vger.kernel.org>; Tue, 22 Oct 2024 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608557; cv=none; b=ViLzPVRhM6DAcy4b1XyVEZXz5OFUqVryIvo8rLmln8xYVWvTafcg6YDPWq/5cfATU2z4Qe22qk0aUmsPk3OtHulLQtIuheHcpLXNis+KQUHt2KanCEuJLNh8N06MscivegKkClXa1Lp+sTdTi1nME5u/o72BwMKPLJzS9Gh0BzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608557; c=relaxed/simple;
	bh=lFchxuWYdoChXXQRufyH2iiBvFGz6l9XBMUrcB9WM6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY4j4KtFqdAwHmYjmbi0Z8qGvl2caGOXBNiF3xefTf1I3XUs5KMJSGMmxgdvsLN2h1jtepDBcM/b1CSjcae2t8oaQUkySxHqRgGyEg1TAfbIhbL/ynxK7g/AG6t5uK+tZ8sS91mTxTm3yyeqjwzDjgFrasP+pTw+5NItBkvivdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=euFVfnXv; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5ebc05007daso1338428eaf.1
        for <ceph-devel@vger.kernel.org>; Tue, 22 Oct 2024 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1729608555; x=1730213355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKaj8XArk4+aUuXdEGwzY4pbQVUlMNZ2d7arPW6y4hE=;
        b=euFVfnXvL3lY+cdxbzYrRV7OwKEvHrB729WWGf1MgUkeePZSHGSTXqbdWhYcRRqq+y
         cOKZW4KxK5rJD9ET3ieYlk/xS9KlTlFmG8ElqqQPGveXuxJI/v328m0w119/1bFTNVxF
         CCBEhoEa92U5XwVi8VfKVwL7ojdLvcOXcSFv2xzXPi+obqvq5xcyzlEHnFdDzk2XymWg
         dEucFuD1FJYzPPpP8tH8mAjG4VxGzdHiVAuA2pqfaBaP6ageIBh50ZBJX8KRNLrB5B25
         K2HtgB/JHL7NZh5l5ge4fX++oCLUPMmC1jsKi30mEQBtYassSqffEiTlpp2+WOwA8dzg
         scCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729608555; x=1730213355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKaj8XArk4+aUuXdEGwzY4pbQVUlMNZ2d7arPW6y4hE=;
        b=KQn7m4IyMvuzBSAL0amnbpDDHtSNN9v+eKcdmo4uaS6Ig6QFykYmJNfaiUDqsvkQSv
         xfJSHOqBwvtTR4X9EEZPPPcbJtE9aK7LaK0aYeiPaxfvIQtF8VnX/2ddZX4lAVgDNNnA
         nJKpCOxZSfbocoDpql6VFAeY0/nO+goh7jxWySgZt8BBjYOA/TinLZ7l5d115V7jmjWO
         OxiRQgkEiQk84QHLR6vphtfKwkiMaV+b8/+MbGrR7J/9nWROq39pXRnkmSkpf2Z+BvPZ
         FT7CSeWvmuQUuDlN4FKFaTb5joHVLuleLAgddaw6RQ9FJFArv9FeMEhlfSHomRowBt5q
         WXCw==
X-Forwarded-Encrypted: i=1; AJvYcCWLoGLr1y1GHIM3A8stQ0T164i10lxMINYwkyHRf5XryfiCT8VVrRKfvAkZBLfUttfQrhoLz/XBC8Hf@vger.kernel.org
X-Gm-Message-State: AOJu0YwRMPWE2FtNmZkDn3pPusI839KswDY0NZll43r/r69p01QjVW21
	6KfmdDl6PfdPolsl8onVFhEF0f6fCTK1UW74VeoocxVQQ8U8l9HnpbZjeHtNtA==
X-Google-Smtp-Source: AGHT+IEwaVAWGLfmNMr+lJeaJ8Yjtm1v6/BmAIKrS4HDg/0jFnT+ZsEs65PuzbPkJaDPNgiT6tOGMw==
X-Received: by 2002:a05:6358:311b:b0:1c3:7503:86bd with SMTP id e5c5f4694b2df-1c3cd4f3699mr170166855d.14.1729608555009;
        Tue, 22 Oct 2024 07:49:15 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ce008fb5e0sm29567476d6.33.2024.10.22.07.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 07:49:14 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <batrick@batbytes.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] ceph: correct ceph_mds_cap_item field name
Date: Tue, 22 Oct 2024 10:48:33 -0400
Message-ID: <20241022144838.1049499-2-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241022144838.1049499-1-batrick@batbytes.com>
References: <20241022144838.1049499-1-batrick@batbytes.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The issue_seq is sent with bulk cap releases, not the current sequence number.

See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_item field name".

See-also: https://tracker.ceph.com/issues/66704
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/mds_client.c         | 2 +-
 include/linux/ceph/ceph_fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c4a5fd94bbbb..0be82de8a6da 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2362,7 +2362,7 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
 		item->ino = cpu_to_le64(cap->cap_ino);
 		item->cap_id = cpu_to_le64(cap->cap_id);
 		item->migrate_seq = cpu_to_le32(cap->mseq);
-		item->seq = cpu_to_le32(cap->issue_seq);
+		item->issue_seq = cpu_to_le32(cap->issue_seq);
 		msg->front.iov_len += sizeof(*item);
 
 		ceph_put_cap(mdsc, cap);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ee1d0e5f9789..4ff3ad5e9210 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -822,7 +822,7 @@ struct ceph_mds_cap_release {
 struct ceph_mds_cap_item {
 	__le64 ino;
 	__le64 cap_id;
-	__le32 migrate_seq, seq;
+	__le32 migrate_seq, issue_seq;
 } __attribute__ ((packed));
 
 #define CEPH_MDS_LEASE_REVOKE           1  /*    mds  -> client */
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


