Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BE454497D
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 12:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242930AbiFIKxH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 06:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbiFIKxG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 06:53:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48351D12E;
        Thu,  9 Jun 2022 03:53:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 04FD421E0E;
        Thu,  9 Jun 2022 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654771984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nHo1V4OXl1fsgoJ0X4r6OgxS7vBNLp6zrOgtEoQsT7A=;
        b=g5yHi3cy0wdKjPTR4+KFch0zqU9rZcFXZpJp5xZR+T2x5WEwq6PdDMT2Sf1qrQscAc2F49
        Ux8FWUhOw4bxic4/LLa8+3UTL2sGB6atDT3kOk9M4hYIfbfCwDVJyBEBLMxjm+//CRpxPE
        GDB4ZJdjet4+6WvaQPtjf22efpXt7Co=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654771984;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nHo1V4OXl1fsgoJ0X4r6OgxS7vBNLp6zrOgtEoQsT7A=;
        b=pu9H7YpgArBP/0N9t6Go4PzfhmsI1KZ4HU2qGPN79W7OrcLqb20F0vokdQcruFM6PfecVo
        h2ccF5/zPZFo/JAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 831A013456;
        Thu,  9 Jun 2022 10:53:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CET7HA/RoWK1EAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Jun 2022 10:53:03 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 456a2098;
        Thu, 9 Jun 2022 10:53:44 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2 1/2] generic/020: adjust max_attrval_size for ceph
Date:   Thu,  9 Jun 2022 11:53:42 +0100
Message-Id: <20220609105343.13591-2-lhenriques@suse.de>
In-Reply-To: <20220609105343.13591-1-lhenriques@suse.de>
References: <20220609105343.13591-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
size for the full set of xattrs names+values, which by default is 64K.

This patch fixes the max_attrval_size so that it is slightly < 64K in
order to accommodate any already existing xattrs in the file.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 tests/generic/020 | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tests/generic/020 b/tests/generic/020
index d8648e96286e..76f13220fe85 100755
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -128,7 +128,7 @@ _attr_get_max()
 	pvfs2)
 		max_attrval_size=8192
 		;;
-	xfs|udf|9p|ceph)
+	xfs|udf|9p)
 		max_attrval_size=65536
 		;;
 	bcachefs)
@@ -139,6 +139,14 @@ _attr_get_max()
 		# the underlying filesystem, so just use the lowest value above.
 		max_attrval_size=1024
 		;;
+	ceph)
+		# CephFS does not have a maximum value for attributes.  Instead,
+		# it imposes a maximum size for the full set of xattrs
+		# names+values, which by default is 64K.  Set this to a value
+		# that is slightly smaller than 64K so that it can accommodate
+		# already existing xattrs.
+		max_attrval_size=65000
+		;;
 	*)
 		# Assume max ~1 block of attrs
 		BLOCK_SIZE=`_get_block_size $TEST_DIR`
