Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387CF5A1250
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbiHYNcE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242716AbiHYNbx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B690EB515A
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B577B8290E
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF08C43470;
        Thu, 25 Aug 2022 13:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434305;
        bh=m26PekdO69XCvkaj/D1aAcDnysbCrYEN5Y0VIM0imN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGYgkVqYuwHmTo3IxxrPjGlfvXyI8ZicWGuTw8otxl2AOpfEFY+EZcI1ii5itKU4H
         JzWrY2KocYQOZBvFdK6qrZSVJ0KZUkgQp8KicCKVrUi0NJwbX5iG9vIv6mA5mwuzuh
         fLbBy5ICtKjvwBRqNVUeIiJjdod9rR5zyvbyFPHs6QlGyHNQQEFhz0B276pH46JdM0
         vNKZ8JXwS6MKOdLKjT2sz8ap157baeBQXJvAXgaQu5fga2/uO8Mjvgx7ocmGe79K0Z
         EkNUMf8LpUzY88cJJBXiYFftcuvX4M3pYx8JcNbnhLcpNZfTi+Zg7Uj8hPcTeldh1E
         RIANHCtzfeWHQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 16/29] ceph: don't use special DIO path for encrypted inodes
Date:   Thu, 25 Aug 2022 09:31:19 -0400
Message-Id: <20220825133132.153657-17-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
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

Eventually I want to merge the synchronous and direct read codepaths,
possibly via new netfs infrastructure. For now, the direct path is not
crypto-enabled, so use the sync read/write paths instead.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index bd5e04d994ac..2444854dc805 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1729,7 +1729,9 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		     ceph_cap_string(got));
 
 		if (!ceph_has_inline_data(ci)) {
-			if (!retry_op && (iocb->ki_flags & IOCB_DIRECT)) {
+			if (!retry_op &&
+			    (iocb->ki_flags & IOCB_DIRECT) &&
+			    !IS_ENCRYPTED(inode)) {
 				ret = ceph_direct_read_write(iocb, to,
 							     NULL, NULL);
 				if (ret >= 0 && ret < len)
@@ -1955,7 +1957,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 		/* we might need to revert back to that point */
 		data = *from;
-		if (iocb->ki_flags & IOCB_DIRECT)
+		if ((iocb->ki_flags & IOCB_DIRECT) && !IS_ENCRYPTED(inode))
 			written = ceph_direct_read_write(iocb, &data, snapc,
 							 &prealloc_cf);
 		else
-- 
2.37.2

