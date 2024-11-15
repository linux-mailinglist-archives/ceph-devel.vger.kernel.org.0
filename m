Return-Path: <ceph-devel+bounces-2080-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 574AB9CDCA1
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2024 11:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19DD72825DD
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2024 10:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B35A11B6539;
	Fri, 15 Nov 2024 10:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="rW/eJ1LP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [178.154.239.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9708B1B5EDC;
	Fri, 15 Nov 2024 10:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731666720; cv=none; b=nuFoS2ndO+N/hokPS26hEu0Mn+YdalpnAAhf7CtNVKCAfvw+dznjWo/V+6UFA8pMDtgcG0MqQp8hR0w0Xy412slo6yvxKafKOvV8J2XSyW8hlyUsLEI3EmMLbM8iO7PRQ82OdTETPmdGSIvftERL9mgfXF+edmAH5DqIuMGrk14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731666720; c=relaxed/simple;
	bh=RrJaHlVMymGlw8fwDlYcfB8vt61avtxcamuUvFLvaM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ePLDDgMNPs0pscSytz712MxNUpAIOZjx3/0y0hJYLv1Iev3RPKJpNOM90ouASx1vLe+CUXE+dZq+dCcr7ItZ/8Vp+Fy6/GDIAFFkljAZRXLcQUBtJU/K159mdw5yE8b9PKe3Gk0l0xfWix0fok2483WFiOpaP5aSj9lSpWUrQv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=rW/eJ1LP; arc=none smtp.client-ip=178.154.239.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from mail-nwsmtp-smtp-production-main-19.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-19.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:3143:0:640:c03:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id C5A256095E;
	Fri, 15 Nov 2024 13:31:48 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-19.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id lVKc247OdSw0-z0zZUYFA;
	Fri, 15 Nov 2024 13:31:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1731666708; bh=uQmpaFKxMGiJXm+HiZXngl2vcYv0imLPVObMGqPD1Ts=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=rW/eJ1LPw8H//qhRi97+TZhMBmWMUv4Bmjl8gyI7K0+/Qvb9I/jxWkuVI4BVUxg0W
	 kvqTnfAP19d11yn4izjq7Wbvk5HFeTzSPyZqMt1xhhigy0k4E5Ao1Npy+FaiA7J07S
	 zm3dx6sii1dHHzjTjYVjf0XbmU6XKsakvTsITLsg=
Authentication-Results: mail-nwsmtp-smtp-production-main-19.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org,
	stable@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 4.19/5.4/5.10] ceph: fix possible overflow in start_read()
Date: Fri, 15 Nov 2024 13:31:24 +0300
Message-ID: <20241115103124.1361582-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a huge read request with >= 524288 pages in list passed
to 'start_read()', 'nr_pages << PAGE_SHIFT' may overflow 'int'
(for a convenient 4K page size) and make 'len' undefined, so
prefer 's64' for 'nr_pages' instead. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 2362f2591f4a..bc50918284bf 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -329,7 +329,7 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 	int i;
 	struct page **pages;
 	pgoff_t next_index;
-	int nr_pages = 0;
+	s64 nr_pages = 0;
 	int got = 0;
 	int ret = 0;
 
@@ -370,7 +370,7 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 			break;
 	}
 	len = nr_pages << PAGE_SHIFT;
-	dout("start_read %p nr_pages %d is %lld~%lld\n", inode, nr_pages,
+	dout("start_read %p nr_pages %lld is %lld~%lld\n", inode, nr_pages,
 	     off, len);
 	vino = ceph_vino(inode);
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, vino, off, &len,
-- 
2.47.0


