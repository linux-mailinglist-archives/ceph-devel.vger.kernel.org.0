Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8FD32CFE0
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Mar 2021 10:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbhCDJlT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Mar 2021 04:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237792AbhCDJlA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Mar 2021 04:41:00 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0431DC061574;
        Thu,  4 Mar 2021 01:40:20 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id b18so20376314wrn.6;
        Thu, 04 Mar 2021 01:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9B1qRNEkgiYM5e4Rnx0MUxTJfW3B+WFA4nF4a8IG1Q=;
        b=kqVtZTrb2w1p+loQqs+tswteQ6Z300X2ogL0nfpDZwRrJloEuka6Qw3vbUznk9C/mP
         vAc+7/i3tCgseKniKiFZ1FEGT5USitOdaHx8q+dlr9Gp0Botig2yuooK/Ga3uM5o7uSW
         qpU9D7pKZrXxLKa8M9REIDyLjIJZ37+CRU8kz8lRGssHKNu7J2k1uG8GF4xO80RZDvhr
         fbYoyaFU+22zZHyXCX88e/XZW0Y/TjXyh8wWm0ch3ylVn8cabBUR9rXuPQEzViDMDg7d
         kQZB2RWb34DjYLTMuQCoJ/iHGnUvORj8TL3mM06a4mhPCETW0ncNxqQ5seEmMo4C2CGA
         DTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9B1qRNEkgiYM5e4Rnx0MUxTJfW3B+WFA4nF4a8IG1Q=;
        b=T3HVI2d+hszN9lVlEVDupyluYALtUu7ihUfzjwD+x3XXHFn4gpBvpCW7u5Xp84FmyN
         36QK0H2aP5ITOljw8/zpdzx/gGUTma5yOxdTUkl/yb/tG4j6FnC4H0HuB7zXjIzKdkSY
         gNryaruLatfPTZF5XwL4ztx3UqcRVS3vAT/m77dZ3eIvCGFA46ZA5vfv6zDbcIb3A3q9
         eSPN+KOtVKbZt3+AbOyGlqWc73NLd3UI8Yp765pVTnb/bvEzi8VEjwiaqCyddlpDzPKq
         liv6tmoRtqYLTjPOAmiruSpKCCbc1Kot5nlS7M3Rmp75KjVJToz/teFANAJ3ygkFPeOz
         6YxQ==
X-Gm-Message-State: AOAM531Uo60oam7pmhGi/X9Qvyv8MslIihtOTu4yvPnsxy4oSg/XJqE4
        eQtRq2FJb4GKwoMFGIeTinX9mhDhQKcz/Q==
X-Google-Smtp-Source: ABdhPJy5rhRh3oIwq+uQ7c2BFcomsa5X6e0OMtaarr4aRCxsiyv3xNoF5kJaWXKyZ+4A1ooWqFB6Uw==
X-Received: by 2002:adf:a219:: with SMTP id p25mr3049987wra.400.1614850818747;
        Thu, 04 Mar 2021 01:40:18 -0800 (PST)
Received: from localhost.localdomain ([170.253.51.130])
        by smtp.googlemail.com with ESMTPSA id l2sm6127295wml.38.2021.03.04.01.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 01:40:18 -0800 (PST)
From:   Alejandro Colomar <alx.manpages@gmail.com>
To:     linux-man@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Steve French <sfrench@samba.org>
Cc:     Alejandro Colomar <alx.manpages@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Jeff Layton <jlayton@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Ian Lance Taylor <iant@google.com>,
        Luis Lozano <llozano@chromium.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Olga Kornievskaia <aglo@umich.edu>,
        Christoph Hellwig <hch@infradead.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Walter Harms <wharms@bfs.de>
Subject: [RFC v4] copy_file_range.2: Update cross-filesystem support for 5.12
Date:   Thu,  4 Mar 2021 10:38:07 +0100
Message-Id: <20210304093806.10589-1-alx.manpages@gmail.com>
X-Mailer: git-send-email 2.30.1.721.g45526154a5
In-Reply-To: <20210224142307.7284-1-lhenriques@suse.de>
References: <20210224142307.7284-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Linux 5.12 fixes a regression.

Cross-filesystem (introduced in 5.3) copies were buggy.

Move the statements documenting cross-fs to BUGS.
Kernels 5.3..5.11 should be patched soon.

State version information for some errors related to this.

Reported-by: Luis Henriques <lhenriques@suse.de>
Reported-by: Amir Goldstein <amir73il@gmail.com>
Related: <https://lwn.net/Articles/846403/>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Nicolas Boichat <drinkcat@chromium.org>
Cc: Ian Lance Taylor <iant@google.com>
Cc: Luis Lozano <llozano@chromium.org>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Olga Kornievskaia <aglo@umich.edu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: ceph-devel <ceph-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Cc: Walter Harms <wharms@bfs.de>
Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>
---

v3:
        - Don't remove some important text.
        - Reword BUGS.
v4:
	- Reword.
	- Link to BUGS.

Thanks, Amir, for all the help and better wordings.

Cheers,

Alex

---
 man2/copy_file_range.2 | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/man2/copy_file_range.2 b/man2/copy_file_range.2
index 611a39b80..f58bfea8f 100644
--- a/man2/copy_file_range.2
+++ b/man2/copy_file_range.2
@@ -169,6 +169,9 @@ Out of memory.
 .B ENOSPC
 There is not enough space on the target filesystem to complete the copy.
 .TP
+.BR EOPNOTSUPP " (since Linux 5.12)"
+The filesystem does not support this operation.
+.TP
 .B EOVERFLOW
 The requested source or destination range is too large to represent in the
 specified data types.
@@ -184,10 +187,17 @@ or
 .I fd_out
 refers to an active swap file.
 .TP
-.B EXDEV
+.BR EXDEV " (before Linux 5.3)"
+The files referred to by
+.IR fd_in " and " fd_out
+are not on the same filesystem.
+.TP
+.BR EXDEV " (since Linux 5.12)"
 The files referred to by
 .IR fd_in " and " fd_out
-are not on the same mounted filesystem (pre Linux 5.3).
+are not on the same filesystem,
+and the source and target filesystems are not of the same type,
+or do not support cross-filesystem copy.
 .SH VERSIONS
 The
 .BR copy_file_range ()
@@ -200,8 +210,11 @@ Areas of the API that weren't clearly defined were clarified and the API bounds
 are much more strictly checked than on earlier kernels.
 Applications should target the behaviour and requirements of 5.3 kernels.
 .PP
-First support for cross-filesystem copies was introduced in Linux 5.3.
-Older kernels will return -EXDEV when cross-filesystem copies are attempted.
+Since Linux 5.12,
+cross-filesystem copies can be achieved
+when both filesystems are of the same type,
+and that filesystem implements support for it.
+See BUGS for behavior prior to 5.12.
 .SH CONFORMING TO
 The
 .BR copy_file_range ()
@@ -226,6 +239,12 @@ gives filesystems an opportunity to implement "copy acceleration" techniques,
 such as the use of reflinks (i.e., two or more inodes that share
 pointers to the same copy-on-write disk blocks)
 or server-side-copy (in the case of NFS).
+.SH BUGS
+In Linux kernels 5.3 to 5.11,
+cross-filesystem copies were implemented by the kernel,
+if the operation was not supported by individual filesystems.
+However, on some virtual filesystems,
+the call failed to copy, while still reporting success.
 .SH EXAMPLES
 .EX
 #define _GNU_SOURCE
-- 
2.30.1.721.g45526154a5

