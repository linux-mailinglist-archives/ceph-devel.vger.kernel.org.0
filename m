Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1DB52EA4C
	for <lists+ceph-devel@lfdr.de>; Fri, 20 May 2022 12:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348368AbiETKuw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 May 2022 06:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348340AbiETKu1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 May 2022 06:50:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5244154B08;
        Fri, 20 May 2022 03:50:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9C9161F8BD;
        Fri, 20 May 2022 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653043819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QOjyaVmBZfxQqmgII5bbA/vNMF/63ApN5nBJCRaxlyI=;
        b=rM+MsnCH2EyOxyByutRcntO7hyUHSc8/GBwObN+hs3vqqxQmjO2FRjm2QTjskACewpjDNq
        8h7Ec+Ewuw17T9jNBCqTFG2W/ZaCD9dJopbaUSycrmD5c1xGAclAKdYDw80VsJPaZEVcw7
        qOLAmeKj+fH1f5BnXk/rJr+23A1sHYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653043819;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QOjyaVmBZfxQqmgII5bbA/vNMF/63ApN5nBJCRaxlyI=;
        b=Q/8kFwruqOES1LVXlj+oam4uVd5vm7feMsII+jYXWMr2nkKzb1mWfef0jZc5ii+8U6Z9Ng
        fp4JuZTa0/7K/gCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6021013A5F;
        Fri, 20 May 2022 10:50:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id S1LHFGtyh2InGAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 20 May 2022 10:50:19 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 22bb1dc9;
        Fri, 20 May 2022 10:50:56 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph/001: skip metrics check if no copyfrom mount option is used
Date:   Fri, 20 May 2022 11:50:55 +0100
Message-Id: <20220520105055.31520-1-lhenriques@suse.de>
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

Checking the metrics is only valid if 'copyfrom' mount option is
explicitly set, otherwise the kernel won't be doing any remote object
copies.  Fix the logic to skip this metrics checking if 'copyfrom' isn't
used.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 tests/ceph/001 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/ceph/001 b/tests/ceph/001
index 7970ce352bab..2e6a5e6be2d6 100755
--- a/tests/ceph/001
+++ b/tests/ceph/001
@@ -86,11 +86,15 @@ check_copyfrom_metrics()
 	local copies=$4
 	local c1=$(get_copyfrom_total_copies)
 	local s1=$(get_copyfrom_total_size)
+	local hascopyfrom=$(_fs_options $TEST_DEV | grep "copyfrom")
 	local sum
 
 	if [ ! -d $metrics_dir ]; then
 		return # skip metrics check if debugfs isn't mounted
 	fi
+	if [ -z $hascopyfrom ]; then
+		return # ... or if we don't have copyfrom mount option
+	fi
 
 	sum=$(($c0+$copies))
 	if [ $sum -ne $c1 ]; then
