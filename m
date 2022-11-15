Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CDB629C7B
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Nov 2022 15:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiKOOpf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Nov 2022 09:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiKOOpQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Nov 2022 09:45:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2087727176;
        Tue, 15 Nov 2022 06:44:03 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A86FA1F8D2;
        Tue, 15 Nov 2022 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668523442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5DG1Uhvjr2nebGEtrDXagxI6OIIcIOPdw5cys3pEnVU=;
        b=Oyo4PtUTV6OQnvRWcMTjurCb+4vO2gj5dykHXPtcu8HPE0HkpdA9rnPAFwomeuqK0Ddiaj
        IQQ4sGtieg8gmoMpylBQi8uTHGjQPB0QJIRYXTxagB2GIP+gVgZBgfBFmRmv7m6bU7zY3r
        Szb6eOzGuWly/OMK2nO8DkfIphbsNEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668523442;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5DG1Uhvjr2nebGEtrDXagxI6OIIcIOPdw5cys3pEnVU=;
        b=4jx5Gf8Z0rO5KHVz8MDzimzsKThh2I5gHi8lbZZOU36WwbxaCCUg7n1Sav5PiIGBaBe0Sz
        LQVVqM4EjFN7I8Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5661713A91;
        Tue, 15 Nov 2022 14:44:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7k59ErKlc2NVCQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 15 Nov 2022 14:44:02 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 6f62b2e7;
        Tue, 15 Nov 2022 14:45:01 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph/005: skip test if using "test_dummy_encryption"
Date:   Tue, 15 Nov 2022 14:45:00 +0000
Message-Id: <20221115144500.10015-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When using the "test_dummy_encryption" mount option, new file and directory
names will be encrypted.  This means that if using as a mount base directory
a newly created directory, we would have to use the encrypted directory name
instead.  For the moment, ceph doesn't provide a way to get this encrypted
file name, thus for now simply skip this test.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 tests/ceph/005 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/ceph/005 b/tests/ceph/005
index fd71d91350db..015f6571b098 100755
--- a/tests/ceph/005
+++ b/tests/ceph/005
@@ -13,6 +13,7 @@ _begin_fstest auto quick quota
 
 _supported_fs ceph
 _require_scratch
+_exclude_test_mount_option "test_dummy_encryption"
 
 _scratch_mount
 mkdir -p "$SCRATCH_MNT/quota-dir/subdir"
