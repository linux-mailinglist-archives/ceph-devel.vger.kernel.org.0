Return-Path: <ceph-devel+bounces-2172-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5560D9D1B21
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 23:28:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CA1D281954
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 22:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF891E8820;
	Mon, 18 Nov 2024 22:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="NhOZx2qh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BF21BD9FB
	for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2024 22:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731968920; cv=none; b=KMS/63q17AQbFSH9vm1TIwZcvnjsXpnLPZvuUk78fwkCkDNdXkrhCO8c0ItY2dAfsspMk3OWAD1l7XXY76RfgYEaXs//0IzS/ocZZMeNkpXrshN6DITucU9/qXoh60U6q3dvhmFB8SJL598+mJ7kg824lixLQLfx06u0ZqMCXJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731968920; c=relaxed/simple;
	bh=AMRwCOm6PPsMK1+VolimqEuMDwoiKrof204t0pu7GY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iF/Dsc/mPhezoZxftD85yNj1gNCSKtRDRYzwQdr8uSxIdXrqNS4iqxlO9Z+q5iHF0+5vlVJZEyCxao02SH7ZkZi+sQvgnx0mhBGDnmTLmrognYVCYdwE00vwIvaNelMKkk3Hp+hnwIEoXkASW1CLzE7x2/S2SLHtNlFWmQLEawU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=NhOZx2qh; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4319399a411so1946585e9.2
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2024 14:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731968915; x=1732573715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aELIIOy3P0XH2d0/thP7GBbWQkXjiSTD8BNOrpNwIQg=;
        b=NhOZx2qh8pw8Vqnl8A34eIB+i4o5cGnBS2X4VcWjtUpoTW2IJAvMQHBj7rkRtz8MdR
         KueZKl2wYtqlIJ/I087OfqMSNv9XHWzj1tYgqZIaBVBbpAdspW1CdpQ83NQF3t5R/8B5
         hApuOlRREsCLP8txcc6QmS5MdUvJqxW5RsrHYsQ7AjFz99ECSNcGhWuBQez+JwaDHuMD
         l2mIzd5TDcLklvCjmyl5WFSsA6WWOq256ezlBL3piELaU6d/W4zEh8ggtPUVU4K0/8A5
         aMyQtPNhsOFkdQWbltGy9KuvrfoWyvRJnKoMOaZScqcjKrFTK0jC9fE8XKv+UPZxtsob
         SOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731968915; x=1732573715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aELIIOy3P0XH2d0/thP7GBbWQkXjiSTD8BNOrpNwIQg=;
        b=DMTq7QTmr+WpVyAL5t7SEMaHd6Uyv+WdTX7MDQlQRSUYcP0qfvRNLeeUq/5w0/byQM
         sX9qwIPBP7IkozwKMwIeCUAsKjAESSRj2uGTiQtwyyrDVt/ThfU8OqvbMI4qBk0IcFho
         QUkp+iwJgXdKonc6pjfvjtSYbJGoXBx3ytL3twYQZPluuoVmfklXSsMFxfY3NA5jdO6d
         BSV5NLKcuXUaLF8FCyDs1nYEQOt4H/40W7ofzJm6ZVyFHIQovgOIZP8AV1Djp1/OOaHD
         kgV08eiJNfn5o8WVJFpN5jzxw4/POuVichgLxiGN+Kj90aezbXBot0Nds7maU2DeGAwu
         u6pw==
X-Forwarded-Encrypted: i=1; AJvYcCWEo41LGdU+u/+pyGXgouYms4T5ye0HjJd5JoFvS9hDSmhtSsX6Ql3AXUY7k6YtzhBTzljkj3pbR5xQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxEfe5bMkKKAkBHy8PkkIoG2JgxFzOE715ogC4W4FOa9g1Jo1W+
	d6o0e3D5FYsCFZ0O/kXWCPXriNsCU5R1cevEovueNd9Ftr/GL2FCr58Dv3VORnc=
X-Google-Smtp-Source: AGHT+IG051lv97ph0aZr4al15OTxoT+XUgzRS4h6XjL8falTMSmWXyru1OZtOCYZDfSMFASCZhXhuA==
X-Received: by 2002:a05:600c:1f14:b0:42c:b1ee:4b04 with SMTP id 5b1f17b1804b1-432df79193emr100670675e9.28.1731968915579;
        Mon, 18 Nov 2024 14:28:35 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f12b600023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f12:b600:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265907sm178325795e9.13.2024.11.18.14.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 14:28:35 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dario@cure53.de
Cc: stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
Date: Mon, 18 Nov 2024 23:28:28 +0100
Message-ID: <20241118222828.240530-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the full path to be built by ceph_mdsc_build_path() happens to be
longer than PATH_MAX, then this function will enter an endless (retry)
loop, effectively blocking the whole task.  Most of the machine
becomes unusable, making this a very simple and effective DoS
vulnerability.

I cannot imagine why this retry was ever implemented, but it seems
rather useless and harmful to me.  Let's remove it and fail with
ENAMETOOLONG instead.

Cc: stable@vger.kernel.org
Reported-by: Dario Weißer <dario@cure53.de>
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/mds_client.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c4a5fd94bbbb..4f6ac015edcd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2808,12 +2808,11 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 
 	if (pos < 0) {
 		/*
-		 * A rename didn't occur, but somehow we didn't end up where
-		 * we thought we would. Throw a warning and try again.
+		 * The path is longer than PATH_MAX and this function
+		 * cannot ever succeed.  Creating paths that long is
+		 * possible with Ceph, but Linux cannot use them.
 		 */
-		pr_warn_client(cl, "did not end path lookup where expected (pos = %d)\n",
-			       pos);
-		goto retry;
+		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	*pbase = base;
-- 
2.45.2


