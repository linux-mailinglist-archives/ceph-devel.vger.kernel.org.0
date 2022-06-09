Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712D454497F
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 12:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243061AbiFIKxO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 06:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbiFIKxL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 06:53:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CEBE085;
        Thu,  9 Jun 2022 03:53:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 90A261F909;
        Thu,  9 Jun 2022 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654771984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEmJn680m/TQKB4Uu9ncMP6P+6Qq9FOSqC0c0ffBrNQ=;
        b=kvFwpF0xpDVIUkb6DFF2EPAltgZHnU1UhjGdNOSb6YL4T+qzYZrVO/H7eDKtbrqaDAJnaj
        RxV4Q8pvZxJJIrEqHOnhIKNuTfaSr5cnTpxQXXCEe3Wg3BIIIHMC0eKzeosT6ExrRqeas+
        bOTUA+G52MZZxJCwBe9R77AXtRw7pnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654771984;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEmJn680m/TQKB4Uu9ncMP6P+6Qq9FOSqC0c0ffBrNQ=;
        b=YV/LYmVrKiXcNCqezPvErvJg3qZYMGFCifHpRGfU6XqqlLHh+PPsaW+6GBsb5h2pJTMPVj
        HBM7HCwUG3TErsDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1AB1513456;
        Thu,  9 Jun 2022 10:53:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iPSEAxDRoWK1EAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Jun 2022 10:53:04 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id b14799e5;
        Thu, 9 Jun 2022 10:53:44 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2 2/2] generic/486: adjust the max xattr size
Date:   Thu,  9 Jun 2022 11:53:43 +0100
Message-Id: <20220609105343.13591-3-lhenriques@suse.de>
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
And since ceph reports 4M as the blocksize (the default ceph object size),
generic/486 will fail in this filesystem because it will end up using
XATTR_SIZE_MAX to set the size of the 2nd (big) xattr value.

The fix is to adjust the max size in attr_replace_test so that it takes
into account the initial xattr name and value lengths.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 src/attr_replace_test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
index cca8dcf8ff60..1c8d1049a1d8 100644
--- a/src/attr_replace_test.c
+++ b/src/attr_replace_test.c
@@ -29,6 +29,11 @@ int main(int argc, char *argv[])
 	char *value;
 	struct stat sbuf;
 	size_t size = sizeof(value);
+	/*
+	 * Take into account the initial (small) xattr name and value sizes and
+	 * subtract them from the XATTR_SIZE_MAX maximum.
+	 */
+	size_t maxsize = XATTR_SIZE_MAX - strlen(name) - 1;
 
 	if (argc != 2)
 		fail("Usage: %s <file>\n", argv[0]);
@@ -46,7 +51,7 @@ int main(int argc, char *argv[])
 	size = sbuf.st_blksize * 3 / 4;
 	if (!size)
 		fail("Invalid st_blksize(%ld)\n", sbuf.st_blksize);
-	size = MIN(size, XATTR_SIZE_MAX);
+	size = MIN(size, maxsize);
 	value = malloc(size);
 	if (!value)
 		fail("Failed to allocate memory\n");
