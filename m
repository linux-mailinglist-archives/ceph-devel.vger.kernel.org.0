Return-Path: <ceph-devel+bounces-3616-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B16BB5986F
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 16:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F87E3AC2AF
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 14:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2DC32F75B;
	Tue, 16 Sep 2025 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzHK56T4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142CF30C616
	for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031177; cv=none; b=luMquBiEjj6fgaoVBZ6UeESYav57PeDxOALpg++TIVd1Iirpd/85SSX/0PFSxlhlRdJAFHFcoA0KagdKZWEDllzszGxkGN/NzE+ilxPD81dReNazeJ7e8uSoJ06Oicm5Lfl1K8kgyYGIoBOpw73SNJQHadb+UWQcnghUR/77HFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031177; c=relaxed/simple;
	bh=4ZH9W3P+XiG/Sp7tBDITc58g7he5Ng0NmNakO8szh+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2V0bCvuO8LeV1sH1q4x7GZ6+BjdTK93c/8HjWG2pUreQCbMLrFGx5FgsEB8keky7rKbR/N8omzt/IGQei319UGP2d592gqtwVgZhJGM7L8Vo56UQnEVuWCa288GRk4rbOjWEFwObUWr0z+YRY6gpqtfsuK0+Mx1BanV5SkmX4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzHK56T4; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dd5e24d16so52697045e9.3
        for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 06:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031174; x=1758635974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhJbct8Hpn8FASNagja9p1KxL0ag1VLHqziGZAwrXc4=;
        b=NzHK56T4Gc9JTM6H5ShPFQQhyyD1KBGLZZDgYq4XZa1aMIo2n4DP9S0SqtZSlgWAel
         URh6NqbNPTAC0XBYWmTWUCNq3f7yIBNCgTDGy30CRsnWD3N6BeCrDUdCf8AY1Jy0sxfs
         WxF4HDJQyHIVnXBszwq0VmZmX6SitvC+7rsMYWXwI9n075Gotqh9WWoCi35qff0KJekl
         vzrjUrDNBpGx9Ytd4bcUK8NHqrUw/DQeUDJF/Nrmm/urXLiciDnr62isLxnvHErkwNE9
         ChRWElykA0Gkfi8CJCeridEoKr/rNMWmUrWzXUSrCFAYe/597o+/Dg7K3iJmLIkP7uTy
         7GFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031174; x=1758635974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EhJbct8Hpn8FASNagja9p1KxL0ag1VLHqziGZAwrXc4=;
        b=e5HXVUZt4toxulI4l519l80XqAm2iNz5HEWcGJzntXZWrmzr7bjsg5tvrJsVIUUmff
         ZkJQD4DfP1jP/saQ++LATjcCRdKdHGRNtsxo4rkJiDUGk71hwH6IKov/4XgE1wYRLhg4
         ARSE0mBMKzHUDcpp4YR1XCgHe92GoJa5DFIv6EZyw6gfKzyfAFaETpAopO9Zsnuh4FJk
         19AtNLIkrjtPGG1pXdyQNwr0tLVNTMsOnRyUqADECTSV5ecD8hUTV5SMRboXsfzkitQs
         EVZiGPEKtTENW4nTonl8qBO5t4JwVsgHHdn12e3Mm8b1Igvb3fcYnzzQFOf0aQ6wtHih
         PRVA==
X-Forwarded-Encrypted: i=1; AJvYcCWpPNAo4FOrhxVsApphkmO4iSj+qMRsZOeR6MUdBZczXGVT//ayktsj7lLoA3pP7Xw7ojy7xz/w7stR@vger.kernel.org
X-Gm-Message-State: AOJu0YwTmnc/Hw3Xmp0uW3QTCCBhotglDeN/M2l1zL61GPzFaFiIkuME
	zTHjurkqGlk2nvoQCGDJ7TIRuNMfBY6Bcm74JvbQgWtehNvqw8X0PF+N
X-Gm-Gg: ASbGnctdumrCunpOFPZWXesEhlTcnKuYHSEeIbfbZyzbkQMrg6ah7YP15bif7jls4B4
	wlco5BYhE7l4xfstXc21rKRER3q1lYVBLqpGF8FyuSzPY3Zk1gmzFjCoYluOhyd3NaVKCBMaieb
	LoDeEapPc8I+BgNFK2m+RcueAQCNv7ZQ4n+OE4/n+H5eMxwJ4cqM4T6fsxcgyMNMpYjW2gWblbe
	QYWWrohvOLSlizcvHVd1LtSSgxJcPxjuSCvVzR3OUXwFGptC2oEMcIrc74AYA3y1cFUQLDNoTuI
	DGMvZjzcy3+lrNpqsH+6bbDkQaJmOGALswLWyuZPT+4DQrbiDaNlbSnY3E+oftlMJi4IVBTJvlw
	F45yYsVOjTQr3sSK/uXU2RZbJfqhIQ7+r+9rlGO4aE9C1XP0PYTEq0Haf3riWEKt85sQyW+Kq
X-Google-Smtp-Source: AGHT+IEv/yp+v5i4wDZD8rx/vzr2v/aCCUSPqPNX1ISHbufqpWah1qF1v3yMiZroJvxSpOFaPBPDfg==
X-Received: by 2002:a5d:5d01:0:b0:3e1:734b:5393 with SMTP id ffacd0b85a97d-3e7657b6a36mr14835320f8f.28.1758031174218;
        Tue, 16 Sep 2025 06:59:34 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.06.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:59:33 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v4 01/12] fs: provide accessors for ->i_state
Date: Tue, 16 Sep 2025 15:58:49 +0200
Message-ID: <20250916135900.2170346-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916135900.2170346-1-mjguzik@gmail.com>
References: <20250916135900.2170346-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

In order to keep things manageable this patchset merely gets the thing
off the ground with only lockdep checks baked in.

Current consumers can be trivially converted.

Suppose flags I_A and I_B are to be handled, then if ->i_lock is held:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_add(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_del(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_set(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally, add "_once"
suffix for the read routine or "_raw" for the rest:

state = inode->i_state  	=> state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_add_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_del_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_set_raw(inode, I_A | I_B)

The "_once" vs "_raw" discrepancy stems from the read variant differing
by READ_ONCE as opposed to just lockdep checks.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 59 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4fd010cf5bf..d54171f13c7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -756,7 +756,7 @@ enum inode_state_bits {
 	/* reserved wait address bit 3 */
 };
 
-enum inode_state_flags_t {
+enum inode_state_flags_enum {
 	I_NEW			= (1U << __I_NEW),
 	I_SYNC			= (1U << __I_SYNC),
 	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
@@ -840,7 +840,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_t	i_state;
+	enum inode_state_flags_enum i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -899,6 +899,61 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	lockdep_assert_held(&inode->i_lock);
+	return inode->i_state;
+}
+
+static inline void inode_state_add_raw(struct inode *inode,
+				       enum inode_state_flags_enum addflags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | addflags);
+}
+
+static inline void inode_state_add(struct inode *inode,
+				   enum inode_state_flags_enum addflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_add_raw(inode, addflags);
+}
+
+static inline void inode_state_del_raw(struct inode *inode,
+				       enum inode_state_flags_enum delflags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~delflags);
+}
+
+static inline void inode_state_del(struct inode *inode,
+				   enum inode_state_flags_enum delflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_del_raw(inode, delflags);
+}
+
+static inline void inode_state_set_raw(struct inode *inode,
+				       enum inode_state_flags_enum setflags)
+{
+	WRITE_ONCE(inode->i_state, setflags);
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum setflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_set_raw(inode, setflags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.43.0


