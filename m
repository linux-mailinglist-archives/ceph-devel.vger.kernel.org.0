Return-Path: <ceph-devel+bounces-3794-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C855BC7D9F
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 10:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B0C419E7A3F
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 08:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947022D3A89;
	Thu,  9 Oct 2025 07:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QK8TLnBV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84F92D2488
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996786; cv=none; b=bnibVpTTjO0BxCzowxargiUzCu8KJkNg1vuTokBXUq415aa+uID11fKgPIpLR3rVhXnfhO6OIOBznC5QWCcAiUlP3zSwjtjyA6kp5+1SWkwsCNqHyJt7wGd4ZgX0S+EjVaPAjwEQRm9ASFNbQffHFJijUzhDJsPcjsqUiZSQanY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996786; c=relaxed/simple;
	bh=ASNy7RmtSltSBzEynaqDPxE2iqjwE0ZPcjj4whWJ4kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVUDFJzP8YSi1EoWAKitBNOnadBZrINFkdrQgacJ5JgRSuqpVA2OSA3eeR0JrbLlsEA240kdyMIx5j3L05UHyYwgawDEQmQRfriNzbjdindaCDY5BdEjspzs5lJuzOxGUZaL/wBoiVALN9g4zAuQZvfvc8pr0DcIKl8XykZXc5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QK8TLnBV; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b48d8deaef9so111914466b.2
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 00:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996783; x=1760601583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnyVCyplzK+z1W2ORGsEbSjRDIE71IW/QrGYX9ePnTE=;
        b=QK8TLnBV8F6IPKH9b//mxMoquBU1AYrHverDd2jJnQIsgDXYysnPt+5qBsl4ki720U
         3ocIW7Jcipyxz+FB5i0HVbJvTq1bAwhiq0szN2RgKkAbWEjK59xK71mA/UXyiIHGLjks
         i8X1rXeYq/6eOyN9qk6y7SDbeKEfkeMPkSkycmy6w9cX4IbDACFodVHNf7ayS2tuQQzf
         IKbgSxng/5QEfd21nDFSwlasUSaPDixT4WIxVsZxCU8P/0dDBiGiYR4j/rTXKjR9ALI1
         mumT8GIbxFNYEvHLNz1UYKyV+o9ECQ3E/6bbvg2TYrcGqhvXosgo02hjcVjVX1duKbm9
         ES7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996783; x=1760601583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hnyVCyplzK+z1W2ORGsEbSjRDIE71IW/QrGYX9ePnTE=;
        b=dMwgsXd9kwPJUKFGbhCThngza8kkDBxG+YwB40dS7lEkgwzx7rEh+yMNGIFfh6Ja7c
         mPfQyBxJs9Kjo8Fy+INbcoeJ+zQnXlEQWWNUkDOwhgmCyEmRwsWxNYWpc9c0donlVSsC
         sr8qerk3GpebktmvfweKYUWDyiHkZSLQy+p7FLizLKub7PXOY9RbCVJqnezY/rVJBEgu
         UYT1uuRL1ExDfuY960+1OBMxtfSxFzYcEXfmTuJr28B3P9pQXXpX15JwUJ3P8w5F80NN
         mUhUrKofiBR4svFWwTIeomyUuevVe9IOdVyXIF9j/X6JOClzVrmVCnh9yhh0Fj9Mi4p4
         fGwA==
X-Forwarded-Encrypted: i=1; AJvYcCU1caO474stFoTkAnxk4sLRdeCzqhYv82mRTENkDXhwWbTiFbRUXgiEwvAhIAU5tlsK1NzytJzvDGCP@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa/yx+EmTkULq3osWCi3gwx9Y+A4lv82Gr4rmNiqP1RHOadq90
	WfNMS1Afmp9KHPl2Axb74jhpa2T/G7GJTsaSazHyvkP2mkvgVxleBzHt
X-Gm-Gg: ASbGncu8kNGtGWwTilBXzzX0z8qf+PPQTiCPwY9BJGYVsCPTc+qI1M31+0Shs949ana
	ixd3RXeUCjfH5CLtz+FmU2ovo1ZLcP07RbkQZ9QcMOL0G7p9CF7ZWHWPhbO750DlD9Ej6NoR1n/
	LMjxIw8FSFZpi0VhLUDgxcMJwElHJoMeJTs1fKA9iLNhYXxiznu3v0HFhdlOQVGh603Jyr8eFdU
	9qMJVHXw6+OrO2DpgrWTzXIp2Audkv1oBijfSwydABz9R1Tvcz9Xz7Zs/x4kayZnHX2qvIL1cwt
	tHXAvkjXI1lWBwNpjnaiK0Bu2djD+9c+mD0e8/j/1Kz59Oi+Q0HotuM0+pZvmkjXQM/AVUERwRG
	m9aTa1VlRuhCW2DsDnR0sSgAW+qqTuiaROjDX6BTU3tFpGUG3uEfPLCxpDYKc1anGDa30cjKLL4
	BSOxQ2W6aai8JMpJEawxCQ+kLS098l6EWx
X-Google-Smtp-Source: AGHT+IHSi6VF6s0uOD+PumlBjGkMUoulpOekOEwVZLQpfCJd1Jc4jSCHGMuyuANtbvnedJ6DnWPu/g==
X-Received: by 2002:a17:907:7f0e:b0:b48:44bc:44f2 with SMTP id a640c23a62f3a-b50ac8e52b0mr657263766b.43.1759996782956;
        Thu, 09 Oct 2025 00:59:42 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:42 -0700 (PDT)
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
Subject: [PATCH v7 02/14] fs: spell out fenced ->i_state accesses with explicit smp_wmb/smp_rmb
Date: Thu,  9 Oct 2025 09:59:16 +0200
Message-ID: <20251009075929.1203950-3-mjguzik@gmail.com>
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

The incomming helpers don't ship with _release/_acquire variants, for
the time being anyway.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/fs-writeback.c           | 5 +++--
 include/linux/backing-dev.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..9cda19a40ca2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -476,10 +476,11 @@ static bool inode_do_switch_wbs(struct inode *inode,
 	switched = true;
 skip_switch:
 	/*
-	 * Paired with load_acquire in unlocked_inode_to_wb_begin() and
+	 * Paired with an acquire fence in unlocked_inode_to_wb_begin() and
 	 * ensures that the new wb is visible if they see !I_WB_SWITCH.
 	 */
-	smp_store_release(&inode->i_state, inode->i_state & ~I_WB_SWITCH);
+	smp_wmb();
+	inode->i_state &= ~I_WB_SWITCH;
 
 	xa_unlock_irq(&mapping->i_pages);
 	spin_unlock(&inode->i_lock);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3e64f14739dd..065cba5dc111 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -277,10 +277,11 @@ unlocked_inode_to_wb_begin(struct inode *inode, struct wb_lock_cookie *cookie)
 	rcu_read_lock();
 
 	/*
-	 * Paired with store_release in inode_switch_wbs_work_fn() and
+	 * Paired with a release fence in inode_do_switch_wbs() and
 	 * ensures that we see the new wb if we see cleared I_WB_SWITCH.
 	 */
-	cookie->locked = smp_load_acquire(&inode->i_state) & I_WB_SWITCH;
+	cookie->locked = inode->i_state & I_WB_SWITCH;
+	smp_rmb();
 
 	if (unlikely(cookie->locked))
 		xa_lock_irqsave(&inode->i_mapping->i_pages, cookie->flags);
-- 
2.34.1


