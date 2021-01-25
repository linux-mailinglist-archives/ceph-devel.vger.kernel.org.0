Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F3C302936
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Jan 2021 18:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbhAYRoA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Jan 2021 12:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbhAYRgN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Jan 2021 12:36:13 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0F4C06174A
        for <ceph-devel@vger.kernel.org>; Mon, 25 Jan 2021 09:35:32 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id rv9so19221173ejb.13
        for <ceph-devel@vger.kernel.org>; Mon, 25 Jan 2021 09:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r16rr3PpNJda6H3LTIvIsC+W4mgjo7uSIQiXyzTVjF8=;
        b=sqZAyIFwt+Ko9Rc6WNxzYpYA3++4RU9r6WvCiyazMmOWkK/nimJgNaIpw6k1+N4BFU
         grM61+0+Sir3wA6pOkCS3lWkhMWKMHo/zIJXIrwYBXf8dsgvlXreK3tJVye4VG1hOTpx
         Sskhvq764iIwaMHQK07a4XoHLlFV0PKZlT9ArLukdHDIdxhF9dqxBB8xf1VSWXJ3C5Rf
         exiXHNenrOmk6Fg1D3cDYAtoP8Gn1srGNheuRidVP1mrhesYyIJDtfnwIiGLaZOZaVuU
         Nn+yQtMBRBseuOtvZOsssNCkQS+cv1CUwqRhYcI+t0uszT4ORSwVC/jszHlRSNEK0Mci
         L52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r16rr3PpNJda6H3LTIvIsC+W4mgjo7uSIQiXyzTVjF8=;
        b=MIdxDeiAK9h6DRLWcOO9D2TKbxNPP3cNOy2gXTauVOnEsLTXGFQnD6goppURsHwNCE
         Og8qK7H6aWUtnqKva1g8WY4Ox3Lxwvzxtcn8BZLrkB1EpGA/9gWQ+8xr2d/hv6cHRbSg
         x+cq29ObtcUkECJ1LE6uw66FRR1Fa4yQNoQfGikJoQArZq1kMrl5mzQy/sWj8wL6QpmU
         C5KgjBTd0HuL31QG957Lm+pAImCbOxyvFirM4bLzuqjhLIOctNYnfDTddWQ4Y0PHkOCJ
         6pMwe47iky6uJVg5Dhgl8BhbvZl2p0HlPjLMcYinnT8Bug0PaMnKdOq2EEggud9HOae5
         dawg==
X-Gm-Message-State: AOAM533aqjsZniD15MyvyC1fX1yyKax/kRrcasNc+xbb3PhJzJjT30B9
        gy/jhDLHqiJehmlQEcK8aiHaN9iQiBA=
X-Google-Smtp-Source: ABdhPJy99bzr4VQFROpfiKm7UlaKsH+/tjMZqqarjtG6REf1ZxXmbUlJu4oRsJCm9M2UbB6RoYHE3Q==
X-Received: by 2002:a17:906:1e87:: with SMTP id e7mr1072009ejj.322.1611596131225;
        Mon, 25 Jan 2021 09:35:31 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id cx6sm11326703edb.53.2021.01.25.09.35.29
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 09:35:30 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] libceph: deprecate [no]cephx_require_signatures options
Date:   Mon, 25 Jan 2021 18:35:26 +0100
Message-Id: <20210125173526.10103-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

These options were introduced in 3.19 with support for message signing
and are rather useless, as explained in commit a51983e4dd2d ("libceph:
add nocephx_sign_messages option").  Deprecate them.

In case there is someone out there with a cluster that lacks support
for MSG_AUTH feature (very unlikely but has to be considered since we
haven't formally raised the bar from argonaut to bobtail yet), make
nocephx_sign_messages also waive MSG_AUTH requirement.  This is probably
how it should have been done in the first place -- if we aren't going
to sign, requiring the signing feature makes no sense.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/libceph.h |  7 +++----
 net/ceph/ceph_common.c       | 11 +++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index eb9008bb3992..409d8c29bc4f 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -32,10 +32,9 @@
 #define CEPH_OPT_NOSHARE          (1<<1) /* don't share client with other sbs */
 #define CEPH_OPT_MYIP             (1<<2) /* specified my ip */
 #define CEPH_OPT_NOCRC            (1<<3) /* no data crc on writes (msgr1) */
-#define CEPH_OPT_NOMSGAUTH	  (1<<4) /* don't require msg signing feat */
-#define CEPH_OPT_TCP_NODELAY	  (1<<5) /* TCP_NODELAY on TCP sockets */
-#define CEPH_OPT_NOMSGSIGN	  (1<<6) /* don't sign msgs (msgr1) */
-#define CEPH_OPT_ABORT_ON_FULL	  (1<<7) /* abort w/ ENOSPC when full */
+#define CEPH_OPT_TCP_NODELAY      (1<<4) /* TCP_NODELAY on TCP sockets */
+#define CEPH_OPT_NOMSGSIGN        (1<<5) /* don't sign msgs (msgr1) */
+#define CEPH_OPT_ABORT_ON_FULL    (1<<6) /* abort w/ ENOSPC when full */
 
 #define CEPH_OPT_DEFAULT   (CEPH_OPT_TCP_NODELAY)
 
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 271287c5ec12..bec181181d41 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -307,7 +307,8 @@ static const struct constant_table ceph_param_ms_mode[] = {
 
 static const struct fs_parameter_spec ceph_parameters[] = {
 	fsparam_flag	("abort_on_full",		Opt_abort_on_full),
-	fsparam_flag_no ("cephx_require_signatures",	Opt_cephx_require_signatures),
+	__fsparam	(NULL, "cephx_require_signatures", Opt_cephx_require_signatures,
+			 fs_param_neg_with_no|fs_param_deprecated, NULL),
 	fsparam_flag_no ("cephx_sign_messages",		Opt_cephx_sign_messages),
 	fsparam_flag_no ("crc",				Opt_crc),
 	fsparam_string	("crush_location",		Opt_crush_location),
@@ -596,9 +597,9 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		break;
 	case Opt_cephx_require_signatures:
 		if (!result.negated)
-			opt->flags &= ~CEPH_OPT_NOMSGAUTH;
+			warn_plog(&log, "Ignoring cephx_require_signatures");
 		else
-			opt->flags |= CEPH_OPT_NOMSGAUTH;
+			warn_plog(&log, "Ignoring nocephx_require_signatures, use nocephx_sign_messages");
 		break;
 	case Opt_cephx_sign_messages:
 		if (!result.negated)
@@ -686,8 +687,6 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 		seq_puts(m, "noshare,");
 	if (opt->flags & CEPH_OPT_NOCRC)
 		seq_puts(m, "nocrc,");
-	if (opt->flags & CEPH_OPT_NOMSGAUTH)
-		seq_puts(m, "nocephx_require_signatures,");
 	if (opt->flags & CEPH_OPT_NOMSGSIGN)
 		seq_puts(m, "nocephx_sign_messages,");
 	if ((opt->flags & CEPH_OPT_TCP_NODELAY) == 0)
@@ -756,7 +755,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private)
 	client->supported_features = CEPH_FEATURES_SUPPORTED_DEFAULT;
 	client->required_features = CEPH_FEATURES_REQUIRED_DEFAULT;
 
-	if (!ceph_test_opt(client, NOMSGAUTH))
+	if (!ceph_test_opt(client, NOMSGSIGN))
 		client->required_features |= CEPH_FEATURE_MSG_AUTH;
 
 	/* msgr */
-- 
2.19.2

