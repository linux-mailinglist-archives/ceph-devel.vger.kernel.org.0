Return-Path: <ceph-devel+bounces-3793-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CA9BC7D93
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 10:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB024189F57A
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 08:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE0E2D248D;
	Thu,  9 Oct 2025 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMirGicO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19FD2D12F3
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 07:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996784; cv=none; b=hSkA2PE3gAU8eIM4sXID46h1KqXFGTqX+Tsa8MBUi3XHeK2+Iy52Rml3fuwiuvvlurVwguYmZZ4IiKdWvXdWcwVJUuySaHcfCrk0k6nhHYXZZX1EPXyMZ5kglPMCxnv2z7bKPY+fatjZiS5QJeFdkz0idi15UVQosjgc3X0Ay0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996784; c=relaxed/simple;
	bh=hn/T4KF427I5vM1FE3EEQtD8Ky5WVe1EdG5AuHI54+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4m3qEzeFb7A5FIMFtlSAStVgJhy7ar2u814onvR60RLlZRzbOE9SZtRUSigF/ghkZE2sXADEBybK1Lr19hAor64GH2qt8vxmXKODhcJbkh7RlqTWKXaa9RDM7fTofqWl/6wquXAEmIKwdmnBV1XsK2FHc+jsKzYCLYAwbRFjbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMirGicO; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7322da8so111555066b.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 00:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996781; x=1760601581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v56yGNQ37Majx7vHh2h4KlxSuTszWt/5MXXh209zdXY=;
        b=lMirGicOJdPSNtq9UZZJiIbkDKhy9CQKtYmj64hbx8QVtEfVQuXDHFoFXpPwusWLPp
         TgB2diOAbyyiUZcXGKKHKQWVgGL1Jx5zQmAsLuWo7rzUL/RHUceQ6EmmLLL7Tuuvpp4o
         p9ObZpVAYRgOtDSAocog43dOeC1QR+/iw8CnAsNHbYFgI5Ks4nU2NhrpX0ALFEcaEVps
         HMcARGcAMROGsXQWYoNrwFrRuRN/dEOF92/+8jeLPDMVuQaS266+1IDl1a5rwpVSlF6c
         2XA+0rOpC18GFVQLbBReMGiW4hLHZ1ZRNPiZz+JymED71pXEAhX8lcUFUw1rNjt8rgI/
         ickw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996781; x=1760601581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v56yGNQ37Majx7vHh2h4KlxSuTszWt/5MXXh209zdXY=;
        b=ElxS4KqqJn4hQhMQfoRtSejDvCsMsreLLNfYJfLyTMu+Lg0aRIsG1bW0WejWHci8wO
         8XOROHjHARpXyASh0njI6xLAtZeSiLXegvL1K3CL2wBSu0wwJF4w0+zBcfYy5U0lbKeF
         Z6w2CE2Zh4naP0Odl398hUOeNrDNtGIpDmiGJp18dweQcYzuGh9djI4UnZvLZZA0MF0b
         SG1zqTF2vJTuNBWtzS+Mqgo9mgaAzAzaPbVnAHdwWZ7RwHjA+DYvmssBld7udDakl0E1
         1Eg5u1h4c0E7AZoYvr6bgKcBDCSzS3uk1RokWASyHUROhWYSLrDBDr5yl48a/+n91fPE
         47OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP7p0qsguBhwsKWbOmbXa2VrTd92BJGa2AaPoAXOfislmWcO6Y5PaSwcAxxRl8Bp4iLxp2csMYPzsM@vger.kernel.org
X-Gm-Message-State: AOJu0YycsnPNCyBM5FBWFKf8L7KxMcbdSqw7B/8vEu7YK97OxKJWGD6f
	Po+2WdxxyL58y0y23FM6KbH6wg+E6rt7Q7s7kAuRVIM90SrCpKhKTCUg
X-Gm-Gg: ASbGncu7zgB7CGbx5gtjgJHpL8kE4omgjlmzUEVj2X4M4PaQW7qaCEapP8FU95eso0o
	9lw6VyULNCI1MM6XVWnUUQIhQAvFHUkhNDy+ugIPSMMg8BQXoUWGVygASddqVDc4X8+WmfjGLII
	v2DCqrOMKVM9zSgAzEEyH5RB/yxZXb5P5jUA+q9K72jDGie/8CZUQhaQpcZ2noiKU/CM43e74qi
	tSFPXM9n6vi+3s1LuExDEzWineijJaHpCbzQQcbQw0XXELo0jsoz7y5uoEuqTgG5kW3vdCd6wEM
	qWHu2Msg4ywEaw6BBYW+SuMmTWDr8oQ2MhHsMBAxDOctw2XOq9vLoPHSAd+v2heYuF1rPj/YA2m
	OQAGm5LRP6M/ifB9rjSf74Ay1pKGHsgK9CO/6xZ+Yu50QWU6gIDcUCSrKuvBWpikr1zlQAY6lWv
	wJtFOqPBXJRIBNowSRLcrD14sxPV41zEzP
X-Google-Smtp-Source: AGHT+IEc4DRH7N7VTwKCGCSJIEPnJelkA9fOKTTSeoDugfMSCygU9n//Fy4KEuh4pwZhlTzmLezAHw==
X-Received: by 2002:a17:907:3f17:b0:b41:abc9:613c with SMTP id a640c23a62f3a-b50ac5d08e9mr658923266b.51.1759996781064;
        Thu, 09 Oct 2025 00:59:41 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:40 -0700 (PDT)
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
Subject: [PATCH v7 01/14] fs: move wait_on_inode() from writeback.h to fs.h
Date: Thu,  9 Oct 2025 09:59:15 +0200
Message-ID: <20251009075929.1203950-2-mjguzik@gmail.com>
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

The only consumer outside of fs/inode.c is gfs2 and it already includes
fs.h in the relevant file.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h        | 10 ++++++++++
 include/linux/writeback.h | 11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ac62b9d10b00..b35014ba681b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -949,6 +949,16 @@ static inline void inode_fake_hash(struct inode *inode)
 	hlist_add_fake(&inode->i_hash);
 }
 
+static inline void wait_on_inode(struct inode *inode)
+{
+	wait_var_event(inode_state_wait_address(inode, __I_NEW),
+		       !(READ_ONCE(inode->i_state) & I_NEW));
+	/*
+	 * Pairs with routines clearing I_NEW.
+	 */
+	smp_rmb();
+}
+
 /*
  * inode->i_rwsem nesting subclasses for the lock validator:
  *
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e1e1231a6830..06195c2a535b 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -189,17 +189,6 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
 void inode_wait_for_writeback(struct inode *inode);
 void inode_io_list_del(struct inode *inode);
 
-/* writeback.h requires fs.h; it, too, is not included from here. */
-static inline void wait_on_inode(struct inode *inode)
-{
-	wait_var_event(inode_state_wait_address(inode, __I_NEW),
-		       !(READ_ONCE(inode->i_state) & I_NEW));
-	/*
-	 * Pairs with routines clearing I_NEW.
-	 */
-	smp_rmb();
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 #include <linux/cgroup.h>
-- 
2.34.1


