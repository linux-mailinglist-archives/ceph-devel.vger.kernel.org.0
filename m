Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C27545505
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 21:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbiFITea (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 15:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiFITe1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 15:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A11C4253
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 12:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0D6061E43
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 19:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98345C34114;
        Thu,  9 Jun 2022 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654803265;
        bh=rTafXJkUnC60M6i+MKKBCXEtfwtAZgG3wC4h3Km2ub8=;
        h=From:To:Cc:Subject:Date:From;
        b=HO9CpH+zLoTxF3MTMYCO1M0UvZ/6GZogGkeBVyrvSwk+BbuS0EECnmx6HCwnUU9s8
         5qPidunvr5/Q0D830i4y4jjH4E90tbxj4os+fPiN6sg7OPJbHsWsmhPgzxq+2RySgn
         /Hw+eC9sscFgVyMAGcJMeFqoRotw1u3qX+SZU96iy69CEU/g2n8XBz6ZGwudKrHXls
         UQeWnJOxCrbTHdSxyFDlXvj1oaMVHbHqM8+L4HomF3i+qJaYm8KNMLRYaJkMh60rnh
         JpcDkZUZKzU1vbPgs1BGmE5U0ORUNMZIJ/6emBR4zyf5meTrpTY1M3n/xICWBL3401
         /MJO+C1sJ5bYw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, dhowells@redhat.com, ceph-devel@vger.kernel.org
Subject: [PATCH 0/2] ceph: add new iov_iter type and use it for reads
Date:   Thu,  9 Jun 2022 15:34:21 -0400
Message-Id: <20220609193423.167942-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patchset was inspired by some earlier work that David Howells did
to add a similar type.

Currently, we take an iov_iter from the netfs layer, turn that into an
array of pages, and then pass that to the messenger which eventually
turns that back into an iov_iter before handing it back to the socket.

This patchset adds a new ceph_msg_data_type that uses an iov_iter
directly instead of requiring an array of pages or bvecs. This allows
us to avoid an extra allocation in the buffered read path, and should
make it easier to plumb in write helpers later.

For now, this is still just a slow, stupid implementation that hands
the socket layer a page at a time like the existing messenger does. It
doesn't yet attempt to pass through the iov_iter directly.

I have some patches that pass the cursor's iov_iter directly to the
socket in the receive path, but it requires some infrastructure that's
not in mainline yet (iov_iter_scan(), for instance). It should be
possible to something similar in the send path as well.

Jeff Layton (2):
  libceph: add new iov_iter-based ceph_msg_data_type and
    ceph_osd_data_type
  ceph: use osd_req_op_extent_osd_iter for netfs reads

 fs/ceph/addr.c                  | 18 +---------
 include/linux/ceph/messenger.h  |  5 +++
 include/linux/ceph/osd_client.h |  4 +++
 net/ceph/messenger.c            | 64 +++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c           | 27 ++++++++++++++
 5 files changed, 101 insertions(+), 17 deletions(-)

-- 
2.36.1

