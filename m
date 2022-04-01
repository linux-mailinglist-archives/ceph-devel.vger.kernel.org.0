Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AB64EEBC1
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 12:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345138AbiDAKr2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 06:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345144AbiDAKrZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 06:47:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48171D7D80;
        Fri,  1 Apr 2022 03:45:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 310BD21A97;
        Fri,  1 Apr 2022 10:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648809932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dSa6lUbtlcUWa6YkCzcLLpuhGobQruaSMXkd+E+FfX8=;
        b=wzW0FkeJy4LLBnuR5qiaUv5f+2z0Xb1bnXDSec9Tdr3rQmjN7SfqJpM+h5QfN0ca18SaN3
        NZZbfBCpiipaJQ3MrdziG1zcxEQPRDoKUgdwIdfFR5DWUowwi71ufryGZTrmHyVR13rNiy
        FuKZnxUxJBYdKPUEc8xjIW9htjy8eug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648809932;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dSa6lUbtlcUWa6YkCzcLLpuhGobQruaSMXkd+E+FfX8=;
        b=GVNnqhiIgeX/LjcTY/1DAxcy0bKPXoRHAnOSRCTV+fu5zhEubdGHwWIL4kK968on6C58N2
        IoSjJtU6l25JWuCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF788132C1;
        Fri,  1 Apr 2022 10:45:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PBnJK8vXRmJeAwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 01 Apr 2022 10:45:31 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 89546f7b;
        Fri, 1 Apr 2022 10:45:54 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] common/encrypt: allow the use of 'fscrypt:' as key prefix
Date:   Fri,  1 Apr 2022 11:45:53 +0100
Message-Id: <20220401104553.32036-1-lhenriques@suse.de>
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

fscrypt keys have used the $FSTYP as prefix.  However this format is being
deprecated -- newer kernels already allow the usage of the generic
'fscrypt:' prefix for ext4 and f2fs.  This patch allows the usage of this
new prefix for testing filesystems that have never supported the old
format, but keeping the $FSTYP prefix for filesystems that support it, so
that old kernels can be tested.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 common/encrypt | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index f90c4ef05a3f..897c97e0f6fa 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -250,6 +250,27 @@ _num_to_hex()
 	fi
 }
 
+# Keys are named $FSTYP:KEYDESC where KEYDESC is the 16-character key descriptor
+# hex string.  Newer kernels (ext4 4.8 and later, f2fs 4.6 and later) also allow
+# the common key prefix "fscrypt:" in addition to their filesystem-specific key
+# prefix ("ext4:", "f2fs:").  It would be nice to use the common key prefix, but
+# for now use the filesystem- specific prefix for these 2 filesystems to make it
+# possible to test older kernels, and the "fscrypt" prefix for anything else.
+_get_fs_keyprefix()
+{
+	local prefix=""
+
+	case $FSTYP in
+	ext4|f2fs|ubifs)
+		prefix="$FSTYP"
+		;;
+	*)
+		prefix="fscrypt"
+		;;
+	esac
+	echo $prefix
+}
+
 # Add the specified raw encryption key to the session keyring, using the
 # specified key descriptor.
 _add_session_encryption_key()
@@ -268,18 +289,11 @@ _add_session_encryption_key()
 	#	};
 	#
 	# The kernel ignores 'mode' but requires that 'size' be 64.
-	#
-	# Keys are named $FSTYP:KEYDESC where KEYDESC is the 16-character key
-	# descriptor hex string.  Newer kernels (ext4 4.8 and later, f2fs 4.6
-	# and later) also allow the common key prefix "fscrypt:" in addition to
-	# their filesystem-specific key prefix ("ext4:", "f2fs:").  It would be
-	# nice to use the common key prefix, but for now use the filesystem-
-	# specific prefix to make it possible to test older kernels...
-	#
 	local mode=$(_num_to_hex 0 4)
 	local size=$(_num_to_hex 64 4)
+	local prefix=$(_get_fs_keyprefix)
 	echo -n -e "${mode}${raw}${size}" |
-		$KEYCTL_PROG padd logon $FSTYP:$keydesc @s >>$seqres.full
+		$KEYCTL_PROG padd logon $prefix:$keydesc @s >>$seqres.full
 }
 
 #
@@ -302,7 +316,8 @@ _generate_session_encryption_key()
 _unlink_session_encryption_key()
 {
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local prefix=$(_get_fs_keyprefix)
+	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
 	$KEYCTL_PROG unlink $keyid >>$seqres.full
 }
 
@@ -310,7 +325,8 @@ _unlink_session_encryption_key()
 _revoke_session_encryption_key()
 {
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local prefix=$(_get_fs_keyprefix)
+	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
 	$KEYCTL_PROG revoke $keyid >>$seqres.full
 }
 
