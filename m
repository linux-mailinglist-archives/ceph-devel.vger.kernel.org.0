Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5AC4F130E
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Apr 2022 12:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357605AbiDDK1e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Apr 2022 06:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbiDDK13 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Apr 2022 06:27:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C4A3C720;
        Mon,  4 Apr 2022 03:25:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 166B6210EF;
        Mon,  4 Apr 2022 10:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649067932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3LM5PNUZKHWZTEzzuZ62klwLDh0By7F8hBNvXQABbb0=;
        b=ZFWb2ucQCnaEWxAwUAWgrZaEwGtSirbPRXJKvHn5qYcs6M4rWqt0U/kcayiSLRXSHUzUwn
        QGCUksthtp5S6MUt1DxHFwgvuj8xvDsEOco34XvcdJKlnSVbnZchDJxOPwvhg/AWKb1evm
        bfsrdjKtbcot5JxKZop2Eaa0tPHh9Cg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649067932;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3LM5PNUZKHWZTEzzuZ62klwLDh0By7F8hBNvXQABbb0=;
        b=HQH4OpeVUyZaLa6/nILa4jmQpx37y1lHvISMTdRUGg7prJfqdAgCOc5hkeKE7owGF532Ph
        lc6OxU0hvgmcxgCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A12C712FC5;
        Mon,  4 Apr 2022 10:25:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wxkUJJvHSmIjQgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 04 Apr 2022 10:25:31 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 433e0e59;
        Mon, 4 Apr 2022 10:25:55 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2] common/encrypt: allow the use of 'fscrypt:' as key prefix
Date:   Mon,  4 Apr 2022 11:25:54 +0100
Message-Id: <20220404102554.6616-1-lhenriques@suse.de>
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
 common/encrypt | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

Changes since v1:
- ubifs now follows into the default case (i.e. to use the 'fscrypt' key
  prefix)
- dropped local variable from _get_fs_keyprefix()

diff --git a/common/encrypt b/common/encrypt
index f90c4ef05a3f..6dae7708d52b 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -250,6 +250,24 @@ _num_to_hex()
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
+	case $FSTYP in
+	ext4|f2fs)
+		echo $FSTYP
+		;;
+	*)
+		echo fscrypt
+		;;
+	esac
+}
+
 # Add the specified raw encryption key to the session keyring, using the
 # specified key descriptor.
 _add_session_encryption_key()
@@ -268,18 +286,11 @@ _add_session_encryption_key()
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
@@ -302,7 +313,8 @@ _generate_session_encryption_key()
 _unlink_session_encryption_key()
 {
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local prefix=$(_get_fs_keyprefix)
+	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
 	$KEYCTL_PROG unlink $keyid >>$seqres.full
 }
 
@@ -310,7 +322,8 @@ _unlink_session_encryption_key()
 _revoke_session_encryption_key()
 {
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local prefix=$(_get_fs_keyprefix)
+	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
 	$KEYCTL_PROG revoke $keyid >>$seqres.full
 }
 
