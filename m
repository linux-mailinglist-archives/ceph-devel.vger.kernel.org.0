Return-Path: <ceph-devel+bounces-1465-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A71990D736
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Jun 2024 17:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A9CFB35E1D
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Jun 2024 14:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5913E15B55E;
	Tue, 18 Jun 2024 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="w5f5bU6r"
X-Original-To: ceph-devel@vger.kernel.org
Received: from forward206c.mail.yandex.net (forward206c.mail.yandex.net [178.154.239.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A336415B0ED
	for <ceph-devel@vger.kernel.org>; Tue, 18 Jun 2024 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718721771; cv=none; b=fnUQHdMRMFByLzdrkRxbrBjTnHdwH5T3XfGcV5up50GZiwrU3ghrHJ8IE80vkE5LQYHj7QA4k8LqRIxlf2PlLsNXii4FiGRFHJVAuRu+uEEmYonnzJ4Eeoo3qP+5XCwDd5uBPUsKiP8oEHRjHJ3gy9igIVRGvErWFLs8ctJRz6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718721771; c=relaxed/simple;
	bh=7CSnApVUPDmGgABDjOkeFdiVRavYGFx9yRE+tyKPwCA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lLGBfoc7+WEhcMKnGpn+iAPKboxHTBZNxfNB/DU/Cw/Lx6bp1pHpUOacPfACl3LOrw+bFI3J6fJcQZbBhn0KiDAboEFcmngPOde4GNf9g0b0wIKxv2wOMG7JB5HjyfI/JVEmcRsQK6owFg//WfEkbJYBc+qyXykCn/YU5s6O2Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=w5f5bU6r; arc=none smtp.client-ip=178.154.239.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d101])
	by forward206c.mail.yandex.net (Yandex) with ESMTPS id CD92165D11
	for <ceph-devel@vger.kernel.org>; Tue, 18 Jun 2024 17:37:30 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:2146:0:640:e7:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 1CC7C608EE;
	Tue, 18 Jun 2024 17:37:23 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LbJrdcWoHiE0-UXJjdVMN;
	Tue, 18 Jun 2024 17:37:22 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1718721442; bh=ZWNNcYnQ3CZhD2KHiJ7ZAu7ftnna/AofMwidsdVWBWc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=w5f5bU6rj9nsD4APlugX1ipQdG1HRWaf6xFgKARJaBwcUadkt01pUHUsZm14D/e1W
	 Tr5NC/oxua47cIkvrXAtUR4RsUzT8fjiSAXEXVXXWQyMP1NIXAfpgtplKK/thRfE94
	 ifn+ZAqV9Uxajnpgf8tCJZw2GZv/wjhreMGFZ1+8=
Authentication-Results: mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ceph: avoid call to strlen() in ceph_mds_auth_match()
Date: Tue, 18 Jun 2024 17:36:40 +0300
Message-ID: <20240618143640.169194-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'snprintf()' returns the number of characters emitted,
an extra call to 'strlen()' in 'ceph_mds_auth_match()' may
be dropped. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ceph/mds_client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c2157f6e0c69..7224283046a7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5665,9 +5665,9 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 				if (!_tpath)
 					return -ENOMEM;
 				/* remove the leading '/' */
-				snprintf(_tpath, n, "%s/%s", spath + 1, tpath);
+				tlen = snprintf(_tpath, n, "%s/%s",
+						spath + 1, tpath);
 				free_tpath = true;
-				tlen = strlen(_tpath);
 			}
 
 			/*
-- 
2.45.2


