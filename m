Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9500C540230
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 17:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343885AbiFGPOh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 11:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245023AbiFGPOg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 11:14:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9530D69B6D;
        Tue,  7 Jun 2022 08:14:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 55D9B219EE;
        Tue,  7 Jun 2022 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654614874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wpjPIR+wUVjX3PE+Tq8yv5deHvOVU6vemMV4suTxgb4=;
        b=yEgZbTYk1KA3ZQ5251qfmquIzZkdhELMkNs2C0gCFRA8JsVpmmjJPDlVs7UGYb/gJTc5px
        RV6/SMJO1u11Eodmccf6t9+PS3NwxULdwcKNEn6ZPfyBlackYjTHxY2LtauLrZOxYFh/zU
        au7tA7w+12BkjKgLuuod5pF4u2fUMWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654614874;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wpjPIR+wUVjX3PE+Tq8yv5deHvOVU6vemMV4suTxgb4=;
        b=2dnF1mWJ5ERAGxQAI3XU1cNAUIe7gZwhxHCNx0s2mE2PjO01ft8Obs/dtlfuwIzVTl1UL9
        MjUQ+ukZ4XQc7PAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E6C8A13A88;
        Tue,  7 Jun 2022 15:14:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sDckNVlrn2JRWwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 15:14:33 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 0ef3a077;
        Tue, 7 Jun 2022 15:15:14 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH 2/2] src/attr_replace_test: dynamically adjust the max xattr size
Date:   Tue,  7 Jun 2022 16:15:13 +0100
Message-Id: <20220607151513.26347-3-lhenriques@suse.de>
In-Reply-To: <20220607151513.26347-1-lhenriques@suse.de>
References: <20220607151513.26347-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
size for the full set of an inode's xattrs names+values, which by default
is 64K but it can be changed by a cluster admin.

Test generic/486 started to fail after fixing a ceph bug where this limit
wasn't being imposed.  Adjust dynamically the size of the xattr being set
if the error returned is -ENOSPC.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 src/attr_replace_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
index cca8dcf8ff60..de18e643f469 100644
--- a/src/attr_replace_test.c
+++ b/src/attr_replace_test.c
@@ -62,7 +62,10 @@ int main(int argc, char *argv[])
 
 	/* Then, replace it with bigger one, forcing short form to leaf conversion. */
 	memset(value, '1', size);
-	ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
+	do {
+		ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
+		size -= 256;
+	} while ((ret < 0) && (errno == ENOSPC) && (size > 0));
 	if (ret < 0) die();
 	close(fd);
 
