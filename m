Return-Path: <ceph-devel+bounces-3913-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F33C2E33A
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 22:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDE9A3BCF1D
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 21:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF70298CBE;
	Mon,  3 Nov 2025 21:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4DgHtVy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49232D5A07
	for <ceph-devel@vger.kernel.org>; Mon,  3 Nov 2025 21:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762206828; cv=none; b=FUfuf7x8TsJLSneW0DAzy/3CnXiSkyyBFO8nTCs+MVMpxhSkAbR8AsLdlc8Jzh7KLeBzVT8dkYUKRNjUeBxV+0EB3bnkPhWF1tRbUXV/sCKl//IeqYNDWl6VpwlfH6GxK66YNbZS2mCSdBkHwGwE0HyqFXWJ3hb8GPVpWth3uQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762206828; c=relaxed/simple;
	bh=sPqikk8IfHK6l4Xsn7d4draU7xWEggakKqYkuEgkk2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHYfzMkVpfOiLQHKK9Ev9YHtffeb+g2I3FIpmcyY/AOI+wthj1J6C2oraPGxjvp9bum3bB5/cZE/J+LmyaSt+A6D63/9QIC5MDtIzG/vqF0rqQwmYupLpMkmT9uwbrQRfT++6QI2g/2lrXPmq/VvqoTgTWdTOcBdukr4MOW3dtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l4DgHtVy; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47754547a38so3335855e9.2
        for <ceph-devel@vger.kernel.org>; Mon, 03 Nov 2025 13:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762206825; x=1762811625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOV7ZVVKrY8n2FUjCM3HKq+73EyAgYwpsndYq/2AQdg=;
        b=l4DgHtVyH7DNZWqg5SOIVUeIZVdfjaxKlasuobIvnxiniceNL/jwXIy+MYdXeZ0Z/t
         8zYfei/JO9n2r2N5ugIaBMFZOjCLcc1P+cb3i8JnmniK7GwCzVn1VzW9l/qMli5RsZwO
         aLn7f2HKqW/rP04cwKu1lk+OeV+73jYHqqQX6QS2bYAywN67RejZdotZalT36Pb258g3
         IjZFTRfYFZgdbPj0X2e4l+iERlQhio/jDa1a5M7CtvAtyXtuq2CtV+Jjc/UnIZNzinTG
         J5BR84i0eGLFJB+RNXs0J9N+i1Q23pNGT+z9YMVkScsnqL6sR/BFZ88UjSRYcV6t0F8y
         unnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762206825; x=1762811625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BOV7ZVVKrY8n2FUjCM3HKq+73EyAgYwpsndYq/2AQdg=;
        b=vAYOLZVy0hFR4iF5HrjE8HrUKg/DjyfDZdTdTbZU7G4Ud0nDOlDvXjqWLWmtg8wTti
         FlQLpAyv3F0f7P3L83s4HGSOE+XncstA7AzM7KdykHEYMTE5O4xkLWKzza+YgWEht1ab
         Knzwy/MZAzSFMkpISL1xEhONHH/OgDzs1nRWML3/9iVXTMGU20jsVpGvKnsT/3SkxENk
         oOMLL1NTUmkQW445VyZ8gres+4mhgVopt9dYV6FppJ2UfhYmrJ5COfxch6mdgR2TC3I5
         y4K/HzRR9nTIodTnvIRk3k8c8tglmTPUEbLcWhdfHTHsyBKotCJPOiOVPtLvL/fxncm2
         +a9Q==
X-Gm-Message-State: AOJu0YxleK8GDeGNt+Yf0LFMkiVA2R2rPDKFkbh17ME7bHCwuCKt5yoR
	EoFMH8UzrwnDEZWXv4gNK6srIK9yfbl7SZ3gkrmOxZftWpVwu2nNrt2zLT0SpA==
X-Gm-Gg: ASbGnctclygUvgBfnbYFIKfoKG/Xdpovjbaxy+PO3VZaqu4G0rZVZXbN5BoVq3LnRfF
	ysoCehNVGYtPv+KI90iAofsF5mVm3ECbkJ5fcbkLpuH2tgSnmf/8MUvrRKmBDpV0K4nhlzaGuXH
	Yb4e1JcbOjReyLq3bcGhGgY3j49UyqGoPoNG/0H/LSmoLg2RqfJRE4jLT2mLEN6nnRU1QvQOdwu
	usmSPH941dRXkh1IhNRviTNti9RXeaRJB9TykqndhYLoApG+TzSRe3M9ynJdQk7SuKbpbTHSyQa
	ocEV0ItZ0JR/4r4X5ifgiNCBnBa/0KAhlaJLIz/wlLfj2QtTPaV24wKXaLaxtpA7roch8nIYr7n
	jeLkpEY7ursuUF40o3FLm9dAWj6wHwuxDaCB9ZcFDk8ErwVspc69o4ELlfOm8cSw8WzEfZxpOpA
	qd0X5IzYhLu1BU8wKiU1u0fZE4HAp+n1svdDi5Y5bzNZPULtPCjQ==
X-Google-Smtp-Source: AGHT+IEO6nKahK1LHf43m7UrityQ998TRsQt7F5tkgdaGRaETe8s4KxkLemfvoLSNGCNOktHlFbItQ==
X-Received: by 2002:a5d:5846:0:b0:3fb:9950:b9eb with SMTP id ffacd0b85a97d-429bd683f6cmr10825984f8f.28.1762206824912;
        Mon, 03 Nov 2025 13:53:44 -0800 (PST)
Received: from zambezi.redhat.com (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18efd3sm986521f8f.5.2025.11.03.13.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 13:53:44 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH 2/2] libceph: drop started parameter of __ceph_open_session()
Date: Mon,  3 Nov 2025 22:53:27 +0100
Message-ID: <20251103215329.1856726-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251103215329.1856726-1-idryomov@gmail.com>
References: <20251103215329.1856726-1-idryomov@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the previous commit revamping the timeout handling, started isn't
used anymore.  It could be taken into account by adjusting the initial
value of the timeout, but there is little point as both callers capture
the timestamp shortly before calling __ceph_open_session() -- the only
thing of note that happens in the interim is taking client->mount_mutex
and that isn't expected to take multiple seconds.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/super.c              | 2 +-
 include/linux/ceph/libceph.h | 3 +--
 net/ceph/ceph_common.c       | 5 ++---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 48f184aea1bb..20cb336ebc9f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1152,7 +1152,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 		const char *path = fsc->mount_options->server_path ?
 				     fsc->mount_options->server_path + 1 : "";
 
-		err = __ceph_open_session(fsc->client, started);
+		err = __ceph_open_session(fsc->client);
 		if (err < 0)
 			goto out;
 
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 733e7f93db66..63e0e2aa1ce9 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -306,8 +306,7 @@ struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
 u64 ceph_client_gid(struct ceph_client *client);
 extern void ceph_destroy_client(struct ceph_client *client);
 extern void ceph_reset_client_addr(struct ceph_client *client);
-extern int __ceph_open_session(struct ceph_client *client,
-			       unsigned long started);
+extern int __ceph_open_session(struct ceph_client *client);
 extern int ceph_open_session(struct ceph_client *client);
 int ceph_wait_for_latest_osdmap(struct ceph_client *client,
 				unsigned long timeout);
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 285e981730e5..e734e57be083 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -788,7 +788,7 @@ EXPORT_SYMBOL(ceph_reset_client_addr);
 /*
  * mount: join the ceph cluster, and open root directory.
  */
-int __ceph_open_session(struct ceph_client *client, unsigned long started)
+int __ceph_open_session(struct ceph_client *client)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	long timeout = ceph_timeout_jiffies(client->options->mount_timeout);
@@ -844,12 +844,11 @@ EXPORT_SYMBOL(__ceph_open_session);
 int ceph_open_session(struct ceph_client *client)
 {
 	int ret;
-	unsigned long started = jiffies;  /* note the start time */
 
 	dout("open_session start\n");
 	mutex_lock(&client->mount_mutex);
 
-	ret = __ceph_open_session(client, started);
+	ret = __ceph_open_session(client);
 
 	mutex_unlock(&client->mount_mutex);
 	return ret;
-- 
2.49.0


