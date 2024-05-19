Return-Path: <ceph-devel+bounces-1146-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E71A58C942B
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 11:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 228341C20B2D
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 09:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E9F2C87C;
	Sun, 19 May 2024 09:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="okS4Sb9h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from msa.smtpout.orange.fr (smtp-77.smtpout.orange.fr [80.12.242.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C454241E7;
	Sun, 19 May 2024 09:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716109833; cv=none; b=abwgNEvQr2tUW8bG3U96qz1CYRdSTn79yo6FlR0zUCNRIWvAiO+biYWzqvn4KWN8zYG2EwJp61rD98LoOkVtGdbc192Owb7nZ0EvDxhWXSY+0aNImnIiswriKAuTothr6wm1RqGo6aMPJUbhju6ioJcSWDPrl7Pq52kaIF/a4CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716109833; c=relaxed/simple;
	bh=WHLI54myjQZgi0GBCy9D+0xHgarTdc8QkTWV2HYfM/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9fi5D7ChqClWT3i+Q6b6d5gmB6akvKVYDgiObLHPWdwmz+r31ON8ZMI02wkA2X3tf2X4QMElujOT7GGEL3jK2ARklIZRaopD4tD0uoRVsBuDxKmLNA9aOUbxwKpiNA0CTvlZKDnUnEmkhPMpmvy+i7rAcuu8r38gcqNLuLKdNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=okS4Sb9h; arc=none smtp.client-ip=80.12.242.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from localhost.localdomain ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id 8cYSsFC8hNQ4U8cYespYD1; Sun, 19 May 2024 11:10:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1716109820;
	bh=BuzLzcGApaGthL63ihFJK2+ain4oC/YEb1ozPZvoVBw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=okS4Sb9hoEuVjb/kMR4hDnZ7f6paQP6y+KGUUnGBCL3cEN9W2FRGXwRMKCtQiu7j8
	 GwFGm+DxRbnK/KEb4xhXYM0qZB9XEHTgZWBXftEXsIh7Bi+Wr+Cf+N7EXmWrt2XmB2
	 6D42KRIi34gw9NqHAD8RVWjp+i5Em6sh2J+lfdDhNXazdeaJvaBQ5NayMjaeDQeamH
	 OtHdnCMjSOqdnF77nvm5QrzWz5uEE/9Erjdid7uya0HZycP+Y17WT6q4DON/3BeJX5
	 /ZK9tzEykO9ORHOTdCr8HRdYPBdI7+glqOV4CBYU0npR9mRG8LI4B+1IHlgj+eB6M2
	 gxMgDGkCLoadg==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 19 May 2024 11:10:20 +0200
X-ME-IP: 86.243.17.157
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ceph-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 2/2 net-next] libceph: Use __counted_by() in  struct ceph_snap_context
Date: Sun, 19 May 2024 11:09:59 +0200
Message-ID: <c883cccd53beb412f4806d28f48e8a3ddd4f0995.1716109606.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>
References: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Annotate the 'snaps' flexible array in "struct ceph_snap_context" with
__counted_by() so that additional checks can be made, if enabled.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 include/linux/ceph/libceph.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 4497d0a6772c..485efc8837d5 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -164,7 +164,7 @@ struct ceph_snap_context {
 	refcount_t nref;
 	u64 seq;
 	u32 num_snaps;
-	u64 snaps[];
+	u64 snaps[] __counted_by(num_snaps);
 };
 
 extern struct ceph_snap_context *ceph_create_snap_context(u32 snap_count,
-- 
2.45.1


