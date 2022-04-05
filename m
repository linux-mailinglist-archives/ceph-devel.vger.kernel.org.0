Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88594F36F4
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Apr 2022 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbiDELJN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Apr 2022 07:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349449AbiDEJtx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 5 Apr 2022 05:49:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B07BC21;
        Tue,  5 Apr 2022 02:46:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CC66F1F745;
        Tue,  5 Apr 2022 09:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649151971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0uwiZrHoEAwcm/6E7Q4jt1XioHQJ0mFo4nPx9wPkC7M=;
        b=vTn7v+5eE15F5XfHC49KXH+GbYNHajNpptQnF+HdxDHcDqC5/E2zq7VyorIH4WHv63ULg0
        2qJRneUAxahohw9lAX3IV44S+WYD2+SWA+no5R8erN+S7hS3XIX957vJ1TOCi3jKmTJHSR
        SWjo/6/b2npudNu3Ns72QZN9LNLe/HU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649151971;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0uwiZrHoEAwcm/6E7Q4jt1XioHQJ0mFo4nPx9wPkC7M=;
        b=ZURMVzrBie0K8SUtopzCCv8PIes2tV/5g2C0ME6LLs4Ml3WuF6n5XCnsd0H6HVf4kETvx6
        KzpG7Mc4JuhDEADw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6B3D813A04;
        Tue,  5 Apr 2022 09:46:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6i9RF+MPTGKdPQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 05 Apr 2022 09:46:11 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 33f2eaf2;
        Tue, 5 Apr 2022 09:46:34 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v3] common/encrypt: allow the use of 'fscrypt:' as key prefix
Date:   Tue,  5 Apr 2022 10:46:33 +0100
Message-Id: <20220405094633.17285-1-lhenriques@suse.de>
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
deprecated and newer kernels are expected to use the generic 'fscrypt:'
prefix instead.  This patch adds support for this new prefix, and only
uses $FSTYP on filesystems that didn't initially supported it, i.e. ext4 and
f2fs.  This will allow old kernels to be tested.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 common/encrypt | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

Changes since v2:
- updated _get_fs_keyprefix() and commit description

Changes since v1:
- ubifs now follows into the default case (i.e. to use the 'fscrypt' key
  prefix)
- dropped local variable from _get_fs_keyprefix()

diff --git a/common/encrypt b/common/encrypt
index f90c4ef05a3f..e2683f99dcc2 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -250,6 +250,25 @@ _num_to_hex()
 	fi
 }
 
+# When fscrypt keys are added using the legacy mechanism (process-subscribed
+# keyrings rather than filesystem keyrings), they are normally named
+# "fscrypt:KEYDESC" where KEYDESC is the 16-character key descriptor hex string.
+# However, ext4 and f2fs didn't add support for the "fscrypt" prefix until
+# kernel v4.8 and v4.6, respectively.  Before that, they used "ext4" and "f2fs",
+# respectively.  To allow testing ext4 and f2fs encryption on kernels older than
+# this, we use these filesystem-specific prefixes for ext4 and f2fs.
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
@@ -268,18 +287,11 @@ _add_session_encryption_key()
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
@@ -302,7 +314,8 @@ _generate_session_encryption_key()
 _unlink_session_encryption_key()
 {
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local prefix=$(_get_fs_keyprefix)
+	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
 	$KEYCTL_PROG unlink $keyid >>$seqres.full
 }
 
@@ -310,7 +323,8 @@ _unlink_session_encryption_key()
 _revoke_session_encryption_key()
 {
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local prefix=$(_get_fs_keyprefix)
+	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
 	$KEYCTL_PROG revoke $keyid >>$seqres.full
 }
 
