Return-Path: <ceph-devel+bounces-1891-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F3A991BB9
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 03:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27AC51C20FBA
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 01:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8677A54738;
	Sun,  6 Oct 2024 01:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="qebLZu1u"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A654310A18;
	Sun,  6 Oct 2024 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177605; cv=none; b=PAe2xxOLpSmmopRe/jUUzORsys1ZV475ij+MORKd03x3dsK6j64KZLuCb778B9bhZHUDlBT7o4Ay49UKBbihBZIFxlTRg3WGYWVgh0env7ePPndzYxfnpyIF1Tk8qD4b3TCrP/k/apIM2sGVSaXN/mY4rZ4SkG3eLokoXCHEHJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177605; c=relaxed/simple;
	bh=+3eYkmZ73kJwT6bLA1lV3xCVKKFZuDi8QptcLVB14FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TceDcuT7Po+93H4H22UrZY4OjoiEhd6Mb4DE1GqpMcQmzmEgTbW9O4xwXRc0C1o/loj7Zra2peq5fOFuNhOD4NTOualjUUf5/wK54/Occzt2e7Yy0Ws8QQHfibducEd3DkcB9wE2QhaG5qsPwKfExGcrwGdTpzm21X1QZQKIvjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=qebLZu1u; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=EZS/lTZ8aHdEQcGNta0bwoK+ZREYdcJEcsEzL5DBoX0=; b=qebLZu1uM7dqJ3iT
	KJ4gkFV/HhjOmpCrrsmVj3AVbhV9H7LVd2P6qlvu+wkHTSF1qfsBdY4jqwxYrCJpi0DTvtT+qnTVl
	GwhE2uqtokbBrtGO0WGWEpth+gjf5qABowFMeZgqoCnaHy0zcv8LPvLvgM8QF99SCUnt5kncTr7rn
	okIIHvIOualVW+Vg7ZJbpllFSORHK2YzNrkZvCZrk6QvZbUV0I2LP46n3yVoV9x1KzpcGhuN5bN1x
	7WdpCt9t72JPb2XyI4GUYhlFl2GNR1X9/+y5DOUNVWNqHjhY57ekXrOXjriVtdwLa/BzdIFruRJLY
	aLXr7ObO6x7xB6lcUA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxFwG-009DsK-06;
	Sun, 06 Oct 2024 01:20:00 +0000
From: linux@treblig.org
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 4/5] libceph: Remove unused ceph_crypto_key_encode
Date: Sun,  6 Oct 2024 02:19:55 +0100
Message-ID: <20241006011956.373622-5-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241006011956.373622-1-linux@treblig.org>
References: <20241006011956.373622-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

ceph_crypto_key_encode() was added in 2010's commit
8b6e4f2d8b21 ("ceph: aes crypto and base64 encode/decode helpers")

but has remained unused (the decode is used).

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 net/ceph/crypto.c | 12 ------------
 net/ceph/crypto.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 051d22c0e4ad..01b2ce1e8fc0 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -74,18 +74,6 @@ int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
 	return set_secret(dst, src->key);
 }
 
-int ceph_crypto_key_encode(struct ceph_crypto_key *key, void **p, void *end)
-{
-	if (*p + sizeof(u16) + sizeof(key->created) +
-	    sizeof(u16) + key->len > end)
-		return -ERANGE;
-	ceph_encode_16(p, key->type);
-	ceph_encode_copy(p, &key->created, sizeof(key->created));
-	ceph_encode_16(p, key->len);
-	ceph_encode_copy(p, key->key, key->len);
-	return 0;
-}
-
 int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
 {
 	int ret;
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index 13bd526349fa..23de29fc613c 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -21,7 +21,6 @@ struct ceph_crypto_key {
 
 int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
 			  const struct ceph_crypto_key *src);
-int ceph_crypto_key_encode(struct ceph_crypto_key *key, void **p, void *end);
 int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end);
 int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *in);
 void ceph_crypto_key_destroy(struct ceph_crypto_key *key);
-- 
2.46.2


