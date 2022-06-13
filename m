Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5813C548BC0
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jun 2022 18:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378393AbiFMNlQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jun 2022 09:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379266AbiFMNkP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jun 2022 09:40:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF49DF99;
        Mon, 13 Jun 2022 04:31:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 739EC21D97;
        Mon, 13 Jun 2022 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655119861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/Ex511XuC26n5wfZYvopT0bcTC6AXzGxUIymSLcgms=;
        b=FQiqw9j9N44s/RaZVxh2N5XOl0AHJn/c84EiVZ+SylLAca4ImXEHoqSEbOfcDXTkBEhD7d
        3w5c5a8NXEOVvyWwhOX4OOQRWbjkq7YIHrB3iSbd26RdR3PY0mVEin0gphnGg1pULU5kZT
        8f2OFYMSXPUy9Ieoqa3MxOtjb4PW9GY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655119861;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/Ex511XuC26n5wfZYvopT0bcTC6AXzGxUIymSLcgms=;
        b=cWzveilIrWdo7cULXTFleIOEpe0hv5bK9iM4p7CDnqa17Hc2zeN+B+d7jO991dMUyvA79v
        9dS6yEuAMyiQdWBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4543134CF;
        Mon, 13 Jun 2022 11:31:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qP4iMfQfp2ICeQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 13 Jun 2022 11:31:00 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 96a7b3fd;
        Mon, 13 Jun 2022 11:31:43 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, Zorro Lang <zlang@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v3 2/2] generic/486: adjust the max xattr size
Date:   Mon, 13 Jun 2022 12:31:42 +0100
Message-Id: <20220613113142.4338-3-lhenriques@suse.de>
In-Reply-To: <20220613113142.4338-1-lhenriques@suse.de>
References: <20220613113142.4338-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
size for the full set of xattrs names+values, which by default is 64K.  And
since it reports 4M as the blocksize (the default ceph object size),
generic/486 will fail in ceph because the XATTR_SIZE_MAX value can't be used
in attr_replace_test.

The fix is to add a new argument to the test so that the max size can be
passed in instead of trying to auto-probe a value for it.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 src/attr_replace_test.c | 30 ++++++++++++++++++++++++++----
 tests/generic/486       | 11 ++++++++++-
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
index cca8dcf8ff60..1218e7264c8f 100644
--- a/src/attr_replace_test.c
+++ b/src/attr_replace_test.c
@@ -20,19 +20,41 @@ exit(1); } while (0)
 fprintf(stderr, __VA_ARGS__); exit (1); \
 } while (0)
 
+void usage(char *progname)
+{
+	fail("usage: %s [-m max_attr_size] <file>\n", progname);
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
 	int fd;
+	int c;
 	char *path;
 	char *name = "user.world";
 	char *value;
 	struct stat sbuf;
 	size_t size = sizeof(value);
+	size_t maxsize = XATTR_SIZE_MAX;
+
+	while ((c = getopt(argc, argv, "m:")) != -1) {
+		char *endp;
+
+		switch (c) {
+		case 'm':
+			maxsize = strtoul(optarg, &endp, 0);
+			if (*endp || (maxsize > XATTR_SIZE_MAX))
+				fail("Invalid 'max_attr_size' value\n");
+			break;
+		default:
+			usage(argv[0]);
+		}
+	}
 
-	if (argc != 2)
-		fail("Usage: %s <file>\n", argv[0]);
-	path = argv[1];
+	if (optind == argc - 1)
+		path = argv[optind];
+	else
+		usage(argv[0]);
 
 	fd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
 	if (fd < 0) die();
@@ -46,7 +68,7 @@ int main(int argc, char *argv[])
 	size = sbuf.st_blksize * 3 / 4;
 	if (!size)
 		fail("Invalid st_blksize(%ld)\n", sbuf.st_blksize);
-	size = MIN(size, XATTR_SIZE_MAX);
+	size = MIN(size, maxsize);
 	value = malloc(size);
 	if (!value)
 		fail("Failed to allocate memory\n");
diff --git a/tests/generic/486 b/tests/generic/486
index 7de198f93a71..7dbfcb9835d9 100755
--- a/tests/generic/486
+++ b/tests/generic/486
@@ -41,7 +41,16 @@ filter_attr_output() {
 		sed -e 's/has a [0-9]* byte value/has a NNNN byte value/g'
 }
 
-$here/src/attr_replace_test $SCRATCH_MNT/hello
+max_attr_size=65536
+
+# attr_replace_test can't easily auto-probe the attr size for ceph because:
+# - ceph imposes a maximum value for the total xattr names+values, and
+# - ceph reports the 'object size' in the block size, which is, by default, much
+#   larger than XATTR_SIZE_MAX (4M > 64k)
+# Hence, we need to provide it with a maximum size.
+[ "$FSTYP" = "ceph" ] && max_attr_size=65000
+
+$here/src/attr_replace_test -m $max_attr_size $SCRATCH_MNT/hello
 $ATTR_PROG -l $SCRATCH_MNT/hello >>$seqres.full 2>&1
 $ATTR_PROG -l $SCRATCH_MNT/hello | filter_attr_output
 
