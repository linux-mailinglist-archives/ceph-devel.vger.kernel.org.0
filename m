Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857BF540413
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344233AbiFGQvR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 12:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiFGQvQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 12:51:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876A1F5D37;
        Tue,  7 Jun 2022 09:51:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4860D1F989;
        Tue,  7 Jun 2022 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654620674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=shFOWPg68Uwfa4tVZjUM5dOMRJq90YtpwIjmrRmGpPo=;
        b=t1ojOnn5jcQS5iyPgsK2IgVRD06NDn8Wlx1oeTZQJU3wW6SCcoUz9SpdjTYzCa8T7oUYPC
        Mih6orQFPbLub+mVZApYXc/yy+tC7ThwsPrhBbteYZ1mRh0ri9kkp+G7CXWWT4n/fy9YTu
        3Lz3/y1KxRMr2dhXJUn/Zj5WzhwubkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654620674;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=shFOWPg68Uwfa4tVZjUM5dOMRJq90YtpwIjmrRmGpPo=;
        b=c0iiTrFjea4UEkWLV5XzqMPf2suuifZc87N0BX4XGZcA1rMhuk94r8xipLoMWRkkFXV/wU
        fqda68qOMDVWNyBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CACFB13638;
        Tue,  7 Jun 2022 16:51:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ikBFLgGCn2J6BAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 16:51:13 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 4e2cb5fe;
        Tue, 7 Jun 2022 16:51:54 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2] src/attr_replace_test: dynamically adjust the max xattr size
Date:   Tue,  7 Jun 2022 17:51:53 +0100
Message-Id: <20220607165153.27797-1-lhenriques@suse.de>
In-Reply-To: <87wnds8mxv.fsf@brahms.olymp>
References: <87wnds8mxv.fsf@brahms.olymp>
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

CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum size
for the full set of xattrs names+values, which by default is 64K but may be
changed.

Test generic/486 started to fail after fixing a ceph bug where this limit
wasn't being imposed.  Adjust dynamically the size of the xattr being set
if the error returned is -ENOSPC.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 src/attr_replace_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
index cca8dcf8ff60..d1b92703ba2a 100644
--- a/src/attr_replace_test.c
+++ b/src/attr_replace_test.c
@@ -62,7 +62,10 @@ int main(int argc, char *argv[])
 
 	/* Then, replace it with bigger one, forcing short form to leaf conversion. */
 	memset(value, '1', size);
-	ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
+	do {
+		ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
+		size -= 256;
+	} while ((ret < 0) && (errno == ENOSPC) && (size > 256));
 	if (ret < 0) die();
 	close(fd);
 
