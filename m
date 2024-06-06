Return-Path: <ceph-devel+bounces-1277-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D81418FF2BC
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 18:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B1532891AB
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 16:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6CF198A19;
	Thu,  6 Jun 2024 16:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="LCzVh+sV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E4917BC9
	for <ceph-devel@vger.kernel.org>; Thu,  6 Jun 2024 16:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717692130; cv=none; b=klsZoXITNvfzvV60llIWpKIepZyKP+qT6VGDBd1CPeHfyloAffoKUe6VQ7OYgH728OIPFuBcPinYBC5utop4BqZs7hRm+6wqCv+6KiXrTeAc69fD0w7BSOKZBTn661HEDqBwD7V6dycpfbQIFMxNVc4ZrtjBT+v4pp5Hf7dhVWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717692130; c=relaxed/simple;
	bh=ZRNfyg/9QgeO3gss2GzH/5lgQLFM3FF9Hna9vq7/wuA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rOBvIGj8gTilwhzPsfQAsV5au28HeKv5Z3FIgw3fl6x6y2EBMEiH2M8RaLNPdvHqlQR0VAuCNDQsQelSbTvxwIcjAEW2u1pvORgB7ArlEgB5IdzLKZrz/C7RYGTxXOWsdoMh5jOXIiC55SYNyc+uHEZFJ0OQNw7EyCt1/YYtWeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=LCzVh+sV; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57a2f032007so1493340a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2024 09:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1717692125; x=1718296925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KWNindFIaZB1HTMS5OMX0T5eIKkBoU4yCP7CEwF9Bsg=;
        b=LCzVh+sVi4j+dFc5vM+617+Ey5nt535/Z3ZfEcFCt9YOm5AD4gv7nteljTsXANoazc
         3tn6k9481ql2El2XSV824BW7y5OEaT9nAukscsOQMG82Sxnr1SUJ8mN14ZxPtDHzRKhG
         SIh/yDkow1TUNIRmMjbN71LHKuvavqrYUGU/29djsogQ8zHoqTSXLuF6YhI4OQpVa6tA
         zE0wFubbrfvli++xgVaQgFcyYMKI7djIvmosjsIyBW44FWEhMeSteeAQVgJA02wdpFoG
         5+3+f8ibQvmvE+Ch22WY9aMWvRJ3p5rc7dDy22spDB5V1uXYeIExQyFj4ZlLrmIjQLBX
         cP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717692125; x=1718296925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KWNindFIaZB1HTMS5OMX0T5eIKkBoU4yCP7CEwF9Bsg=;
        b=MSJnLyr3Nm0OCFAtMz7x5kv0QOC2OMalvgwL5KJCPnrXaOe1dqkBUmHdiCKsOujWnM
         vA091YfT0rIjk5MhYRGTQSdZ41lMFP8LdJfqaSFFqUyiXfChISiI0owhgEXPT9zAxoqU
         VVDhf3OHfSMVA5humvo11ja8CjKVrAC6HlQutyauyxVXwA3XIUGnz6AY5yekgwcUtGBM
         eB5xuM3KW3pHrHmgvn7vL9Tfmx0RaNvD67A+4Ms1EMa5IfwFmzv6C78awbp7xgIJ8h8j
         VajOCb9Dw69PJxc2x/Yy1Xn0N4z7gWVfyri+SILU5zlux7tGNMPpbTqZugXxW/tErEmn
         LLaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0zYe592eqQR/R8WN93wkVDUPcKG74fcQuLzEv8kc/Dqgauv+GwBTHxeoQwE5EHlybgkes9MTmT5WeWdSaXK2LvZ6LgD+RkzTBzQ==
X-Gm-Message-State: AOJu0YyN0xKRvkrzxoYcEI84bbQDu7qXc0Csxcw9ub9MYQkpoG2ljJ5k
	3+TaaLqgjvN0sLAwhDiHg0HDq1cHrV9r/cP/tM9yWeOpBJ0EaImFokkMwGSWaD4=
X-Google-Smtp-Source: AGHT+IGezYB/CP2cKfOnUTPtY92b+O/1mJo3K5LLRIqQOWwVekjh9HlCAC/3Rn7sQArIvZjoyd3fGQ==
X-Received: by 2002:a17:906:fb0e:b0:a69:1137:120a with SMTP id a640c23a62f3a-a6cdb0f5646mr6187166b.51.1717692125468;
        Thu, 06 Jun 2024 09:42:05 -0700 (PDT)
Received: from raven.blarg.de (p200300dc6f0efb00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f0e:fb00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c806eb099sm118003766b.102.2024.06.06.09.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 09:42:05 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH] fs/ceph/mds_client: use cap_wait_list only if debugfs is enabled
Date: Thu,  6 Jun 2024 18:41:57 +0200
Message-Id: <20240606164157.3765143-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only debugfs uses this list.  By omitting it, we save some memory and
reduce lock contention on `caps_list_lock`.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/caps.c       | 6 ++++++
 fs/ceph/mds_client.c | 2 ++
 fs/ceph/mds_client.h | 6 ++++++
 3 files changed, 14 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c4941ba245ac..772879aa26ee 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3067,10 +3067,13 @@ int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
 				       flags, &_got);
 		WARN_ON_ONCE(ret == -EAGAIN);
 		if (!ret) {
+#ifdef CONFIG_DEBUG_FS
 			struct ceph_mds_client *mdsc = fsc->mdsc;
 			struct cap_wait cw;
+#endif
 			DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+#ifdef CONFIG_DEBUG_FS
 			cw.ino = ceph_ino(inode);
 			cw.tgid = current->tgid;
 			cw.need = need;
@@ -3079,6 +3082,7 @@ int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
 			spin_lock(&mdsc->caps_list_lock);
 			list_add(&cw.list, &mdsc->cap_wait_list);
 			spin_unlock(&mdsc->caps_list_lock);
+#endif // CONFIG_DEBUG_FS
 
 			/* make sure used fmode not timeout */
 			ceph_get_fmode(ci, flags, FMODE_WAIT_BIAS);
@@ -3097,9 +3101,11 @@ int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
 			remove_wait_queue(&ci->i_cap_wq, &wait);
 			ceph_put_fmode(ci, flags, FMODE_WAIT_BIAS);
 
+#ifdef CONFIG_DEBUG_FS
 			spin_lock(&mdsc->caps_list_lock);
 			list_del(&cw.list);
 			spin_unlock(&mdsc->caps_list_lock);
+#endif
 
 			if (ret == -EAGAIN)
 				continue;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c2157f6e0c69..62238f3e6e19 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5505,7 +5505,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
 	mdsc->last_renew_caps = jiffies;
 	INIT_LIST_HEAD(&mdsc->cap_delay_list);
+#ifdef CONFIG_DEBUG_FS
 	INIT_LIST_HEAD(&mdsc->cap_wait_list);
+#endif
 	spin_lock_init(&mdsc->cap_delay_lock);
 	INIT_LIST_HEAD(&mdsc->cap_unlink_delay_list);
 	INIT_LIST_HEAD(&mdsc->snap_flush_list);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index cfa18cf915a0..13dd83f783ec 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -416,6 +416,8 @@ struct ceph_quotarealm_inode {
 	struct inode *inode;
 };
 
+#ifdef CONFIG_DEBUG_FS
+
 struct cap_wait {
 	struct list_head	list;
 	u64			ino;
@@ -424,6 +426,8 @@ struct cap_wait {
 	int			want;
 };
 
+#endif // CONFIG_DEBUG_FS
+
 enum {
 	CEPH_MDSC_STOPPING_BEGIN = 1,
 	CEPH_MDSC_STOPPING_FLUSHING = 2,
@@ -512,7 +516,9 @@ struct ceph_mds_client {
 	spinlock_t	caps_list_lock;
 	struct		list_head caps_list; /* unused (reserved or
 						unreserved) */
+#ifdef CONFIG_DEBUG_FS
 	struct		list_head cap_wait_list;
+#endif
 	int		caps_total_count;    /* total caps allocated */
 	int		caps_use_count;      /* in use */
 	int		caps_use_max;	     /* max used caps */
-- 
2.39.2


