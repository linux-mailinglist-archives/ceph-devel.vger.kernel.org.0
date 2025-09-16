Return-Path: <ceph-devel+bounces-3626-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DA9B598D6
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 16:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5609188DF48
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 14:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA25836209B;
	Tue, 16 Sep 2025 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxR8ybYu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3145D35E4FC
	for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031208; cv=none; b=febmEM6CT/h8DH+SrG+GQHMxyTVOqQoHZ7gpRyeSsmsCPy6josS6dv/MH2p3FmXiZnmuXhMZzyxf3NZc2VlZk1mWB1wxt4Ik0tleSPctOFk/0kBKCTV2fMga80NG9bfGWGBFsTuA/c27gY7p2ewBRE0F0LC/PHXgRG5CpzcgQsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031208; c=relaxed/simple;
	bh=9uB5tIoSu0Ihqwy/dzzpF33dCVQXqPEjiR4jiBdlE6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZ1RepqQKI5rE9E8ghgDC+62fDvsD4LEmNOqMo/YqMO8SiGNz+Kjh/qYR+viKuHfrqMWLBGEKeHyRabv5Iua10iUPExcPVqGZXJPUUDJH4/K62BeEgjT8FZGQQZz5AIlPQtQfLnUycWu2ru/F1xt8noMvhePdGxJTx6JR9uwWZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lxR8ybYu; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b9a856dc2so34723705e9.0
        for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 07:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031204; x=1758636004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jXBWCescUObzsT6Su0exTy7Btg138NHvbE5HLT4Jeo=;
        b=lxR8ybYuXYa9qNaTZ+hqKLsxR/u6BY6zzV/gtp4yDl4JzRW+ztA7qdJaNySrU8LmcZ
         +FSmJWBbnjLDWgyo81qjnG8LLkp49YRNdYlJqvcNLp1+zhsno83coVbLSowVmYzeurvP
         XsYd6YlG2dkp1qWYP1If5nmE0BPIBxlP6+3WVOfS6fWAMuJASV8e6HHvYe6qc7kxCtMz
         5HAaBdC8JUnGb9Wy/Tj8Fc6l2KcFMwegRHdlBFMG2gPhJIngXhaUXjdOvXzJA8ybaSYe
         J3/HVLwK1FojmIoSbCzAg99/Fl9poOSdGL8rtQSt6SG5a0ebPl6+1AKIxIWjjcXLmRom
         jeCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031204; x=1758636004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jXBWCescUObzsT6Su0exTy7Btg138NHvbE5HLT4Jeo=;
        b=Sy9xx4C/NUWjUEybWpPNMuLCWXqBq/oy7FhkZt4stCfjBPee3/jWAflvkOUM4LFp57
         U6HFqX5OTK97E9I8tneDnuj4Ck6mh5OfIqBa/fMqpDZ1yE/Tukh1QbXkl+2687WrPboz
         K8lxAtZvytt05pFx6iEZhFPHwjylmo33U+/VnhIC+YTaL9uChriYLe7leSRSFbEgPEAv
         OKpUVvttJRzI/t0D1iHeisNQuV7iVlXZI+GCfzLIqPuEm/DpjxeX/Jp7jBnLC37NTXZY
         xWztjRVcI4633C3CdiJX3RqWW+xR63l32qh0tRpWkrjgps5KqQsqXzyeHsoyvth8+K/q
         MW+w==
X-Forwarded-Encrypted: i=1; AJvYcCX4/ofCk5uEfqfOzSwIVd5JCysIADP78sy5U92X073olyrRGbPjIDsaLBIZkzAjCZB3Uom969BfRHQb@vger.kernel.org
X-Gm-Message-State: AOJu0YzKtQ+wStWUdV6epBUG9M4bxxoiMpp9Fb1+e2Pe2Rmx1K1MVbpn
	FEGrTY98NyH+z1OGnFwhQb1J7ggR/o2qi1HguBv/fmxhrk2RupZ9jTsX
X-Gm-Gg: ASbGnct2H1mLuBZJb/KZFU8D9mU2jXEHcWejaeJy4rCaablvNHLC3OcJE+RXbz3HxyF
	/S1K+lCSuD36uv3RYSEhq5EZvStYYJe4I6knwGr+rIcqqFXkMl0OS1oXBiykQcKqLQSQkg763oy
	0oAE8/t/+zt5GnS9vBBSP8wxPph0RlMZUC1bw51QnXp2IAdVfLixeWANvz+DwMNVWe/osWNCZ4b
	iSujYZPcbTsOwtiq5BycDqVgLniIkQCx5NxBEr/oIDsVp2bgMBoN70ujK9NbxvK0d3Tli+uXDwY
	eKFWdH18Jl4Tf/8EBz7D7V5Uu1LFlN+G26WJVezDHq4FxbjpsVqSdPPnXeLwvasvJ9tVSqsiPs1
	uHLZsEyzZCOZY2UYOYww5PNYiB6SbCEc6FNNrToH70Ylsi/KwBJY3JuGqR4JJMTtFwEPtfHR1
X-Google-Smtp-Source: AGHT+IHwPsVwzVQ+3BwThlohyBuVsh7mtJyWbIwjAmCzyS+IiOJcg7GYx0sFvI9t/faLf/pLubt0LQ==
X-Received: by 2002:a05:600c:190f:b0:45b:4282:7b60 with SMTP id 5b1f17b1804b1-460614f9f91mr11287815e9.34.1758031204161;
        Tue, 16 Sep 2025 07:00:04 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.07.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:00:03 -0700 (PDT)
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
Subject: [PATCH v4 11/12] overlayfs: use the new ->i_state accessors
Date: Tue, 16 Sep 2025 15:58:59 +0200
Message-ID: <20250916135900.2170346-12-mjguzik@gmail.com>
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

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/overlayfs/dir.c   |  2 +-
 fs/overlayfs/inode.c |  6 +++---
 fs/overlayfs/util.c  | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 70b8687dc45e..eb3419c25dfc 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -659,7 +659,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		goto out_drop_write;
 
 	spin_lock(&inode->i_lock);
-	inode->i_state |= I_CREATING;
+	inode_state_add(inode, I_CREATING);
 	spin_unlock(&inode->i_lock);
 
 	inode_init_owner(&nop_mnt_idmap, inode, dentry->d_parent->d_inode, mode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ecb9f2019395..3f7ef3dae5e5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1149,7 +1149,7 @@ struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir)
 	if (!trap)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(trap->i_state & I_NEW)) {
+	if (!(inode_state_read_once(trap) & I_NEW)) {
 		/* Conflicting layer roots? */
 		iput(trap);
 		return ERR_PTR(-ELOOP);
@@ -1240,7 +1240,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		inode = ovl_iget5(sb, oip->newinode, key);
 		if (!inode)
 			goto out_err;
-		if (!(inode->i_state & I_NEW)) {
+		if (!(inode_state_read_once(inode) & I_NEW)) {
 			/*
 			 * Verify that the underlying files stored in the inode
 			 * match those in the dentry.
@@ -1299,7 +1299,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	if (upperdentry)
 		ovl_check_protattr(inode, upperdentry);
 
-	if (inode->i_state & I_NEW)
+	if (inode_state_read_once(inode) & I_NEW)
 		unlock_new_inode(inode);
 out:
 	return inode;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a33115e7384c..cfc7a7b00fba 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1019,8 +1019,8 @@ bool ovl_inuse_trylock(struct dentry *dentry)
 	bool locked = false;
 
 	spin_lock(&inode->i_lock);
-	if (!(inode->i_state & I_OVL_INUSE)) {
-		inode->i_state |= I_OVL_INUSE;
+	if (!(inode_state_read(inode) & I_OVL_INUSE)) {
+		inode_state_add(inode, I_OVL_INUSE);
 		locked = true;
 	}
 	spin_unlock(&inode->i_lock);
@@ -1034,8 +1034,8 @@ void ovl_inuse_unlock(struct dentry *dentry)
 		struct inode *inode = d_inode(dentry);
 
 		spin_lock(&inode->i_lock);
-		WARN_ON(!(inode->i_state & I_OVL_INUSE));
-		inode->i_state &= ~I_OVL_INUSE;
+		WARN_ON(!(inode_state_read(inode) & I_OVL_INUSE));
+		inode_state_del(inode, I_OVL_INUSE);
 		spin_unlock(&inode->i_lock);
 	}
 }
@@ -1046,7 +1046,7 @@ bool ovl_is_inuse(struct dentry *dentry)
 	bool inuse;
 
 	spin_lock(&inode->i_lock);
-	inuse = (inode->i_state & I_OVL_INUSE);
+	inuse = (inode_state_read(inode) & I_OVL_INUSE);
 	spin_unlock(&inode->i_lock);
 
 	return inuse;
-- 
2.43.0


