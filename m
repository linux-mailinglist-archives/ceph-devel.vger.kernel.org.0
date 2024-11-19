Return-Path: <ceph-devel+bounces-2177-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB919D1E42
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 03:28:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50D351F22B2D
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 02:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF243147C71;
	Tue, 19 Nov 2024 02:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="b/IKcUX0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EBA1459FD
	for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 02:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983293; cv=none; b=WuR7Y93DZgIAzucAOTkK5KLlZmMWNjlOVbbMbm0e7EdQ1CwjyzNs787jUuJykoRt+tiMC0JoWjN0TXex/3mxFU+Yb4C5NdUHFr9M0/A4XTVFqAGIKE1DRoobLfDgKqVTc+B3A6sCzWvEVj0JwVKyC5yx1bBFO8gRXX34jKIKm2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983293; c=relaxed/simple;
	bh=j5OqzA808wGEP+bKAmEuOLSp0ilqpAKOPXYB3RrPwFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUHfqeuuPYo6INfniFoBvEauKHkDqTdtv39CwseJZSkzn3vPghttRTib3iADf3Ed7g1EppFRE5ZCDyqfec4qUNFcN1RLA7G7rIbTYYz57z9a53ALjlsDI9my4pgXZ0nwqlkSIyjUvVJw0h7GBnVqrNBavh1B65CVpdVHbEM18Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=b/IKcUX0; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7b15d7b7a32so27765685a.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2024 18:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1731983291; x=1732588091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LoKHGpIVEQElQT2i7Eoq44Yb2XIPlFWQJI91QoJIm0s=;
        b=b/IKcUX0tRAWD5TRB1/DNmfYSqO98lSamyIbrqnB0QiGTpJ8436ZoVPgEQhPGrkZ29
         lKQFspam66NKrjknzL2sZniohNvFx1BSnODZJuZRPTtQoM8D5VvVLETr0vJ1vTLWBV7Q
         a98lspKvvWsmJk4B1nugxbi4toFRsCSJkiY20TUJ6GSwink85BAjeIvegLGEQxGG3ezH
         PL/+RWcnfmaxp0NumjDbwABKpBnR6h6dDNgJ15b8n1ihGQV2qOuSpcQQXcnWw8xdUJ9A
         wJkv/FGwIk+cz1j9+uFfRJnzYi0EFUMlGi+w6s6JroZjGhpVqHBTFsJAwNhPe9uebYS3
         Jigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731983291; x=1732588091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LoKHGpIVEQElQT2i7Eoq44Yb2XIPlFWQJI91QoJIm0s=;
        b=c/C58wsMvV2In86ZyUsENnb/fnLn4joT7c1jMGwkTMcm1IbNneESaGQTMg6iZmMIED
         WNLPjOQM7BMK4ApArqh7dI7Nm4At8VLxgx3dFTMMGM3BuuwMi3guNwIyvv4Xo5pSaYKf
         4qUJSu4CoDhjbxIL7wHpLKrk63UQEKMnwbkorDrcI0QNhUxwJlMKaPPn7YGqHDcOYrIM
         yQRhIjEmcPd36mBTqHErR1kclONnVRYplnco/6gDSRT9lcrCjkvOws6fbEviWfxU7Fqd
         RlWugYTKyihF2hNuoixosP3lj0LcBWHlt2a5DDN7OuUCpC3OzWH56K/UOlkAmHHJ63CT
         lFpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUX0RDtt+b6y7mZFb7mOqn0Eayho1DHqsKTL5Xog4fyk5wTHCxdD0qnd5jX6JtZsWidlliAOJYcHQJT@vger.kernel.org
X-Gm-Message-State: AOJu0YxnKymcOG6JPoW1LawgcyXoCHsePYM/rHZhOzcRZfcV20yQsC3J
	/tnZLdnqjIvYRlc73Vg74v72eIfuEeDpkpSCT5AkKKEthQlOcH5uuQo+XpgCOQ==
X-Google-Smtp-Source: AGHT+IH24L6W1WFxX10+OPV06uTEfQ35DE7BpeSJuTuXfhwSsQwDw7jOTD7+koW8z0c9fbohlEJ16w==
X-Received: by 2002:a05:620a:1a18:b0:7ac:b3bf:c30b with SMTP id af79cd13be357-7b3622ce775mr2170267885a.32.1731983290965;
        Mon, 18 Nov 2024 18:28:10 -0800 (PST)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b37a8a9fdesm48293485a.124.2024.11.18.18.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 18:28:09 -0800 (PST)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <batrick@batbytes.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/3] ceph: correct ceph_mds_cap_peer field name
Date: Mon, 18 Nov 2024 21:27:49 -0500
Message-ID: <20241119022752.1256662-3-batrick@batbytes.com>
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

See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_peer field name".

See-also: https://tracker.ceph.com/issues/66704
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/caps.c               | 18 +++++++++---------
 include/linux/ceph/ceph_fs.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bed34fc11c91..27410bc9ce15 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4086,17 +4086,17 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 t_cap_id;
 	unsigned mseq = le32_to_cpu(ex->migrate_seq);
-	unsigned t_seq, t_mseq;
+	unsigned t_issue_seq, t_mseq;
 	int target, issued;
 	int mds = session->s_mds;
 
 	if (ph) {
 		t_cap_id = le64_to_cpu(ph->cap_id);
-		t_seq = le32_to_cpu(ph->seq);
+		t_issue_seq = le32_to_cpu(ph->issue_seq);
 		t_mseq = le32_to_cpu(ph->mseq);
 		target = le32_to_cpu(ph->mds);
 	} else {
-		t_cap_id = t_seq = t_mseq = 0;
+		t_cap_id = t_issue_seq = t_mseq = 0;
 		target = -1;
 	}
 
@@ -4134,12 +4134,12 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 	if (tcap) {
 		/* already have caps from the target */
 		if (tcap->cap_id == t_cap_id &&
-		    ceph_seq_cmp(tcap->seq, t_seq) < 0) {
+		    ceph_seq_cmp(tcap->seq, t_issue_seq) < 0) {
 			doutc(cl, " updating import cap %p mds%d\n", tcap,
 			      target);
 			tcap->cap_id = t_cap_id;
-			tcap->seq = t_seq - 1;
-			tcap->issue_seq = t_seq - 1;
+			tcap->seq = t_issue_seq - 1;
+			tcap->issue_seq = t_issue_seq - 1;
 			tcap->issued |= issued;
 			tcap->implemented |= issued;
 			if (cap == ci->i_auth_cap) {
@@ -4154,7 +4154,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		int flag = (cap == ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
 		tcap = new_cap;
 		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
-			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
+			     t_issue_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
 
 		if (!list_empty(&ci->i_cap_flush_list) &&
 		    ci->i_auth_cap == tcap) {
@@ -4268,14 +4268,14 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 		doutc(cl, " remove export cap %p mds%d flags %d\n",
 		      ocap, peer, ph->flags);
 		if ((ph->flags & CEPH_CAP_FLAG_AUTH) &&
-		    (ocap->seq != le32_to_cpu(ph->seq) ||
+		    (ocap->seq != le32_to_cpu(ph->issue_seq) ||
 		     ocap->mseq != le32_to_cpu(ph->mseq))) {
 			pr_err_ratelimited_client(cl, "mismatched seq/mseq: "
 					"%p %llx.%llx mds%d seq %d mseq %d"
 					" importer mds%d has peer seq %d mseq %d\n",
 					inode, ceph_vinop(inode), peer,
 					ocap->seq, ocap->mseq, mds,
-					le32_to_cpu(ph->seq),
+					le32_to_cpu(ph->issue_seq),
 					le32_to_cpu(ph->mseq));
 		}
 		ceph_remove_cap(mdsc, ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 4ff3ad5e9210..2d7d86f0290d 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -808,7 +808,7 @@ struct ceph_mds_caps {
 
 struct ceph_mds_cap_peer {
 	__le64 cap_id;
-	__le32 seq;
+	__le32 issue_seq;
 	__le32 mseq;
 	__le32 mds;
 	__u8   flags;
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


