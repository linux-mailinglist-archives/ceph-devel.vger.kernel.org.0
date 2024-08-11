Return-Path: <ceph-devel+bounces-1649-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D0194E323
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Aug 2024 22:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3176E281A32
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Aug 2024 20:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D173415C139;
	Sun, 11 Aug 2024 20:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rqnjjrk4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C3115748B;
	Sun, 11 Aug 2024 20:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723409720; cv=none; b=iGzzftqFOumAVCjz3ZOaqfc7at3U80WzpMoOvT0RnkfH+5LTJEPl4HqLfTY1pWIuqW5320dPWLzJOhcWv/QQJD6SU464cmmVLJSNY+D7tJ3XdfxufuuUVJO/TBGfhaAoA/c52Kr0XSzQ5WIG7X26mvx1Xz2NSAW8civJ4RP86SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723409720; c=relaxed/simple;
	bh=Gn3mBmXSNAIEDTNNdahtRzycMSUt9QdZhgGG3ql5dho=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o9i3bpvkJalZBWEaI2w4Zu0CdaKooZujUhKtZaw9FtotqqjdlCo14lQeDtLn2z/7xuu69ioAoDrAdwQ7xT8lvJg3n4kEtkTLmbUHXLvODA69Ethy00xsPXD1sN1F+KNiLRcwVs+o1tdoRrCUQqHSOWwnbwHH84B6PZF8xc411x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rqnjjrk4; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3db157cb959so2676386b6e.0;
        Sun, 11 Aug 2024 13:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723409718; x=1724014518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H4SeDVIANIrOeb9t0saBRKGNpwjINdqknCPqErRRrlI=;
        b=Rqnjjrk4QZacTd/OOE/SJtpZprKZkLXpIBFZbiHaVCqeFjExqUVA7JyVzqG6vfnnrP
         phJP2rYFXMdYITjel1LAmkwAESAFd5CADiKKYqSiBCHQfGotzDQI/zCHrTwKBFxa92FQ
         M0ZzdWNc+koUNhGSunqR8RmTWYpR+8Iv7h7+eY+MmurQBcTToj5iKaE4CIGRWivCKsaK
         N6cOkgorQfyly5H2s1buPxK8U+eRpmasTUUkveWGDO295WpTs5WOPizwHCS+NGwswerc
         tgb2XhSyxzIb5UNzZzwG9FPW4EpcUdhQjq3FZln6HDmKsN2IQ19l01EGtUNzc1CXwUZm
         c7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723409718; x=1724014518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4SeDVIANIrOeb9t0saBRKGNpwjINdqknCPqErRRrlI=;
        b=kJj/MsKvzQEFs8D5ntzZba9ee7KxYM5US5waHtYm05Xy6Mg0tir8AxxJtJ07cIRaNm
         330QdGdkVXSmTZ3k8cyNfyIIqnyIvyKeIdKVCnIPln8LrwLhxiIb90jEfQGwL1KpQ45n
         YzTydsu6yu+TdTVnEoA+omjGQRDMMZg4HzuNKSiVGd1sM5Hk8RWPrebcwouqssrcZZj+
         CWpqZfV2kDJtYSE5vrC3blDvhdCHTQHlDdpaMzi7sPJEi0ab+OaO2E8kdcx7eGToQGxm
         6+wPDBarbxvWdWfD6IdLiBJf879ll1Ha9NnzZdqeRdXEaq21De7ZeKrIgvJFhuRu5e3Y
         WGJg==
X-Forwarded-Encrypted: i=1; AJvYcCVOSJ/iG0NZZ22UyIBoZ4bR9jG5ll6PpmcTLRSF7i+biz8QDvQ95PMZvKl3rhHTPXcuFIj7Mn9gG1V8WCw84vcNvoQLNlGNpGrPiTcWv2xYkbk75YFdwHT6htT04Tshudd+gOtctX4i3vmiKWbHhMUMLa/FM1EVuRuwz7/PpFdRqg==
X-Gm-Message-State: AOJu0Ywzs0LCokkUgk40YXwo19xgrl5VHs7Gfht7xeli9xm9ly9ipvTH
	cA47+Zm9yxnLwujhA5CIoNIwsGEcs9rMFtYUpHRXlNUkeRueE6ps
X-Google-Smtp-Source: AGHT+IEJwN2eVeEROsDiqEyPNFYRAjj3OwAeO8Gj7zX0gtGLDUKvMoX+5i1EWN3cTP8T7z8ov1UEoQ==
X-Received: by 2002:a05:6358:5923:b0:1ad:1adc:ad39 with SMTP id e5c5f4694b2df-1b176f1d0f3mr1107090355d.8.1723409718057;
        Sun, 11 Aug 2024 13:55:18 -0700 (PDT)
Received: from dev0.. ([2405:201:6803:30b3:6c2e:a6d:389a:e911])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5874ef7sm2759636b3a.38.2024.08.11.13.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 13:55:17 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: idryomov@gmail.com,
	xiubli@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	Abhinav Jain <jain.abhinav177@gmail.com>
Subject: [PATCH net v2] libceph: Make the arguments const as per the TODO
Date: Mon, 12 Aug 2024 02:25:09 +0530
Message-Id: <20240811205509.1089027-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net/ceph/crypto.c:
Modify arguments to const in ceph_crypto_key_decode().
Modify ceph_key_preparse() and ceph_crypto_key_unarmor()
in accordance with the changes.

net/ceph/crypto.h:
Add changes in the prototype of ceph_crypto_key_decode().

net/ceph/auth_x.c:
Modify the arguments to function ceph_crypto_key_decode()
being called in the function process_one_ticket().

v1:
lore.kernel.org/all/20240811193645.1082042-1-jain.abhinav177@gmail.com

Changes since v1:
 - Incorrect changes made in v1 fixed.
 - Found the other files where the change needed to be made.

Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
---
 net/ceph/auth_x.c |  4 +++-
 net/ceph/crypto.c | 15 ++++++++-------
 net/ceph/crypto.h |  2 +-
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index b71b1635916e..81272603f981 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -204,7 +204,9 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	if (tkt_struct_v != 1)
 		goto bad;
 
-	ret = ceph_crypto_key_decode(&new_session_key, &dp, dend);
+	ret = ceph_crypto_key_decode(&new_session_key, \
+		(const void **)&dp, (const void *)dend);
+
 	if (ret)
 		goto out;
 
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 051d22c0e4ad..905b80d738b1 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -86,7 +86,7 @@ int ceph_crypto_key_encode(struct ceph_crypto_key *key, void **p, void *end)
 	return 0;
 }
 
-int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
+int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
 {
 	int ret;
 
@@ -109,7 +109,8 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
 {
 	int inlen = strlen(inkey);
 	int blen = inlen * 3 / 4;
-	void *buf, *p;
+	void *buf;
+	const void *p;
 	int ret;
 
 	dout("crypto_key_unarmor %s\n", inkey);
@@ -123,7 +124,7 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
 	}
 
 	p = buf;
-	ret = ceph_crypto_key_decode(key, &p, p + blen);
+	ret = ceph_crypto_key_decode(key, &p, (const void *)((const char *)p + blen));
 	kfree(buf);
 	if (ret)
 		return ret;
@@ -300,7 +301,7 @@ static int ceph_key_preparse(struct key_preparsed_payload *prep)
 	struct ceph_crypto_key *ckey;
 	size_t datalen = prep->datalen;
 	int ret;
-	void *p;
+	const void *p;
 
 	ret = -EINVAL;
 	if (datalen <= 0 || datalen > 32767 || !prep->data)
@@ -311,9 +312,9 @@ static int ceph_key_preparse(struct key_preparsed_payload *prep)
 	if (!ckey)
 		goto err;
 
-	/* TODO ceph_crypto_key_decode should really take const input */
-	p = (void *)prep->data;
-	ret = ceph_crypto_key_decode(ckey, &p, (char*)prep->data+datalen);
+	p = prep->data;
+	ret = ceph_crypto_key_decode(ckey, &p, \
+			(const void *)((const char *)prep->data + datalen));
 	if (ret < 0)
 		goto err_ckey;
 
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index 13bd526349fa..ba57376fa635 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -22,7 +22,7 @@ struct ceph_crypto_key {
 int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
 			  const struct ceph_crypto_key *src);
 int ceph_crypto_key_encode(struct ceph_crypto_key *key, void **p, void *end);
-int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end);
+int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end);
 int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *in);
 void ceph_crypto_key_destroy(struct ceph_crypto_key *key);
 
-- 
2.34.1


