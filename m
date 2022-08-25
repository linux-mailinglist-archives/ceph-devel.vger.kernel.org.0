Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E95D5A125F
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242884AbiHYNcc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242729AbiHYNcF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:32:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA23B5A74
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 589DA61D07
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5018BC4347C;
        Thu, 25 Aug 2022 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434313;
        bh=QphBE616auSB+zZidkGpeODlEg1SAHOBw/o43+yc8Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js2bxNkU3Qe+12KmGltXE2m4iTxCWzK7CDAw6vKRCig+UQ8Ope07OfD2VzFIX1+N9
         E48xlj7XssbBKWdW1vTM8oQ43gZj0yH++n8mhntG7ozklmsqk5T82LJ0WHjkZJSXy/
         kwrSo7iMTzgKwPgbgVLEeotREPRIBhmnvJ8UTz6SXMzAFmWVXmTlnB4/bOe3Y5sRoV
         lJNDwGdusyQ8uFhufXpfySKxs+HdUlBAcijHvDzxvb3i5qyoCeQKWF7lZBNXd52qiH
         BOevcrq//jB9HuEoMIS8MUkywPYk+X7E4i1b/WsUSeU1GcKQqoaHsMFsT56u15qjo2
         YQi6GB2KiQB/A==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 27/29] ceph: update documentation regarding snapshot naming limitations
Date:   Thu, 25 Aug 2022 09:31:30 -0400
Message-Id: <20220825133132.153657-28-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/ceph.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
index 4942e018db85..d487cabe792d 100644
--- a/Documentation/filesystems/ceph.rst
+++ b/Documentation/filesystems/ceph.rst
@@ -57,6 +57,16 @@ a snapshot on any subdirectory (and its nested contents) in the
 system.  Snapshot creation and deletion are as simple as 'mkdir
 .snap/foo' and 'rmdir .snap/foo'.
 
+Snapshot names have two limitations:
+
+* They can not start with an underscore ('_'), as these names are reserved
+  for internal usage by the MDS.
+* They can not exceed 240 characters in size.  This is because the MDS makes
+  use of long snapshot names internally, which follow the format:
+  `_<SNAPSHOT-NAME>_<INODE-NUMBER>`.  Since filenames in general can't have
+  more than 255 characters, and `<node-id>` takes 13 characters, the long
+  snapshot names can take as much as 255 - 1 - 1 - 13 = 240.
+
 Ceph also provides some recursive accounting on directories for nested
 files and bytes.  That is, a 'getfattr -d foo' on any directory in the
 system will reveal the total number of nested regular files and
-- 
2.37.2

