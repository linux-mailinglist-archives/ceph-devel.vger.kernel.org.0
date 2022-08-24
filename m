Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391D95A030B
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Aug 2022 22:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbiHXUxj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Aug 2022 16:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiHXUxh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Aug 2022 16:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C31A786ED
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 13:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05154B826A7
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 20:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAD9C433D6;
        Wed, 24 Aug 2022 20:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661374413;
        bh=ay/rO1WILJ21eot41xkv648HtJvtIszlbHasaUlmynY=;
        h=From:To:Cc:Subject:Date:From;
        b=rP/Pkgd3PfkqF6WY2yjQz1yDuirLa0NTbSfR8iuZxd/Lg7QheYBYVYhuexrTn0XA5
         /j97vdy1A7P8YFdkjFUN/6JojGpfLLhciZaSVrqATjgrIa0X8brISVmln+BgQUiokN
         SlZ+3zZ2gvLTJ3cMNUbtgD7Q9l2yuvJcscKX3rQFkf4EIeRDtUzFoB/M1QH8kt6ZMB
         Xb1A/CcxoM1faobcOSHD3GDJs4YO35gJx6dFO0aEDtRx9zGrQuzApiE7G4d1JK92j7
         3RwsVGBcoMS0hou1umMXpsYmGO35kzr0J49MPj1f4oQABaX0lT/rMwltlo92MZwFdd
         hIVosnYRSRm4Q==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: fix error handling in ceph_sync_write
Date:   Wed, 24 Aug 2022 16:53:31 -0400
Message-Id: <20220824205331.473248-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
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

ceph_sync_write has assumed that a zero result in req->r_result means
success. Testing with a recent cluster however shows the OSD returning
a non-zero length written here. I'm not sure whether and when this
changed, but fix the code to accept either result.

Assume a negative result means error, and anything else is a success. If
we're given a short length, then return a short write.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 86265713a743..c0b2c8968be9 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1632,11 +1632,19 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 					  req->r_end_latency, len, ret);
 out:
 		ceph_osdc_put_request(req);
-		if (ret != 0) {
+		if (ret < 0) {
 			ceph_set_error_write(ci);
 			break;
 		}
 
+		/*
+		 * FIXME: it's unclear whether all OSD versions return the
+		 * length written on a write. For now, assume that a 0 return
+		 * means that everything got written.
+		 */
+		if (ret && ret < len)
+			len = ret;
+
 		ceph_clear_error_write(ci);
 		pos += len;
 		written += len;
-- 
2.37.2

