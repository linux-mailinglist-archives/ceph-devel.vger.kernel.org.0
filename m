Return-Path: <ceph-devel+bounces-2191-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F0A9D6807
	for <lists+ceph-devel@lfdr.de>; Sat, 23 Nov 2024 08:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96331161241
	for <lists+ceph-devel@lfdr.de>; Sat, 23 Nov 2024 07:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1023A17F505;
	Sat, 23 Nov 2024 07:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="cure/U5c"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32F917332C
	for <ceph-devel@vger.kernel.org>; Sat, 23 Nov 2024 07:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732346488; cv=none; b=g2U9peAbVGSi6Gq1wkCr2yYUanZEVwOrXe1WZqUwWf7p5vUvAFt1ljdzhXGlbdTESmc2IGr9y/EOR1phmHY/heHixN24Ap5b+FxwG/MaSPMgQ/l8Jklo3e4EdChYX9gusr2zTaBJ+07GvTFdAaoNEL/OXfWBKTLKAMtJ86/Ov5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732346488; c=relaxed/simple;
	bh=+z64crTzMeFzmw/jT4jJtpA1lPJMidF5DLwvfUo6cww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDPLiYYEZdd9rAzyRn3MeUqGPyuQ1Nuu67oG5NYU+/PDavCEx2zdeKb0ZlmVch92Lg1Z//lzwCoMzvRZrNR6gv70wtw0Ob4Zf6NTwuUk+Dj1NNFQGQgPgbroO4dWNBV7eaS5a5mboOnOaYT0U3ZSYaWT3gdi6p9C2RkrgC+yIqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=cure/U5c; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so460689866b.0
        for <ceph-devel@vger.kernel.org>; Fri, 22 Nov 2024 23:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732346485; x=1732951285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9y2CaneH6LYbzywEj7ypEqXyfCm8sgyQdgBr9xERX0c=;
        b=cure/U5cxm5en35gQes3hMT7f/thZI9c1WrzfpucNtjCrKpVKNB+rTvZcBNZj4HxIQ
         v/T41UDX9E3LVHbZpRIyVZBVbwT48LhoApD2TgYPrhoC2rQ9fKnY50Wbw0jtSytTO7Ae
         MBC8a/+hX8aNhfFPKqiVjwfSllJytrlcnwczaI6zLUMgB8UtBP58bBwsS9/0W1LlX5nO
         MP8/ULSCOPCaMxpzf5RfCzUTv0rVaM4XApcnuLxR4xO6glOBlZVhgb1oBex/MCkAyOxs
         MZT1MoqHqkcC06SWjmpa+n3PNj+glel6tPJmEtby5seWdVFL6Xjkl8jLC8RkGve/iIiF
         ZseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732346485; x=1732951285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9y2CaneH6LYbzywEj7ypEqXyfCm8sgyQdgBr9xERX0c=;
        b=q9Wtngualhu9+nHR529QxLc1kcp9Wl9G8KmK5CwhBQn/dx+WlPWb8I9+m9VvhgyCaq
         2r4IK4Eejh5QoYmB04cboy5i3+7KS4GfaZo4hOE9sBUJIfrZkkphOIocbFCZeEmdBZ7Z
         JnE7Bw9VSmvUkmnmKyg+Qn0VRtoatxJqSU8/OMeABub5i8dH+uCxr9/75oe3TjKm70Z4
         BW9sg1VDJcgaw6oI0NEFkIA5xTpFuBNnpKVo1ZXmcNECg7ChoZOsYoLxk0BOEg3vPtMX
         HJaGSekOoKLOJfugiF5sq5Zys+tOeRNAxmLe5503S1nNPFJmawH/xJrgz/+VlO+LzruY
         rT3A==
X-Forwarded-Encrypted: i=1; AJvYcCUuSMi2wtm+pDpTvOk2ff9smU6HsGm5TV17glypoA/8ZMfThGLarNxad3tp2y3U6sWt1/MEcRbLwlTG@vger.kernel.org
X-Gm-Message-State: AOJu0YwNVRrbJzyu3771Fpj3MHxnXFsQZsa0p9fINQ/ZSSDNWYuySln/
	POyzsc/PYxcT7R6/s0E5rbeeRpAhZY2lR9MlfzS+164r47zMkgYxSd/zus+OMpk=
X-Gm-Gg: ASbGncs8pet39hEN222God9hFbzxIH25yVxPGZkf5GV2fpVhbToVSGtKXkVwZ0qER88
	KrgqvPH97uE6Zv2AgyjO9PfjvOkcJxceCt/xV4wKgsy3XkZFp8phAcRBTstUX8HXGwoC+JseRCQ
	iJnQI3pF8tOmyRxDtuPlKu7QVVvJefwyTUwEvhWEQska6xCrJobKa/YwlruGURw9nf/f0kF9xnM
	ohY6KHU/6+5+k8VbrmumYKWvWZkAsbhn9AM+RXl8zAYS5eenkLAS94KM7Y0yCIyMAQp12JbVHAh
	D9nZ3hNQQoVkPjHZJhc2JH5l7JxXbbXh9BTXEifGGpGhLHCeTQ==
X-Google-Smtp-Source: AGHT+IEY8ATKSUaTZnvSh1YYi/SwNKyCxkgCkPA+YBufTqzJcf0vqiSyrwM7memjfbxXU05UWPkOww==
X-Received: by 2002:a17:907:1c8e:b0:a9a:238a:381d with SMTP id a640c23a62f3a-aa509d7c6afmr559551466b.52.1732346485043;
        Fri, 22 Nov 2024 23:21:25 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f12b600023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f12:b600:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d01ffd96e4sm1590029a12.60.2024.11.22.23.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 23:21:24 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 2/2] fs/ceph/mds_client: fix cred leak in ceph_mds_check_access()
Date: Sat, 23 Nov 2024 08:21:21 +0100
Message-ID: <20241123072121.1897163-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241123072121.1897163-1-max.kellermann@ionos.com>
References: <20241123072121.1897163-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

get_current_cred() increments the reference counter, but the
put_cred() call was missing.

Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/mds_client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e8a5994de8b6..35d83c8c2874 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5742,6 +5742,7 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
 
 		err = ceph_mds_auth_match(mdsc, s, cred, tpath);
 		if (err < 0) {
+			put_cred(cred);
 			return err;
 		} else if (err > 0) {
 			/* always follow the last auth caps' permision */
@@ -5757,6 +5758,8 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
 		}
 	}
 
+	put_cred(cred);
+
 	doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
 	      rw_perms_s);
 	if (root_squash_perms && rw_perms_s == NULL) {
-- 
2.45.2


