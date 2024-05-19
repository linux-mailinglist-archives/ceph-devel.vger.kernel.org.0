Return-Path: <ceph-devel+bounces-1147-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FB68C9432
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 11:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D10721C20A98
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 09:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42AF231A60;
	Sun, 19 May 2024 09:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Fwg2QKOm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C19CC125;
	Sun, 19 May 2024 09:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716110380; cv=none; b=KxAm2z1uayq2t7cefKCxAQ0b3wZVD0MQvkt8o4SO6p4tGhOXk36DZ+bTdVyUVE+jKDkVGA+TAHMEPjEMCM4zUZXyvB0g8YIOm9y2rs9AnmzpxrQVqwBT0ZTk6S8+f8bHM1YkhlPv56GTG9TCB84/HXrptEYi5hvGQQjFWf8UFcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716110380; c=relaxed/simple;
	bh=2Io+Fz92zJ104X+y+nqXRgFvu2MtCDcDNZhKBzNDC5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HlTqm7ne3SVbGwY+Vqhe/YliMdLZGhZ9+EyY4B5BIPSbyqmzc3vAaJz881EI5c0TpKLjicJa/cr5PNIiSPRJ0jTPBsDGjikB3/0pZZhwhYWG5PqEmO1vO/xTlASeHne6LsZeVlL0xJJWRJYuBw5V+KDRjPTjGu/JnH8onV2HqYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Fwg2QKOm; arc=none smtp.client-ip=80.12.242.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from localhost.localdomain ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id 8cYSsFC8hNQ4U8cYSspY8i; Sun, 19 May 2024 11:10:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1716109810;
	bh=ZiwYqa/OT+egvt96+ug0V0xJ+qb/MMnvIJ/vMwb2q84=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Fwg2QKOmzOVxipJAi1QrNN07ZhrxdXAZDJsyPMcP9DtpkEFUPxtXBpRk2xkAqvwkz
	 rVaYBKpWurpPvr706qcDKnWpCc6dudb6EWXjESZSpzjlUr/uW1/ONwJHb9DhESSTQK
	 9mkuAvDOhMHVXLZ4JTLwdzUaNc2LaxmSDTv+7jx+ZhI36EJgOkVJq29ig3RP10BDao
	 LIZ3f1GRX1jfan4mcTyNvRfxWOO7pjr5VY5dXRXXLAou+aJdYnP+f5UsXfnAoOfFjG
	 G8uhXfYL/Hy7U/KqVMRsK0AeTaqeBwydUR/VkfbagFHmAn+F2nXSvUP+jr5Qf8fU6s
	 mdzzUL+H1IN9Q==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 19 May 2024 11:10:10 +0200
X-ME-IP: 86.243.17.157
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 1/2 net-next] libceph: Use sruct_size() in ceph_create_snap_context()
Date: Sun, 19 May 2024 11:09:58 +0200
Message-ID: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use sruct_size() instead of hand-writing it.
This makes the code more readable and safer.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 net/ceph/snapshot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ceph/snapshot.c b/net/ceph/snapshot.c
index e24315937c45..7363ccebee99 100644
--- a/net/ceph/snapshot.c
+++ b/net/ceph/snapshot.c
@@ -28,11 +28,8 @@ struct ceph_snap_context *ceph_create_snap_context(u32 snap_count,
 						gfp_t gfp_flags)
 {
 	struct ceph_snap_context *snapc;
-	size_t size;
 
-	size = sizeof (struct ceph_snap_context);
-	size += snap_count * sizeof (snapc->snaps[0]);
-	snapc = kzalloc(size, gfp_flags);
+	snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
 	if (!snapc)
 		return NULL;
 
-- 
2.45.1


