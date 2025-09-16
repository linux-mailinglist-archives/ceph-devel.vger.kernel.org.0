Return-Path: <ceph-devel+bounces-3627-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FB4B598E2
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 16:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C17D71BC400C
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 14:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B57311C1B;
	Tue, 16 Sep 2025 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3nhuz8Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26800368093
	for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031212; cv=none; b=UkBAiWPQy1Y7CUd92V+GSSZoKvpQb5TsBNQaiX2u5b5SZ5VhwCfrlW6ZtU0coSvhCZtQBHMJClM8ucb8yPOQsvK/A5w2YRtrLSjwXnM6RcEbiUwdUfVWF81zJyfb5EMxGSAd5I6FzFd9JRURSpLB90v3A07QZf8hu1685GAWrk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031212; c=relaxed/simple;
	bh=QCGFM/cnMeWMX3htX5p6eryZx4ChTW6raUZie6Xkq4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd+3eLIcAZBB5UHAGPjUKxNo2FTAkBaE6NTsoJ8QrPPo8sLrrxq5iSi71QjFATFT5Bq7WqlnlAzue8MTMfocjoOrDr2wOcW5Cl7xMiazwpx0M1sm/trX0Gl7wec3f/oz2Ef3qK9tIuvtUKHRIXoubuUhG2HE9N6oeBEYRE9t5o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3nhuz8Z; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45f29e5e89bso33324155e9.2
        for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 07:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031208; x=1758636008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3p/HZf12MlzeyzMfr2O5f/PDaT3y6+eiNIS1WtKNH8=;
        b=L3nhuz8Z9oR2kJSqns3xH/4NNgB63DxIRTaNe5oIxa1VLEVdkRdB/o3wev4JT9FNev
         eYpTXmtMWdeLljSdxJ79OLMkhJkiqrc6h7LHAZW+X5s3QVxcasSgLD7hAUeJrGRLubrB
         rulGsgIDFkzQK+2p9g4U8tVgIq95EgJGWBcjRk5IWOXboTPeJq5Wl8CIcLDDTCttURg+
         Z/kpRYpJML9Zm7dCljBFAix9m7eNOll6G7VSP+j67BxEW1aC/WZ7ZjSMe8UMq+FpcsCJ
         Gpseb7IWms7Lemr8sJ3X2y84OXx4aqfDuLL8yMdr7v3hdlC3zgsgY4glFyVdW2zXXK2M
         b5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031208; x=1758636008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3p/HZf12MlzeyzMfr2O5f/PDaT3y6+eiNIS1WtKNH8=;
        b=BJGUM1l+oboZRI0baTLFmeokg7njwUEtwql07PmpPeih6nmWneTugafObaSYYvZKgI
         p3OlqJ4pjEc8lA5l3r2rwpAU7gZdt9TLc4k7MxCNJlzTOP/rQsAecSNVAcFnUj5mQXrc
         uDK3uAXx8OwbcKHMtjWs7m0dQasT9Hc1tkeKi2MWHnlinp05X77eV32McFnqODNTNI6r
         rj3XtoF7skqQ49oac/yI9UoBb8CFPhd4ScMrsIac+PaKGFwx+95qT3ty9VpR8lPRbzEe
         iSZsYo91F5p2/16tZMZ9xQ1Ox2qK1dQk2bgA964ABt3Rwy7nc0yoe0CBsXAliakU8TWe
         +U6g==
X-Forwarded-Encrypted: i=1; AJvYcCVjji6GREuiEKB1ncUES7Ap3I1pgTkp5r2EAQWGSxgzu3Gf6+4i6pSO5vZlCljrbPzj/I/lvmF4+Im9@vger.kernel.org
X-Gm-Message-State: AOJu0YxeXYLolexuClstz5UnfW6SOV9of3rhtk8H+Jpscp8FmYgeZ1y5
	QeUAzOa7xfDwmGpL2+8i+Mjv0DMXPxf9b4WQL+gorjMnrpQe5DIXKDAg
X-Gm-Gg: ASbGncvW5HAPYCkMSbC6P+N/grNkmWlqhTvg55gM3vtpTV2T0xgyuqGgFslXuAiIuYK
	mqTeAHsNBD118Yc+XN9PECJgG2Hg9ly0fhi83cXGJKkhIL0w3P6KXFe6NCz9iO/5aiPTMqjEl+o
	vZ48BsYxdCSX26BPhHwOCdi5w28vg647tNL375SbZH7QQCDsR4/n0kv6ZNZ/JT8iIHiUNpUW8UH
	py0gFrTxydN1lO8B6AHf5yfOaE9jTH0wARdGhGEu9sAvKTFVzrC9epCap1sHpWLYTznSvYkN4/X
	u05y7Wb88nzBkhxkJrd5F98Cv0Cq2r7SG4sFr0IgZ3CYP5gttfteC74Srq/HHquTCMdX9UeV0nO
	W0yjXk1lRx/SJmcslWlWK7J+3bgUMviFIr1BLQJdKAeSP6tpuanxr0xob68qi0j9PBLDOOOxe
X-Google-Smtp-Source: AGHT+IG3ojTnTVy1hdNr03FmdV6E3sTeXWaDybJz1f1E1nvEGmI8CA+2Pel84ZsC9/O7zHxZywZmtw==
X-Received: by 2002:a05:600c:5246:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45f211c8aa9mr181401305e9.10.1758031208380;
        Tue, 16 Sep 2025 07:00:08 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.07.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:00:07 -0700 (PDT)
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
Subject: [PATCH v4 12/12] fs: make plain ->i_state access fail to compile
Date: Tue, 16 Sep 2025 15:59:00 +0200
Message-ID: <20250916135900.2170346-13-mjguzik@gmail.com>
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

... to make sure all accesses are properly validated.

Merely renaming the var to __i_state still lets the compiler make the
following suggestion:
error: 'struct inode' has no member named 'i_state'; did you mean '__i_state'?

Unfortunately some people will add the __'s and call it a day.

In order to make it harder to mess up in this way, hide it behind a
struct. The resulting error message should be convincing in terms of
checking what to do:
error: invalid operands to binary & (have 'struct inode_state_flags' and 'int')

Of course people determined to do a plain access can still do it, but
nothing can be done for that case.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11eef4ef5ace..80c53af7bc5a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -782,6 +782,13 @@ enum inode_state_flags_enum {
 #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
 
+/*
+ * Use inode_state_read() & friends to access.
+ */
+struct inode_state_flags {
+	enum inode_state_flags_enum __state;
+};
+
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -840,7 +847,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_enum i_state;
+	struct inode_state_flags i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -906,19 +913,19 @@ struct inode {
  */
 static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
 {
-	return READ_ONCE(inode->i_state);
+	return READ_ONCE(inode->i_state.__state);
 }
 
 static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
 {
 	lockdep_assert_held(&inode->i_lock);
-	return inode->i_state;
+	return inode->i_state.__state;
 }
 
 static inline void inode_state_add_raw(struct inode *inode,
 				       enum inode_state_flags_enum addflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state | addflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | addflags);
 }
 
 static inline void inode_state_add(struct inode *inode,
@@ -931,7 +938,7 @@ static inline void inode_state_add(struct inode *inode,
 static inline void inode_state_del_raw(struct inode *inode,
 				       enum inode_state_flags_enum delflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state & ~delflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~delflags);
 }
 
 static inline void inode_state_del(struct inode *inode,
@@ -944,7 +951,7 @@ static inline void inode_state_del(struct inode *inode,
 static inline void inode_state_set_raw(struct inode *inode,
 				       enum inode_state_flags_enum setflags)
 {
-	WRITE_ONCE(inode->i_state, setflags);
+	WRITE_ONCE(inode->i_state.__state, setflags);
 }
 
 static inline void inode_state_set(struct inode *inode,
-- 
2.43.0


