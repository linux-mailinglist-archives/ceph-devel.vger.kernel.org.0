Return-Path: <ceph-devel+bounces-3802-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E2133BC7E81
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 10:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5B4E14FA424
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 08:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3EA62E0B64;
	Thu,  9 Oct 2025 08:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ew5zYcEq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383C62DEA6E
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 07:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996802; cv=none; b=UKKp7+mKyp4DL/taaOhkKdsadYbJxED2dyyiZPB46KJSvtOYSRq8msuKdeF61ityq2NR/0rtQKvuvAl22bXDMKgLQgAXFrp/9iXOjCxjeehxkOnUWr9vtWGj6/H3ugQeDQ4jfWrbExAni52NITQl2yVuZO1eytpjal/Bs91dd1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996802; c=relaxed/simple;
	bh=/cqQv1oOvMBB/gcvyCBa5YEa/IRjaQrlQOy43h9dHwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5n+IB/q+k0fAA3EKg4nfFUCvPUTMaDq+zzeTbCmwmDHvZdjlUvWAm/C4JXPJj9Mu0/k0rpT4tSWimfQLq9kafwcOX+MBhj8ksDsbR7ZagxK6QtGZX7xC8IQQGjSH7ZIka8QwqPP2oYSd3+N/VNW+qjszIJ2VwTd1mER5qdMcUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ew5zYcEq; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b3d80891c6cso269087166b.1
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 00:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996796; x=1760601596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vvnOkz4atcWA58/jQeeHXsdoEGYAYVoEEVQml2bbRs=;
        b=ew5zYcEqadDCdgfUV94LO5s5dKRdiH+8Dutj252LuqFpGQY3Al5ZbBAEvxojhptiJR
         rl1xUN4umLW6XOvHlxU5+c6ZWtUsAy892+6aOjsQFQX7m65Fc/ttE7TR+P/aAjdIyAGJ
         sH0REWKNY2CgVor/+4ZIgNyCRL0vbfKsMTxQpI8eMqJdIfvKp2d545gMdWLP0fJrLcMq
         qZ7b4bT1XKcWCCzKOi7AcqA0BgH6lD4E0YOXuX3O+1HvgRy0/V8bDlTgIgtGqJFf+lCb
         /mmt6jsAV9783xlDpf+hcOwio7PpIOL+M1MnEux3epL3MXBORiw04cOYKoM7fgZkuotU
         vw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996796; x=1760601596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/vvnOkz4atcWA58/jQeeHXsdoEGYAYVoEEVQml2bbRs=;
        b=UaAeAPEWV0fraVi+zMt/PO2PJxHsq9z5YN8hsVcit6Nv338RpSVcXw2i7yiFKl7ZWX
         28ZG2Yuu0yYgLv0zvqld52NJzrTasLkKu4CjlQin5doyy52QD6oTrh/iIenZMAzDbCJs
         wW2wCPxDZaDvzQMVLMeba2r4bqrwHMvUMLr8buKhLbo9LreLBByIh74VYg1zHGqIbo3V
         daUgmUhUSvpZSQnEdoc2cL121iCwdPPvl59cRlBfAxZeOyjkHwx9HjP0xNOzike7v9ZT
         OQ79tUGoXOMZR4fWZQrFfIiyp0eHSduW1QVtAXnZ7SuBvxDSb753uaMXZJXSSxtl6oGP
         w3fA==
X-Forwarded-Encrypted: i=1; AJvYcCVnjQb7LnYjmFnrraUsfTM6htZUtmWwiF3uPOALMKcFtivsh2GLGRzTN81JJ/LOc5hMVnhH0Kccekq5@vger.kernel.org
X-Gm-Message-State: AOJu0YxAr72Sb9ENmEsxeaGKyHLhNQ7HHKs5cpK+ibt/eKjWmaqy+AK7
	BHTR+b32r6oJyB6c3Gyu97mOHvr9pF8SVXEnXx2/V/K+Ef47DfvIKLPC
X-Gm-Gg: ASbGncsQoZBwoGScOdwV5SZxZQa5cAAPUTf1VKdWVy2aHGKzRQeHXbe+jnDVVe0as9j
	ywQN0XT81upJRCPs+YFS1T4xs3zkbBf7sqBwctgw0Mf9XHD3Ii18x6/T8L+43sQVmN6Nrw70Z9x
	OYPlonE8qegWX2L5YgGJLI9SyNN0LIT1bYxCurDdy7XLvI6ErJ3ny+FjfT/TPH14l80blc+YdZ3
	q1X8A7bfRDk9cpu05qlAIo2L0kxlbSZI7iHAKyX/mTcNleHsaUBKXL2K4vb4FnaH2vUgeH56cue
	JI6wGiyRo8qF3eDYDqYdbtlYojnZqKdEuchNqH1SF+xuRyEX7XHQtSniK341zROKAiXKrVFFG7X
	lKijYKl6L4+LYjgsUcaJ8VBlvpwwAxGqBU3GsGq/QTtgR+2mFMyScSqS6vRI0DeOHhFrdW0pM17
	GiPvEpHJXddeX1AvVxBLzxMqh+zVlyOnbL
X-Google-Smtp-Source: AGHT+IFk+plQU3gbT8WHeH+M0VCYeK9zkslYVYbphoqJ8EvM8SjW4SFtpg6ttNALumPDiCOlAkCHiA==
X-Received: by 2002:a17:906:f58c:b0:b50:a87e:efe5 with SMTP id a640c23a62f3a-b50bedbf41fmr714239766b.19.1759996796348;
        Thu, 09 Oct 2025 00:59:56 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:55 -0700 (PDT)
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
Subject: [PATCH v7 10/14] gfs2: use the new ->i_state accessors
Date: Thu,  9 Oct 2025 09:59:24 +0200
Message-ID: <20251009075929.1203950-11-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009075929.1203950-1-mjguzik@gmail.com>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

cheat sheet:

If ->i_lock is held, then:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign_raw(inode, I_A | I_B)

 fs/gfs2/file.c       | 2 +-
 fs/gfs2/glops.c      | 2 +-
 fs/gfs2/inode.c      | 4 ++--
 fs/gfs2/ops_fstype.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index bc67fa058c84..ee92f5910ae1 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -744,7 +744,7 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
-	int sync_state = inode->i_state & I_DIRTY;
+	int sync_state = inode_state_read_once(inode) & I_DIRTY;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	int ret = 0, ret1 = 0;
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 0c0a80b3baca..c94e42b0c94d 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -394,7 +394,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	u16 height, depth;
 	umode_t mode = be32_to_cpu(str->di_mode);
 	struct inode *inode = &ip->i_inode;
-	bool is_new = inode->i_state & I_NEW;
+	bool is_new = inode_state_read_once(inode) & I_NEW;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr))) {
 		gfs2_consist_inode(ip);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8a7ed80d9f2d..890c87e3e365 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -127,7 +127,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 
 	ip = GFS2_I(inode);
 
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_once(inode) & I_NEW) {
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
 		struct gfs2_glock *io_gl;
 		int extra_flags = 0;
@@ -924,7 +924,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_dir_no_add(&da);
 	gfs2_glock_dq_uninit(&d_gh);
 	if (!IS_ERR_OR_NULL(inode)) {
-		if (inode->i_state & I_NEW)
+		if (inode_state_read_once(inode) & I_NEW)
 			iget_failed(inode);
 		else
 			iput(inode);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index aa15183f9a16..889682f051ea 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1751,7 +1751,7 @@ static void gfs2_evict_inodes(struct super_block *sb)
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) &&
+		if ((inode_state_read(inode) & (I_FREEING | I_WILL_FREE | I_NEW)) &&
 		    !need_resched()) {
 			spin_unlock(&inode->i_lock);
 			continue;
-- 
2.34.1


