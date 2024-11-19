Return-Path: <ceph-devel+bounces-2176-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 429129D1E41
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 03:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E51391F22B76
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 02:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206CA145A09;
	Tue, 19 Nov 2024 02:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="1i8Qj1aD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25A713A24D
	for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 02:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983291; cv=none; b=uQi6XrbYL1V033eQg+hFvT9PwkfvM2omSSv+d6+IsNxufdBLaU5afeZCb5Xd2f9BeET4I19Lx+r7wdALVC5saeNQVABYz836ks99Podk3cn87PNsiQPMua8ODGrpxNQqItCq01YmEaqWhiJRWnudpza8vvis4t//QRLne//5H5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983291; c=relaxed/simple;
	bh=lFchxuWYdoChXXQRufyH2iiBvFGz6l9XBMUrcB9WM6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3g7zRbCFBIgw/fjhKCTlcFDowRmsBC24n6m1vvKTLHKi2BsZEx9IkfBXsvrGLAwXTGOSOjWJRsMBnbqcwQxfXz1dwFoytHsgjb5+RXAbHRvtSiuhh5MD1yQXpVMiyjbONzxriTu2pf44lO0nRiyff428p/GhqhUQVKTG/MsuaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=1i8Qj1aD; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7b35b1ca0c2so467411385a.0
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2024 18:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1731983288; x=1732588088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKaj8XArk4+aUuXdEGwzY4pbQVUlMNZ2d7arPW6y4hE=;
        b=1i8Qj1aDNF4uxJWABUlsRU+FF0C6L/RF1dPUlfAn7qIaGzW1QWQafGnWZAkCtMlbXg
         B+JiJ+azf9YEWyrVSjndIc8CVFgFuFuVMXxecjUSd/HpFLwtbtNGitbmdf8vYqJd6RXH
         CD2Kdt7Ss/oMqd8meI9zsYKLJpg5TUvFS38JY1A1YCmU2nnhnvKMOjH17Umf25B+NvqC
         Rh5VBnWxoEHtKcHqtkhp/VOR1I9JRZFBcBfjkrOTI8/KAOXGg5YP42ftmwrpX77EuqqT
         KiftiBlD3w8L3bKamDXtKo5GdLT3Pv0ZOgGB+Qj88pObGwH6Pug2zS+40RhwxVLAVv08
         FKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731983288; x=1732588088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKaj8XArk4+aUuXdEGwzY4pbQVUlMNZ2d7arPW6y4hE=;
        b=r4mMsVOjY/qVKDkw5pnyyuUmd8mbQsx7bQTJV/hcECjWIxz9ifs8XU52jyi3EDPVuu
         U8p/V//u7fIvBi7T2UUzreKnAoyDIjzDJh455QJsOCX+0fmJNVBT6n/rsyeZjpoGen9g
         7k9cFBPCq7GQGEHtGreoDUpoCPhDyAHpWJ1gdnsym593VT+D/p6UNWqigSIDcLlEjn+x
         TDO2hD+URl6HBnXig3n7XZGsabepSddBVeLIpcxoErNrmkyo3+fzGEvo+EqbxcF917Vk
         7nSDb4ZQaP/O5f5gBjNKeYsg606oBJPXh2Ni9/K7nQvouGY/5wXByns5Er5xpnOToSmw
         jlxA==
X-Forwarded-Encrypted: i=1; AJvYcCXyd8EgJWkHyu0GUBdLzjiyrFUsLcnxQE4zlJviWpD/P8BkuqTvHFg32orq0wo+H6SpcVq269s9FIm4@vger.kernel.org
X-Gm-Message-State: AOJu0YwiHWuoAVUixNugZiErHx65wM5MPaKkO5x2CUA365POTcIGTX/E
	CXXFAkMDqJ9hlHP0ao92eEcq1xoq/XJg8yTpvbBxDH1ykItKKvgnGLrBCyEi4A==
X-Google-Smtp-Source: AGHT+IEg3a2lAF/vb390FhGCGjUrHn5uq6t+rXalinv1TCOWJl5FeBErqn5lQsxGjjhYGbT4Vi/OvA==
X-Received: by 2002:a0c:f807:0:b0:6d4:1e3f:4367 with SMTP id 6a1803df08f44-6d42b8ff1d2mr25243446d6.16.1731983288645;
        Mon, 18 Nov 2024 18:28:08 -0800 (PST)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b37a8a9fdesm48293485a.124.2024.11.18.18.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 18:28:07 -0800 (PST)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <batrick@batbytes.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/3] ceph: correct ceph_mds_cap_item field name
Date: Mon, 18 Nov 2024 21:27:48 -0500
Message-ID: <20241119022752.1256662-2-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241119022752.1256662-1-batrick@batbytes.com>
References: <20241119022752.1256662-1-batrick@batbytes.com>
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


